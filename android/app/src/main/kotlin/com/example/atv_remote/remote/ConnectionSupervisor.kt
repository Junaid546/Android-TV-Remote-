package com.example.atv_remote.remote

import android.util.Log
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.update
import kotlinx.coroutines.launch

object ConnectionSupervisor {
    private const val TAG = "ConnectionSupervisor"
    
    private val _state = MutableStateFlow<RemoteState>(RemoteState.Idle)
    val state = _state.asStateFlow()

    private val supervisorScope = CoroutineScope(Dispatchers.Default)

    fun dispatch(action: RemoteAction) {
        supervisorScope.launch {
            _state.update { current -> StateReducer.reduce(current, action) }
        }
    }

    object StateReducer {
        fun reduce(current: RemoteState, action: RemoteAction): RemoteState {
            val nextState = when (action) {
                is RemoteAction.StartConnection -> {
                    when (current) {
                        is RemoteState.Idle, is RemoteState.AuthFailed, is RemoteState.NetworkLost -> RemoteState.Connecting
                        is RemoteState.Stopping -> RemoteState.Connecting
                        is RemoteState.Connecting, is RemoteState.Connected -> current // Ignore, already active
                        is RemoteState.NoWifi -> current
                    }
                }
                is RemoteAction.NetworkLost -> RemoteState.NetworkLost
                is RemoteAction.NetworkAvailable -> {
                    if (current is RemoteState.NetworkLost) RemoteState.Connecting else current
                }
                is RemoteAction.ConnectionSuccess -> RemoteState.Connected(action.ip, action.name)
                is RemoteAction.ConnectionFailed -> RemoteState.Idle // Can trigger backoff here or in a side-effect
                is RemoteAction.AuthRejected -> RemoteState.AuthFailed(action.reason)
                is RemoteAction.StopRequested -> RemoteState.Stopping
            }
            
            if (current != nextState) {
                Log.i(TAG, "🟢 State transition: ${current.javaClass.simpleName} -> ${nextState.javaClass.simpleName} (Action: ${action.javaClass.simpleName})")
            }
            return nextState
        }
    }
}
