package com.example.atv_remote.pairing

import android.util.Log
import com.google.protobuf.ByteString
import com.google.protobuf.InvalidProtocolBufferException
import com.tvremote.app.proto.PairingProto.PairingConfiguration
import com.tvremote.app.proto.PairingProto.PairingEncoding
import com.tvremote.app.proto.PairingProto.PairingMessage
import com.tvremote.app.proto.PairingProto.PairingOption
import com.tvremote.app.proto.PairingProto.PairingRequest
import com.tvremote.app.proto.PairingProto.PairingSecret
import com.tvremote.app.proto.PairingProto.RoleType
import com.tvremote.app.proto.PairingProto.EncodingType
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.io.DataInputStream
import java.io.DataOutputStream
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

    private class ProtocolReadException(message: String, cause: Throwable? = null) :
        Exception(message, cause)

    suspend fun startPairing(ip: String, deviceName: String) {
        closeSocket()
        currentDeviceIp = ip
        _state.value = PairingState.Connecting(ip)

        withContext(Dispatchers.IO) {
            try {
                certStore.generateIdentityIfNeeded()

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

                val request = PairingMessage.newBuilder()
                    .setProtocolVersion(2)
                    .setStatus(PairingMessage.Status.STATUS_OK)
                    .setPairingRequest(
                        PairingRequest.newBuilder()
                            .setServiceName("ATV Remote")
                            .setClientName(deviceName)
                            .build()
                    )
                    .build()
                writeMessage(request)
                val reqAck = readMessage(2000)
                if (!validateAck(reqAck, "request")) return@withContext
                Log.d(tag, "Request Ack status: ${reqAck!!.status}")

                val option = PairingMessage.newBuilder()
                    .setProtocolVersion(2)
                    .setStatus(PairingMessage.Status.STATUS_OK)
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
                if (!validateAck(optAck, "option")) return@withContext
                Log.d(tag, "Option Ack status: ${optAck!!.status}")

                val config = PairingMessage.newBuilder()
                    .setProtocolVersion(2)
                    .setStatus(PairingMessage.Status.STATUS_OK)
                    .setPairingConfiguration(
                        PairingConfiguration.newBuilder()
                            .setClientRole(RoleType.ROLE_TYPE_INPUT)
                            .setEncoding(
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
                if (!validateAck(confAck, "configuration")) return@withContext
                Log.d(tag, "Config Ack status: ${confAck!!.status}")

                _state.value = PairingState.AwaitingPin
                startPinCountdown()
            } catch (e: ProtocolReadException) {
                Log.e(tag, "startPairing protocol read failed", e)
                fail("Pairing protocol error: ${e.message}", "PROTOCOL_ERROR")
            } catch (e: Exception) {
                Log.e(tag, "startPairing failed", e)
                if (_state.value !is PairingState.Failed) {
                    fail("Connection failed: ${e.message}", "CONNECTION_ERROR")
                }
            }
        }
    }

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
                val normalizedPin = PairingSecretGenerator.normalizeHexPin(pin)
                val clientCert = certStore.getClientCertificate()

                val secretBytes =
                    PairingSecretGenerator.deriveSecret(clientCert, serverCert, normalizedPin)
                if (!PairingSecretGenerator.matchesPinPrefix(secretBytes, normalizedPin)) {
                    fail("Incorrect PIN or pairing failed.", "WRONG_PIN")
                    return@withContext
                }

                val secretMsg = PairingMessage.newBuilder()
                    .setProtocolVersion(2)
                    .setStatus(PairingMessage.Status.STATUS_OK)
                    .setPairingSecret(
                        PairingSecret.newBuilder()
                            .setSecret(ByteString.copyFrom(secretBytes))
                            .build()
                    )
                    .build()

                writeMessage(secretMsg)
                Log.d(tag, "PairingSecret sent. Waiting for result...")

                val result = readMessage(5000)
                Log.d(tag, "TV Response: ${result?.status}")

                if (result == null) {
                    fail("Timed out waiting for pairing result", "PROTOCOL_TIMEOUT")
                    return@withContext
                }

                when (result.status) {
                    PairingMessage.Status.STATUS_OK -> {
                        certStore.saveServerCertificate(currentDeviceIp, serverCert)
                        Log.i(tag, "Pairing SUCCESS for $currentDeviceIp")
                        _state.value = PairingState.Success
                    }
                    PairingMessage.Status.STATUS_BAD_SECRET -> {
                        fail("Incorrect PIN or pairing failed.", "WRONG_PIN")
                    }
                    PairingMessage.Status.STATUS_BAD_CONFIGURATION -> {
                        fail("Pairing configuration rejected by TV", "BAD_CONFIGURATION")
                    }
                    else -> {
                        fail("Pairing error: ${result.status}", "PAIRING_ERROR")
                    }
                }
            } catch (e: IllegalArgumentException) {
                Log.e(tag, "submitPin invalid input", e)
                fail(e.message ?: "PIN should be 6 hex characters.", "INVALID_PIN_FORMAT")
            } catch (e: ProtocolReadException) {
                Log.e(tag, "submitPin protocol read failed", e)
                fail("Pairing protocol error: ${e.message}", "PROTOCOL_ERROR")
            } catch (e: Exception) {
                Log.e(tag, "submitPin failed", e)
                fail("PIN submission error: ${e.message}", "SUBMIT_ERROR")
            } finally {
                closeSocket()
            }
        }
    }

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

    fun cancel() {
        pinExpiryJob?.cancel()
        closeSocket()
        capturedServerCert = null
        _state.value = PairingState.Idle
        Log.d(tag, "Pairing cancelled")
    }

    private fun writeMessage(msg: PairingMessage) {
        val out = output ?: throw IllegalStateException("Output stream is null")
        msg.writeDelimitedTo(out)
        out.flush()
    }

    private fun validateAck(message: PairingMessage?, step: String): Boolean {
        if (message == null) {
            fail("Timed out waiting for $step acknowledgement", "PROTOCOL_TIMEOUT")
            return false
        }
        if (message.status != PairingMessage.Status.STATUS_OK) {
            val code = when (message.status) {
                PairingMessage.Status.STATUS_BAD_CONFIGURATION -> "BAD_CONFIGURATION"
                else -> "PAIRING_ERROR"
            }
            fail("TV rejected $step step: ${message.status}", code)
            return false
        }
        return true
    }

    private fun readMessage(timeoutMs: Int = 0): PairingMessage? {
        val inp = input ?: throw IllegalStateException("Input stream is null")
        val oldTimeout = socket?.soTimeout ?: 0

        if (timeoutMs > 0) socket?.soTimeout = timeoutMs

        try {
            return PairingMessage.parseDelimitedFrom(inp)
        } catch (e: Exception) {
            if (isSocketTimeout(e)) {
                Log.w(tag, "Timeout reading pairing message")
                return null
            }
            val protocolError = when (e) {
                is InvalidProtocolBufferException ->
                    ProtocolReadException("Malformed pairing protobuf", e)
                else -> ProtocolReadException("Failed to read pairing message", e)
            }
            throw protocolError
        } finally {
            if (timeoutMs > 0) socket?.soTimeout = oldTimeout
        }
    }

    private fun isSocketTimeout(error: Throwable?): Boolean {
        var current = error
        while (current != null) {
            if (current is java.net.SocketTimeoutException) return true
            current = current.cause
        }
        return false
    }

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
