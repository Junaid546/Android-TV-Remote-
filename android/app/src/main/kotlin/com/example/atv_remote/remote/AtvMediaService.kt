package com.example.atv_remote.remote

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.media.AudioManager
import android.os.Build
import android.os.IBinder
import android.support.v4.media.MediaMetadataCompat
import android.support.v4.media.session.MediaSessionCompat
import android.support.v4.media.session.PlaybackStateCompat
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.app.ServiceCompat
import androidx.media.AudioAttributesCompat
import androidx.media.AudioFocusRequestCompat
import androidx.media.AudioManagerCompat
import androidx.media.VolumeProviderCompat
import com.example.atv_remote.R
import com.example.atv_remote.pairing.CertificateStore
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.flow.collectLatest
import kotlinx.coroutines.launch

class AtvMediaService : Service() {
    private val TAG = "AtvMediaService"
    private val NOTIFICATION_ID = 45982
    private val CHANNEL_ID = "tv_remote_media_channel"

    private val serviceScope = CoroutineScope(SupervisorJob() + Dispatchers.Main)
    
    private lateinit var mediaSession: MediaSessionCompat
    private lateinit var audioManager: AudioManager
    private lateinit var audioFocusRequest: AudioFocusRequestCompat
    
    private lateinit var secureConfigManager: SecureConfigManager
    private lateinit var certificateStore: CertificateStore
    private lateinit var remoteSession: RemoteSession
    
    private var stateObserverJob: Job? = null

    override fun onCreate() {
        super.onCreate()
        Log.i(TAG, "Starting AtvMediaService")
        
        createNotificationChannel()
        startForegroundSafe()

        secureConfigManager = SecureConfigManager(this)
        certificateStore = CertificateStore(this)
        remoteSession = RemoteSession(this, certificateStore, serviceScope)

        setupMediaSession()
        setupAudioFocus()

        observeConnectionState()
        
        // Let IO thread read config and connect
        serviceScope.launch {
            val ip = secureConfigManager.getTvIp()
            val name = secureConfigManager.getTvName() ?: "Android TV"
            val port = secureConfigManager.getTvPort()

            if (ip != null) {
                Log.i(TAG, "Rehydrating connection to \$ip")
                remoteSession.connect(ip, name, port)
                // Ensure Tile knows we are processing
                ConnectionSupervisor.dispatch(RemoteAction.StartConnection)
            } else {
                Log.e(TAG, "No IP found in SecureConfig, aborting Service")
                stopSelf()
            }
        }
    }
    
    // STRICT FOREGROUND STARTUP COMPLIANCE
    private fun startForegroundSafe() {
        val skeleton = NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle("Initializing Remote...")
            .setSmallIcon(R.mipmap.ic_launcher)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .build()
            
        try {
            ServiceCompat.startForeground(
                this,
                NOTIFICATION_ID,
                skeleton,
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) 
                    ServiceInfo.FOREGROUND_SERVICE_TYPE_MEDIA_PLAYBACK
                else 0
            )
        } catch (e: Exception) {
            Log.e(TAG, "Failed startForeground: \${e.message}")
        }
    }
    
    private fun setupMediaSession() {
        mediaSession = MediaSessionCompat(this, TAG).apply {
            setCallback(object : MediaSessionCompat.Callback() {
                override fun onPlay() {
                    serviceScope.launch { remoteSession.sendKey(85, 3) } // Play/Pause
                }
                override fun onPause() {
                    serviceScope.launch { remoteSession.sendKey(85, 3) }
                }
            })
            
            val volumeProvider = object : VolumeProviderCompat(VolumeProviderCompat.VOLUME_CONTROL_RELATIVE, 100, 50) {
                override fun onAdjustVolume(direction: Int) {
                    val keyCode = if (direction == 1) 24 else 25
                    serviceScope.launch { remoteSession.sendKey(keyCode, 3) }
                }
            }
            setPlaybackToRemote(volumeProvider)
        }
    }
    
    private fun setupAudioFocus() {
        audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
        val focusChangeListener = AudioManager.OnAudioFocusChangeListener { focusChange ->
            when (focusChange) {
                AudioManager.AUDIOFOCUS_LOSS -> {
                    mediaSession.isActive = false
                    abandonAudioFocus()
                }
                AudioManager.AUDIOFOCUS_LOSS_TRANSIENT -> {
                    mediaSession.isActive = false
                }
                AudioManager.AUDIOFOCUS_LOSS_TRANSIENT_CAN_DUCK -> {
                    // Allowed to stay active but shouldn't be aggressive.
                }
                AudioManager.AUDIOFOCUS_GAIN -> {
                    mediaSession.isActive = true 
                }
            }
        }
        
        audioFocusRequest = AudioFocusRequestCompat.Builder(AudioManagerCompat.AUDIOFOCUS_GAIN_TRANSIENT_MAY_DUCK)
            .setAudioAttributes(
                AudioAttributesCompat.Builder()
                    .setUsage(AudioAttributesCompat.USAGE_MEDIA)
                    .setContentType(AudioAttributesCompat.CONTENT_TYPE_SPEECH)
                    .build()
            )
            .setOnAudioFocusChangeListener(focusChangeListener)
            .build()
    }
    
    private fun requestAudioFocus() {
        val result = AudioManagerCompat.requestAudioFocus(audioManager, audioFocusRequest)
        if (result == AudioManager.AUDIOFOCUS_REQUEST_GRANTED) {
            mediaSession.isActive = true
        }
    }
    
    private fun abandonAudioFocus() {
        AudioManagerCompat.abandonAudioFocusRequest(audioManager, audioFocusRequest)
    }
    
    private fun observeConnectionState() {
        stateObserverJob = serviceScope.launch {
            ConnectionSupervisor.state.collectLatest { state ->
                when (state) {
                    is RemoteState.Connected -> {
                        updateNotification(state.name, true)
                        requestAudioFocus()
                    }
                    is RemoteState.Idle, is RemoteState.Stopping, is RemoteState.AuthFailed, is RemoteState.NoWifi, is RemoteState.NetworkLost -> {
                        updateNotification("Disconnected", false)
                        mediaSession.isActive = false
                        abandonAudioFocus()
                    }
                    is RemoteState.Connecting -> {
                        updateNotification("Connecting...", false)
                    }
                }
            }
        }
    }
    
    private fun updateNotification(title: String, isConnected: Boolean) {
        val stateBuilder = PlaybackStateCompat.Builder()
            .setActions(PlaybackStateCompat.ACTION_PLAY or PlaybackStateCompat.ACTION_PAUSE)
            .setState(
                if (isConnected) PlaybackStateCompat.STATE_PLAYING else PlaybackStateCompat.STATE_PAUSED,
                PlaybackStateCompat.PLAYBACK_POSITION_UNKNOWN,
                1.0f
            )
            
        mediaSession.setPlaybackState(stateBuilder.build())
        
        mediaSession.setMetadata(
            MediaMetadataCompat.Builder()
                .putString(MediaMetadataCompat.METADATA_KEY_TITLE, title)
                .putString(MediaMetadataCompat.METADATA_KEY_ARTIST, if (isConnected) "Connected to TV" else "Idle")
                .build()
        )
        
        val notification = NotificationCompat.Builder(this, CHANNEL_ID)
            .setContentTitle(title)
            .setContentText(if (isConnected) "Remote Control Active" else "Connecting...")
            .setSmallIcon(R.mipmap.ic_launcher)
            .setStyle(androidx.media.app.NotificationCompat.MediaStyle().setMediaSession(mediaSession.sessionToken))
            .setPriority(NotificationCompat.PRIORITY_DEFAULT)
            .setOnlyAlertOnce(true)
            .build()

        val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        notificationManager.notify(NOTIFICATION_ID, notification)
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "TV Remote Service",
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = "Keeps remote session alive in background"
                setSound(null, null)
                setShowBadge(false)
            }
            val manager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            manager.createNotificationChannel(channel)
        }
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (intent?.action == "STOP_SERVICE") {
            remoteSession.disconnect()
            stopSelf()
            return START_NOT_STICKY
        }
        return START_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onTaskRemoved(rootIntent: Intent?) {
        super.onTaskRemoved(rootIntent)
        Log.i(TAG, "Process killed. Cleaning up media session.")
        mediaSession.isActive = false
        mediaSession.release()
        abandonAudioFocus()
        ServiceCompat.stopForeground(this, ServiceCompat.STOP_FOREGROUND_REMOVE)
        remoteSession.disconnect()
        stopSelf()
    }
    
    override fun onDestroy() {
        super.onDestroy()
        serviceScope.cancel()
        stateObserverJob?.cancel()
        mediaSession.release()
        abandonAudioFocus()
    }
}
