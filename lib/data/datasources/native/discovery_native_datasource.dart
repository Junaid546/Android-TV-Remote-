import 'package:atv_remote/core/constants/channel_constants.dart';
import 'package:atv_remote/core/errors/exceptions.dart';
import 'package:flutter/services.dart';

class DiscoveryNativeDatasource {
  static const _methodChannel = MethodChannel(
    ChannelConstants.kDiscoveryMethodChannel,
  );
  static const _eventChannel = EventChannel(
    ChannelConstants.kDiscoveryEventChannel,
  );

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

  Stream<List<Map<String, dynamic>>> get discoveryStream {
    return _eventChannel.receiveBroadcastStream().map((event) {
      final list = event as List<dynamic>;
      return list
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();
    });
  }

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
