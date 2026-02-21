package com.example.atv_remote.channels

import android.util.Log
import com.example.atv_remote.remote.RemoteSession
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

/**
 * Bridges [RemoteSession] to Flutter via:
 * - MethodChannel: connect / sendKey / disconnect
 * - EventChannel: connection-state updates
 *
 * The special [direction] value 3 ("DOWN_UP") sends a discrete DOWN+UP
 * pair with an 80ms gap — used for momentary key presses from the UI.
 */
class RemoteChannel(
    private val remoteSession: RemoteSession,
    private val binaryMessenger: BinaryMessenger,
    private val scope: CoroutineScope
) {
    companion object {
        const val METHOD_CHANNEL_NAME = "com.tvremote.app/remote"
        const val EVENT_CHANNEL_NAME  = "com.tvremote.app/remote/events"
    }

    private val tag = "TvRemote"

    fun register() {
        setupMethodChannel()
        setupEventChannel()
    }

    private fun setupMethodChannel() {
        MethodChannel(binaryMessenger, METHOD_CHANNEL_NAME).setMethodCallHandler { call, result ->
            when (call.method) {
                "connect" -> {
                    val ip   = call.argument<String>("ip")
                        ?: return@setMethodCallHandler result.error("INVALID_ARGS", "ip required", null)
                    val name = call.argument<String>("name") ?: "TV"
                    val port = call.argument<Int>("port") ?: 6466

                    Log.d(tag, "MethodChannel: connect ip=$ip name=$name port=$port")
                    scope.launch { remoteSession.connect(ip, name, port) }
                    result.success(null)
                }

                "sendKey" -> {
                    val keyCode   = call.argument<Int>("keyCode")
                        ?: return@setMethodCallHandler result.error("INVALID_ARGS", "keyCode required", null)
                    val direction = call.argument<Int>("direction") ?: 3  // default: DOWN_UP

                    Log.d(tag, "MethodChannel: sendKey keyCode=$keyCode direction=$direction")
                    scope.launch(Dispatchers.IO) {
                        when (direction) {
                            3 -> { // DOWN_UP — press and release
                                remoteSession.sendKey(keyCode, 1) // DOWN
                                delay(80)
                                remoteSession.sendKey(keyCode, 2) // UP
                            }
                            else -> remoteSession.sendKey(keyCode, direction)
                        }
                    }
                    result.success(null)
                }

                "disconnect" -> {
                    Log.d(tag, "MethodChannel: disconnect")
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
                private var stateJob: Job? = null

                override fun onListen(arguments: Any?, sink: EventChannel.EventSink?) {
                    Log.d(tag, "RemoteChannel EventChannel: onListen")
                    stateJob = scope.launch(Dispatchers.Main) {
                        remoteSession.connectionState.collect { state ->
                            sink?.success(state.toMap())
                        }
                    }
                }

                override fun onCancel(arguments: Any?) {
                    Log.d(tag, "RemoteChannel EventChannel: onCancel")
                    stateJob?.cancel()
                    stateJob = null
                }
            }
        )
    }
}
