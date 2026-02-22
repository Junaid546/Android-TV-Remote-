package com.example.atv_remote.remote

import android.util.Log
import com.example.atv_remote.pairing.CertificateStore
import com.tvremote.app.proto.RemoteProto.RemoteDirection
import com.tvremote.app.proto.RemoteProto.RemoteKeyCode
import com.tvremote.app.proto.RemoteProto.RemoteKeyInject
import com.tvremote.app.proto.RemoteProto.RemoteMessage
import com.tvremote.app.proto.RemoteProto.RemotePingRequest
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
import java.util.concurrent.atomic.AtomicBoolean
import javax.net.ssl.SSLSocket

class RemoteSession(
    private val certStore: CertificateStore,
    private val scope: CoroutineScope
) {
    private val tag = "TvRemote"

    companion object {
        const val REMOTE_PORT = 6466
        const val KEEP_ALIVE_INTERVAL_MS = 5_000L
        const val MAX_RECONNECT_ATTEMPTS = 5
        const val RECONNECT_BASE_DELAY_MS = 3_000L
        const val MAX_RECONNECT_DELAY_MS = 30_000L
        const val MAX_MESSAGE_BYTES = 1_048_576 // 1 MB guard
    }

    private val _connectionState =
        MutableStateFlow<RemoteConnectionState>(RemoteConnectionState.Disconnected)
    val connectionState: StateFlow<RemoteConnectionState> = _connectionState.asStateFlow()

    @Volatile private var socket: SSLSocket? = null
    @Volatile private var outputStream: DataOutputStream? = null
    @Volatile private var inputStream: DataInputStream? = null

    private var keepAliveJob: Job? = null
    private var receiveJob: Job? = null

    private var reconnectAttempts = 0
    private var currentDeviceIp: String? = null
    private var currentDeviceName: String = ""

    private val outputLock = Mutex()
    private val handlingDisconnection = AtomicBoolean(false)

    suspend fun connect(
        deviceIp: String,
        deviceName: String,
        port: Int = REMOTE_PORT
    ) {
        currentDeviceIp = deviceIp
        currentDeviceName = deviceName
        Log.d(tag, "connect() → $deviceIp:$port (attempt ${reconnectAttempts + 1})")
        _connectionState.value = RemoteConnectionState.Connecting(deviceIp)

        withContext(Dispatchers.IO) {
            try {
                val rawSocket = createRemoteSocket(deviceIp, port)
                socket = rawSocket
                outputStream = DataOutputStream(rawSocket.outputStream)
                inputStream = DataInputStream(rawSocket.inputStream)

                reconnectAttempts = 0
                handlingDisconnection.set(false)
                _connectionState.value = RemoteConnectionState.Connected(deviceIp, deviceName)
                Log.d(tag, "✅ Connected to $deviceIp:$port")

                startKeepAlive()
                startReceiving()
            } catch (e: Exception) {
                Log.e(tag, "Unexpected connect error: ${e.javaClass.simpleName}: ${e.message}", e)
                if (e is javax.net.ssl.SSLHandshakeException || e.message?.contains("handshake") == true) {
                    certStore.clearServerCertificate(deviceIp)
                    _connectionState.value = RemoteConnectionState.Failed(deviceIp, "REPAIRING_NEEDED")
                } else {
                    scheduleReconnectOrFail("Connect failed: ${e.message}")
                }
            }
        }
    }

    private fun createRemoteSocket(host: String, port: Int = REMOTE_PORT): SSLSocket {
        Log.d(tag, "Creating REMOTE socket → $host:$port")

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
            try { remoteSocket.close() } catch (_: Exception) {}

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
            } catch (_: Exception) {}

            try {
                remoteSocket.connect(java.net.InetSocketAddress(host, port), 10_000)
                remoteSocket.startHandshake()
            } catch (e2: Exception) {
                try { remoteSocket.close() } catch (_: Exception) {}
                throw javax.net.ssl.SSLHandshakeException("Handshake failed for $host:$port")
            }
        }

        Log.d(tag, "Cipher suite: ${remoteSocket.session.cipherSuite}")
        Log.d(tag, "Protocol: ${remoteSocket.session.protocol}")
        return remoteSocket
    }

    suspend fun sendKey(keyCode: Int, direction: Int) {
        if (_connectionState.value !is RemoteConnectionState.Connected) {
            Log.w(tag, "sendKey ignored — not connected (state=${_connectionState.value})")
            return
        }
        withContext(Dispatchers.IO) {
            try {
                val keyInject = RemoteKeyInject.newBuilder()
                    .setKeyCode(
                        RemoteKeyCode.forNumber(keyCode)
                            ?: RemoteKeyCode.KEYCODE_UNKNOWN
                    )
                    .setDirection(
                        RemoteDirection.forNumber(direction)
                            ?: RemoteDirection.REMOTE_DIRECTION_UNKNOWN
                    )
                    .build()

                val message = RemoteMessage.newBuilder()
                    .setRemoteKeyInject(keyInject)
                    .build()

                writeMessage(message.toByteArray())
            } catch (e: IOException) {
                Log.e(tag, "sendKey IO error: ${e.message}", e)
                handleDisconnection("Send failed: ${e.message}")
            }
        }
    }

    fun disconnect() {
        Log.d(tag, "disconnect() called by user/system")
        keepAliveJob?.cancel()
        receiveJob?.cancel()
        closeSocket()
        currentDeviceIp = null
        reconnectAttempts = 0
        handlingDisconnection.set(false)
        _connectionState.value = RemoteConnectionState.Disconnected
    }

    private suspend fun writeMessage(bytes: ByteArray) {
        outputLock.withLock {
            val dos = outputStream ?: throw IOException("Output stream is null — not connected")
            dos.writeInt(bytes.size)
            dos.write(bytes)
            dos.flush()
        }
    }

    private fun startKeepAlive() {
        keepAliveJob?.cancel()
        keepAliveJob = scope.launch(Dispatchers.IO) {
            Log.d(tag, "KeepAlive loop started")
            while (isActive) {
                delay(KEEP_ALIVE_INTERVAL_MS)
                try {
                    val ping = RemoteMessage.newBuilder()
                        .setRemotePingRequest(
                            RemotePingRequest.newBuilder().setVal1(622).build()
                        )
                        .build()
                    writeMessage(ping.toByteArray())
                    Log.d(tag, "→ Ping sent")
                } catch (e: IOException) {
                    Log.e(tag, "KeepAlive IO error: ${e.message}", e)
                    handleDisconnection("Keepalive failed: ${e.message}")
                    break
                } catch (e: Exception) {
                    Log.e(tag, "KeepAlive unexpected error: ${e.message}", e)
                    handleDisconnection("Keepalive error: ${e.message}")
                    break
                }
            }
            Log.d(tag, "KeepAlive loop ended")
        }
    }

    private fun startReceiving() {
        receiveJob?.cancel()
        receiveJob = scope.launch(Dispatchers.IO) {
            Log.d(tag, "Receive loop started")
            while (isActive) {
                try {
                    val dis = inputStream ?: break
                    val length = dis.readInt()

                    if (length <= 0 || length > MAX_MESSAGE_BYTES) {
                        Log.w(tag, "Invalid message length $length — skipping")
                        continue
                    }
                    val bytes = ByteArray(length)
                    dis.readFully(bytes)

                    val msg = RemoteMessage.parseFrom(bytes)
                    when {
                        msg.hasRemotePingResponse() ->
                            Log.d(tag, "← Pong received: ${msg.remotePingResponse.val1}")
                        else ->
                            Log.d(tag, "← Unknown message type, oneof: ${msg.unionCase}")
                    }
                } catch (e: EOFException) {
                    if (isActive) {
                        Log.w(tag, "TV closed connection (EOF)")
                        handleDisconnection("TV closed connection")
                    }
                    break
                } catch (e: IOException) {
                    if (isActive) {
                        Log.e(tag, "Receive IO error: ${e.message}", e)
                        handleDisconnection("Receive error: ${e.message}")
                    }
                    break
                }
            }
            Log.d(tag, "Receive loop ended")
        }
    }

    private suspend fun handleDisconnection(reason: String) {
        if (!handlingDisconnection.compareAndSet(false, true)) {
            Log.d(tag, "handleDisconnection suppressed (already handling): $reason")
            return
        }

        Log.w(tag, "handleDisconnection: $reason")
        keepAliveJob?.cancel()
        receiveJob?.cancel()
        closeSocket()
        scheduleReconnectOrFail(reason)
    }

    private suspend fun scheduleReconnectOrFail(reason: String) {
        val ip = currentDeviceIp ?: run {
            _connectionState.value = RemoteConnectionState.Disconnected
            return
        }

        if (reconnectAttempts < MAX_RECONNECT_ATTEMPTS) {
            reconnectAttempts++
            val backoff = minOf(RECONNECT_BASE_DELAY_MS * reconnectAttempts, MAX_RECONNECT_DELAY_MS)
            Log.d(tag, "⏳ Reconnecting in ${backoff}ms (attempt $reconnectAttempts/$MAX_RECONNECT_ATTEMPTS)")
            _connectionState.value = RemoteConnectionState.Reconnecting(
                ip, reconnectAttempts, MAX_RECONNECT_ATTEMPTS
            )
            delay(backoff)
            handlingDisconnection.set(false)
            connect(ip, currentDeviceName)
        } else {
            Log.e(tag, "❌ Max reconnect attempts reached for $ip")
            _connectionState.value = RemoteConnectionState.Failed(ip, reason)
        }
    }

    private fun closeSocket() {
        try { outputStream?.close() } catch (e: Exception) { Log.w(tag, "outputStream.close: ${e.message}") }
        try { inputStream?.close() }  catch (e: Exception) { Log.w(tag, "inputStream.close: ${e.message}") }
        try { socket?.close() }       catch (e: Exception) { Log.w(tag, "socket.close: ${e.message}") }
        socket = null
        outputStream = null
        inputStream = null
        Log.d(tag, "Socket closed")
    }
}
