import 'package:atv_remote/core/constants/channel_constants.dart';
import 'package:atv_remote/core/errors/exceptions.dart';
import 'package:flutter/services.dart';

abstract interface class PairingNativeDataSource {
  Future<void> startPairing(String ip, int port, String name);
  Future<void> submitPin(String pin);
  Future<void> disconnect();
  Stream<Map<String, dynamic>> get pairingEventStream;
}

class PairingNativeDataSourceImpl implements PairingNativeDataSource {
  static const _methodChannel = MethodChannel(
    ChannelConstants.kPairingMethodChannel,
  );
  static const _eventChannel = EventChannel(
    ChannelConstants.kPairingEventChannel,
  );

  @override
  Stream<Map<String, dynamic>> get pairingEventStream {
    return _eventChannel
        .receiveBroadcastStream()
        .map((event) {
          return Map<String, dynamic>.from(event as Map);
        })
        .handleError((error) {
          if (error is PlatformException) {
            throw NativeChannelException(
              error.code,
              error.message ?? 'Pairing stream error',
            );
          }
          throw error;
        });
  }

  @override
  Future<void> startPairing(String ip, int port, String name) async {
    try {
      await _methodChannel.invokeMethod('startPairing', {
        'ip': ip,
        'port': port,
        'name': name,
      });
    } on PlatformException catch (e) {
      throw NativeChannelException(
        e.code,
        e.message ?? 'Failed to start pairing',
      );
    }
  }

  @override
  Future<void> submitPin(String pin) async {
    try {
      await _methodChannel.invokeMethod('submitPin', {'pin': pin});
    } on PlatformException catch (e) {
      throw NativeChannelException(e.code, e.message ?? 'Failed to submit PIN');
    }
  }

  @override
  Future<void> disconnect() async {
    try {
      await _methodChannel.invokeMethod(
        'cancelPairing',
      ); // Match native 'cancelPairing'
    } on PlatformException catch (e) {
      throw NativeChannelException(
        e.code,
        e.message ?? 'Failed to disconnect pairing',
      );
    }
  }
}
