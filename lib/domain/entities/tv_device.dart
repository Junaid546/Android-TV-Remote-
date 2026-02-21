import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:atv_remote/core/constants/app_constants.dart';

part 'tv_device.freezed.dart';
part 'tv_device.g.dart';

@freezed
class TvDevice with _$TvDevice {
  const factory TvDevice({
    required String id,
    required String name,
    required String ipAddress,
    @Default(AppConstants.kRemotePort) int port,
    @Default(false) bool isPaired,
    DateTime? lastConnected,
    String? certificateFingerprint,
    @Default(0) int signalStrength,
  }) = _TvDevice;

  factory TvDevice.fromJson(Map<String, dynamic> json) =>
      _$TvDeviceFromJson(json);
}
