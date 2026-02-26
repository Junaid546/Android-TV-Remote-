package com.example.atv_remote.remote

import android.os.Build
import android.util.Log
import com.example.atv_remote.pairing.CertificateStore
import com.google.protobuf.InvalidProtocolBufferException
import com.tvremote.app.proto.RemoteProto.RemoteDirection
import com.tvremote.app.proto.RemoteProto.RemoteError
import com.tvremote.app.proto.RemoteProto.RemoteConfigure
import com.tvremote.app.proto.RemoteProto.RemoteDeviceInfo
import com.tvremote.app.proto.RemoteProto.RemoteKeyCode
import com.tvremote.app.proto.RemoteProto.RemoteKeyInject
import com.tvremote.app.proto.RemoteProto.RemoteMessage
import com.tvremote.app.proto.RemoteProto.RemotePingRequest
import com.tvremote.app.proto.RemoteProto.RemotePingResponse
import com.tvremote.app.proto.RemoteProto.RemoteSetVolumeLevel
import com.tvremote.app.proto.RemoteProto.RemoteSetActive
import com.tvremote.app.proto.RemoteProto.RemoteStart
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.isActive
import kotlinx.coroutines.launch
import kotlinx.coroutines.sync.Mutex
import kotlinx.coroutines.sync.withLock
import kotlinx.coroutines.withContext
import java.io.DataInputStream
import java.io.DataOutputStream
import java.io.EOFException
import java.io.IOException
import java.net.ProtocolException
import java.util.concurrent.atomic.AtomicBoolean
import java.util.concurrent.atomic.AtomicInteger
import java.util.concurrent.atomic.AtomicLong
import javax.net.ssl.SSLSocket

class RemoteSession(
    private val certStore: CertificateStore,
    private val scope: CoroutineScope,
) {
    private val tag = "TvRemote"
    private val clientPackageName = "com.example.atv_remote"
    private val clientAppVersion = "1.0.0"

    companion object {
        const val REMOTE_PORT = 6466
        const val IDLE_TIMEOUT_MS = 16_000L
        const val IDLE_WATCHDOG_INTERVAL_MS = 4_000L
        const val NEGOTIATION_TIMEOUT_MS = 12_000L
        const val MAX_RECONNECT_ATTEMPTS = 5
        const val RECONNECT_DELAY_MS = 3_000L
        const val MAX_MESSAGE_BYTES = 1_048_576
        const val DEFAULT_ACTIVE_FEATURES = 622
    }

    private val _connectionState =
        MutableStateFlow<RemoteConnectionState>(RemoteConnectionState.Disconnected)
    val connectionState: StateFlow<RemoteConnectionState> = _connectionState.asStateFlow()

    data class VolumeState(
        val level: Int,
        val max: Int,
        val muted: Boolean,
    ) {
        fun toMap(): Map<String, Any> = mapOf(
            "level" to level,
            "max" to max,
            "muted" to muted,
        )
    }

    private val _volumeState = MutableStateFlow<VolumeState?>(null)
    val volumeState: StateFlow<VolumeState?> = _volumeState.asStateFlow()

    @Volatile private var socket: SSLSocket? = null
    @Volatile private var outputStream: DataOutputStream? = null
    @Volatile private var inputStream: DataInputStream? = null

    private var idleWatchdogJob: Job? = null
    private var receiveJob: Job? = null
    private var reconnectJob: Job? = null
    private var negotiationTimeoutJob: Job? = null

    private var reconnectAttempts = 0
    private var currentDeviceIp: String? = null
    private var currentDeviceName: String = ""
    private var currentDevicePort: Int = REMOTE_PORT

    private val outputLock = Mutex()
    private val connectLock = Mutex()
    private val handlingDisconnection = AtomicBoolean(false)
    private val manualDisconnect = AtomicBoolean(false)
    private val autoReconnectEnabled = AtomicBoolean(true)
    private val remoteReady = AtomicBoolean(false)
    private val lastInboundFrameAt = AtomicLong(0L)
    private val lastOutboundFrameAt = AtomicLong(0L)
    private val negotiatedFeatures = AtomicInteger(DEFAULT_ACTIVE_FEATURES)

    suspend fun connect(
        deviceIp: String,
        deviceName: String,
        port: Int = REMOTE_PORT,
    ) {
        manualDisconnect.set(false)
        currentDeviceIp = deviceIp
        currentDeviceName = deviceName
        currentDevicePort = port

        connectLock.withLock {
            val attemptNumber = if (reconnectAttempts <= 0) 1 else reconnectAttempts
            Log.d(tag, "connect() -> $deviceIp:$port (attempt $attemptNumber)")
            _connectionState.value = RemoteConnectionState.Connecting(deviceIp)

            reconnectJob?.cancel()
            idleWatchdogJob?.cancel()
            receiveJob?.cancel()
            negotiationTimeoutJob?.cancel()
            closeSocket()

            withContext(Dispatchers.IO) {
                try {
                    val rawSocket = createRemoteSocket(deviceIp, port)
                    socket = rawSocket
                    outputStream = DataOutputStream(rawSocket.outputStream)
                    inputStream = DataInputStream(rawSocket.inputStream)

                    handlingDisconnection.set(false)
                    remoteReady.set(false)
                    negotiatedFeatures.set(DEFAULT_ACTIVE_FEATURES)
                    _volumeState.value = null
                    val now = System.currentTimeMillis()
                    lastInboundFrameAt.set(now)
                    lastOutboundFrameAt.set(now)

                    Log.d(tag, "TLS connected to $deviceIp:$port. Waiting for protocol negotiation")
                    startReceiving()
                    startIdleWatchdog()
                    startNegotiationTimeout()
                } catch (e: Exception) {
                    Log.e(
                        tag,
                        "Connect error: ${e.javaClass.simpleName}: ${e.message}",
                        e,
                    )
                    val noServerCertificate =
                        e is IllegalStateException &&
                            e.message?.contains("No server certificate", ignoreCase = true) == true
                    val handshakeFailure =
                        e is javax.net.ssl.SSLHandshakeException ||
                            e.message?.contains("handshake", ignoreCase = true) == true

                    if (noServerCertificate) {
                        reconnectAttempts = 0
                        remoteReady.set(false)
                        _connectionState.value =
                            RemoteConnectionState.Failed(deviceIp, "REPAIRING_NEEDED")
                    } else if (handshakeFailure) {
                        reconnectAttempts = 0
                        remoteReady.set(false)
                        certStore.clearServerCertificate(deviceIp)
                        _connectionState.value = RemoteConnectionState.Failed(deviceIp, "REPAIRING_NEEDED")
                    } else {
                        scheduleReconnectOrFail("Connect failed: ${e.message.orEmpty()}")
                    }
                }
            }
        }
    }

    private fun createRemoteSocket(host: String, port: Int = REMOTE_PORT): SSLSocket {
        Log.d(tag, "Creating REMOTE socket -> $host:$port")

        val sslContext = certStore.createMutualTlsContext(host)
        var remoteSocket = sslContext.socketFactory.createSocket() as SSLSocket

        remoteSocket.useClientMode = true
        remoteSocket.soTimeout = 35_000
        remoteSocket.tcpNoDelay = true
        remoteSocket.keepAlive = true

        try {
            val params = remoteSocket.sslParameters
            params.serverNames = listOf(javax.net.ssl.SNIHostName(host))
            remoteSocket.sslParameters = params
        } catch (e: Exception) {
            Log.w(tag, "SNI setup failed (non-fatal): ${e.message}")
        }

        try {
            remoteSocket.enabledProtocols = arrayOf("TLSv1.2")
            remoteSocket.connect(java.net.InetSocketAddress(host, port), 10_000)
            remoteSocket.startHandshake()
        } catch (e: Exception) {
            Log.w(tag, "TLSv1.2 failed, trying TLSv1.3: ${e.message}")
            try {
                remoteSocket.close()
            } catch (_: Exception) {
                // Ignore close failure during fallback.
            }

            remoteSocket = sslContext.socketFactory.createSocket() as SSLSocket
            remoteSocket.useClientMode = true
            remoteSocket.soTimeout = 35_000
            remoteSocket.tcpNoDelay = true
            remoteSocket.keepAlive = true
            remoteSocket.enabledProtocols = arrayOf("TLSv1.3")

            try {
                val params = remoteSocket.sslParameters
                params.serverNames = listOf(javax.net.ssl.SNIHostName(host))
                remoteSocket.sslParameters = params
            } catch (_: Exception) {
                // Non-fatal.
            }

            try {
                remoteSocket.connect(java.net.InetSocketAddress(host, port), 10_000)
                remoteSocket.startHandshake()
            } catch (_: Exception) {
                try {
                    remoteSocket.close()
                } catch (_: Exception) {
                    // Ignore close failure after failed handshake.
                }
                throw javax.net.ssl.SSLHandshakeException("Handshake failed for $host:$port")
            }
        }

        Log.d(tag, "Cipher suite: ${remoteSocket.session.cipherSuite}")
        Log.d(tag, "Protocol: ${remoteSocket.session.protocol}")
        return remoteSocket
    }

    suspend fun sendKey(keyCode: Int, direction: Int) {
        if (_connectionState.value !is RemoteConnectionState.Connected || !remoteReady.get()) {
            Log.w(tag, "sendKey ignored - not connected (state=${_connectionState.value})")
            return
        }

        val mappedKeyCode = RemoteKeyCode.forNumber(keyCode)
        if (mappedKeyCode == null || mappedKeyCode == RemoteKeyCode.KEYCODE_UNKNOWN) {
            throw IllegalArgumentException("Unsupported keyCode: $keyCode")
        }

        val mappedDirection = RemoteDirection.forNumber(direction)
        if (mappedDirection == null || mappedDirection == RemoteDirection.UNKNOWN_DIRECTION) {
            throw IllegalArgumentException("Unsupported key direction: $direction")
        }

        withContext(Dispatchers.IO) {
            try {
                val keyInject = RemoteKeyInject.newBuilder()
                    .setKeyCode(mappedKeyCode)
                    .setDirection(mappedDirection)
                    .build()

                val message = RemoteMessage.newBuilder()
                    .setRemoteKeyInject(keyInject)
                    .build()

                writeMessage(message)
                Log.d(
                    tag,
                    "Key sent code=$keyCode direction=${mappedDirection.name}",
                )
            } catch (e: IOException) {
                Log.e(tag, "sendKey IO error: ${e.message}", e)
                handleDisconnection("Send failed: ${e.message}")
            }
        }
    }

    fun disconnect() {
        Log.d(tag, "disconnect() called by user/system")
        manualDisconnect.set(true)
        reconnectJob?.cancel()
        idleWatchdogJob?.cancel()
        receiveJob?.cancel()
        negotiationTimeoutJob?.cancel()
        closeSocket()
        currentDeviceIp = null
        reconnectAttempts = 0
        remoteReady.set(false)
        negotiatedFeatures.set(DEFAULT_ACTIVE_FEATURES)
        _volumeState.value = null
        handlingDisconnection.set(false)
        _connectionState.value = RemoteConnectionState.Disconnected
    }

    fun setAutoReconnectEnabled(enabled: Boolean) {
        autoReconnectEnabled.set(enabled)
        Log.d(tag, "Auto reconnect set to $enabled")
    }

    private suspend fun writeMessage(message: RemoteMessage) {
        outputLock.withLock {
            val dos = outputStream ?: throw IOException("Output stream is null - not connected")
            if (message.serializedSize <= 0 || message.serializedSize > MAX_MESSAGE_BYTES) {
                throw ProtocolException("Invalid outbound message size ${message.serializedSize}")
            }
            message.writeDelimitedTo(dos)
            dos.flush()
            lastOutboundFrameAt.set(System.currentTimeMillis())
        }
    }

    private fun startIdleWatchdog() {
        idleWatchdogJob?.cancel()
        idleWatchdogJob = scope.launch(Dispatchers.IO) {
            Log.d(tag, "Idle watchdog started")
            while (isActive) {
                delay(IDLE_WATCHDOG_INTERVAL_MS)
                if (manualDisconnect.get()) break
                try {
                    val now = System.currentTimeMillis()
                    val lastActivityAt =
                        maxOf(lastInboundFrameAt.get(), lastOutboundFrameAt.get())
                    if (lastActivityAt > 0L && now - lastActivityAt > IDLE_TIMEOUT_MS) {
                        Log.w(tag, "Idle timeout after ${now - lastActivityAt}ms")
                        handleDisconnection("IDLE_TIMEOUT")
                        break
                    }
                } catch (e: Exception) {
                    Log.e(tag, "Idle watchdog error: ${e.message}", e)
                    handleDisconnection("IDLE_WATCHDOG_ERROR")
                    break
                }
            }
            Log.d(tag, "Idle watchdog ended")
        }
    }

    private fun startNegotiationTimeout() {
        negotiationTimeoutJob?.cancel()
        negotiationTimeoutJob = scope.launch(Dispatchers.IO) {
            delay(NEGOTIATION_TIMEOUT_MS)
            if (manualDisconnect.get()) return@launch
            if (remoteReady.get()) return@launch
            Log.w(tag, "Negotiation timeout after ${NEGOTIATION_TIMEOUT_MS}ms")
            handleDisconnection("PROTOCOL_NEGOTIATION_TIMEOUT")
        }
    }

    private fun startReceiving() {
        receiveJob?.cancel()
        receiveJob = scope.launch(Dispatchers.IO) {
            Log.d(tag, "Receive loop started")
            while (isActive) {
                try {
                    val dis = inputStream ?: break
                    val msg = RemoteMessage.parseDelimitedFrom(dis)
                        ?: throw EOFException("Remote stream EOF")
                    lastInboundFrameAt.set(System.currentTimeMillis())

                    when {
                        msg.hasRemoteConfigure() -> {
                            handleRemoteConfigure(msg.remoteConfigure)
                        }

                        msg.hasRemoteSetActive() -> {
                            handleRemoteSetActive(msg.remoteSetActive)
                        }

                        msg.hasRemoteStart() -> {
                            handleRemoteStart(msg.remoteStart)
                        }

                        msg.hasRemoteError() -> {
                            handleRemoteError(msg.remoteError)
                        }

                        msg.hasRemoteSetVolumeLevel() -> {
                            handleRemoteSetVolumeLevel(msg.remoteSetVolumeLevel)
                        }

                        msg.hasRemotePingResponse() -> {
                            Log.d(tag, "Ping response received: ${msg.remotePingResponse.val1}")
                        }

                        msg.hasRemotePingRequest() -> {
                            handleRemotePingRequest(msg.remotePingRequest)
                        }

                        msg.hasRemoteKeyInject() -> {
                            Log.d(tag, "Remote key echo: ${msg.remoteKeyInject.keyCode.name}")
                        }

                        else -> {
                            Log.d(tag, "Remote message: ${msg.unionCase}")
                        }
                    }
                } catch (e: InvalidProtocolBufferException) {
                    if (isActive && !manualDisconnect.get()) {
                        Log.w(tag, "Malformed remote frame: ${e.message}")
                        handleDisconnection("MALFORMED_REMOTE_FRAME")
                    }
                    break
                } catch (e: EOFException) {
                    if (isActive && !manualDisconnect.get()) {
                        Log.w(tag, "TV closed connection (EOF)")
                        handleDisconnection("TV closed connection")
                    }
                    break
                } catch (e: IOException) {
                    if (isActive && !manualDisconnect.get()) {
                        Log.e(tag, "Receive IO error: ${e.message}", e)
                        handleDisconnection("Receive error: ${e.message}")
                    }
                    break
                }
            }
            Log.d(tag, "Receive loop ended")
        }
    }

    private suspend fun handleRemoteConfigure(configure: RemoteConfigure) {
        val requestedFeatures = configure.code1.takeIf { it > 0 } ?: DEFAULT_ACTIVE_FEATURES
        negotiatedFeatures.set(requestedFeatures)

        Log.d(
            tag,
            "remote_configure from TV code1=${configure.code1}; reply code1=$requestedFeatures",
        )

        val localDeviceInfo = RemoteDeviceInfo.newBuilder()
            .setModel(Build.MODEL ?: "Android")
            .setVendor(Build.MANUFACTURER ?: "Android")
            .setUnknown1(1)
            .setUnknown2(1)
            .setPackageName(clientPackageName)
            .setAppVersion(clientAppVersion)
            .build()

        val response = RemoteMessage.newBuilder()
            .setRemoteConfigure(
                RemoteConfigure.newBuilder()
                    .setCode1(requestedFeatures)
                    .setDeviceInfo(localDeviceInfo)
                    .build(),
            )
            .build()
        writeMessage(response)
    }

    private suspend fun handleRemoteSetActive(setActive: RemoteSetActive) {
        val requested = setActive.active.takeIf { it > 0 } ?: negotiatedFeatures.get()
        negotiatedFeatures.set(requested)

        val response = RemoteMessage.newBuilder()
            .setRemoteSetActive(
                RemoteSetActive.newBuilder()
                    .setActive(requested)
                    .build(),
            )
            .build()
        writeMessage(response)
        Log.d(tag, "remote_set_active from TV active=${setActive.active}; reply active=$requested")
    }

    private suspend fun handleRemotePingRequest(request: RemotePingRequest) {
        val pong = RemoteMessage.newBuilder()
            .setRemotePingResponse(
                RemotePingResponse.newBuilder()
                    .setVal1(request.val1)
                    .build(),
            )
            .build()
        writeMessage(pong)
        Log.d(tag, "Ping request received val1=${request.val1}; pong sent")
    }

    private fun handleRemoteSetVolumeLevel(volume: RemoteSetVolumeLevel) {
        val maxVolume = volume.volumeMax.toInt().coerceAtLeast(1)
        val level = volume.volumeLevel.toInt().coerceIn(0, maxVolume)
        val muted = volume.volumeMuted
        val updatedState = VolumeState(
            level = level,
            max = maxVolume,
            muted = muted,
        )
        _volumeState.value = updatedState
        Log.d(tag, "Volume update level=$level/$maxVolume muted=$muted")
    }

    private fun handleRemoteStart(start: RemoteStart) {
        Log.d(tag, "remote_start started=${start.started}")
        if (start.started) {
            markSessionReady()
        }
    }

    private suspend fun handleRemoteError(error: RemoteError) {
        val reason = error.message.ifBlank { "REMOTE_PROTOCOL_ERROR" }
        Log.w(tag, "remote_error value=${error.value}, message=$reason")
        handleDisconnection(reason)
    }

    private fun markSessionReady() {
        if (!remoteReady.compareAndSet(false, true)) return
        val ip = currentDeviceIp ?: return
        negotiationTimeoutJob?.cancel()
        reconnectAttempts = 0
        _connectionState.value = RemoteConnectionState.Connected(ip, currentDeviceName)
        Log.i(tag, "Remote session ready for $ip with features=${negotiatedFeatures.get()}")
    }

    private suspend fun handleDisconnection(reason: String) {
        if (manualDisconnect.get()) {
            Log.d(tag, "handleDisconnection ignored (manual disconnect): $reason")
            return
        }
        if (!handlingDisconnection.compareAndSet(false, true)) {
            Log.d(tag, "handleDisconnection suppressed (already handling): $reason")
            return
        }

        Log.w(tag, "handleDisconnection: $reason")
        idleWatchdogJob?.cancel()
        receiveJob?.cancel()
        negotiationTimeoutJob?.cancel()
        remoteReady.set(false)
        _volumeState.value = null
        closeSocket()
        scheduleReconnectOrFail(reason)
    }

    private suspend fun scheduleReconnectOrFail(reason: String) {
        if (manualDisconnect.get()) {
            _connectionState.value = RemoteConnectionState.Disconnected
            handlingDisconnection.set(false)
            return
        }

        val ip = currentDeviceIp ?: run {
            _connectionState.value = RemoteConnectionState.Disconnected
            handlingDisconnection.set(false)
            return
        }

        if (!autoReconnectEnabled.get()) {
            Log.w(tag, "Auto reconnect disabled - failing session")
            _connectionState.value = RemoteConnectionState.Failed(ip, reason)
            handlingDisconnection.set(false)
            return
        }

        if (reconnectAttempts < MAX_RECONNECT_ATTEMPTS) {
            reconnectAttempts++
            Log.d(
                tag,
                "Reconnecting in ${RECONNECT_DELAY_MS}ms (attempt $reconnectAttempts/$MAX_RECONNECT_ATTEMPTS)",
            )
            _connectionState.value = RemoteConnectionState.Reconnecting(
                ip,
                reconnectAttempts,
                MAX_RECONNECT_ATTEMPTS,
            )
            reconnectJob?.cancel()
            reconnectJob = scope.launch(Dispatchers.IO) {
                delay(RECONNECT_DELAY_MS)
                if (manualDisconnect.get()) {
                    handlingDisconnection.set(false)
                    return@launch
                }
                handlingDisconnection.set(false)
                connect(ip, currentDeviceName, currentDevicePort)
            }
        } else {
            Log.e(tag, "Max reconnect attempts reached for $ip")
            _connectionState.value = RemoteConnectionState.Failed(ip, reason)
            handlingDisconnection.set(false)
        }
    }

    private fun closeSocket() {
        try {
            outputStream?.close()
        } catch (e: Exception) {
            Log.w(tag, "outputStream.close: ${e.message}")
        }
        try {
            inputStream?.close()
        } catch (e: Exception) {
            Log.w(tag, "inputStream.close: ${e.message}")
        }
        try {
            socket?.close()
        } catch (e: Exception) {
            Log.w(tag, "socket.close: ${e.message}")
        }
        socket = null
        outputStream = null
        inputStream = null
        Log.d(tag, "Socket closed")
    }
}
