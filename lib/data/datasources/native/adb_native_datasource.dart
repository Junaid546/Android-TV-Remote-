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
          if (error is PlatformException) {
            throw NativeChannelException(
              error.code,
              error.message ?? 'ADB state stream error',
            );
          }
          throw error;
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
    } on PlatformException catch (e) {
      throw NativeChannelException(e.code, e.message ?? 'ADB pairing failed');
    }
  }

  @override
  Future<void> connect(String host, int port) async {
    try {
      await _methodChannel.invokeMethod('connect', {
        'host': host,
        'port': port,
      });
    } on PlatformException catch (e) {
      throw NativeChannelException(
        e.code,
        e.message ?? 'ADB connection failed',
      );
    }
  }

  @override
  Future<void> disconnect() async {
    try {
      await _methodChannel.invokeMethod('disconnect');
    } on PlatformException catch (e) {
      throw NativeChannelException(
        e.code,
        e.message ?? 'ADB disconnect failed',
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
    } on PlatformException catch (e) {
      throw NativeChannelException(e.code, e.message ?? 'ADB shell failed');
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
    } on PlatformException catch (e) {
      throw NativeChannelException(e.code, e.message ?? 'App launch failed');
    }
  }
}
