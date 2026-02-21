package com.example.atv_remote.remote

/**
 * Represents the full lifecycle of a remote control TCP/TLS connection.
 *
 * State transitions:
 * Disconnected → Connecting → Connected ←→ Reconnecting → Failed
 *                                   ↓
 *                               Disconnected (user-initiated)
 */
sealed class RemoteConnectionState {

    object Disconnected : RemoteConnectionState()

    data class Connecting(val deviceIp: String) : RemoteConnectionState()

    data class Connected(
        val deviceIp: String,
        val deviceName: String
    ) : RemoteConnectionState()

    data class Reconnecting(
        val deviceIp: String,
        val attempt: Int,
        val maxAttempts: Int
    ) : RemoteConnectionState()

    data class Failed(
        val deviceIp: String,
        val reason: String
    ) : RemoteConnectionState()

    fun toMap(): Map<String, Any?> = when (this) {
        is Disconnected  -> mapOf("state" to "DISCONNECTED")
        is Connecting    -> mapOf("state" to "CONNECTING",   "deviceIp" to deviceIp)
        is Connected     -> mapOf("state" to "CONNECTED",    "deviceIp" to deviceIp, "deviceName" to deviceName)
        is Reconnecting  -> mapOf("state" to "RECONNECTING", "deviceIp" to deviceIp, "attempt" to attempt, "maxAttempts" to maxAttempts)
        is Failed        -> mapOf("state" to "FAILED",       "deviceIp" to deviceIp, "reason" to reason)
    }
}
