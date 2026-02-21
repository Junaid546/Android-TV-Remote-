import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:atv_remote/domain/entities/tv_device.dart';
import 'package:atv_remote/core/errors/failures.dart';

part 'pairing_status.freezed.dart';

@freezed
sealed class PairingStatus with _$PairingStatus {
  const factory PairingStatus.idle() = Idle;
  const factory PairingStatus.discoveryStarted() = DiscoveryStarted;
  const factory PairingStatus.devicesFound(List<TvDevice> devices) =
      DevicesFound;
  const factory PairingStatus.connecting(TvDevice device) = Connecting;
  const factory PairingStatus.awaitingPin(
    TvDevice device,
    int expiresInSeconds,
  ) = AwaitingPin;
  const factory PairingStatus.pinVerified(TvDevice device) = PinVerified;
  const factory PairingStatus.paired(TvDevice device) = Paired;
  const factory PairingStatus.connected(TvDevice device) = Connected;
  const factory PairingStatus.reconnecting(TvDevice device, int attempt) =
      Reconnecting;
  const factory PairingStatus.disconnected(
    TvDevice? lastDevice,
    String reason,
  ) = Disconnected;
  const factory PairingStatus.connectionFailed(
    TvDevice device,
    Failure failure,
  ) = ConnectionFailed;
  const factory PairingStatus.pinError(
    TvDevice device,
    int attemptsLeft,
    String message,
  ) = PinError;
}
