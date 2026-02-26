package com.example.atv_remote.adb

sealed class AdbSessionState {
    object Disconnected : AdbSessionState()

    data class Pairing(
        val host: String,
        val port: Int,
    ) : AdbSessionState()

    data class Connecting(
        val host: String,
        val port: Int,
    ) : AdbSessionState()

    data class Connected(
        val host: String,
        val port: Int,
    ) : AdbSessionState()

    data class Failed(
        val host: String,
        val port: Int,
        val reason: String,
    ) : AdbSessionState()
}
