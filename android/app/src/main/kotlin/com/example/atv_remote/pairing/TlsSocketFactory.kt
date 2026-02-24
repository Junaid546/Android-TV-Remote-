package com.example.atv_remote.pairing

import android.util.Log
import java.net.InetSocketAddress
import java.security.SecureRandom
import java.security.cert.X509Certificate
import javax.net.ssl.SNIHostName
import javax.net.ssl.SSLContext
import javax.net.ssl.SSLSocket
import javax.net.ssl.X509TrustManager

class TlsHandshakeException(message: String, cause: Throwable? = null) :
    Exception(message, cause)

object TlsSocketFactory {

    private const val TAG = "TvTLS"

    // ─────────────────────────────────────────────────────────────
    // PAIRING SOCKET — port 6467
    // mTLS: client presents cert, accepts any server cert (captures it).
    // ─────────────────────────────────────────────────────────────
    fun createPairingSocket(
        host: String,
        port: Int = 6467,
        certStore: CertificateStore,
        onServerCertCaptured: (X509Certificate) -> Unit
    ): SSLSocket {
        Log.d(TAG, "Creating mTLS PAIRING socket (simplified) → $host:$port")

        var capturedCert: X509Certificate? = null

        // 1. Client Identity
        val clientCert = certStore.getClientCertificate()
        val clientKey = certStore.getClientPrivateKey()

        val clientKs = java.security.KeyStore.getInstance(
            java.security.KeyStore.getDefaultType()
        ).apply {
            load(null)
            setKeyEntry("client", clientKey, null, arrayOf(clientCert))
        }

        val kmf = javax.net.ssl.KeyManagerFactory.getInstance(
            javax.net.ssl.KeyManagerFactory.getDefaultAlgorithm()
        ).apply { init(clientKs, null) }

        // 2. Trust Model: Accept self-signed server certificates
        val trustCapture = object : X509TrustManager {
            override fun checkClientTrusted(chain: Array<out X509Certificate>?, authType: String?) {}
            override fun checkServerTrusted(chain: Array<out X509Certificate>?, authType: String?) {
                capturedCert = chain?.firstOrNull()
                capturedCert?.let {
                    Log.d(TAG, "Server Cert Fingerprint: " + CertificateStore.getFingerprint(it))
                }
            }
            override fun getAcceptedIssuers(): Array<X509Certificate> = emptyArray()
        }

        // 3. TLS Configuration: Force TLSv1.2 explicitly (Android TV rejects TLSv1.3 or uses RSA-PSS which crashes)
        val sslContext = SSLContext.getInstance("TLSv1.2")
        sslContext.init(kmf.keyManagers, arrayOf(trustCapture), SecureRandom())

        // 6️⃣ Connect + handshake with retry logic
        var finalSocket: SSLSocket? = null
        var lastException: Exception? = null

        for (attempt in 1..3) {
            try {
                Log.d(TAG, "Connection attempt $attempt...")
                val socket = sslContext.socketFactory.createSocket() as SSLSocket
                
                // Basic config
                socket.useClientMode = true
                socket.soTimeout = 15_000
                socket.tcpNoDelay = true
                socket.keepAlive = true

                // Strictly enforce TLS 1.2 only. 
                // TLS 1.3 uses RSA-PSS which crashes Conscrypt.
                val supportedProtocols = socket.supportedProtocols.toSet()
                if (supportedProtocols.contains("TLSv1.2")) {
                    socket.enabledProtocols = arrayOf("TLSv1.2")
                }

                socket.enabledCipherSuites = socket.supportedCipherSuites

                // Setup parameters safely
                try {
                    val params = socket.sslParameters
                    params.serverNames = listOf(SNIHostName(host))
                    // FIX: Remove endpointIdentificationAlgorithm = "HTTPS" to allow TOFU with IP addresses
                    params.endpointIdentificationAlgorithm = null 
                    socket.sslParameters = params
                } catch (e: Exception) {
                    Log.w(TAG, "SNI / SSL param set failed: ${e.message}")
                }

                socket.connect(InetSocketAddress(host, port), 10_000)
                socket.startHandshake()
                
                finalSocket = socket
                break
            } catch (e: Exception) {
                Log.w(TAG, "Attempt $attempt failed: ${e.message}")
                lastException = e
                // exponential backoff
                Thread.sleep((attempt * 500).toLong())
            }
        }
        
        val pairingSocket = finalSocket ?: throw Exception("TLS handshake failed after retries for $host:$port", lastException)

        // Logging
        val session = pairingSocket.session
        Log.d(TAG, "Handshake OK! TLS=${session.protocol}, Cipher=${session.cipherSuite}")

        val cert = capturedCert ?: runCatching {
            pairingSocket.session.peerCertificates.firstOrNull() as? X509Certificate
        }.getOrNull() ?: throw Exception("No server certificate received from $host")

        val fingerprint = CertificateStore.getFingerprint(cert)
        Log.d(TAG, "Peer certificate fingerprint: $fingerprint")

        onServerCertCaptured(cert)
        Log.d(TAG, "PAIRING TLS established. Server cert captured.")
        
        return pairingSocket
    }

    // ─────────────────────────────────────────────────────────────
    // REMOTE SOCKET — port 6466
    // Mutual TLS. Client presents cert, trusts only stored server cert.
    // ─────────────────────────────────────────────────────────────
    fun createRemoteSocket(
        host: String,
        port: Int = 6466,
        certStore: CertificateStore
    ): SSLSocket {
        Log.d(TAG, "Creating REMOTE socket → $host:$port")

        // certStore builds the full mTLS context internally
        val sslContext = certStore.createMutualTlsContext(host)

        val socket = sslContext.socketFactory.createSocket() as SSLSocket

        socket.useClientMode = true
        socket.soTimeout = 35_000
        socket.tcpNoDelay = true
        socket.keepAlive = true

        val preferredCiphers = arrayOf(
            "TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA",
            "TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA",
            "TLS_RSA_WITH_AES_128_CBC_SHA",
            "TLS_RSA_WITH_AES_256_CBC_SHA",
            "TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA",
            "TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA"
        )
        val supportedCiphers = socket.supportedCipherSuites.toSet()
        val enabledCiphers = preferredCiphers.filter { it in supportedCiphers }.toTypedArray()
        
        if (enabledCiphers.isEmpty()) {
            Log.w(TAG, "No preferred ciphers available, using all supported")
        } else {
            socket.enabledCipherSuites = enabledCiphers
            Log.d(TAG, "Enabled ciphers: ${enabledCiphers.joinToString()}")
        }

        // Strictly enforce TLS 1.2
        val supportedProtocols = socket.supportedProtocols.toSet()
        if (supportedProtocols.contains("TLSv1.2")) {
            socket.enabledProtocols = arrayOf("TLSv1.2")
        }
        Log.d(TAG, "Enabled protocols: TLSv1.2")

        // NO SNI or ALPN
        
        socket.enabledCipherSuites.forEach { 
            Log.d("${TAG}_DEBUG", "Cipher: $it") 
        }

        try {
            socket.connect(InetSocketAddress(host, port), 10_000)
            socket.startHandshake()
            Log.d(TAG, "Handshake complete. Cipher: ${socket.session.cipherSuite}")
            Log.d(TAG, "Protocol: ${socket.session.protocol}")
        } catch (e: Exception) {
            runCatching { socket.close() }
            throw TlsHandshakeException("Remote TLS handshake failed for $host:$port — ${e.message}", e)
        }

        Log.d(TAG, "REMOTE mTLS established.")
        return socket
    }
}