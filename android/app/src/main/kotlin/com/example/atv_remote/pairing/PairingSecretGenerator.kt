package com.example.atv_remote.pairing

import java.security.MessageDigest
import java.security.cert.X509Certificate
import java.security.interfaces.RSAPublicKey

internal object PairingSecretGenerator {
    private val pinRegex = Regex("^[0-9A-F]{6}$")

    fun normalizeHexPin(pin: String): String {
        val normalized = pin.trim().uppercase()
        require(normalized.matches(pinRegex)) {
            "PIN must be exactly 6 hexadecimal characters (0-9, A-F)."
        }
        return normalized
    }

    fun deriveSecret(
        clientCert: X509Certificate,
        serverCert: X509Certificate,
        normalizedPin: String
    ): ByteArray {
        val clientKey = requireRsaPublicKey(clientCert, "client")
        val serverKey = requireRsaPublicKey(serverCert, "server")
        return deriveSecretFromKeys(clientKey, serverKey, normalizedPin)
    }

    internal fun deriveSecretFromKeys(
        clientKey: RSAPublicKey,
        serverKey: RSAPublicKey,
        normalizedPin: String
    ): ByteArray {
        val nonce = hexToBytes(normalizedPin.substring(2))

        val digest = MessageDigest.getInstance("SHA-256")
        digest.update(stripLeadingNullBytes(clientKey.modulus.abs().toByteArray()))
        digest.update(stripLeadingNullBytes(clientKey.publicExponent.abs().toByteArray()))
        digest.update(stripLeadingNullBytes(serverKey.modulus.abs().toByteArray()))
        digest.update(stripLeadingNullBytes(serverKey.publicExponent.abs().toByteArray()))
        digest.update(nonce)
        return digest.digest()
    }

    fun matchesPinPrefix(secret: ByteArray, normalizedPin: String): Boolean {
        val expectedPrefix = normalizedPin.substring(0, 2).toInt(16)
        return secret.isNotEmpty() && ((secret[0].toInt() and 0xFF) == expectedPrefix)
    }

    private fun requireRsaPublicKey(cert: X509Certificate, label: String): RSAPublicKey {
        val key = cert.publicKey
        require(key is RSAPublicKey) {
            "Expected RSA public key for $label certificate."
        }
        return key
    }

    private fun stripLeadingNullBytes(input: ByteArray): ByteArray {
        var offset = 0
        while (offset < input.size - 1 && input[offset] == 0.toByte()) {
            offset++
        }
        return input.copyOfRange(offset, input.size)
    }

    private fun hexToBytes(hex: String): ByteArray {
        require(hex.matches(Regex("^[0-9A-Fa-f]+$"))) { "Hex input contains invalid characters." }
        val normalized = if (hex.length % 2 == 0) hex else "0$hex"
        val out = ByteArray(normalized.length / 2)
        for (i in out.indices) {
            val hi = Character.digit(normalized[i * 2], 16)
            val lo = Character.digit(normalized[i * 2 + 1], 16)
            require(hi >= 0 && lo >= 0) { "Invalid hex data." }
            out[i] = ((hi shl 4) + lo).toByte()
        }
        return out
    }
}
