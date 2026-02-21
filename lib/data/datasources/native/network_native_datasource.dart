import 'package:atv_remote/core/constants/channel_constants.dart';
import 'package:atv_remote/core/errors/exceptions.dart';
import 'package:flutter/services.dart';

abstract interface class NetworkNativeDataSource {
  Stream<bool> get wifiStatusStream;
}

class NetworkNativeDataSourceImpl implements NetworkNativeDataSource {
  static const _eventChannel = EventChannel(
    ChannelConstants.kNetworkEventChannel,
  );

  @override
  Stream<bool> get wifiStatusStream {
    return _eventChannel
        .receiveBroadcastStream()
        .map((event) {
          final data = Map<String, dynamic>.from(event as Map);
          final connected = data['connected'] as bool? ?? false;
          final type = data['type'] as String? ?? 'none';

          // Only emit true when type is "wifi"
          return connected && type == 'wifi';
        })
        .handleError((error) {
          if (error is PlatformException) {
            throw NativeChannelException(
              error.code,
              error.message ?? 'Network stream error',
            );
          }
          throw error;
        });
  }
}
