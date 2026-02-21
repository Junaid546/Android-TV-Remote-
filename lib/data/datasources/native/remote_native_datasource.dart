import 'dart:async';
import 'package:atv_remote/core/constants/channel_constants.dart';
import 'package:atv_remote/core/errors/exceptions.dart';
import 'package:flutter/services.dart';

abstract interface class RemoteNativeDataSource {
  Future<void> connect(String ip, String name, int port);
  void sendKey(int keyCode, int direction);
  Future<void> disconnect();
  Stream<Map<String, dynamic>> get connectionStateStream;
}

class RemoteNativeDataSourceImpl implements RemoteNativeDataSource {
  static const _methodChannel = MethodChannel(
    ChannelConstants.kRemoteMethodChannel,
  );
  static const _eventChannel = EventChannel(
    ChannelConstants.kRemoteEventChannel,
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
  void sendKey(int keyCode, int direction) {
    // Fire and forget - don't await
    unawaited(
      _methodChannel
          .invokeMethod('sendKey', {'keyCode': keyCode, 'direction': direction})
          .catchError((e) {
            // Log error or handle silently as per requirement
          }),
    );
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
