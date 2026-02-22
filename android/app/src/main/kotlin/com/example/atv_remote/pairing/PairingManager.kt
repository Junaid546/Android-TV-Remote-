package com.example.atv_remote.pairing

import android.util.Log
import com.google.protobuf.ByteString
import com.tvremote.app.proto.PairingProto.*
import kotlinx.coroutines.*
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import java.io.DataInputStream
import java.io.DataOutputStream
import java.security.MessageDigest
import java.security.cert.X509Certificate
import javax.net.ssl.SSLSocket

sealed class PairingState {
    object Idle : PairingState()
    data class Connecting(val ip: String) : PairingState()
    object AwaitingPin : PairingState()
    data class Verifying(val ip: String) : PairingState()
    object Success : PairingState()
    data class Failed(val reason: String, val code: String = "UNKNOWN") : PairingState()
}

class PairingManager(
    private val certStore: CertificateStore,
    private val scope: CoroutineScope
) {
    private val tag = "TvPairing"

    private val _state = MutableStateFlow<PairingState>(PairingState.Idle)
    val state: StateFlow<PairingState> = _state.asStateFlow()

    private val _pinExpiry = MutableStateFlow(0)
    val pinExpiry: StateFlow<Int> = _pinExpiry.asStateFlow()

    private var socket: SSLSocket? = null
    private var input: DataInputStream? = null
    private var output: DataOutputStream? = null
    private var capturedServerCert: X509Certificate? = null
    private var currentDeviceIp: String = ""
    private var pinExpiryJob: Job? = null

    // ─────────────────────────────────────────────────────────────
    // Start Pairing
    // ─────────────────────────────────────────────────────────────

    suspend fun startPairing(ip: String, deviceName: String) {
        currentDeviceIp = ip
        _state.value = PairingState.Connecting(ip)

        withContext(Dispatchers.IO) {
            try {
                // Ensure client identity exists (idempotent)
                certStore.generateIdentityIfNeeded()

                // Connect and capture server cert
                val newSocket = TlsSocketFactory.createPairingSocket(
                    host = ip,
                    certStore = certStore,
                    onServerCertCaptured = { cert ->
                        capturedServerCert = cert
                        Log.d(tag, "Server cert captured for $ip")
                    }
                )

                socket = newSocket
                output = DataOutputStream(newSocket.outputStream)
                input = DataInputStream(newSocket.inputStream)

                // Step 1 — Send PairingRequest
                val request = PairingMessage.newBuilder()
                    .setPairingRequest(
                        PairingRequest.newBuilder()
                            .setServiceName("androidtvremote2")
                            .setClientName(deviceName)
                            .build()
                    )
                    .build()

                writeMessage(request)
                Log.d(tag, "PairingRequest sent")

                // Step 2 — Read response
                val resp1 = readMessage(5000)
                Log.d(tag, "Response 1 status: ${resp1?.status?.code ?: "TIMEOUT"}")

                // Step 3 — Send PairingOption
                val option = PairingMessage.newBuilder()
                    .setPairingOption(
                        PairingOption.newBuilder()
                            .setPreferredRole(RoleType.ROLE_TYPE_INPUT)
                            .addInputEncodings(
                                PairingEncoding.newBuilder()
                                    .setType(EncodingType.ENCODING_TYPE_HEXADECIMAL)
                                    .setSymbolLength(6)
                                    .build()
                            )
                            .build()
                    )
                    .build()

                writeMessage(option)
                Log.d(tag, "PairingOption sent")

                // Step 4 — Read option ack
                val resp2 = readMessage(5000)
                Log.d(tag, "Response 2 status: ${resp2?.status?.code ?: "TIMEOUT"}")

                // Ready for PIN
                _state.value = PairingState.AwaitingPin
                startPinCountdown()

            } catch (e: Exception) {
                Log.e(tag, "startPairing failed", e)
                fail("Connection failed: ${e.message}", "CONNECTION_ERROR")
            }
        }
    }

    // Socket creation delegated to TlsSocketFactory.createPairingSocket()

    // ─────────────────────────────────────────────────────────────
    // Submit PIN
    // ─────────────────────────────────────────────────────────────

    suspend fun submitPin(pin: String) {
        if (_state.value !is PairingState.AwaitingPin) {
            Log.w(tag, "submitPin called in wrong state: ${_state.value}")
            return
        }

        pinExpiryJob?.cancel()
        _state.value = PairingState.Verifying(currentDeviceIp)

        withContext(Dispatchers.IO) {
            try {
                val serverCert = capturedServerCert
                    ?: throw IllegalStateException("Server cert not captured")

                val clientCert = certStore.getClientCertificate()

                var isClientFirst = certStore.isClientFirst(currentDeviceIp)
                var attemptCount = 1

                while (attemptCount <= 2) {
                    val digest = MessageDigest.getInstance("SHA-256")
                    if (isClientFirst) {
                        digest.update(clientCert.encoded)   // client FIRST
                        digest.update(serverCert.encoded)   // server SECOND
                        Log.i(tag, "Secret order used: CLIENT_SERVER")
                    } else {
                        digest.update(serverCert.encoded)   // server FIRST
                        digest.update(clientCert.encoded)   // client SECOND
                        Log.i(tag, "Secret order used: SERVER_CLIENT")
                    }
                    val secretBytes = digest.digest()

                    Log.d(tag, "Client fingerprint: ${certStore.getClientCertificateFingerprint()}")
                    Log.d(tag, "Server fingerprint: ${CertificateStore.getFingerprint(serverCert)}")
                    Log.d(tag, "Secret first 8: ${secretBytes.joinToString("") { "%02x".format(it) }.take(8).uppercase()}")
                    Log.d(tag, "PIN entered by user: $pin (should match first 6 hex)")

                    val secretMsg = PairingMessage.newBuilder()
                        .setPairingSecret(
                            PairingSecret.newBuilder()
                                .setSecret(ByteString.copyFrom(secretBytes))
                                .build()
                        )
                        .build()

                    writeMessage(secretMsg)
                    Log.d(tag, "PairingSecret sent")

                    val result = readMessage()
                    Log.d(tag, "PairingResult: ${result?.status?.code}")

                    if (result?.status?.code == RpcStatus.STATUS_OK) {
                        certStore.setClientFirst(currentDeviceIp, isClientFirst)
                        certStore.saveServerCertificate(currentDeviceIp, serverCert)
                        Log.i(tag, "Pairing SUCCESS for $currentDeviceIp")
                        
                        delay(1000) // Defined 1s delay after pairing SUCCESS
                        
                        _state.value = PairingState.Success
                        return@withContext
                    } else if (result?.status?.code == RpcStatus.STATUS_BAD_SECRET && attemptCount == 1) {
                        Log.w(tag, "STATUS_BAD_SECRET. Retrying with flipped cert order.")
                        isClientFirst = !isClientFirst
                        attemptCount++
                        continue
                    } else {
                        fail("Pairing error: ${result?.status?.code}", if (result?.status?.code == RpcStatus.STATUS_BAD_SECRET) "WRONG_PIN" else "PAIRING_ERROR")
                        return@withContext
                    }
                }

            } catch (e: Exception) {
                Log.e(tag, "submitPin failed", e)
                fail("PIN submission error: ${e.message}", "SUBMIT_ERROR")
            } finally {
                closeSocket()
            }
        }
    }

    // ─────────────────────────────────────────────────────────────
    // PIN Countdown
    // ─────────────────────────────────────────────────────────────

    private fun startPinCountdown(seconds: Int = 60) {
        _pinExpiry.value = seconds
        pinExpiryJob?.cancel()
        pinExpiryJob = scope.launch {
            for (i in seconds downTo 0) {
                _pinExpiry.value = i
                if (i == 0) {
                    Log.w(tag, "PIN expired")
                    fail("PIN expired. Please try again.", "PIN_EXPIRED")
                    break
                }
                delay(1_000)
            }
        }
    }

    // ─────────────────────────────────────────────────────────────
    // Cancel
    // ─────────────────────────────────────────────────────────────

    fun cancel() {
        pinExpiryJob?.cancel()
        closeSocket()
        capturedServerCert = null
        _state.value = PairingState.Idle
        Log.d(tag, "Pairing cancelled")
    }

    // ─────────────────────────────────────────────────────────────
    // Message Framing
    // ─────────────────────────────────────────────────────────────

    private fun writeMessage(msg: PairingMessage) {
        val bytes = msg.toByteArray()
        val out = output ?: throw IllegalStateException("Output stream is null")

        if (bytes.size > 0xFFFF) throw IllegalArgumentException("Message too large: ${bytes.size}")

        out.write((bytes.size shr 8) and 0xFF)   // high byte
        out.write(bytes.size and 0xFF)            // low byte
        out.write(bytes)
        out.flush()
    }

    private fun readMessage(timeoutMs: Int = 0): PairingMessage? {
        val inp = input ?: throw IllegalStateException("Input stream is null")
        val oldTimeout = socket?.soTimeout ?: 0
        
        if (timeoutMs > 0) {
            socket?.soTimeout = timeoutMs
        }

        try {
            val high = inp.read()
            val low = inp.read()

            if (high == -1 || low == -1) throw java.io.EOFException("Stream closed by TV")

            val length = (high shl 8) or low

            if (length <= 0 || length > 0xFFFF) {
                throw java.io.IOException("Invalid message length: $length")
            }

            Log.d(tag, "Read raw bytes length: $length")

            val buffer = ByteArray(length)
            var offset = 0
            while (offset < length) {
                val read = inp.read(buffer, offset, length - offset)
                if (read == -1) throw java.io.EOFException("Stream closed mid-read")
                offset += read
            }

            return PairingMessage.parseFrom(buffer)
        } catch (e: java.net.SocketTimeoutException) {
            Log.w(tag, "Timeout reading message, assuming TV waiting...")
            return null
        } finally {
            if (timeoutMs > 0) {
                socket?.soTimeout = oldTimeout
            }
        }
    }

    // ─────────────────────────────────────────────────────────────
    // Helpers
    // ─────────────────────────────────────────────────────────────

    private fun fail(reason: String, code: String = "UNKNOWN") {
        Log.e(tag, "FAILED [$code]: $reason")
        closeSocket()
        _state.value = PairingState.Failed(reason, code)
    }

    private fun closeSocket() {
        pinExpiryJob?.cancel()
        runCatching { output?.close() }
        runCatching { input?.close() }
        runCatching { socket?.close() }
        socket = null
        input = null
        output = null
    }
}