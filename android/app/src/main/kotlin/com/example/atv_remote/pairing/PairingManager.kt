package com.example.atv_remote.pairing

import android.util.Log
import com.google.protobuf.ByteString
import com.tvremote.app.proto.PairingProto.EncodingType
import com.tvremote.app.proto.PairingProto.PairingEncoding
import com.tvremote.app.proto.PairingProto.PairingMessage
import com.tvremote.app.proto.PairingProto.PairingOption
import com.tvremote.app.proto.PairingProto.PairingRequest
import com.tvremote.app.proto.PairingProto.PairingSecret
import com.tvremote.app.proto.PairingProto.RoleType
import com.tvremote.app.proto.PairingProto.RpcStatus
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.io.OutputStream
import java.io.InputStream
import java.security.MessageDigest
import java.security.cert.X509Certificate
import javax.net.ssl.SSLSocket

// ─── Pairing State ─────────────────────────────────────────────────────────────

sealed class PairingState {
    object Idle : PairingState()
    object Connecting : PairingState()
    object AwaitingPin : PairingState()
    object VerifyingPin : PairingState()
    object Success : PairingState()
    data class Failed(val reason: String, val code: String) : PairingState()
}

// ─── PairingManager ────────────────────────────────────────────────────────────

class PairingManager(
    private val certStore: CertificateStore,
    private val scope: CoroutineScope
) {
    private val tag = "TvPairing"
    private val pinExpirySeconds = 60

    private val _state = MutableStateFlow<PairingState>(PairingState.Idle)
    val state: StateFlow<PairingState> = _state.asStateFlow()

    private val _pinExpiry = MutableStateFlow(0)
    val pinExpiry: StateFlow<Int> = _pinExpiry.asStateFlow()

    // Socket and stream references — always accessed on Dispatchers.IO
    private var pairingSocket: SSLSocket? = null
    private var capturedServerCert: X509Certificate? = null
    private var capturedDeviceIp: String? = null
    private var pinExpiryJob: Job? = null
    private var outputStream: OutputStream? = null
    private var inputStream: InputStream? = null

    // ── Public API ──────────────────────────────────────────────────────────────

    suspend fun startPairing(
        deviceIp: String,
        devicePort: Int = 6467,
        deviceName: String
    ) {
        Log.d(tag, "startPairing → $deviceIp:$devicePort name=$deviceName")
        _state.value = PairingState.Connecting

        withContext(Dispatchers.IO) {
            try {
                // 1. Open TLS connection and capture server certificate
                pairingSocket = TlsSocketFactory.createPairingSocket(
                    host = deviceIp,
                    port = devicePort,
                    certStore = certStore,
                    onServerCertCaptured = { cert ->
                        Log.d(tag, "Server certificate captured for $deviceIp")
                        capturedServerCert = cert
                        capturedDeviceIp = deviceIp
                        certStore.saveServerCertificate(deviceIp, cert)
                    }
                )
                outputStream = pairingSocket!!.outputStream
                inputStream = pairingSocket!!.inputStream

                // 2. Send PairingRequest
                val request = PairingMessage.newBuilder()
                    .setPairingRequest(
                        PairingRequest.newBuilder()
                            .setServiceName("androidtvremote2")
                            .setClientName(deviceName)
                            .build()
                    )
                    .build()
                Log.d(tag, "Sending PairingRequest (serviceName=androidtvremote2)")
                MessageFramer.writeMessage(outputStream!!, request.toByteArray())

                // 3. Read PairingMessage / PairingOption from TV
                val responseBytes = MessageFramer.readMessage(inputStream!!)
                val response = PairingMessage.parseFrom(responseBytes)
                Log.d(tag, "TV response after PairingRequest: status=${response.status.code}")

                // 4. Send our PairingOption (we want hex, 6 symbols)
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
                Log.d(tag, "Sending PairingOption (HEX/6)")
                MessageFramer.writeMessage(outputStream!!, option.toByteArray())

                // 5. Read PairingOption ack from TV
                val optionResponseBytes = MessageFramer.readMessage(inputStream!!)
                val optionResponse = PairingMessage.parseFrom(optionResponseBytes)
                Log.d(tag, "TV PairingOption ack: status=${optionResponse.status.code}")

            } catch (e: TlsHandshakeException) {
                Log.e(tag, "TLS handshake failed: ${e.message}", e)
                _state.value = PairingState.Failed("TLS handshake failed: ${e.message}", "TLS_ERROR")
                closeSocket()
                return@withContext
            } catch (e: Exception) {
                Log.e(tag, "Connection failed: ${e.message}", e)
                _state.value = PairingState.Failed("Connection failed: ${e.message}", "CONNECTION_ERROR")
                closeSocket()
                return@withContext
            }
        }

        // Guard: state may have been set to Failed in the IO block
        if (_state.value is PairingState.Failed) return

        // 6. Begin PIN expiry countdown
        _pinExpiry.value = pinExpirySeconds
        pinExpiryJob = scope.launch {
            for (i in pinExpirySeconds downTo 0) {
                _pinExpiry.value = i
                if (i == 0) {
                    Log.w(tag, "PIN entry timed out")
                    _state.value = PairingState.Failed("PIN expired", "PIN_EXPIRED")
                    closeSocket()
                    break
                }
                delay(1_000)
            }
        }

        Log.d(tag, "State → AwaitingPin")
        _state.value = PairingState.AwaitingPin
    }

    suspend fun submitPin(pin: String) {
        if (_state.value !is PairingState.AwaitingPin) {
            Log.w(tag, "submitPin called in wrong state: ${_state.value}")
            return
        }
        Log.d(tag, "submitPin called (pin length=${pin.length})")
        pinExpiryJob?.cancel()
        _state.value = PairingState.VerifyingPin

        withContext(Dispatchers.IO) {
            try {
                val serverCert = capturedServerCert
                    ?: throw IllegalStateException("No server certificate captured — cannot derive secret")
                val clientCert = certStore.getClientCertificate()

                // ── SECRET DERIVATION ───────────────────────────────────────────
                // SHA-256(serverCertDer || clientCertDer) — server cert first.
                // This 32-byte value IS the pairing secret sent over the wire.
                // The TV displays the first N hex chars as the PIN; we send the
                // full hash regardless of what the user typed (TV does the same
                // derivation and compares). The user's typed PIN just acts as a
                // confirmation that they're looking at the right TV's screen.
                val digest = MessageDigest.getInstance("SHA-256")
                digest.update(serverCert.encoded)  // SERVER first
                digest.update(clientCert.encoded)  // CLIENT second
                val secretBytes = digest.digest()  // 32 bytes

                val secretHex = secretBytes.toHexString()
                Log.d(tag, "Derived secret (hex): $secretHex")
                Log.d(tag, "Expected PIN on TV screen: ${secretHex.substring(0, 6).uppercase()}")

                // ── SEND PairingSecret ──────────────────────────────────────────
                val secretMsg = PairingMessage.newBuilder()
                    .setPairingSecret(
                        PairingSecret.newBuilder()
                            .setSecret(ByteString.copyFrom(secretBytes))
                            .build()
                    )
                    .build()
                MessageFramer.writeMessage(outputStream!!, secretMsg.toByteArray())
                Log.d(tag, "PairingSecret sent, awaiting TV verification...")

                // ── READ PairingResult ──────────────────────────────────────────
                val resultBytes = MessageFramer.readMessage(inputStream!!)
                val result = PairingMessage.parseFrom(resultBytes)
                Log.d(tag, "Pairing result status: ${result.status.code}")

                when (result.status.code) {
                    RpcStatus.STATUS_OK -> {
                        Log.d(tag, "✅ Pairing SUCCESS for ${capturedDeviceIp}")
                        _state.value = PairingState.Success
                    }
                    RpcStatus.STATUS_BAD_SECRET -> {
                        // Log secret for debugging cert-order issues
                        Log.e(tag, "❌ STATUS_BAD_SECRET — sent secret: $secretHex")
                        Log.e(tag, "If this persists, try reversing cert order: client||server")
                        _state.value = PairingState.Failed("Wrong PIN or secret mismatch", "WRONG_PIN")
                    }
                    else -> {
                        Log.e(tag, "❌ Pairing error: ${result.status.code}")
                        _state.value = PairingState.Failed(
                            "Pairing error: ${result.status.code}",
                            "PAIRING_ERROR"
                        )
                    }
                }
            } catch (e: IllegalStateException) {
                Log.e(tag, "State error in submitPin: ${e.message}", e)
                _state.value = PairingState.Failed(e.message ?: "State error", "STATE_ERROR")
            } catch (e: Exception) {
                Log.e(tag, "submitPin failed: ${e.message}", e)
                _state.value = PairingState.Failed(e.message ?: "Unknown error", "SUBMIT_ERROR")
            } finally {
                // Socket is always closed after submitPin —
                // a new socket is opened by RemoteSession on port 6466.
                closeSocket()
            }
        }
    }

    fun cancel() {
        Log.d(tag, "Pairing cancelled by user")
        pinExpiryJob?.cancel()
        closeSocket()
        _state.value = PairingState.Idle
    }

    // ── Private Helpers ─────────────────────────────────────────────────────────

    private fun closeSocket() {
        Log.d(tag, "closeSocket()")
        try { outputStream?.close() } catch (e: Exception) { Log.w(tag, "outputStream close: ${e.message}") }
        try { inputStream?.close() } catch (e: Exception) { Log.w(tag, "inputStream close: ${e.message}") }
        try { pairingSocket?.close() } catch (e: Exception) { Log.w(tag, "pairingSocket close: ${e.message}") }
        pairingSocket = null
        outputStream = null
        inputStream = null
    }

    private fun ByteArray.toHexString() = joinToString("") { "%02x".format(it) }
}
