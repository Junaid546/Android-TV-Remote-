package com.example.atv_remote.remote

import android.content.Context
import androidx.security.crypto.EncryptedSharedPreferences
import androidx.security.crypto.MasterKey
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

/**
 * Operates purely on Dispatchers.IO to prevent Android Keystore blockages
 * on the Main thread when initializing EncryptedSharedPreferences.
 */
class SecureConfigManager(context: Context) {
    private val appContext = context.applicationContext

    private val masterKey by lazy {
        MasterKey.Builder(appContext)
            .setKeyScheme(MasterKey.KeyScheme.AES256_GCM)
            .build()
    }

    private val prefs by lazy {
        EncryptedSharedPreferences.create(
            appContext,
            "atv_secure_prefs",
            masterKey,
            EncryptedSharedPreferences.PrefKeyEncryptionScheme.AES256_SIV,
            EncryptedSharedPreferences.PrefValueEncryptionScheme.AES256_GCM
        )
    }

    suspend fun saveTvState(ip: String, name: String, port: Int) = withContext(Dispatchers.IO) {
        prefs.edit()
            .putString("tv_ip", ip)
            .putString("tv_name", name)
            .putInt("tv_port", port)
            .putBoolean("intent_active", true) // Mark that we explicitly connected
            .apply()
    }

    suspend fun markIntentActive(active: Boolean) = withContext(Dispatchers.IO) {
        prefs.edit().putBoolean("intent_active", active).apply()
    }

    suspend fun readIntentActive(): Boolean = withContext(Dispatchers.IO) {
        prefs.getBoolean("intent_active", false)
    }

    suspend fun getTvIp(): String? = withContext(Dispatchers.IO) {
        prefs.getString("tv_ip", null)
    }

    suspend fun getTvName(): String? = withContext(Dispatchers.IO) {
        prefs.getString("tv_name", null)
    }

    suspend fun getTvPort(): Int = withContext(Dispatchers.IO) {
        prefs.getInt("tv_port", RemoteSession.REMOTE_PORT)
    }
}
