package com.example.atv_remote.pairing

import android.content.Context
import android.util.Base64
import android.util.Log
import java.io.ByteArrayInputStream
import java.security.KeyPairGenerator
import java.security.KeyStore
import java.security.PrivateKey
import java.security.cert.CertificateFactory
import java.security.cert.X509Certificate
import java.util.Date

class CertificateStore(private val context: Context) {

    private val tag = "TvCertStore"

    // ─────────────────────────────────────────────────────────────
    // Client Identity (Software-based using BouncyCastle)
    // ─────────────────────────────────────────────────────────────

    fun generateIdentityIfNeeded() {
        if (prefs().contains("client_cert") && prefs().contains("client_key")) {
            Log.i(tag, "Software-backed identity already exists.")
            return
        }

        Log.i(tag, "Generating software-backed RSA-2048 client identity using BouncyCastle...")

        try {
            // 1. Generate RSA-2048 KeyPair
            val kpg = KeyPairGenerator.getInstance("RSA")
            kpg.initialize(2048)
            val keyPair = kpg.generateKeyPair()

            // 2. Generate self-signed certificate using BouncyCastle
            val subject = org.bouncycastle.asn1.x500.X500Name("CN=AndroidTVRemoteClient")
            val serial = java.math.BigInteger.valueOf(System.currentTimeMillis())
            val notBefore = Date(System.currentTimeMillis() - 24 * 60 * 60 * 1000)
            val notAfter = Date(System.currentTimeMillis() + 10L * 365 * 24 * 60 * 60 * 1000)

            val subjectPublicKeyInfo = org.bouncycastle.asn1.x509.SubjectPublicKeyInfo.getInstance(keyPair.public.encoded)
            val certBuilder = org.bouncycastle.cert.jcajce.JcaX509v3CertificateBuilder(
                subject, serial, notBefore, notAfter, subject, keyPair.public
            )

            val signer = org.bouncycastle.operator.jcajce.JcaContentSignerBuilder("SHA256withRSA").build(keyPair.private)
            val certHolder = certBuilder.build(signer)
            
            val cert = org.bouncycastle.cert.jcajce.JcaX509CertificateConverter().getCertificate(certHolder)

            // 3. Save to SharedPreferences as Base64
            prefs().edit()
                .putString("client_cert", Base64.encodeToString(cert.encoded, Base64.NO_WRAP))
                .putString("client_key", Base64.encodeToString(keyPair.private.encoded, Base64.NO_WRAP))
                .apply()

            Log.i(tag, "Software identity generated successfully: ${getClientCertificateFingerprint()}")
        } catch (e: Exception) {
            Log.e(tag, "Failed to generate software identity: ${e.message}", e)
            throw e
        }
    }

    fun getClientCertificate(): X509Certificate {
        val encoded = prefs().getString("client_cert", null)
            ?: throw IllegalStateException("Client cert not found in SharedPreferences")
        val bytes = Base64.decode(encoded, Base64.NO_WRAP)
        return CertificateFactory.getInstance("X.509")
            .generateCertificate(ByteArrayInputStream(bytes)) as X509Certificate
    }

    fun getClientPrivateKey(): PrivateKey {
        val encoded = prefs().getString("client_key", null)
            ?: throw IllegalStateException("Client key not found in SharedPreferences")
        val bytes = Base64.decode(encoded, Base64.NO_WRAP)
        
        val keyFactory = java.security.KeyFactory.getInstance("RSA")
        val keySpec = java.security.spec.PKCS8EncodedKeySpec(bytes)
        return keyFactory.generatePrivate(keySpec)
    }

    fun getClientCertificateFingerprint(): String {
        val cert = getClientCertificate()
        return getFingerprint(cert)
    }

    // ─────────────────────────────────────────────────────────────
    // Server Certificate Storage (per device IP)
    // ─────────────────────────────────────────────────────────────

    fun saveServerCertificate(deviceIp: String, cert: X509Certificate) {
        val key = serverCertKey(deviceIp)
        prefs().edit()
            .putString(key, Base64.encodeToString(cert.encoded, Base64.NO_WRAP))
            .apply()
        Log.d(tag, "Server cert saved for $deviceIp")
    }

    fun getServerCertificate(deviceIp: String): X509Certificate? {
        val encoded = prefs().getString(serverCertKey(deviceIp), null) ?: return null
        val bytes = Base64.decode(encoded, Base64.NO_WRAP)
        return CertificateFactory.getInstance("X.509")
            .generateCertificate(ByteArrayInputStream(bytes)) as X509Certificate
    }

    @Synchronized
    fun hasServerCertificate(deviceIp: String): Boolean =
        prefs().contains(serverCertKey(deviceIp))

    @Synchronized
    fun isPaired(deviceIp: String): Boolean = hasServerCertificate(deviceIp)

    fun clearServerCertificate(deviceIp: String) {
        prefs().edit().remove(serverCertKey(deviceIp)).apply()
        Log.d(tag, "Server cert cleared for $deviceIp")
    }

    // ─────────────────────────────────────────────────────────────
    // Cert Order Persistence for STATUS_BAD_SECRET
    // ─────────────────────────────────────────────────────────────
    
    @Synchronized
    fun isClientFirst(deviceIp: String): Boolean {
        return prefs().getBoolean("cert_order_${deviceIp.replace(".", "_")}", true)
    }

    @Synchronized
    fun setClientFirst(deviceIp: String, clientFirst: Boolean) {
        prefs().edit().putBoolean("cert_order_${deviceIp.replace(".", "_")}", clientFirst).apply()
    }

    // ─────────────────────────────────────────────────────────────
    // mTLS Context for RemoteSession
    // ─────────────────────────────────────────────────────────────

    fun createMutualTlsContext(deviceIp: String): javax.net.ssl.SSLContext {
        generateIdentityIfNeeded()

        val clientCert = getClientCertificate()
        val clientKey = getClientPrivateKey()

        val serverCert = getServerCertificate(deviceIp)
            ?: throw IllegalStateException("No server certificate for $deviceIp. Pair first.")

        // KeyStore with client identity
        val clientKs = KeyStore.getInstance(KeyStore.getDefaultType()).apply {
            load(null)
            setKeyEntry("client", clientKey, null, arrayOf(clientCert))
        }

        val kmf = javax.net.ssl.KeyManagerFactory.getInstance(
            javax.net.ssl.KeyManagerFactory.getDefaultAlgorithm()
        ).apply { init(clientKs, null) }

        // TrustStore with ONLY the server cert
        val trustKs = KeyStore.getInstance(KeyStore.getDefaultType()).apply {
            load(null)
            setCertificateEntry("server", serverCert)
        }

        val tmf = javax.net.ssl.TrustManagerFactory.getInstance(
            javax.net.ssl.TrustManagerFactory.getDefaultAlgorithm()
        ).apply { init(trustKs) }

        return javax.net.ssl.SSLContext.getInstance("TLSv1.2").apply {
            init(kmf.keyManagers, tmf.trustManagers, java.security.SecureRandom())
        }
    }

    // ─────────────────────────────────────────────────────────────
    // Helpers
    // ─────────────────────────────────────────────────────────────

    private fun prefs() = context.getSharedPreferences("atv_cert_store", Context.MODE_PRIVATE)

    private fun serverCertKey(ip: String) = "server_cert_${ip.replace(".", "_")}"

    companion object {
        fun getFingerprint(cert: X509Certificate): String {
            val digest = java.security.MessageDigest.getInstance("SHA-256")
            return digest.digest(cert.encoded).joinToString(":") { "%02X".format(it) }
        }
    }
}