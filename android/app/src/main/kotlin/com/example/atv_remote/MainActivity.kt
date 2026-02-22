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

    private lateinit var discoveryEngine: NsdDiscoveryEngine
    private lateinit var remoteSession: RemoteSession

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val messenger = flutterEngine.dartExecutor.binaryMessenger

        Log.d(tag, "Registering Flutter channels")

        try {
            // Discovery
            discoveryEngine = NsdDiscoveryEngine(applicationContext, scope)
            DiscoveryChannel(
                engine = discoveryEngine,
                binaryMessenger = messenger,
                coroutineScope = scope
            ).register()

            // Shared certificate store — one instance, passed everywhere
            val certStore = CertificateStore(applicationContext)

            // Generate client identity once at startup
            certStore.generateIdentityIfNeeded()

            // Pairing
            PairingChannel(
                pairingManager = PairingManager(
                    certStore = certStore,
                    scope = scope
                ),
                binaryMessenger = messenger,
                scope = scope
            ).register()

            // Remote control — uses RemoteSession, NOT ControlConnectionManager
            remoteSession = RemoteSession(
                certStore = certStore,
                scope = scope
            )
            RemoteChannel(
                remoteSession = remoteSession,
                binaryMessenger = messenger,
                scope = scope
            ).register()

            // Network monitoring
            NetworkChannel(
                context = applicationContext,
                binaryMessenger = messenger,
                scope = scope
            ).register()

            Log.d(tag, "All channels registered ✅")

        } catch (e: Exception) {
            Log.e(tag, "Channel registration failed", e)
        }
    }

    override fun onDestroy() {
        Log.d(tag, "Cleaning up native resources")
        try {
            if (::discoveryEngine.isInitialized) discoveryEngine.destroy()
            if (::remoteSession.isInitialized) remoteSession.disconnect()
            scope.cancel()
        } catch (e: Exception) {
            Log.e(tag, "Cleanup error", e)
        }
        super.onDestroy()
    }
}