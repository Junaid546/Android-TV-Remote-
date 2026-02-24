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
                    .setProtocolVersion(2)
                    .setStatus(200)
                    .setPairingRequest(
                        PairingRequest.newBuilder()
                            .setServiceName("ATV Remote")
                            .setClientName("ATV Remote")
                            .build()
                    )
                    .build()
                writeMessage(request)
                val reqAck = readMessage(2000)
                Log.d(tag, "Request Ack status: ${reqAck?.status}")

                // Step 2 — Send PairingOption
                val option = PairingMessage.newBuilder()
                    .setProtocolVersion(2)
                    .setStatus(200)
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
                val optAck = readMessage(2000)
                Log.d(tag, "Option Ack status: ${optAck?.status}")

                // Step 3 — Send PairingConfiguration
                val config = PairingMessage.newBuilder()
                    .setProtocolVersion(2)
                    .setStatus(200)
                    .setPairingConfiguration(
                        PairingConfiguration.newBuilder()
                            .setClientRole(RoleType.ROLE_TYPE_INPUT)
                            .setClientInputEncoding(
                                PairingEncoding.newBuilder()
                                    .setType(EncodingType.ENCODING_TYPE_HEXADECIMAL)
                                    .setSymbolLength(6)
                                    .build()
                            )
                            .build()
                    )
                    .build()
                writeMessage(config)
                val confAck = readMessage(2000)
                Log.d(tag, "Config Ack status: ${confAck?.status}")
                
                // Read whatever the TV sent (Option, Config) to clear the buffer before PIN
                var tempMsg = readMessage(1000)
                while (tempMsg != null) {
                    Log.d(tag, "Cleared message from buffer")
                    tempMsg = readMessage(1000)
                }

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
                        .setProtocolVersion(2)
                        .setStatus(200)
                        .setPairingSecret(
                            PairingSecret.newBuilder()
                                .setSecret(ByteString.copyFrom(secretBytes))
                                .build()
                        )
                        .build()

                    writeMessage(secretMsg)
                    Log.d(tag, "PairingSecret sent")

                    val result = readMessage()
                    Log.d(tag, "PairingResult: ${result?.status}")

                    if (result?.status == 200) {
                        certStore.setClientFirst(currentDeviceIp, isClientFirst)
                        certStore.saveServerCertificate(currentDeviceIp, serverCert)
                        Log.i(tag, "Pairing SUCCESS for $currentDeviceIp")
                        
                        delay(1000) // Defined 1s delay after pairing SUCCESS
                        
                        _state.value = PairingState.Success
                        return@withContext
                    } else if (result?.status == 401 && attemptCount == 1) {
                        Log.w(tag, "STATUS_BAD_SECRET (401). Retrying with flipped cert order.")
                        isClientFirst = !isClientFirst
                        attemptCount++
                        continue
                    } else {
                        fail("Pairing error: ${result?.status}", if (result?.status == 401) "WRONG_PIN" else "PAIRING_ERROR")
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
        val out = output ?: throw IllegalStateException("Output stream is null")
        msg.writeDelimitedTo(out)
        out.flush()
    }

    private fun readMessage(timeoutMs: Int = 0): PairingMessage? {
        val inp = input ?: throw IllegalStateException("Input stream is null")
        val oldTimeout = socket?.soTimeout ?: 0

        if (timeoutMs > 0) socket?.soTimeout = timeoutMs

        try {
            // parseDelimitedFrom automatically reads the varint length and the exact payload
            return PairingMessage.parseDelimitedFrom(inp)
        } catch (e: java.net.SocketTimeoutException) {
            Log.w(tag, "Timeout reading message, assuming TV waiting...")
            return null
        } catch (e: Exception) {
            Log.e(tag, "Error reading message", e)
            return null
        } finally {
            if (timeoutMs > 0) socket?.soTimeout = oldTimeout
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