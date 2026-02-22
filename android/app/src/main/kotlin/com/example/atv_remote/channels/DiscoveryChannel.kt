package com.example.atv_remote.channels

import com.example.atv_remote.discovery.DiscoveredDevice
import com.example.atv_remote.discovery.NsdDiscoveryEngine
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.flow.collectLatest
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.net.InetSocketAddress
import java.net.Socket

class DiscoveryChannel(
    private val engine: NsdDiscoveryEngine,
    private val binaryMessenger: BinaryMessenger,
    private val coroutineScope: CoroutineScope
) {
    companion object {
        const val METHOD_CHANNEL_NAME = "com.tvremote.app/discovery"
        const val EVENT_CHANNEL_NAME = "com.tvremote.app/discovery/events"
    }

    private var eventJob: Job? = null

    // Called from MainActivity — matches .register() call
    fun register() {
        setupMethodChannel()
        setupEventChannel()
    }

    private fun setupMethodChannel() {
        MethodChannel(binaryMessenger, METHOD_CHANNEL_NAME).setMethodCallHandler { call, result ->
            when (call.method) {
                "startDiscovery" -> {
                    engine.startDiscovery()
                    result.success(null)
                }
                "stopDiscovery" -> {
                    engine.stopDiscovery()
                    result.success(null)
                }
                "addManualDevice" -> {
                    val args = call.arguments as? Map<*, *>
                    val ip = args?.get("ip") as? String
                    val name = args?.get("name") as? String ?: "Manual Device"

                    if (ip == null) {
                        result.error("INVALID_ARGS", "ip is required", null)
                        return@setMethodCallHandler
                    }

                    coroutineScope.launch(Dispatchers.IO) {
                        val reachable = try {
                            Socket().use { socket ->
                                socket.connect(InetSocketAddress(ip, 6466), 10_000)
                                true
                            }
                        } catch (e: Exception) {
                            false
                        }

                        withContext(Dispatchers.Main) {
                            if (reachable) {
                                val device = DiscoveredDevice(
                                    id = ip,
                                    name = name,
                                    ipAddress = ip,
                                    port = 6466,
                                    serviceType = "_androidtvremote2._tcp"
                                )
                                result.success(device.toMap())
                            } else {
                                result.error(
                                    "UNREACHABLE",
                                    "Device at $ip not reachable on port 6466",
                                    null
                                )
                            }
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
                override fun onListen(arguments: Any?, sink: EventChannel.EventSink?) {
                    eventJob = coroutineScope.launch(Dispatchers.IO) {
                        // Device list stream
                        launch {
                            try {
                                engine.devicesFlow.collectLatest { devices ->
                                    withContext(Dispatchers.Main) {
                                        sink?.success(devices.map { it.toMap() })
                                    }
                                }
                            } catch (e: Exception) {
                                withContext(Dispatchers.Main) {
                                    sink?.error("DISCOVERY_ERROR", e.message, null)
                                }
                            }
                        }
                        // Error stream
                        launch {
                            engine.errorFlow.collect { error ->
                                withContext(Dispatchers.Main) {
                                    sink?.error("DISCOVERY_ERROR", error, null)
                                }
                            }
                        }
                    }
                }

                override fun onCancel(arguments: Any?) {
                    eventJob?.cancel()
                    eventJob = null
                }
            }
        )
    }
}