package com.example.atv_remote.pairing

import java.security.KeyPairGenerator
import java.security.SecureRandom
import java.security.interfaces.RSAPublicKey
import org.junit.Assert.assertArrayEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Assert.fail
import org.junit.Test

class PairingSecretGeneratorTest {

    @Test
    fun `normalizes valid hex pin`() {
        val normalized = PairingSecretGenerator.normalizeHexPin("e8bbeb")
        assertTrue(normalized == "E8BBEB")
    }

    @Test
    fun `rejects invalid pin format`() {
        try {
            PairingSecretGenerator.normalizeHexPin("12AZ9")
            fail("Expected invalid PIN format exception")
        } catch (_: IllegalArgumentException) {
            // expected
        }
    }

    @Test
    fun `derives deterministic secret for fixture keys`() {
        val clientKey = generatePublicKey(seed = 1234L)
        val serverKey = generatePublicKey(seed = 5678L)

        val noncePin = "00BBEB"
        val firstSecret =
            PairingSecretGenerator.deriveSecretFromKeys(clientKey, serverKey, noncePin)
        val requiredPrefix =
            (firstSecret[0].toInt() and 0xFF).toString(16).uppercase().padStart(2, '0')
        val matchedPin = "${requiredPrefix}BBEB"

        val secondSecret =
            PairingSecretGenerator.deriveSecretFromKeys(clientKey, serverKey, matchedPin)

        assertArrayEquals(firstSecret, secondSecret)
        assertTrue(PairingSecretGenerator.matchesPinPrefix(secondSecret, matchedPin))

        val wrongPrefix =
            ((firstSecret[0].toInt() and 0xFF) xor 0xFF)
                .toString(16)
                .uppercase()
                .padStart(2, '0')
        val wrongPin = "${wrongPrefix}BBEB"
        assertFalse(PairingSecretGenerator.matchesPinPrefix(secondSecret, wrongPin))
    }

    private fun generatePublicKey(seed: Long): RSAPublicKey {
        val random = SecureRandom.getInstance("SHA1PRNG").apply { setSeed(seed) }
        val generator = KeyPairGenerator.getInstance("RSA")
        generator.initialize(1024, random)
        return generator.generateKeyPair().public as RSAPublicKey
    }
}
