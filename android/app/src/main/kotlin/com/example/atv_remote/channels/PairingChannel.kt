package com.example.atv_remote.channels

import android.util.Log
import com.example.atv_remote.pairing.PairingManager
import com.example.atv_remote.pairing.PairingState
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.launch

class PairingChannel(
    private val pairingManager: PairingManager,
    private val binaryMessenger: BinaryMessenger,
    private val scope: CoroutineScope
) {
    companion object {
        const val METHOD_CHANNEL_NAME = "com.tvremote.app/pairing"
        const val EVENT_CHANNEL_NAME = "com.tvremote.app/pairing/events"
    }

    private val tag = "TvPairing"
    private val methodChannel = MethodChannel(binaryMessenger, METHOD_CHANNEL_NAME)
    private val eventChannel = EventChannel(binaryMessenger, EVENT_CHANNEL_NAME)
    private var stateJob: Job? = null

    fun register() {
        setupMethodChannel()
        setupEventChannel()
    }

    private fun setupMethodChannel() {
        methodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "startPairing" -> {
                    val ip = call.argument<String>("ip")
                        ?: return@setMethodCallHandler result.error("INVALID_ARGS", "ip required", null)
                    val port = call.argument<Int>("port") ?: 6467
                    val name = call.argument<String>("name") ?: "Android TV"

                    Log.d(tag, "MethodChannel: startPairing ip=$ip port=$port name=$name")
                    scope.launch {
                        pairingManager.startPairing(
                            deviceIp = ip,
                            devicePort = port,
                            deviceName = name
                        )
                    }
                    result.success(null)
                }

                "submitPin" -> {
                    val pin = call.argument<String>("pin")
                        ?: return@setMethodCallHandler result.error("INVALID_ARGS", "pin required", null)

                    Log.d(tag, "MethodChannel: submitPin (length=${pin.length})")
                    scope.launch {
                        pairingManager.submitPin(pin)
                    }
                    result.success(null)
                }

                "cancelPairing" -> {
                    Log.d(tag, "MethodChannel: cancelPairing")
                    pairingManager.cancel()
                    result.success(null)
                }

                else -> result.notImplemented()
            }
        }
    }

    private fun setupEventChannel() {
        eventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, sink: EventChannel.EventSink?) {
                Log.d(tag, "EventChannel: onListen")
                stateJob = scope.launch {
                    // Pairing state stream
                    launch(Dispatchers.Main) {
                        pairingManager.state.collect { state ->
                            val map: Map<String, Any?> = mapOf(
                                "type" to "STATE",
                                "state" to state.toStateString(),
                                "errorCode" to (state as? PairingState.Failed)?.code,
                                "errorMessage" to (state as? PairingState.Failed)?.reason
                            )
                            sink?.success(map)
                        }
                    }
                    // PIN countdown stream
                    launch(Dispatchers.Main) {
                        pairingManager.pinExpiry.collect { seconds ->
                            sink?.success(
                                mapOf(
                                    "type" to "PIN_EXPIRY",
                                    "seconds" to seconds
                                )
                            )
                        }
                    }
                }
            }

            override fun onCancel(arguments: Any?) {
                Log.d(tag, "EventChannel: onCancel")
                stateJob?.cancel()
                stateJob = null
            }
        })
    }

    private fun PairingState.toStateString(): String = when (this) {
        PairingState.Idle -> "IDLE"
        PairingState.Connecting -> "CONNECTING"
        PairingState.AwaitingPin -> "AWAITING_PIN"
        PairingState.VerifyingPin -> "VERIFYING_PIN"
        PairingState.Success -> "SUCCESS"
        is PairingState.Failed -> "FAILED"
    }
}
