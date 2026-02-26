package com.example.atv_remote.channels

import com.example.atv_remote.remote.RemoteSession
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class RemoteChannel(
    private val remoteSession: RemoteSession,
    private val binaryMessenger: BinaryMessenger,
    private val scope: CoroutineScope
) {
    companion object {
        const val METHOD_CHANNEL_NAME = "com.tvremote.app/remote"
        const val EVENT_CHANNEL_NAME = "com.tvremote.app/remote/events"
        const val VOLUME_EVENT_CHANNEL_NAME = "com.tvremote.app/remote/volume/events"
    }

    fun register() {
        setupMethodChannel()
        setupEventChannel()
        setupVolumeEventChannel()
    }

    private fun setupMethodChannel() {
        MethodChannel(binaryMessenger, METHOD_CHANNEL_NAME).setMethodCallHandler { call, result ->
            when (call.method) {
                "connect" -> {
                    val ip = call.argument<String>("ip")
                        ?: return@setMethodCallHandler result.error("INVALID_ARGS", "ip required", null)
                    val name = call.argument<String>("name") ?: "TV"
                    val port = call.argument<Int>("port") ?: RemoteSession.REMOTE_PORT
                    scope.launch { remoteSession.connect(ip, name, port) }
                    result.success(null)
                }
                "sendKey" -> {
                    val keyCode = call.argument<Int>("keyCode")
                        ?: return@setMethodCallHandler result.error("INVALID_ARGS", "keyCode required", null)
                    val direction = call.argument<Int>("direction") ?: 3
                    scope.launch {
                        try {
                            remoteSession.sendKey(keyCode, direction)
                            withContext(Dispatchers.Main) { result.success(null) }
                        } catch (e: IllegalArgumentException) {
                            withContext(Dispatchers.Main) {
                                result.error("INVALID_KEY", e.message, null)
                            }
                        } catch (e: Exception) {
                            withContext(Dispatchers.Main) {
                                result.error(
                                    "SEND_KEY_FAILED",
                                    e.message ?: "Failed to send key",
                                    null,
                                )
                            }
                        }
                    }
                }
                "disconnect" -> {
                    remoteSession.disconnect()
                    result.success(null)
                }
                "setAutoReconnect" -> {
                    val enabled = call.argument<Boolean>("enabled") ?: true
                    remoteSession.setAutoReconnectEnabled(enabled)
                    result.success(null)
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
                    job = scope.launch {
                        remoteSession.connectionState.collect { state ->
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
            }
        )
    }

    private fun setupVolumeEventChannel() {
        EventChannel(binaryMessenger, VOLUME_EVENT_CHANNEL_NAME).setStreamHandler(
            object : EventChannel.StreamHandler {
                private var job: Job? = null

                override fun onListen(arguments: Any?, sink: EventChannel.EventSink?) {
                    job = scope.launch {
                        remoteSession.volumeState.collect { state ->
                            withContext(Dispatchers.Main) {
                                if (state != null) {
                                    sink?.success(state.toMap())
                                }
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
}
