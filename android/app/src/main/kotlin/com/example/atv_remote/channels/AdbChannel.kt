package com.example.atv_remote.channels

import com.example.atv_remote.adb.AdbSessionManager
import com.example.atv_remote.adb.AdbSessionState
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class AdbChannel(
    private val adbSessionManager: AdbSessionManager,
    private val binaryMessenger: BinaryMessenger,
    private val scope: CoroutineScope,
) {
    companion object {
        const val METHOD_CHANNEL_NAME = "com.tvremote.app/adb"
        const val EVENT_CHANNEL_NAME = "com.tvremote.app/adb/events"
    }

    fun register() {
        setupMethodChannel()
        setupEventChannel()
    }

    private fun setupMethodChannel() {
        MethodChannel(binaryMessenger, METHOD_CHANNEL_NAME).setMethodCallHandler { call, result ->
            when (call.method) {
                "pair" -> {
                    val host = call.argument<String>("host")
                        ?: return@setMethodCallHandler result.error("INVALID_ARGS", "host required", null)
                    val port = call.argument<Int>("port")
                        ?: return@setMethodCallHandler result.error("INVALID_ARGS", "port required", null)
                    val code = call.argument<String>("pairingCode")
                        ?: return@setMethodCallHandler result.error("INVALID_ARGS", "pairingCode required", null)

                    scope.launch {
                        val pairResult = adbSessionManager.pair(host, port, code)
                        withContext(Dispatchers.Main) {
                            pairResult.fold(
                                onSuccess = { result.success(mapOf("ok" to true)) },
                                onFailure = { error ->
                                    result.error(
                                        "ADB_PAIR_FAILED",
                                        error.message ?: "ADB pairing failed",
                                        null,
                                    )
                                },
                            )
                        }
                    }
                }

                "connect" -> {
                    val host = call.argument<String>("host")
                        ?: return@setMethodCallHandler result.error("INVALID_ARGS", "host required", null)
                    val port = call.argument<Int>("port")
                        ?: return@setMethodCallHandler result.error("INVALID_ARGS", "port required", null)

                    scope.launch {
                        val connectResult = adbSessionManager.connect(host, port)
                        withContext(Dispatchers.Main) {
                            connectResult.fold(
                                onSuccess = { result.success(mapOf("ok" to true)) },
                                onFailure = { error ->
                                    result.error(
                                        "ADB_CONNECT_FAILED",
                                        error.message ?: "ADB connection failed",
                                        null,
                                    )
                                },
                            )
                        }
                    }
                }

                "disconnect" -> {
                    adbSessionManager.disconnect()
                    result.success(null)
                }

                "runShell" -> {
                    val command = call.argument<String>("command")
                        ?: return@setMethodCallHandler result.error("INVALID_ARGS", "command required", null)

                    scope.launch {
                        val shellResult = adbSessionManager.runShell(command)
                        withContext(Dispatchers.Main) {
                            shellResult.fold(
                                onSuccess = { output ->
                                    result.success(mapOf("ok" to true, "output" to output))
                                },
                                onFailure = { error ->
                                    result.error(
                                        "ADB_SHELL_FAILED",
                                        error.message ?: "ADB shell failed",
                                        null,
                                    )
                                },
                            )
                        }
                    }
                }

                "launchApp" -> {
                    val packageName = call.argument<String>("packageName")
                        ?: return@setMethodCallHandler result.error("INVALID_ARGS", "packageName required", null)
                    val activityName = call.argument<String>("activityName")
                    val playStoreFallback = call.argument<Boolean>("playStoreFallback") ?: true

                    scope.launch {
                        val launchResult = adbSessionManager.launchApp(
                            packageName = packageName,
                            activityName = activityName,
                            playStoreFallback = playStoreFallback,
                        )
                        withContext(Dispatchers.Main) {
                            launchResult.fold(
                                onSuccess = { output -> result.success(output) },
                                onFailure = { error ->
                                    result.error(
                                        "ADB_LAUNCH_FAILED",
                                        error.message ?: "App launch failed",
                                        null,
                                    )
                                },
                            )
                        }
                    }
                }

                else -> result.notImplemented()
            }
        }
    }

    private fun setupEventChannel() {
        EventChannel(binaryMessenger, EVENT_CHANNEL_NAME).setStreamHandler(
            object : EventChannel.StreamHandler {
                private var job: Job? = null

                override fun onListen(arguments: Any?, sink: EventChannel.EventSink?) {
                    job?.cancel()
                    job = scope.launch {
                        adbSessionManager.state.collect { state ->
                            withContext(Dispatchers.Main) {
                                sink?.success(state.toMap())
                            }
                        }
                    }
                }

                override fun onCancel(arguments: Any?) {
                    job?.cancel()
                    job = null
                }
            },
        )
    }

    private fun AdbSessionState.toMap(): Map<String, Any?> = when (this) {
        is AdbSessionState.Disconnected -> mapOf(
            "state" to "DISCONNECTED",
            "connected" to false,
        )

        is AdbSessionState.Pairing -> mapOf(
            "state" to "PAIRING",
            "host" to host,
            "port" to port,
            "connected" to false,
        )

        is AdbSessionState.Connecting -> mapOf(
            "state" to "CONNECTING",
            "host" to host,
            "port" to port,
            "connected" to false,
        )

        is AdbSessionState.Connected -> mapOf(
            "state" to "CONNECTED",
            "host" to host,
            "port" to port,
            "connected" to true,
        )

        is AdbSessionState.Failed -> mapOf(
            "state" to "FAILED",
            "host" to host,
            "port" to port,
            "reason" to reason,
            "connected" to false,
        )
    }
}
