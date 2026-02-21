import 'package:atv_remote/domain/entities/tv_device.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_state.freezed.dart';

@freezed
class RemoteState with _$RemoteState {
  const factory RemoteState({
    TvDevice? device,
    @Default(false) bool isConnected,
    @Default(false) bool isMuted,
    @Default(0.5) double volume,
  }) = _RemoteState;
}
