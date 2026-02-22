package com.example.atv_remote.channels

import com.example.atv_remote.remote.RemoteConnectionState
import com.example.atv_remote.remote.RemoteSession
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

class RemoteChannel(
    private val remoteSession: RemoteSession,
    private val binaryMessenger: BinaryMessenger,
    private val scope: CoroutineScope
) {
    companion object {
        const val METHOD_CHANNEL_NAME = "com.tvremote.app/remote"
        const val EVENT_CHANNEL_NAME = "com.tvremote.app/remote/events"
    }

    fun register() {
        setupMethodChannel()
        setupEventChannel()
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
                        if (direction == 3) {
                            remoteSession.sendKey(keyCode, 1)
                            delay(80)
                            remoteSession.sendKey(keyCode, 2)
                        } else {
                            remoteSession.sendKey(keyCode, direction)
                        }
                    }
                    result.success(null)
                }
                "disconnect" -> {
                    remoteSession.disconnect()
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
                            sink?.success(state.toMap())
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

    private fun RemoteConnectionState.toMap(): Map<String, Any?> = when (this) {
        is RemoteConnectionState.Disconnected ->
            mapOf("state" to "DISCONNECTED")
        is RemoteConnectionState.Connecting ->
            mapOf("state" to "CONNECTING", "ip" to deviceIp)
        is RemoteConnectionState.Connected ->
            mapOf("state" to "CONNECTED", "ip" to deviceIp, "name" to deviceName)
        is RemoteConnectionState.Reconnecting ->
            mapOf("state" to "RECONNECTING", "ip" to deviceIp, "attempt" to attempt, "maxAttempts" to maxAttempts)
        is RemoteConnectionState.Failed ->
            mapOf("state" to "FAILED", "ip" to deviceIp, "reason" to reason)
    }
}