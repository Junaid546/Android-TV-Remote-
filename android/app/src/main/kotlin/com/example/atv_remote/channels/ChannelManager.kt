package com.example.atv_remote.channels

import android.content.Context
import android.util.Log
import com.example.atv_remote.adb.AdbSessionManager
import com.example.atv_remote.discovery.NsdDiscoveryEngine
import com.example.atv_remote.pairing.CertificateStore
import com.example.atv_remote.pairing.PairingManager
import com.example.atv_remote.remote.RemoteSession
import io.flutter.embedding.engine.FlutterEngine
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.launch

/**
 * Manages all Flutter Platform Channels for the application.
 */
class ChannelManager(
    private val context: Context,
    private val flutterEngine: FlutterEngine,
    private val scope: CoroutineScope
) {
    private val tag = "TvChannelMgr"
    private val messenger = flutterEngine.dartExecutor.binaryMessenger

    private var discoveryEngine: NsdDiscoveryEngine? = null
    private var remoteSession: RemoteSession? = null
    private var adbSessionManager: AdbSessionManager? = null

    fun registerAll() {
        Log.i(tag, "Registering all platform channels...")

        try {
            // 1. Shared Infrastructure
            val certStore = CertificateStore(context)
            // Ensure identity exists as early as possible
            scope.launch {
                try {
                    certStore.generateIdentityIfNeeded()
                } catch (e: Exception) {
                    Log.e(tag, "Identity generation failed", e)
                }
            }

            // 2. Discovery
            val engine = NsdDiscoveryEngine(context, scope)
            discoveryEngine = engine
            DiscoveryChannel(engine, messenger, scope).register()
            Log.d(tag, "DiscoveryChannel registered")

            // 3. Pairing
            val pairingManager = PairingManager(certStore, scope)
            PairingChannel(pairingManager, messenger, scope).register()
            Log.d(tag, "PairingChannel registered")

            // 4. Remote Control
            val session = RemoteSession(context, certStore, scope)
            remoteSession = session
            RemoteChannel(context, session, messenger, scope).register()
            Log.d(tag, "RemoteChannel registered")

            // 5. ADB / App Launch
            val adbManager = AdbSessionManager(context, certStore, scope)
            adbSessionManager = adbManager
            AdbChannel(adbManager, messenger, scope).register()
            Log.d(tag, "AdbChannel registered")

            // 6. Network Monitoring
            NetworkChannel(context, messenger, scope).register()
            Log.d(tag, "NetworkChannel registered")

            Log.i(tag, "All channels registered successfully")
        } catch (e: Exception) {
            Log.e(tag, "CRITICAL: Channel registration failed entirely", e)
        }
    }

    fun destroy() {
        Log.d(tag, "Destroying channels...")
        try {
            discoveryEngine?.destroy()
            remoteSession?.destroy()
            adbSessionManager?.disconnect()
            discoveryEngine = null
            remoteSession = null
            adbSessionManager = null
        } catch (e: Exception) {
            Log.e(tag, "Error during channel destruction", e)
        }
    }
}

