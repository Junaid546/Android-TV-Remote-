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

    private val tag = "TvPairingChannel"
    private var stateJob: Job? = null

    fun register() {
        setupMethodChannel()
        setupEventChannel()
    }

    private fun setupMethodChannel() {
        MethodChannel(binaryMessenger, METHOD_CHANNEL_NAME).setMethodCallHandler { call, result ->
            when (call.method) {
                "startPairing" -> {
                    val ip = call.argument<String>("ip")
                        ?: return@setMethodCallHandler result.error("INVALID_ARGS", "ip required", null)
                    val name = call.argument<String>("name") ?: "Android TV"
                    Log.d(tag, "startPairing ip=$ip name=$name")
                    scope.launch { pairingManager.startPairing(ip = ip, deviceName = name) }
                    result.success(null)
                }
                "submitPin" -> {
                    val pin = call.argument<String>("pin")
                        ?: return@setMethodCallHandler result.error("INVALID_ARGS", "pin required", null)
                    Log.d(tag, "submitPin length=${pin.length}")
                    scope.launch { pairingManager.submitPin(pin) }
                    result.success(null)
                }
                "cancelPairing" -> {
                    Log.d(tag, "cancelPairing")
                    pairingManager.cancel()
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun setupEventChannel() {
        EventChannel(binaryMessenger, EVENT_CHANNEL_NAME).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, sink: EventChannel.EventSink?) {
                    Log.d(tag, "EventChannel onListen")
                    stateJob = scope.launch {
                        // Pairing state stream
                        launch(Dispatchers.Main) {
                            pairingManager.state.collect { state ->
                                sink?.success(state.toMap())
                            }
                        }
                        // PIN countdown stream
                        launch(Dispatchers.Main) {
                            pairingManager.pinExpiry.collect { seconds ->
                                sink?.success(
                                    mapOf("type" to "PIN_EXPIRY", "seconds" to seconds)
                                )
                            }
                        }
                    }
                }

                override fun onCancel(arguments: Any?) {
                    Log.d(tag, "EventChannel onCancel")
                    stateJob?.cancel()
                    stateJob = null
                }
            }
        )
    }

    // Matches PairingState sealed class in PairingManager.kt exactly
    private fun PairingState.toMap(): Map<String, Any?> = when (this) {
        is PairingState.Idle ->
            mapOf("type" to "STATE", "state" to "IDLE")
        is PairingState.Connecting ->
            mapOf("type" to "STATE", "state" to "CONNECTING", "ip" to this.ip)
        is PairingState.AwaitingPin ->
            mapOf("type" to "STATE", "state" to "AWAITING_PIN")
        is PairingState.Verifying ->
            mapOf("type" to "STATE", "state" to "VERIFYING", "ip" to this.ip)
        is PairingState.Success ->
            mapOf("type" to "STATE", "state" to "SUCCESS")
        is PairingState.Failed ->
            mapOf(
                "type" to "STATE",
                "state" to "FAILED",
                "errorCode" to this.code,
                "errorMessage" to this.reason
            )
    }
}