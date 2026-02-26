import 'dart:async';

import 'package:atv_remote/data/datasources/native/adb_native_datasource.dart';
import 'package:atv_remote/core/errors/exceptions.dart';
import 'package:atv_remote/presentation/providers/repository_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdbState {
  const AdbState({
    this.connectionState = 'DISCONNECTED',
    this.host,
    this.port,
    this.reason,
    this.isBusy = false,
  });

  final String connectionState;
  final String? host;
  final int? port;
  final String? reason;
  final bool isBusy;

  bool get isConnected => connectionState == 'CONNECTED';

  AdbState copyWith({
    String? connectionState,
    String? host,
    int? port,
    String? reason,
    bool? isBusy,
    bool clearReason = false,
  }) {
    return AdbState(
      connectionState: connectionState ?? this.connectionState,
      host: host ?? this.host,
      port: port ?? this.port,
      reason: clearReason ? null : (reason ?? this.reason),
      isBusy: isBusy ?? this.isBusy,
    );
  }
}

final adbNotifierProvider = StateNotifierProvider<AdbNotifier, AdbState>(
  (ref) => AdbNotifier(ref),
);

class AdbNotifier extends StateNotifier<AdbState> {
  AdbNotifier(this._ref) : super(const AdbState()) {
    _subscription = _datasource.stateStream.listen(
      _onStateEvent,
      onError: (Object e, StackTrace st) {
        state = state.copyWith(
          connectionState: 'FAILED',
          reason: _mapError(e),
          isBusy: false,
        );
      },
    );

    _ref.onDispose(() async {
      await _subscription?.cancel();
    });
  }

  final Ref _ref;
  StreamSubscription<Map<String, dynamic>>? _subscription;

  AdbNativeDataSource get _datasource => _ref.read(adbNativeDataSourceProvider);

  Future<void> pair({
    required String host,
    required int port,
    required String pairingCode,
  }) async {
    if (state.isBusy) return;
    state = state.copyWith(
      isBusy: true,
      connectionState: 'PAIRING',
      host: host,
      port: port,
      clearReason: true,
    );

    try {
      await _datasource.pair(host, port, pairingCode);
      state = state.copyWith(isBusy: false, clearReason: true);
    } on NativeChannelException catch (e) {
      state = state.copyWith(
        isBusy: false,
        connectionState: 'FAILED',
        reason: _mapError(e),
      );
      rethrow;
    }
  }

  Future<void> connect({required String host, required int port}) async {
    if (state.isBusy) return;
    state = state.copyWith(
      isBusy: true,
      connectionState: 'CONNECTING',
      host: host,
      port: port,
      clearReason: true,
    );

    try {
      await _datasource.connect(host, port);
      state = state.copyWith(isBusy: false, clearReason: true);
    } on NativeChannelException catch (e) {
      state = state.copyWith(
        isBusy: false,
        connectionState: 'FAILED',
        reason: _mapError(e),
      );
      rethrow;
    }
  }

  Future<void> disconnect() async {
    await _datasource.disconnect();
    state = const AdbState();
  }

  Future<String> runShell(String command) async {
    return _datasource.runShell(command);
  }

  Future<Map<String, dynamic>> launchApp({
    required String packageName,
    String? activityName,
    bool playStoreFallback = true,
  }) async {
    return _datasource.launchApp(
      packageName,
      activityName: activityName,
      playStoreFallback: playStoreFallback,
    );
  }

  void _onStateEvent(Map<String, dynamic> event) {
    state = state.copyWith(
      connectionState: event['state'] as String? ?? state.connectionState,
      host: event['host'] as String? ?? state.host,
      port: event['port'] as int? ?? state.port,
      reason: event['reason'] as String?,
      isBusy: false,
    );
  }

  String _mapError(Object error) {
    if (error is NativeChannelException) {
      return error.message;
    }
    return error.toString();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
