import 'package:atv_remote/core/constants/channel_constants.dart';
import 'package:atv_remote/core/errors/exceptions.dart';
import 'package:flutter/services.dart';

class PairingNativeDatasource {
  static const _methodChannel = MethodChannel(
    ChannelConstants.kPairingMethodChannel,
  );
  static const _eventChannel = EventChannel(
    ChannelConstants.kPairingEventChannel,
  );

  Future<void> startPairing(String ip, int port) async {
    try {
      await _methodChannel.invokeMethod('startPairing', {
        'ip': ip,
        'port': port,
      });
    } on PlatformException catch (e) {
      throw NativeChannelException(
        e.code,
        e.message ?? 'Failed to start pairing',
      );
    }
  }

  Future<void> submitPin(String pin) async {
    try {
      await _methodChannel.invokeMethod('submitPin', {'pin': pin});
    } on PlatformException catch (e) {
      throw NativeChannelException(e.code, e.message ?? 'Failed to submit PIN');
    }
  }

  Future<void> disconnect() async {
    try {
      await _methodChannel.invokeMethod('disconnect');
    } on PlatformException catch (e) {
      throw NativeChannelException(e.code, e.message ?? 'Failed to disconnect');
    }
  }

  Stream<Map<String, dynamic>> get pairingStatusStream {
    return _eventChannel.receiveBroadcastStream().map((event) {
      return Map<String, dynamic>.from(event as Map);
    });
  }
}
