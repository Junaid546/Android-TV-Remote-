import 'dart:async';
import 'package:atv_remote/core/constants/channel_constants.dart';
import 'package:atv_remote/core/errors/exceptions.dart';
import 'package:flutter/services.dart';

abstract interface class RemoteNativeDataSource {
  Future<void> connect(String ip, String name, int port);
  Future<void> sendKey(int keyCode, int direction);
  Future<void> setAutoReconnect(bool enabled);
  Future<void> disconnect();
  Stream<Map<String, dynamic>> get connectionStateStream;
  Stream<Map<String, dynamic>> get volumeStateStream;
}

class RemoteNativeDataSourceImpl implements RemoteNativeDataSource {
  static const _methodChannel = MethodChannel(
    ChannelConstants.kRemoteMethodChannel,
  );
  static const _eventChannel = EventChannel(
    ChannelConstants.kRemoteEventChannel,
  );
  static const _volumeEventChannel = EventChannel(
    ChannelConstants.kRemoteVolumeEventChannel,
  );

  @override
  Stream<Map<String, dynamic>> get connectionStateStream {
    return _eventChannel
        .receiveBroadcastStream()
        .map((event) {
          return Map<String, dynamic>.from(event as Map);
        })
        .handleError((error) {
          if (error is PlatformException) {
            throw NativeChannelException(
              error.code,
              error.message ?? 'Remote stream error',
            );
          }
          throw error;
        });
  }

  @override
  Stream<Map<String, dynamic>> get volumeStateStream {
    return _volumeEventChannel
        .receiveBroadcastStream()
        .map((event) => Map<String, dynamic>.from(event as Map))
        .handleError((error) {
          if (error is PlatformException) {
            throw NativeChannelException(
              error.code,
              error.message ?? 'Remote volume stream error',
            );
          }
          throw error;
        });
  }

  @override
  Future<void> connect(String ip, String name, int port) async {
    try {
      await _methodChannel.invokeMethod('connect', {
        'ip': ip,
        'name': name,
        'port': port,
      });
    } on PlatformException catch (e) {
      throw NativeChannelException(
        e.code,
        e.message ?? 'Failed to connect remote',
      );
    }
  }

  @override
  Future<void> sendKey(int keyCode, int direction) async {
    try {
      await _methodChannel.invokeMethod('sendKey', {
        'keyCode': keyCode,
        'direction': direction,
      });
    } on PlatformException catch (e) {
      throw NativeChannelException(e.code, e.message ?? 'Failed to send key');
    }
  }

  @override
  Future<void> setAutoReconnect(bool enabled) async {
    try {
      await _methodChannel.invokeMethod('setAutoReconnect', {
        'enabled': enabled,
      });
    } on PlatformException catch (e) {
      throw NativeChannelException(
        e.code,
        e.message ?? 'Failed to set auto reconnect',
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
        e.message ?? 'Failed to disconnect remote',
      );
    }
  }
}
