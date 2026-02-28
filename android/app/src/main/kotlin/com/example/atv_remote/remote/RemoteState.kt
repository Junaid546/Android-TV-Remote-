package com.example.atv_remote.remote

/**
 * Deterministic finite state machine for the Remote Session lifecycle.
 */
sealed class RemoteState {
    object Idle : RemoteState()
    object NoWifi : RemoteState()
    object NetworkLost : RemoteState()
    object Connecting : RemoteState()
    data class Connected(val ip: String, val name: String) : RemoteState()
    data class AuthFailed(val reason: String) : RemoteState()
    object Stopping : RemoteState()
}

/**
 * Actions that transition the state machine into different permutations.
 */
sealed class RemoteAction {
    object StartConnection : RemoteAction()
    object NetworkLost : RemoteAction()
    object NetworkAvailable : RemoteAction()
    data class ConnectionSuccess(val ip: String, val name: String) : RemoteAction()
    data class ConnectionFailed(val reason: String) : RemoteAction()
    data class AuthRejected(val reason: String) : RemoteAction()
    object StopRequested : RemoteAction()
}
