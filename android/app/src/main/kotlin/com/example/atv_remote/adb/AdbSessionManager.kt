package com.example.atv_remote.adb

import android.content.Context
import android.os.Build
import android.util.Log
import com.example.atv_remote.pairing.CertificateStore
import io.github.muntashirakon.adb.AdbAuthenticationFailedException
import io.github.muntashirakon.adb.AdbPairingRequiredException
import io.github.muntashirakon.adb.AbsAdbConnectionManager
import io.github.muntashirakon.adb.AdbStream
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.sync.Mutex
import kotlinx.coroutines.sync.withLock
import kotlinx.coroutines.withContext
import java.io.IOException
import java.net.ConnectException
import java.net.NoRouteToHostException
import java.net.SocketTimeoutException
import java.net.UnknownHostException
import java.security.PrivateKey
import java.security.cert.Certificate
import java.util.concurrent.TimeUnit

class AdbSessionManager(
    private val context: Context,
    private val certStore: CertificateStore,
    private val scope: CoroutineScope,
) {
    private val tag = "TvAdb"
    private val operationLock = Mutex()

    private val _state = MutableStateFlow<AdbSessionState>(AdbSessionState.Disconnected)
    val state: StateFlow<AdbSessionState> = _state.asStateFlow()

    @Volatile private var host: String = ""
    @Volatile private var port: Int = 0
    @Volatile private var manager: TvAdbConnectionManager? = null

    suspend fun pair(host: String, pairPort: Int, pairingCode: String): Result<Unit> {
        return withContext(Dispatchers.IO) {
            operationLock.withLock {
                this@AdbSessionManager.host = host
                _state.value = AdbSessionState.Pairing(host, pairPort)
                runCatching {
                    val connectionManager = manager ?: createManager(host).also {
                        manager = it
                    }
                    val paired = connectionManager.pair(host, pairPort, pairingCode)
                    if (!paired) {
                        throw IOException("ADB pairing was not accepted by the TV")
                    }
                    Log.d(tag, "ADB paired with $host:$pairPort")
                    Unit
                }.onFailure { e ->
                    _state.value = AdbSessionState.Failed(
                        host = host,
                        port = pairPort,
                        reason = e.message.orEmpty(),
                    )
                    Log.e(tag, "ADB pairing failed: ${e.message}", e)
                }
            }
        }
    }

    suspend fun connect(host: String, connectPort: Int): Result<Unit> {
        return withContext(Dispatchers.IO) {
            operationLock.withLock {
                this@AdbSessionManager.host = host
                this@AdbSessionManager.port = connectPort
                _state.value = AdbSessionState.Connecting(host, connectPort)

                runCatching {
                    val connectionManager = manager ?: createManager(host).also {
                        manager = it
                    }
                    connectionManager.setHostAddress(host)
                    val connected = connectionManager.connect(host, connectPort)
                    if (!connected && !connectionManager.isConnected) {
                        Log.w(
                            tag,
                            "Direct ADB connect failed for $host:$connectPort. Trying mDNS auto-connect fallback.",
                        )
                        val autoConnected =
                            connectionManager.autoConnect(context, TimeUnit.SECONDS.toMillis(8))
                        if (!autoConnected && !connectionManager.isConnected) {
                            throw IOException(
                                "Unable to connect to ADB on $host:$connectPort. " +
                                    "Use Wireless debugging connect port shown on TV.",
                            )
                        }
                    }
                    _state.value = AdbSessionState.Connected(host, connectPort)
                    Log.d(tag, "ADB connected to $host:$connectPort")
                    Unit
                }.onFailure { e ->
                    val reason = mapConnectFailure(host, connectPort, e)
                    resetManager()
                    _state.value = AdbSessionState.Failed(
                        host = host,
                        port = connectPort,
                        reason = reason,
                    )
                    Log.e(tag, "ADB connect failed: $reason", e)
                }
            }
        }
    }

    suspend fun runShell(command: String): Result<String> {
        return withContext(Dispatchers.IO) {
            operationLock.withLock {
                runCatching {
                    val connectionManager = manager ?: throw IOException("ADB manager is not initialized")
                    if (!connectionManager.isConnected) {
                        throw IOException("ADB is not connected")
                    }
                    executeShellLocked(connectionManager, command)
                }.onFailure { e ->
                    if (host.isNotEmpty() && port > 0) {
                        _state.value = AdbSessionState.Failed(host, port, e.message.orEmpty())
                    }
                    Log.e(tag, "ADB shell failed: ${e.message}", e)
                }
            }
        }
    }

    suspend fun launchApp(
        packageName: String,
        activityName: String?,
        playStoreFallback: Boolean,
    ): Result<Map<String, Any>> {
        return withContext(Dispatchers.IO) {
            operationLock.withLock {
                runCatching {
                    val connectionManager = manager ?: throw IOException("ADB manager is not initialized")
                    if (!connectionManager.isConnected) {
                        throw IOException("ADB is not connected")
                    }

                    val intentCommand = if (!activityName.isNullOrBlank()) {
                        "am start -n $activityName"
                    } else {
                        "am start -a android.intent.action.MAIN -c android.intent.category.LAUNCHER -p $packageName"
                    }

                    val primaryOutput = executeShellLocked(connectionManager, intentCommand)
                    if (!containsLaunchError(primaryOutput)) {
                        return@runCatching mapOf(
                            "ok" to true,
                            "usedFallback" to false,
                            "openedPlayStore" to false,
                            "output" to primaryOutput,
                        )
                    }

                    val fallbackOutput = executeShellLocked(
                        connectionManager,
                        "monkey -p $packageName -c android.intent.category.LAUNCHER 1",
                    )
                    if (!containsLaunchError(fallbackOutput)) {
                        return@runCatching mapOf(
                            "ok" to true,
                            "usedFallback" to true,
                            "openedPlayStore" to false,
                            "output" to "$primaryOutput\n$fallbackOutput",
                        )
                    }

                    if (playStoreFallback) {
                        val storeOutput = executeShellLocked(
                            connectionManager,
                            "am start -a android.intent.action.VIEW -d market://details?id=$packageName",
                        )
                        return@runCatching mapOf(
                            "ok" to false,
                            "usedFallback" to true,
                            "openedPlayStore" to true,
                            "output" to "$primaryOutput\n$fallbackOutput\n$storeOutput",
                        )
                    }

                    mapOf(
                        "ok" to false,
                        "usedFallback" to true,
                        "openedPlayStore" to false,
                        "output" to "$primaryOutput\n$fallbackOutput",
                    )
                }.onFailure { e ->
                    if (host.isNotEmpty() && port > 0) {
                        _state.value = AdbSessionState.Failed(host, port, e.message.orEmpty())
                    }
                    Log.e(tag, "ADB launch failed: ${e.message}", e)
                }
            }
        }
    }

    fun disconnect() {
        runCatching {
            manager?.disconnect()
            manager = null
            host = ""
            port = 0
            _state.value = AdbSessionState.Disconnected
            Log.d(tag, "ADB disconnected")
        }.onFailure { e ->
            Log.w(tag, "ADB disconnect warning: ${e.message}")
            _state.value = AdbSessionState.Disconnected
        }
    }

    private fun createManager(host: String): TvAdbConnectionManager {
        return TvAdbConnectionManager().apply {
            setHostAddress(host)
            setApi(Build.VERSION.SDK_INT)
            setTimeout(12, TimeUnit.SECONDS)
            setThrowOnUnauthorised(true)
        }
    }

    private fun executeShellLocked(
        connectionManager: TvAdbConnectionManager,
        command: String,
    ): String {
        val stream = connectionManager.openStream("shell:$command")
        return readShellOutput(stream)
    }

    private fun readShellOutput(stream: AdbStream): String {
        return stream.use {
            val inputStream = it.openInputStream()
            val buffer = ByteArray(4096)
            val output = StringBuilder()
            while (true) {
                val read = inputStream.read(buffer)
                if (read <= 0) break
                output.append(String(buffer, 0, read))
            }
            output.toString().trim()
        }
    }

    private fun containsLaunchError(output: String): Boolean {
        val normalized = output.lowercase()
        return normalized.contains("error") ||
            normalized.contains("exception") ||
            normalized.contains("unable to resolve") ||
            normalized.contains("does not exist") ||
            normalized.contains("not started")
    }

    private fun mapConnectFailure(host: String, port: Int, error: Throwable): String {
        val root = rootCause(error)
        return when (root) {
            is AdbPairingRequiredException ->
                "ADB pairing is required. Pair this phone from TV Wireless debugging first."

            is AdbAuthenticationFailedException ->
                "ADB authorization failed. Remove paired devices on TV and pair again."

            is ConnectException ->
                "Cannot reach ADB at $host:$port. Verify TV IP and Wireless debugging connect port."

            is NoRouteToHostException, is UnknownHostException ->
                "Cannot reach $host. Verify TV IP address and that both devices are on the same Wi-Fi."

            is SocketTimeoutException ->
                "ADB connection timed out for $host:$port. Ensure phone and TV are on same Wi-Fi."

            is InterruptedException ->
                "ADB discovery timed out. Open Wireless debugging on TV and try again."

            is IOException ->
                when {
                    root.message?.contains("ECONNREFUSED", ignoreCase = true) == true ->
                        "Cannot reach ADB at $host:$port. Verify TV IP and Wireless debugging connect port."

                    root.message?.contains("timed out", ignoreCase = true) == true ->
                        "ADB connection timed out for $host:$port. Ensure phone and TV are on same Wi-Fi."

                    else ->
                        root.message
                            ?.takeIf { it.isNotBlank() }
                            ?: "ADB connection failed for $host:$port. Verify host and connect port on TV."
                }

            else -> root.message
                ?.takeIf { it.isNotBlank() }
                ?: "ADB connection failed for $host:$port. Verify host and connect port on TV."
        }
    }

    private fun resetManager() {
        runCatching { manager?.disconnect() }
            .onFailure { e -> Log.w(tag, "ADB reset warning: ${e.message}") }
        manager = null
    }

    private fun rootCause(error: Throwable): Throwable {
        var current = error
        while (current.cause != null && current.cause !== current) {
            current = current.cause!!
        }
        return current
    }

    private inner class TvAdbConnectionManager : AbsAdbConnectionManager() {
        override fun getPrivateKey(): PrivateKey = certStore.getClientPrivateKey()

        override fun getCertificate(): Certificate = certStore.getClientCertificate()

        override fun getDeviceName(): String = "ATV Remote"
    }
}
