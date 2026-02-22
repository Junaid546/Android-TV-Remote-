package com.example.atv_remote.discovery

import android.content.Context
import android.net.nsd.NsdManager
import android.net.nsd.NsdServiceInfo
import android.net.wifi.WifiManager
import android.util.Log
import kotlinx.coroutines.*
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharedFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asSharedFlow
import kotlinx.coroutines.flow.asStateFlow
import java.net.InetSocketAddress
import java.net.Socket
import java.util.concurrent.ConcurrentHashMap

class NsdDiscoveryEngine(
    private val context: Context,
    private val scope: CoroutineScope
) {
    private val tag = "TvDiscovery"
    private val subnetTag = "TvSubnetScan"

    private val _devicesFlow = MutableStateFlow<List<DiscoveredDevice>>(emptyList())
    val devicesFlow: StateFlow<List<DiscoveredDevice>> = _devicesFlow.asStateFlow()

    private val _errorFlow = MutableSharedFlow<String>()
    val errorFlow: SharedFlow<String> = _errorFlow.asSharedFlow()

    private val nsdManager: NsdManager? by lazy {
        context.getSystemService(Context.NSD_SERVICE) as? NsdManager
    }

    private val wifiManager: WifiManager? by lazy {
        context.applicationContext.getSystemService(Context.WIFI_SERVICE) as? WifiManager
    }

    private var multicastLock: WifiManager.MulticastLock? = null
    private val discoveryListeners = mutableListOf<NsdManager.DiscoveryListener>()
    private val discoveredIps = ConcurrentHashMap.newKeySet<String>()
    
    private var scanJob: Job? = null
    private var subnetFallbackJob: Job? = null

    private val serviceTypes = listOf(
        "_androidtvremote2._tcp",
        "_androidtvremote._tcp",
        "_googlerpc._tcp"
    )

    fun startDiscovery() {
        Log.d(tag, "startDiscovery requested")
        stopDiscovery()

        _devicesFlow.value = emptyList()
        discoveredIps.clear()

        acquireMulticastLock()

        scanJob = scope.launch(Dispatchers.IO) {
            startNsdDiscovery()
            
            // 15 seconds wait for fallback
            delay(15000L)
            if (discoveredIps.isEmpty() && isActive) {
                Log.d(tag, "15s passed with no devices. Starting subnet fallback scan.")
                startSubnetScan()
            }
        }
    }

    private fun startNsdDiscovery() {
        serviceTypes.forEach { serviceType ->
            startServiceDiscovery(serviceType)
        }
    }

    private fun startServiceDiscovery(serviceType: String) {
        val listener = object : NsdManager.DiscoveryListener {
            override fun onDiscoveryStarted(regType: String) {
                Log.d(tag, "onDiscoveryStarted: $regType")
            }

            override fun onServiceFound(serviceInfo: NsdServiceInfo) {
                Log.d(tag, "onServiceFound: ${serviceInfo.serviceName} type: ${serviceInfo.serviceType}")
                resolveServiceWithRetry(serviceInfo, 0)
            }

            override fun onServiceLost(serviceInfo: NsdServiceInfo) {
                Log.d(tag, "onServiceLost: ${serviceInfo.serviceName}")
                scope.launch {
                    val currentList = _devicesFlow.value
                    val newList = currentList.filterNot { it.name == serviceInfo.serviceName }
                    if (newList.size != currentList.size) {
                        _devicesFlow.emit(newList)
                    }
                }
            }

            override fun onDiscoveryStopped(type: String) {
                Log.d(tag, "onDiscoveryStopped: $type")
            }

            override fun onStartDiscoveryFailed(type: String, errorCode: Int) {
                Log.e(tag, "onStartDiscoveryFailed: $errorCode for $type")
                try {
                    nsdManager?.stopServiceDiscovery(this)
                } catch (e: Exception) {
                    Log.e(tag, "Error stopping after start fail", e)
                }
                // Handle ALREADY_ACTIVE by restarting
                if (errorCode == NsdManager.FAILURE_ALREADY_ACTIVE) {
                    scope.launch(Dispatchers.IO) {
                        delay(1000)
                        startServiceDiscovery(type)
                    }
                }
            }

            override fun onStopDiscoveryFailed(type: String, errorCode: Int) {
                Log.e(tag, "onStopDiscoveryFailed: $errorCode for $type")
            }
        }

        synchronized(discoveryListeners) {
            discoveryListeners.add(listener)
        }
        try {
            nsdManager?.discoverServices(serviceType, NsdManager.PROTOCOL_DNS_SD, listener)
        } catch (e: Exception) {
            Log.e(tag, "Error starting discovery for $serviceType", e)
        }
    }

    private fun resolveServiceWithRetry(serviceInfo: NsdServiceInfo, attempt: Int) {
        val resolveListener = object : NsdManager.ResolveListener {
            override fun onResolveFailed(serviceInfo: NsdServiceInfo, errorCode: Int) {
                Log.e(tag, "onResolveFailed for ${serviceInfo.serviceName}: $errorCode")
                if (errorCode == NsdManager.FAILURE_ALREADY_ACTIVE && attempt < 3) {
                    scope.launch(Dispatchers.IO) {
                        delay(500)
                        resolveServiceWithRetry(serviceInfo, attempt + 1)
                    }
                }
            }

            override fun onServiceResolved(resolvedInfo: NsdServiceInfo) {
                Log.d(tag, "onServiceResolved: ${resolvedInfo.serviceName}")
                val ip = resolvedInfo.host?.hostAddress ?: resolvedInfo.host?.canonicalHostName ?: return
                
                if (!ip.contains('.')) { // Skip IPv6
                    return
                }

                if (discoveredIps.contains(ip)) return

                scope.launch(Dispatchers.IO) {
                    if (probeTcpPort(ip, 6466)) {
                        if (discoveredIps.add(ip)) {
                            val device = DiscoveredDevice(
                                id = ip,
                                name = resolvedInfo.serviceName,
                                ipAddress = ip,
                                port = resolvedInfo.port.takeIf { it > 0 } ?: 6466,
                                serviceType = resolvedInfo.serviceType
                            )
                            val currentList = _devicesFlow.value
                            _devicesFlow.emit(currentList + device)
                        }
                    }
                }
            }
        }
        try {
            nsdManager?.resolveService(serviceInfo, resolveListener)
        } catch (e: Exception) {
            Log.e(tag, "Exception in resolveService", e)
            if (attempt < 3) {
                scope.launch(Dispatchers.IO) {
                    delay(500)
                    resolveServiceWithRetry(serviceInfo, attempt + 1)
                }
            }
        }
    }

    private fun startSubnetScan() {
        subnetFallbackJob?.cancel()
        subnetFallbackJob = scope.launch(Dispatchers.IO) {
            val dhcpInfo = wifiManager?.dhcpInfo ?: return@launch
            val ipAddress = dhcpInfo.ipAddress
            // ipAddress is little-endian
            val ipBytes = byteArrayOf(
                (ipAddress and 0xFF).toByte(),
                ((ipAddress shr 8) and 0xFF).toByte(),
                ((ipAddress shr 16) and 0xFF).toByte(),
                0
            )
            
            val baseIp = "${ipBytes[0].toInt() and 0xFF}.${ipBytes[1].toInt() and 0xFF}.${ipBytes[2].toInt() and 0xFF}"
            Log.d(tag, "Starting subnet scan on $baseIp.x")

            val deferredList = mutableListOf<Deferred<Unit>>()
            val semaphore = kotlinx.coroutines.sync.Semaphore(20)
            
            for (i in 1..254) {
                val ip = "$baseIp.$i"
                deferredList.add(async {
                    semaphore.acquire()
                    try {
                        if (!discoveredIps.contains(ip)) {
                            Log.d(subnetTag, "Probing $ip")
                            if (probeTcpPort(ip, 6466) || probeTcpPort(ip, 6467)) {
                                if (discoveredIps.add(ip)) {
                                    val device = DiscoveredDevice(
                                        id = ip,
                                        name = "Android TV ($ip)",
                                        ipAddress = ip,
                                        port = 6466,
                                        serviceType = "SubnetScan"
                                    )
                                    val currentList = _devicesFlow.value
                                    _devicesFlow.emit(currentList + device)
                                }
                            }
                        }
                    } finally {
                        semaphore.release()
                    }
                })
            }
            deferredList.awaitAll()
            Log.d(tag, "Subnet scan completed")
        }
    }

    private fun probeTcpPort(ip: String, port: Int): Boolean {
        var socket: Socket? = null
        return try {
            socket = Socket()
            socket.connect(InetSocketAddress(ip, port), 3000)
            true
        } catch (e: Exception) {
            false
        } finally {
            try {
                socket?.close()
            } catch (e: Exception) {
                // Ignore close errors
            }
        }
    }

    fun stopDiscovery() {
        Log.d(tag, "stopDiscovery requested")
        
        scanJob?.cancel()
        scanJob = null
        subnetFallbackJob?.cancel()
        subnetFallbackJob = null

        synchronized(discoveryListeners) {
            discoveryListeners.forEach { listener ->
                try {
                    nsdManager?.stopServiceDiscovery(listener)
                } catch (e: Exception) {
                    Log.w(tag, "stopDiscovery failed: ${e.message}")
                }
            }
            discoveryListeners.clear()
        }
        
        releaseMulticastLock()
    }

    private fun acquireMulticastLock() {
        if (multicastLock == null) {
            multicastLock = wifiManager?.createMulticastLock("NsdDiscovery")
            multicastLock?.setReferenceCounted(false)
        }
        try {
            if (multicastLock?.isHeld == false) {
                multicastLock?.acquire()
                Log.d(tag, "MulticastLock acquired")
            }
        } catch (e: Exception) {
            Log.e(tag, "Error acquiring MulticastLock", e)
        }
    }

    private fun releaseMulticastLock() {
        try {
            multicastLock?.let {
                if (it.isHeld) {
                    it.release()
                    Log.d(tag, "MulticastLock released")
                }
            }
        } catch (e: Exception) {
            Log.e(tag, "Error releasing MulticastLock", e)
        }
    }

    fun destroy() {
        stopDiscovery()
    }
}
