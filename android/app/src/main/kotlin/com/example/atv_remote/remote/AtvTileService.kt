package com.example.atv_remote.remote

import android.app.NotificationManager
import android.content.Context
import android.content.Intent
import android.os.Build
import android.service.quicksettings.Tile
import android.service.quicksettings.TileService
import android.util.Log
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.cancel
import kotlinx.coroutines.flow.collectLatest
import kotlinx.coroutines.launch

class AtvTileService : TileService() {
    private val TAG = "AtvTileService"
    private val tileScope = CoroutineScope(Dispatchers.Main)
    private var stateObserverJob: Job? = null
    
    private lateinit var secureConfigManager: SecureConfigManager

    override fun onCreate() {
        super.onCreate()
        secureConfigManager = SecureConfigManager(this)
    }

    override fun onStartListening() {
        super.onStartListening()
        Log.d(TAG, "onStartListening")

        stateObserverJob?.cancel()
        stateObserverJob = tileScope.launch {
            // Rehydrate based on stored user intent + active state machine flow if possible
            val isIntentActive = secureConfigManager.readIntentActive()
            Log.d(TAG, "Rehydrated intent active state: \$isIntentActive")

            ConnectionSupervisor.state.collectLatest { state ->
                val tile = qsTile ?: return@collectLatest
                
                when (state) {
                    is RemoteState.Connected -> {
                        tile.state = Tile.STATE_ACTIVE
                        tile.label = state.name
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                            tile.subtitle = "Connected"
                        }
                    }
                    is RemoteState.Connecting -> {
                        tile.state = Tile.STATE_UNAVAILABLE
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                            tile.subtitle = "Connecting..."
                        }
                    }
                    is RemoteState.AuthFailed, is RemoteState.NetworkLost, is RemoteState.NoWifi -> {
                        tile.state = Tile.STATE_INACTIVE
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                            tile.subtitle = "Disconnected"
                        }
                    }
                    is RemoteState.Idle, is RemoteState.Stopping -> {
                        if (isIntentActive) {
                            // The process probably just lived or died, but user wanted it active.
                            // However, we are technically idle.
                            tile.state = Tile.STATE_INACTIVE
                        } else {
                            tile.state = Tile.STATE_INACTIVE
                        }
                        tile.label = "TV Remote"
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                            tile.subtitle = "Tap to Connect"
                        }
                    }
                }
                tile.updateTile()
            }
        }
    }

    override fun onStopListening() {
        super.onStopListening()
        Log.d(TAG, "onStopListening")
        stateObserverJob?.cancel()
    }

    override fun onClick() {
        Log.d(TAG, "Tile clicked")
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            val nm = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            if (!nm.areNotificationsEnabled()) {
                val tile = qsTile
                tile.state = Tile.STATE_UNAVAILABLE
                tile.subtitle = "Permission Needed"
                tile.updateTile()
                
                // Direct user to Settings
                val intent = Intent(android.provider.Settings.ACTION_APP_NOTIFICATION_SETTINGS)
                    .putExtra(android.provider.Settings.EXTRA_APP_PACKAGE, packageName)
                    .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                startActivityAndCollapse(intent)
                return
            }
        }

        val tile = qsTile ?: return
        val serviceIntent = Intent(this, AtvMediaService::class.java)

        if (tile.state == Tile.STATE_ACTIVE) {
            // Stop it
            serviceIntent.action = "STOP_SERVICE"
            startService(serviceIntent)
        } else {
            // Start it
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                startForegroundService(serviceIntent)
            } else {
                startService(serviceIntent)
            }
            
            tile.state = Tile.STATE_UNAVAILABLE
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                tile.subtitle = "Connecting..."
            }
            tile.updateTile()
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        tileScope.cancel()
    }
}
