package com.example.atv_remote.channels

import com.example.atv_remote.discovery.DiscoveredDevice
import com.example.atv_remote.discovery.NsdDiscoveryEngine
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.*
import kotlinx.coroutines.flow.collectLatest
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

    private var methodChannel: MethodChannel? = null
    private var eventChannel: EventChannel? = null
    private var eventJob: Job? = null

    init {
        setupChannels()
    }

    private fun setupChannels() {
        methodChannel = MethodChannel(binaryMessenger, METHOD_CHANNEL_NAME).apply {
            setMethodCallHandler { call, result ->
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
                            result.error("INVALID_ARGS", "IP is required", null)
                            return@setMethodCallHandler
                        }

                        coroutineScope.launch(Dispatchers.IO) {
                            val reachable = try {
                                Socket().use { socket ->
                                    socket.connect(InetSocketAddress(ip, 6466), 10000)
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
                                    // Normally we should also update engine or just return it
                                    // For now, return it and assume UI adds it
                                    result.success(device.toMap())
                                } else {
                                    result.error("UNREACHABLE", "Device at $ip not reachable on port 6466", null)
                                }
                            }
                        }
                    }
                    else -> result.notImplemented()
                }
            }
        }

        eventChannel = EventChannel(binaryMessenger, EVENT_CHANNEL_NAME).apply {
            setStreamHandler(object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    eventJob = coroutineScope.launch(Dispatchers.IO) {
                        try {
                            engine.devicesFlow.collectLatest { devices ->
                                withContext(Dispatchers.Main) {
                                    events?.success(devices.map { it.toMap() })
                                }
                            }
                        } catch (e: Exception) {
                            withContext(Dispatchers.Main) {
                                events?.error("DISCOVERY_ERROR", e.message, null)
                            }
                        }
                    }
                    
                    // Also collect errors
                    coroutineScope.launch(Dispatchers.IO) {
                        engine.errorFlow.collect { error ->
                            withContext(Dispatchers.Main) {
                                events?.error("DISCOVERY_ERROR", error, null)
                            }
                        }
                    }
                }

                override fun onCancel(arguments: Any?) {
                    eventJob?.cancel()
                    eventJob = null
                }
            })
        }
    }
}
