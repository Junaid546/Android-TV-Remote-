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

    /**
     * Single coroutine scope shared by all native channels.
     * SupervisorJob ensures one cancelled child doesn't tear down the rest.
     * Cancelled only in [onDestroy].
     */
    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.Main)

    // Held here so we can call destroy() / disconnect() in onDestroy
    private lateinit var discoveryEngine: NsdDiscoveryEngine
    private lateinit var remoteSession: RemoteSession

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val messenger = flutterEngine.dartExecutor.binaryMessenger

        Log.d(tag, "configureFlutterEngine — registering all channels")

        // ── Discovery ──────────────────────────────────────────────────────────
        discoveryEngine = NsdDiscoveryEngine(applicationContext)
        DiscoveryChannel(
            engine = discoveryEngine,
            binaryMessenger = messenger,
            coroutineScope = scope
        ) // DiscoveryChannel registers itself in its init block

        // ── Certificate store (shared by pairing + remote) ─────────────────────
        val certStore = CertificateStore(applicationContext)

        // ── Pairing ────────────────────────────────────────────────────────────
        PairingChannel(
            pairingManager = PairingManager(certStore = certStore, scope = scope),
            binaryMessenger = messenger,
            scope = scope
        ).register()

        // ── Remote session ─────────────────────────────────────────────────────
        remoteSession = RemoteSession(certStore = certStore, scope = scope)
        RemoteChannel(
            remoteSession = remoteSession,
            binaryMessenger = messenger,
            scope = scope
        ).register()

        // ── Network connectivity ───────────────────────────────────────────────
        NetworkChannel(
            context = applicationContext,
            binaryMessenger = messenger,
            scope = scope
        ).register()

        Log.d(tag, "All channels registered ✅")
    }

    override fun onDestroy() {
        Log.d(tag, "onDestroy — tearing down")
        // Order matters: cancel scope first to stop all coroutines,
        // then clean up native resources.
        scope.cancel()
        discoveryEngine.destroy()
        remoteSession.disconnect()
        super.onDestroy()
    }
}
