package com.example.atv_remote.pairing

import android.content.Context
import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyProperties
import android.util.Base64
import android.util.Log
import androidx.security.crypto.EncryptedSharedPreferences
import androidx.security.crypto.MasterKey
import java.math.BigInteger
import java.security.KeyPairGenerator
import java.security.KeyStore
import java.security.MessageDigest
import java.security.PrivateKey
import java.security.cert.CertificateFactory
import java.security.cert.X509Certificate
import java.util.Date
import javax.security.auth.x500.X500Principal

// TEST: Call getClientCertificate() twice → must return same cert both times
// TEST: Call getClientPrivateKey() → must not be null
// TEST: getClientCertificateFingerprint() → must return non-empty string
// TEST: saveServerCertificate("192.168.1.5", cert) then getServerCertificate("192.168.1.5")
//       → must return cert with same encoded bytes
// TEST: clearServerCertificate → getServerCertificate returns null

class CertificateStore(private val context: Context) {

    private val tag = "TvCertStore"
    private val keystoreAlias = "tvremote_client_key"
    private val clientCertPrefKey = "client_certificate_pem"
    private val androidKeyStoreName = "AndroidKeyStore"

    private val encryptedPrefs by lazy {
        Log.d(tag, "Initializing EncryptedSharedPreferences")
        val masterKey = MasterKey.Builder(context)
            .setKeyScheme(MasterKey.KeyScheme.AES256_GCM)
            .build()

        EncryptedSharedPreferences.create(
            context,
            "tv_remote_secure_prefs",
            masterKey,
            EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
            EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM
        )
    }

    // ─── Public API ────────────────────────────────────────────────────────────

    fun getClientCertificate(): X509Certificate {
        Log.d(tag, "getClientCertificate called")
        val pem = encryptedPrefs.getString(clientCertPrefKey, null)
        if (pem != null) {
            Log.d(tag, "Found existing client certificate in EncryptedSharedPreferences")
            return pemToX509(pem)
        }
        Log.d(tag, "No client certificate found, generating new one")
        generateAndStoreClientCertificate()
        val newPem = encryptedPrefs.getString(clientCertPrefKey, null)
            ?: throw IllegalStateException("Certificate generation succeeded but PEM not found")
        return pemToX509(newPem)
    }

    fun getClientPrivateKey(): PrivateKey {
        Log.d(tag, "getClientPrivateKey called")
        val ks = KeyStore.getInstance(androidKeyStoreName).apply { load(null) }
        val key = ks.getKey(keystoreAlias, null) as? PrivateKey
        if (key != null) {
            Log.d(tag, "Found existing private key in AndroidKeyStore")
            return key
        }
        Log.d(tag, "Private key not found, generating new certificate+key pair")
        generateAndStoreClientCertificate()
        return ks.getKey(keystoreAlias, null) as? PrivateKey
            ?: throw IllegalStateException("Key generation succeeded but key not found in AndroidKeyStore")
    }

    fun saveServerCertificate(deviceIp: String, cert: X509Certificate) {
        val key = "server_cert_${sanitizeIp(deviceIp)}"
        val pem = x509ToPem(cert)
        encryptedPrefs.edit().putString(key, pem).apply()
        Log.d(tag, "Saved server certificate for $deviceIp under key $key")
    }

    fun getServerCertificate(deviceIp: String): X509Certificate? {
        val key = "server_cert_${sanitizeIp(deviceIp)}"
        val pem = encryptedPrefs.getString(key, null) ?: run {
            Log.d(tag, "No server certificate found for $deviceIp")
            return null
        }
        Log.d(tag, "Loaded server certificate for $deviceIp")
        return pemToX509(pem)
    }

    fun clearServerCertificate(deviceIp: String) {
        val key = "server_cert_${sanitizeIp(deviceIp)}"
        encryptedPrefs.edit().remove(key).apply()
        Log.d(tag, "Cleared server certificate for $deviceIp (key: $key)")
    }

    fun getClientCertificateFingerprint(): String {
        val cert = getClientCertificate()
        val digest = MessageDigest.getInstance("SHA-256").digest(cert.encoded)
        val hex = digest.joinToString(":") { "%02X".format(it) }
        Log.d(tag, "Client certificate fingerprint: $hex")
        return hex
    }

    // ─── Private Helpers ───────────────────────────────────────────────────────

    private fun generateAndStoreClientCertificate() {
        Log.d(tag, "Generating RSA-2048 key pair in AndroidKeyStore (alias=$keystoreAlias)")

        val notBefore = Date()
        val notAfter = Date(System.currentTimeMillis() + 10L * 365 * 24 * 3600 * 1000)

        val spec = KeyGenParameterSpec.Builder(
            keystoreAlias,
            KeyProperties.PURPOSE_SIGN or KeyProperties.PURPOSE_VERIFY
        )
            .setKeySize(2048)
            .setSignaturePaddings(KeyProperties.SIGNATURE_PADDING_RSA_PKCS1)
            .setDigests(KeyProperties.DIGEST_SHA256)
            .setCertificateSubject(X500Principal("CN=tvremote,O=tvremote"))
            .setCertificateSerialNumber(BigInteger.ONE)
            .setCertificateNotBefore(notBefore)
            .setCertificateNotAfter(notAfter)
            .build()

        val kpg = KeyPairGenerator.getInstance(KeyProperties.KEY_ALGORITHM_RSA, androidKeyStoreName)
        kpg.initialize(spec)
        kpg.generateKeyPair()
        Log.d(tag, "Key pair generated in AndroidKeyStore")

        // The Android KeyStore automatically creates a self-signed certificate for the keypair.
        // We extract it and persist it to EncryptedSharedPreferences.
        val ks = KeyStore.getInstance(androidKeyStoreName).apply { load(null) }
        val cert = ks.getCertificate(keystoreAlias) as X509Certificate
        Log.d(tag, "Extracted self-signed certificate from AndroidKeyStore")

        val pem = x509ToPem(cert)
        encryptedPrefs.edit().putString(clientCertPrefKey, pem).apply()
        Log.d(tag, "Stored client certificate PEM in EncryptedSharedPreferences")
    }

    private fun sanitizeIp(ip: String): String = ip.replace(".", "_")

    private fun pemToX509(pem: String): X509Certificate {
        val stripped = pem
            .replace("-----BEGIN CERTIFICATE-----", "")
            .replace("-----END CERTIFICATE-----", "")
            .replace("\\s".toRegex(), "")
        val der = Base64.decode(stripped, Base64.DEFAULT)
        return CertificateFactory.getInstance("X.509")
            .generateCertificate(der.inputStream()) as X509Certificate
    }

    private fun x509ToPem(cert: X509Certificate): String {
        val encoded = Base64.encodeToString(cert.encoded, Base64.NO_WRAP)
        // Wrap at 64 characters per PEM standard
        val wrapped = encoded.chunked(64).joinToString("\n")
        return "-----BEGIN CERTIFICATE-----\n$wrapped\n-----END CERTIFICATE-----"
    }
}
