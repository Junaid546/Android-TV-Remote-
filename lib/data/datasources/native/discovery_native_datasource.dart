import 'package:atv_remote/core/constants/channel_constants.dart';
import 'package:atv_remote/core/errors/exceptions.dart';
import 'package:flutter/services.dart';

abstract interface class DiscoveryNativeDataSource {
  Future<void> startDiscovery();
  Future<void> stopDiscovery();
  Future<Map<String, dynamic>> addManualDevice(String ip, String name);
  Stream<List<Map<String, dynamic>>> get discoveryStream;
}

class DiscoveryNativeDataSourceImpl implements DiscoveryNativeDataSource {
  static const _methodChannel = MethodChannel(
    ChannelConstants.kDiscoveryMethodChannel,
  );
  static const _eventChannel = EventChannel(
    ChannelConstants.kDiscoveryEventChannel,
  );

  @override
  Stream<List<Map<String, dynamic>>> get discoveryStream {
    return _eventChannel
        .receiveBroadcastStream()
        .map(
          (event) => (event as List)
              .cast<Map<Object?, Object?>>()
              .map((e) => e.cast<String, dynamic>())
              .toList(),
        )
        .handleError((error) {
          if (error is PlatformException) {
            throw NativeChannelException(
              error.code,
              error.message ?? 'Discovery stream error',
            );
          }
          throw error;
        });
  }

  @override
  Future<void> startDiscovery() async {
    try {
      await _methodChannel.invokeMethod('startDiscovery');
    } on PlatformException catch (e) {
      throw NativeChannelException(
        e.code,
        e.message ?? 'Failed to start discovery',
      );
    }
  }

  @override
  Future<void> stopDiscovery() async {
    try {
      await _methodChannel.invokeMethod('stopDiscovery');
    } on PlatformException catch (e) {
      throw NativeChannelException(
        e.code,
        e.message ?? 'Failed to stop discovery',
      );
    }
  }

  @override
  Future<Map<String, dynamic>> addManualDevice(String ip, String name) async {
    try {
      final result = await _methodChannel.invokeMethod('addManualDevice', {
        'ip': ip,
        'name': name,
      });
      return Map<String, dynamic>.from(result as Map);
    } on PlatformException catch (e) {
      throw NativeChannelException(
        e.code,
        e.message ?? 'Failed to add manual device',
      );
    }
  }
}
