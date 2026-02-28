import 'dart:async';

import 'package:atv_remote/data/datasources/native/adb_native_datasource.dart';
import 'package:atv_remote/core/errors/exceptions.dart';
import 'package:atv_remote/presentation/providers/repository_providers.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdbResult<T> {
  const AdbResult.success([this.data]) : errorMessage = null, isSuccess = true;

  const AdbResult.failure(this.errorMessage) : data = null, isSuccess = false;

  final T? data;
  final String? errorMessage;
  final bool isSuccess;

  bool get isFailure => !isSuccess;
}

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

  Future<AdbResult<void>> pair({
    required String host,
    required int port,
    required String pairingCode,
  }) async {
    if (state.isBusy) {
      return const AdbResult<void>.failure(
        'Another ADB operation is already in progress.',
      );
    }
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
      return const AdbResult<void>.success();
    } catch (e) {
      final message = _mapError(e);
      state = state.copyWith(
        isBusy: false,
        connectionState: 'FAILED',
        reason: message,
      );
      return AdbResult<void>.failure(message);
    }
  }

  Future<AdbResult<void>> connect({
    required String host,
    required int port,
  }) async {
    if (state.isBusy) {
      return const AdbResult<void>.failure(
        'Another ADB operation is already in progress.',
      );
    }
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
      return const AdbResult<void>.success();
    } catch (e) {
      final message = _mapError(e);
      state = state.copyWith(
        isBusy: false,
        connectionState: 'FAILED',
        reason: message,
      );
      return AdbResult<void>.failure(message);
    }
  }

  Future<AdbResult<void>> disconnect() async {
    try {
      await _datasource.disconnect();
      state = const AdbState();
      return const AdbResult<void>.success();
    } catch (e) {
      final message = _mapError(e);
      state = state.copyWith(
        isBusy: false,
        connectionState: 'FAILED',
        reason: message,
      );
      return AdbResult<void>.failure(message);
    }
  }

  Future<AdbResult<String>> runShell(String command) async {
    try {
      final output = await _datasource.runShell(command);
      return AdbResult<String>.success(output);
    } catch (e) {
      return AdbResult<String>.failure(_mapError(e));
    }
  }

  Future<AdbResult<Map<String, dynamic>>> launchApp({
    required String packageName,
    String? activityName,
    bool playStoreFallback = true,
  }) async {
    try {
      final result = await _datasource.launchApp(
        packageName,
        activityName: activityName,
        playStoreFallback: playStoreFallback,
      );
      return AdbResult<Map<String, dynamic>>.success(result);
    } catch (e) {
      return AdbResult<Map<String, dynamic>>.failure(_mapError(e));
    }
  }

  void _onStateEvent(Map<String, dynamic> event) {
    final rawPort = event['port'];
    final parsedPort = rawPort is int
        ? rawPort
        : rawPort is num
        ? rawPort.toInt()
        : state.port;
    final rawReason = event['reason'];

    state = state.copyWith(
      connectionState: event['state'] as String? ?? state.connectionState,
      host: event['host'] as String? ?? state.host,
      port: parsedPort,
      reason: rawReason?.toString(),
      isBusy: false,
    );
  }

  String _mapError(Object error) {
    if (error is NativeChannelException) {
      return _normalizeErrorMessage(error.message, code: error.code);
    }
    if (error is PlatformException) {
      return _normalizeErrorMessage(error.message, code: error.code);
    }
    return _normalizeErrorMessage(error.toString());
  }

  String _normalizeErrorMessage(String? message, {String? code}) {
    final normalized = message?.trim() ?? '';
    if (normalized.isNotEmpty && !normalized.startsWith('PlatformException(')) {
      return normalized;
    }
    return _defaultMessageForCode(code);
  }

  String _defaultMessageForCode(String? code) {
    return switch (code) {
      'ADB_CONNECT_FAILED' =>
        'ADB connection failed. Verify TV IP and Wireless Debugging connect port.',
      'ADB_PAIR_FAILED' =>
        'ADB pairing failed. Verify pairing port/code on the TV and try again.',
      'ADB_DISCONNECT_FAILED' => 'ADB disconnect failed. Try again.',
      'ADB_SHELL_FAILED' => 'ADB command failed. Reconnect and retry.',
      'ADB_LAUNCH_FAILED' => 'Could not launch app over ADB.',
      'ADB_STATE_STREAM_ERROR' =>
        'ADB state stream failed. Try reconnecting ADB.',
      'ADB_STATE_STREAM_FAILED' =>
        'ADB state stream failed. Try reconnecting ADB.',
      'INVALID_ARGS' => 'Invalid ADB request. Check host/port values.',
      _ => 'ADB operation failed. Please try again.',
    };
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
