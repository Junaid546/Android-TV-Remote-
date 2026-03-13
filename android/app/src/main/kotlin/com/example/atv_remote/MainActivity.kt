package com.example.atv_remote

import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.RenderMode
import io.flutter.embedding.engine.FlutterEngine
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel

class MainActivity : FlutterActivity() {

    private val tag = "TvMain"

    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.IO)
    private lateinit var channelManager: com.example.atv_remote.channels.ChannelManager

    override fun onCreate(savedInstanceState: android.os.Bundle?) {
        // ── Anti-debug: kill app if debugger is attached ──────────────────────────
        if (android.os.Debug.isDebuggerConnected()) {
            android.os.Process.killProcess(android.os.Process.myPid())
        }

        // ── Anti-tamper: verify APK signature hasn't been modified ───────────────
        try {
            val packageInfo = packageManager.getPackageInfo(
                packageName,
                android.content.pm.PackageManager.GET_SIGNATURES
            )
            val signatureHash = packageInfo.signatures[0].toByteArray()
                .let { java.security.MessageDigest.getInstance("SHA-256").digest(it) }
                .joinToString("") { "%02x".format(it) }

            // TODO (Junaid): Replace with your actual SHA-256 after first signed build
            // Run: keytool -printcert -jarfile your-release.apk
            val expectedHash = "REPLACE_WITH_YOUR_RELEASE_SIGNATURE_SHA256"

            if (signatureHash != expectedHash) {
                android.os.Process.killProcess(android.os.Process.myPid())
            }
        } catch (e: Exception) {
            android.os.Process.killProcess(android.os.Process.myPid())
        }
        super.onCreate(savedInstanceState)
    }

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

    override fun getRenderMode(): RenderMode {
        // Texture mode is more compatible with devices that struggle with
        // SurfaceView buffer formats (seen as gralloc format allocation errors).
        return RenderMode.texture
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
