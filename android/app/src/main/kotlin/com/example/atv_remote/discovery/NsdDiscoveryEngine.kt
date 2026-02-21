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
import kotlinx.coroutines.sync.Mutex
import kotlinx.coroutines.sync.withLock
import java.util.concurrent.atomic.AtomicBoolean
import java.util.concurrent.atomic.AtomicInteger

class NsdDiscoveryEngine(private val context: Context) {
    private val tag = "TvDiscovery"
    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.IO)

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
    private var discoveryListener: NsdManager.DiscoveryListener? = null

    private val resolveQueue = ArrayDeque<NsdServiceInfo>()
    private val resolving = AtomicBoolean(false)
    private val discoveredIps = mutableSetOf<String>()
    
    // Retry tracking for resolve failures
    private val retryCountMap = mutableMapOf<String, Int>()
    private val MAX_RETRIES = 3

    fun startDiscovery() {
        Log.d(tag, "startDiscovery requested")
        stopDiscovery()

        _devicesFlow.value = emptyList()
        discoveredIps.clear()
        retryCountMap.clear()

        acquireMulticastLock()

        val listener = object : NsdManager.DiscoveryListener {
            override fun onDiscoveryStarted(regType: String) {
                Log.d(tag, "onDiscoveryStarted: $regType")
            }

            override fun onServiceFound(serviceInfo: NsdServiceInfo) {
                Log.d(tag, "onServiceFound: ${serviceInfo.serviceName}")
                if (serviceInfo.serviceType == "_androidtvremote2._tcp.") {
                   synchronized(resolveQueue) {
                       resolveQueue.add(serviceInfo)
                   }
                   triggerResolve()
                }
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

            override fun onDiscoveryStopped(serviceType: String) {
                Log.d(tag, "onDiscoveryStopped: $serviceType")
                discoveryListener = null
            }

            override fun onStartDiscoveryFailed(serviceType: String, errorCode: Int) {
                Log.e(tag, "onStartDiscoveryFailed: $errorCode")
                scope.launch {
                    _errorFlow.emit("Discovery start failed with error code: $errorCode")
                }
                stopDiscovery()
            }

            override fun onStopDiscoveryFailed(serviceType: String, errorCode: Int) {
                Log.e(tag, "onStopDiscoveryFailed: $errorCode")
            }
        }

        discoveryListener = listener
        try {
            nsdManager?.discoverServices("_androidtvremote2._tcp", NsdManager.PROTOCOL_DNS_SD, listener)
        } catch (e: Exception) {
            Log.e(tag, "Error starting discovery", e)
            scope.launch { _errorFlow.emit("Exception starting discovery: ${e.message}") }
        }
    }

    private fun triggerResolve() {
        if (resolving.get()) return

        val nextService = synchronized(resolveQueue) {
            if (resolveQueue.isEmpty()) return
            resolveQueue.removeFirst()
        }

        resolving.set(true)

        val resolveListener = object : NsdManager.ResolveListener {
            override fun onResolveFailed(serviceInfo: NsdServiceInfo, errorCode: Int) {
                Log.e(tag, "onResolveFailed for ${serviceInfo.serviceName}: $errorCode")
                
                if (errorCode == NsdManager.FAILURE_ALREADY_ACTIVE) {
                    val retryKey = serviceInfo.serviceName
                    val retries = retryCountMap.getOrDefault(retryKey, 0)
                    if (retries < MAX_RETRIES) {
                        retryCountMap[retryKey] = retries + 1
                        val delayMs = 200L * (1 shl retries) // exponential backoff: 200, 400, 800
                        scope.launch {
                            delay(delayMs)
                            synchronized(resolveQueue) {
                                resolveQueue.addFirst(serviceInfo)
                            }
                            resolving.set(false)
                            triggerResolve()
                        }
                    } else {
                        Log.e(tag, "Max retries reached for ${serviceInfo.serviceName}")
                        resolving.set(false)
                        triggerResolve()
                    }
                } else {
                    scope.launch {
                        _errorFlow.emit("Resolve failed for ${serviceInfo.serviceName}: $errorCode")
                    }
                    resolving.set(false)
                    triggerResolve()
                }
            }

            override fun onServiceResolved(serviceInfo: NsdServiceInfo) {
                Log.d(tag, "onServiceResolved: ${serviceInfo.serviceName} at ${serviceInfo.host?.hostAddress}")
                
                val host = serviceInfo.host ?: run {
                    resolving.set(false)
                    triggerResolve()
                    return
                }

                val ip = host.hostAddress ?: run {
                    resolving.set(false)
                    triggerResolve()
                    return
                }

                // Filter out IPv6, only accept IPv4
                if (!ip.contains('.')) {
                    Log.d(tag, "Skipping non-IPv4 address: $ip")
                    resolving.set(false)
                    triggerResolve()
                    return
                }

                if (discoveredIps.contains(ip)) {
                    Log.d(tag, "IP already discovered: $ip")
                    resolving.set(false)
                    triggerResolve()
                    return
                }

                discoveredIps.add(ip)
                val device = DiscoveredDevice(
                    id = ip,
                    name = serviceInfo.serviceName,
                    ipAddress = ip,
                    port = serviceInfo.port,
                    serviceType = serviceInfo.serviceType
                )

                scope.launch {
                    val currentList = _devicesFlow.value
                    if (currentList.none { it.ipAddress == ip }) {
                        _devicesFlow.emit(currentList + device)
                    }
                }

                resolving.set(false)
                triggerResolve()
            }
        }

        try {
            nsdManager?.resolveService(nextService, resolveListener)
        } catch (e: Exception) {
            Log.e(tag, "Exception in resolveService", e)
            resolving.set(false)
            triggerResolve()
        }
    }

    fun stopDiscovery() {
        Log.d(tag, "stopDiscovery requested")
        try {
            discoveryListener?.let {
                nsdManager?.stopServiceDiscovery(it)
            }
        } catch (e: IllegalArgumentException) {
            // Already stopped or not started
            Log.w(tag, "stopDiscovery failed: ${e.message}")
        } catch (e: Exception) {
            Log.e(tag, "Error stopping discovery", e)
        }

        discoveryListener = null
        resolving.set(false)
        synchronized(resolveQueue) {
            resolveQueue.clear()
        }
        
        releaseMulticastLock()
        
        // Cancel all pending state updates
        scope.coroutineContext.cancelChildren()
    }

    private fun acquireMulticastLock() {
        if (multicastLock == null) {
            multicastLock = wifiManager?.createMulticastLock("NsdDiscovery")
            multicastLock?.setReferenceCounted(false)
        }
        multicastLock?.acquire()
        Log.d(tag, "MulticastLock acquired")
    }

    private fun releaseMulticastLock() {
        multicastLock?.let {
            if (it.isHeld) {
                it.release()
                Log.d(tag, "MulticastLock released")
            }
        }
    }

    fun destroy() {
        stopDiscovery()
        scope.cancel()
    }
}
