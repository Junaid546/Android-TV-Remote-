package com.example.atv_remote

import android.util.Log
import androidx.annotation.NonNull
import com.example.atv_remote.channels.DiscoveryChannel
import com.example.atv_remote.channels.NetworkChannel
import com.example.atv_remote.channels.PairingChannel
import com.example.atv_remote.channels.RemoteChannel
import com.example.atv_remote.discovery.NsdDiscoveryEngine
import com.example.atv_remote.pairing.CertificateStore
import com.example.atv_remote.pairing.PairingManager
import com.example.atv_remote.remote.RemoteSession
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel

class MainActivity : FlutterActivity() {

    private val tag = "TvMain"

    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.IO)
    private lateinit var channelManager: com.example.atv_remote.channels.ChannelManager

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        Log.d(tag, "Configuring Flutter Engine and Channels")

        channelManager = com.example.atv_remote.channels.ChannelManager(
            context = applicationContext,
            flutterEngine = flutterEngine,
            scope = scope
        )
        channelManager.registerAll()
    }

    override fun onDestroy() {
        Log.d(tag, "Cleaning up native resources")
        try {
            if (::channelManager.isInitialized) channelManager.destroy()
            scope.cancel()
        } catch (e: Exception) {
            Log.e(tag, "Cleanup error", e)
        }
        super.onDestroy()
    }
}