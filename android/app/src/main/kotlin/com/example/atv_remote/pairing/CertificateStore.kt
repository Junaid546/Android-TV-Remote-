package com.example.atv_remote.pairing

import android.content.Context
import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyProperties
import android.util.Base64
import android.util.Log
import java.io.ByteArrayInputStream
import java.security.KeyPairGenerator
import java.security.KeyStore
import java.security.PrivateKey
import java.security.cert.CertificateFactory
import java.security.cert.X509Certificate
import java.security.spec.ECGenParameterSpec
import java.util.Date
import javax.security.auth.x500.X500Principal

class CertificateStore(private val context: Context) {

    private val tag = "TvCertStore"
    private val androidKeyStore = "AndroidKeyStore"

    // One shared identity for all devices
    private val clientAlias = "atv_remote_client_identity"

    // ─────────────────────────────────────────────────────────────
    // Client Identity (software-based to bypass AndroidKeyStore hardware crashes)
    // ─────────────────────────────────────────────────────────────

    fun generateIdentityIfNeeded() {
        if (prefs().contains("client_cert") && prefs().contains("client_key")) {
            return // Already generated
        }

        Log.i(tag, "Generating software-based RSA-2048 client identity...")

        // 1. Generate RSA-2048 KeyPair in software (bypasses AndroidKeyStore strictness)
        val kpg = KeyPairGenerator.getInstance("RSA")
        kpg.initialize(2048)
        val keyPair = kpg.generateKeyPair()

        // 2. Generate Self-Signed X.509 Certificate using BouncyCastle
        val now = System.currentTimeMillis()
        val startDate = Date(now - 24 * 60 * 60 * 1000) // Yesterday
        val endDate = Date(now + 10L * 365 * 24 * 60 * 60 * 1000) // 10 years

        val certBuilder = org.bouncycastle.cert.jcajce.JcaX509v3CertificateBuilder(
            org.bouncycastle.asn1.x500.X500Name("CN=AndroidTVRemoteClient"),
            java.math.BigInteger.valueOf(now),
            startDate,
            endDate,
            org.bouncycastle.asn1.x500.X500Name("CN=AndroidTVRemoteClient"),
            keyPair.public
        )

        val contentSigner = org.bouncycastle.operator.jcajce.JcaContentSignerBuilder("SHA256WithRSAEncryption")
            .build(keyPair.private)

        val certHolder = certBuilder.build(contentSigner)
        val cert = org.bouncycastle.cert.jcajce.JcaX509CertificateConverter()
            .setProvider(org.bouncycastle.jce.provider.BouncyCastleProvider())
            .getCertificate(certHolder)

        // 3. Save to SharedPreferences as Base64
        prefs().edit()
            .putString("client_cert", Base64.encodeToString(cert.encoded, Base64.NO_WRAP))
            .putString("client_key", Base64.encodeToString(keyPair.private.encoded, Base64.NO_WRAP))
            .apply()

        Log.i(tag, "Software identity generated: ${getClientCertificateFingerprint()}")
    }

    fun getClientCertificate(): X509Certificate {
        val encoded = prefs().getString("client_cert", null) 
            ?: throw IllegalStateException("Client cert not found")
        val bytes = Base64.decode(encoded, Base64.NO_WRAP)
        return CertificateFactory.getInstance("X.509")
            .generateCertificate(ByteArrayInputStream(bytes)) as X509Certificate
    }

    fun getClientPrivateKey(): PrivateKey {
        val encoded = prefs().getString("client_key", null)
            ?: throw IllegalStateException("Client key not found")
        val bytes = Base64.decode(encoded, Base64.NO_WRAP)
        val spec = java.security.spec.PKCS8EncodedKeySpec(bytes)
        return java.security.KeyFactory.getInstance("RSA").generatePrivate(spec)
    }

    fun getClientCertificateFingerprint(): String {
        val cert = getClientCertificate()
        val digest = java.security.MessageDigest.getInstance("SHA-256")
        return digest.digest(cert.encoded).joinToString(":") { "%02X".format(it) }
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