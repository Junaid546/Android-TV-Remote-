package com.example.atv_remote.channels

import android.annotation.SuppressLint
import android.content.Context
import android.net.ConnectivityManager
import android.net.Network
import android.net.NetworkCapabilities
import android.os.Handler
import android.os.Looper
import android.util.Log
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import kotlinx.coroutines.CoroutineScope

class NetworkChannel(
    private val context: Context,
    private val binaryMessenger: BinaryMessenger,
    private val scope: CoroutineScope
) {
    companion object {
        const val EVENT_CHANNEL_NAME = "com.tvremote.app/network/events"
    }

    private val tag = "TvNetwork"

    fun register() {
        EventChannel(binaryMessenger, EVENT_CHANNEL_NAME).setStreamHandler(
            object : EventChannel.StreamHandler {
                private var networkCallback: ConnectivityManager.NetworkCallback? = null

                override fun onListen(arguments: Any?, sink: EventChannel.EventSink?) {
                    Log.d(tag, "NetworkChannel onListen")
                    val cm = context.getSystemService(Context.CONNECTIVITY_SERVICE)
                            as ConnectivityManager

                    // Emit current state immediately
                    Handler(Looper.getMainLooper()).post {
                        sink?.success(cm.currentConnectivityMap())
                    }

                    val callback = object : ConnectivityManager.NetworkCallback() {
                        override fun onAvailable(network: Network) {
                            val caps = cm.getNetworkCapabilities(network)
                            val type = caps?.networkType() ?: "other"
                            Log.d(tag, "Network available: $type")
                            Handler(Looper.getMainLooper()).post {
                                sink?.success(mapOf("connected" to true, "type" to type))
                            }
                        }

                        override fun onLost(network: Network) {
                            Log.d(tag, "Network lost")
                            Handler(Looper.getMainLooper()).post {
                                sink?.success(mapOf("connected" to false, "type" to "none"))
                            }
                        }

                        override fun onCapabilitiesChanged(
                            network: Network,
                            caps: NetworkCapabilities
                        ) {
                            val type = caps.networkType()
                            Handler(Looper.getMainLooper()).post {
                                sink?.success(mapOf("connected" to true, "type" to type))
                            }
                        }
                    }

                    networkCallback = callback
                    cm.registerDefaultNetworkCallback(callback)
                }

                override fun onCancel(arguments: Any?) {
                    Log.d(tag, "NetworkChannel onCancel")
                    val cm = context.getSystemService(Context.CONNECTIVITY_SERVICE)
                            as ConnectivityManager
                    networkCallback?.let {
                        try {
                            cm.unregisterNetworkCallback(it)
                        } catch (e: Exception) {
                            Log.w(tag, "unregisterNetworkCallback: ${e.message}")
                        }
                    }
                    networkCallback = null
                }
            }
        )
    }

    @SuppressLint("MissingPermission")
    private fun ConnectivityManager.currentConnectivityMap(): Map<String, Any> {
        val net = activeNetwork
        val caps = net?.let { getNetworkCapabilities(it) }
        val connected = caps?.hasCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET) == true
        val type = caps?.networkType() ?: "none"
        return mapOf("connected" to connected, "type" to type)
    }

    private fun NetworkCapabilities.networkType(): String = when {
        hasTransport(NetworkCapabilities.TRANSPORT_WIFI) -> "wifi"
        hasTransport(NetworkCapabilities.TRANSPORT_CELLULAR) -> "cellular"
        hasTransport(NetworkCapabilities.TRANSPORT_ETHERNET) -> "ethernet"
        else -> "other"
    }
}