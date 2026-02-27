import 'package:atv_remote/core/constants/channel_constants.dart';
import 'package:atv_remote/core/errors/exceptions.dart';
import 'package:flutter/services.dart';

abstract interface class AdbNativeDataSource {
  Future<void> pair(String host, int port, String pairingCode);
  Future<void> connect(String host, int port);
  Future<void> disconnect();
  Future<String> runShell(String command);
  Future<Map<String, dynamic>> launchApp(
    String packageName, {
    String? activityName,
    bool playStoreFallback,
  });
  Stream<Map<String, dynamic>> get stateStream;
}

class AdbNativeDataSourceImpl implements AdbNativeDataSource {
  static const _methodChannel = MethodChannel(
    ChannelConstants.kAdbMethodChannel,
  );
  static const _eventChannel = EventChannel(ChannelConstants.kAdbEventChannel);

  @override
  Stream<Map<String, dynamic>> get stateStream {
    return _eventChannel
        .receiveBroadcastStream()
        .map((event) => Map<String, dynamic>.from(event as Map))
        .handleError((error) {
          throw _toNativeChannelException(
            error,
            defaultCode: 'ADB_STATE_STREAM_ERROR',
            defaultMessage: 'ADB state stream error',
          );
        });
  }

  @override
  Future<void> pair(String host, int port, String pairingCode) async {
    try {
      await _methodChannel.invokeMethod('pair', {
        'host': host,
        'port': port,
        'pairingCode': pairingCode,
      });
    } catch (error) {
      throw _toNativeChannelException(
        error,
        defaultCode: 'ADB_PAIR_FAILED',
        defaultMessage: 'ADB pairing failed',
      );
    }
  }

  @override
  Future<void> connect(String host, int port) async {
    try {
      await _methodChannel.invokeMethod('connect', {
        'host': host,
        'port': port,
      });
    } catch (error) {
      throw _toNativeChannelException(
        error,
        defaultCode: 'ADB_CONNECT_FAILED',
        defaultMessage: 'ADB connection failed',
      );
    }
  }

  @override
  Future<void> disconnect() async {
    try {
      await _methodChannel.invokeMethod('disconnect');
    } catch (error) {
      throw _toNativeChannelException(
        error,
        defaultCode: 'ADB_DISCONNECT_FAILED',
        defaultMessage: 'ADB disconnect failed',
      );
    }
  }

  @override
  Future<String> runShell(String command) async {
    try {
      final result = await _methodChannel.invokeMethod<Map<dynamic, dynamic>>(
        'runShell',
        {'command': command},
      );
      final map = Map<String, dynamic>.from(result ?? const {});
      return (map['output'] as String? ?? '').trim();
    } catch (error) {
      throw _toNativeChannelException(
        error,
        defaultCode: 'ADB_SHELL_FAILED',
        defaultMessage: 'ADB shell failed',
      );
    }
  }

  @override
  Future<Map<String, dynamic>> launchApp(
    String packageName, {
    String? activityName,
    bool playStoreFallback = true,
  }) async {
    try {
      final result = await _methodChannel
          .invokeMethod<Map<dynamic, dynamic>>('launchApp', {
            'packageName': packageName,
            'activityName': activityName,
            'playStoreFallback': playStoreFallback,
          });
      return Map<String, dynamic>.from(result ?? const {});
    } catch (error) {
      throw _toNativeChannelException(
        error,
        defaultCode: 'ADB_LAUNCH_FAILED',
        defaultMessage: 'App launch failed',
      );
    }
  }

  NativeChannelException _toNativeChannelException(
    Object error, {
    required String defaultCode,
    required String defaultMessage,
  }) {
    if (error is NativeChannelException) return error;
    if (error is PlatformException) {
      return NativeChannelException(
        error.code,
        error.message ?? defaultMessage,
      );
    }
    return NativeChannelException(defaultCode, error.toString());
  }
}
