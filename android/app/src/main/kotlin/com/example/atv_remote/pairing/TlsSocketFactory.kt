package com.example.atv_remote.pairing

import android.util.Log
import java.net.InetSocketAddress
import java.security.KeyStore
import java.security.SecureRandom
import java.security.cert.X509Certificate
import javax.net.ssl.HandshakeCompletedListener
import javax.net.ssl.KeyManagerFactory
import javax.net.ssl.SSLContext
import javax.net.ssl.SSLSocket
import javax.net.ssl.TrustManagerFactory
import javax.net.ssl.X509TrustManager

class TlsHandshakeException(message: String) : Exception(message)

object TlsSocketFactory {

    private val tag = "TvCertStore"

    /**
     * Creates an unauthenticated TLS socket for PAIRING (port 6467).
     * Accepts ANY server certificate — used to capture the TV's certificate.
     * No client certificate is presented in this phase.
     *
     * [onServerCertCaptured] is invoked synchronously on handshake completion
     * with the TV's X509Certificate, which must immediately be persisted.
     */
    fun createPairingSocket(
        host: String,
        port: Int = 6467,
        certStore: CertificateStore,
        onServerCertCaptured: (X509Certificate) -> Unit
    ): SSLSocket {
        Log.d(tag, "createPairingSocket → $host:$port")

        val acceptAllTrustManager = object : X509TrustManager {
            override fun checkClientTrusted(chain: Array<out X509Certificate>?, authType: String?) {}
            override fun checkServerTrusted(chain: Array<out X509Certificate>?, authType: String?) {
                // Accept all — we capture the cert, not verify it
            }
            override fun getAcceptedIssuers(): Array<X509Certificate> = emptyArray()
        }

        val sslContext = SSLContext.getInstance("TLS")
        // null KeyManagers → no client certificate presented
        sslContext.init(null, arrayOf(acceptAllTrustManager), SecureRandom())

        val socket = sslContext.socketFactory.createSocket() as SSLSocket
        socket.soTimeout = 30_000
        socket.tcpNoDelay = true
        socket.useClientMode = true

        val handshakeListener = HandshakeCompletedListener { event ->
            try {
                val serverCert = event.peerCertificates?.firstOrNull() as? X509Certificate
                    ?: throw TlsHandshakeException("No peer certificate received from $host")
                Log.d(tag, "Pairing handshake complete, captured server cert from $host")
                onServerCertCaptured(serverCert)
            } catch (e: TlsHandshakeException) {
                Log.e(tag, "HandshakeCompletedListener error: ${e.message}", e)
            }
        }
        socket.addHandshakeCompletedListener(handshakeListener)

        Log.d(tag, "Connecting pairing socket to $host:$port")
        socket.connect(InetSocketAddress(host, port), 10_000)
        socket.startHandshake()

        Log.d(tag, "Pairing socket established to $host:$port")
        return socket
    }

    /**
     * Creates a mutually-authenticated TLS socket for REMOTE CONTROL (port 6466).
     * - Presents the app's client certificate to the TV.
     * - Trusts ONLY the stored server certificate for this specific device.
     *
     * Throws [TlsHandshakeException] if no server certificate is stored (device not paired).
     */
    fun createRemoteSocket(
        host: String,
        port: Int = 6466,
        certStore: CertificateStore
    ): SSLSocket {
        Log.d(tag, "createRemoteSocket → $host:$port")

        // ── Key Manager: present client cert ────────────────────────────────
        val clientCert = certStore.getClientCertificate()
        val clientKey = certStore.getClientPrivateKey()

        val clientKeyStore = KeyStore.getInstance(KeyStore.getDefaultType()).apply { load(null) }
        // null password — key is backed by AndroidKeyStore, not extracted
        clientKeyStore.setKeyEntry("client", clientKey, null, arrayOf(clientCert))

        val kmf = KeyManagerFactory.getInstance(KeyManagerFactory.getDefaultAlgorithm())
        kmf.init(clientKeyStore, null)
        Log.d(tag, "KeyManagerFactory initialised with client certificate")

        // ── Trust Manager: trust ONLY the stored server cert ────────────────
        val serverCert = certStore.getServerCertificate(host)
            ?: throw TlsHandshakeException("No stored certificate for $host. Pair with the device first.")

        val trustStore = KeyStore.getInstance(KeyStore.getDefaultType()).apply { load(null) }
        trustStore.setCertificateEntry("server", serverCert)

        val tmf = TrustManagerFactory.getInstance(TrustManagerFactory.getDefaultAlgorithm())
        tmf.init(trustStore)
        Log.d(tag, "TrustManagerFactory initialised: trusting stored cert for $host")

        // ── SSLContext ───────────────────────────────────────────────────────
        val sslContext = SSLContext.getInstance("TLS")
        sslContext.init(kmf.keyManagers, tmf.trustManagers, SecureRandom())

        val socket = sslContext.socketFactory.createSocket() as SSLSocket
        socket.soTimeout = 35_000
        socket.tcpNoDelay = true
        socket.keepAlive = true
        socket.useClientMode = true

        Log.d(tag, "Connecting remote socket to $host:$port")
        socket.connect(InetSocketAddress(host, port), 10_000)
        socket.startHandshake()

        Log.d(tag, "Remote (mTLS) socket established to $host:$port")
        return socket
    }
}
