import 'package:atv_remote/core/constants/channel_constants.dart';
import 'package:atv_remote/core/errors/exceptions.dart';
import 'package:atv_remote/domain/entities/remote_command.dart';
import 'package:flutter/services.dart';

class RemoteNativeDatasource {
  static const _methodChannel = MethodChannel(
    ChannelConstants.kRemoteMethodChannel,
  );
  static const _eventChannel = EventChannel(
    ChannelConstants.kRemoteEventChannel,
  );

  Future<void> sendCommand(RemoteCommand command) async {
    try {
      final Map<String, dynamic> args = command.when(
        keyCommand: (keyCode, action) => {
          'type': 'key',
          'code': keyCode,
          'action': action.name,
        },
        textCommand: (text) => {'type': 'text', 'text': text},
        wakeCommand: () => {'type': 'wake'},
      );
      await _methodChannel.invokeMethod('sendCommand', args);
    } on PlatformException catch (e) {
      throw NativeChannelException(
        e.code,
        e.message ?? 'Failed to send command',
      );
    }
  }

  Stream<bool> get connectionStatusStream {
    return _eventChannel.receiveBroadcastStream().map((event) => event as bool);
  }
}
