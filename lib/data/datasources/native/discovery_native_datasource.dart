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

  Stream<Map<String, dynamic>> get discoveryStream {
    return _eventChannel.receiveBroadcastStream().map((event) {
      return Map<String, dynamic>.from(event as Map);
    });
  }
}
