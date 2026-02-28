package com.example.atv_remote.channels

import android.annotation.SuppressLint
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.PowerManager
import android.provider.Settings
import com.example.atv_remote.remote.RemoteSession
import com.example.atv_remote.remote.SecureConfigManager
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class RemoteChannel(
    private val context: Context,
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
                    scope.launch {
                        com.example.atv_remote.remote.SecureConfigManager(context).saveTvState(ip, name, port)
                        remoteSession.connect(ip, name, port) 
                    }
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
                    scope.launch {
                        SecureConfigManager(context).markIntentActive(false)
                    }
                    remoteSession.disconnect()
                    result.success(null)
                }
                "setAutoReconnect" -> {
                    val enabled = call.argument<Boolean>("enabled") ?: true
                    remoteSession.setAutoReconnectEnabled(enabled)
                    result.success(null)
                }
                "isIgnoringBatteryOptimizations" -> {
                    val pm = context.getSystemService(Context.POWER_SERVICE) as PowerManager
                    val isIgnoring = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                        pm.isIgnoringBatteryOptimizations(context.packageName)
                    } else {
                        true
                    }
                    result.success(isIgnoring)
                }
                "requestIgnoreBatteryOptimizations" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                        @SuppressLint("BatteryLife")
                        val intent = Intent(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS).apply {
                            data = Uri.parse("package:${context.packageName}")
                            flags = Intent.FLAG_ACTIVITY_NEW_TASK
                        }
                        context.startActivity(intent)
                        result.success(true)
                    } else {
                        result.success(false)
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
