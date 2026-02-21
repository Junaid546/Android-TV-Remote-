import 'package:atv_remote/domain/usecases/device_storage_use_cases.dart';
import 'package:atv_remote/domain/usecases/discovery_use_cases.dart';
import 'package:atv_remote/domain/usecases/pairing_use_cases.dart';
import 'package:atv_remote/domain/usecases/remote_use_cases.dart';
import 'package:atv_remote/domain/usecases/settings_use_cases.dart';
import 'package:atv_remote/presentation/providers/data_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'use_case_providers.g.dart';

// Device Storage Use Cases
@riverpod
GetSavedDevicesUseCase getSavedDevicesUseCase(GetSavedDevicesUseCaseRef ref) =>
    GetSavedDevicesUseCase(ref.watch(deviceStorageRepositoryProvider));

@riverpod
SaveDeviceUseCase saveDeviceUseCase(SaveDeviceUseCaseRef ref) =>
    SaveDeviceUseCase(ref.watch(deviceStorageRepositoryProvider));

@riverpod
RemoveDeviceUseCase removeDeviceUseCase(RemoveDeviceUseCaseRef ref) =>
    RemoveDeviceUseCase(ref.watch(deviceStorageRepositoryProvider));

@riverpod
GetLastConnectedDeviceUseCase getLastConnectedDeviceUseCase(
  GetLastConnectedDeviceUseCaseRef ref,
) => GetLastConnectedDeviceUseCase(ref.watch(deviceStorageRepositoryProvider));

@riverpod
UpdateDeviceUseCase updateDeviceUseCase(UpdateDeviceUseCaseRef ref) =>
    UpdateDeviceUseCase(ref.watch(deviceStorageRepositoryProvider));

// Discovery Use Cases
@riverpod
StartDiscoveryUseCase startDiscoveryUseCase(StartDiscoveryUseCaseRef ref) =>
    StartDiscoveryUseCase(ref.watch(discoveryRepositoryProvider));

@riverpod
StopDiscoveryUseCase stopDiscoveryUseCase(StopDiscoveryUseCaseRef ref) =>
    StopDiscoveryUseCase(ref.watch(discoveryRepositoryProvider));

@riverpod
AddManualDeviceUseCase addManualDeviceUseCase(AddManualDeviceUseCaseRef ref) =>
    AddManualDeviceUseCase(ref.watch(discoveryRepositoryProvider));

@riverpod
DiscoveryDeviceStreamUseCase discoveryDeviceStreamUseCase(
  DiscoveryDeviceStreamUseCaseRef ref,
) => DiscoveryDeviceStreamUseCase(ref.watch(discoveryRepositoryProvider));

// Pairing Use Cases
@riverpod
ConnectToDeviceUseCase connectToDeviceUseCase(ConnectToDeviceUseCaseRef ref) =>
    ConnectToDeviceUseCase(
      ref.watch(pairingRepositoryProvider),
      ref.watch(deviceStorageRepositoryProvider),
    );

@riverpod
SubmitPinUseCase submitPinUseCase(SubmitPinUseCaseRef ref) =>
    SubmitPinUseCase(ref.watch(pairingRepositoryProvider));

@riverpod
DisconnectUseCase disconnectUseCase(DisconnectUseCaseRef ref) =>
    DisconnectUseCase(ref.watch(pairingRepositoryProvider));

@riverpod
PairingStatusStreamUseCase pairingStatusStreamUseCase(
  PairingStatusStreamUseCaseRef ref,
) => PairingStatusStreamUseCase(ref.watch(pairingRepositoryProvider));

// Remote Use Cases
@riverpod
SendCommandUseCase sendCommandUseCase(SendCommandUseCaseRef ref) =>
    SendCommandUseCase(ref.watch(remoteRepositoryProvider));

@riverpod
ConnectRemoteUseCase connectRemoteUseCase(ConnectRemoteUseCaseRef ref) =>
    ConnectRemoteUseCase(ref.watch(remoteRepositoryProvider));

@riverpod
DisconnectRemoteUseCase disconnectRemoteUseCase(
  DisconnectRemoteUseCaseRef ref,
) => DisconnectRemoteUseCase(ref.watch(remoteRepositoryProvider));

@riverpod
RemoteConnectionAliveStreamUseCase remoteConnectionAliveStreamUseCase(
  RemoteConnectionAliveStreamUseCaseRef ref,
) => RemoteConnectionAliveStreamUseCase(ref.watch(remoteRepositoryProvider));

// Settings Use Cases
@riverpod
GetThemeModeUseCase getThemeModeUseCase(GetThemeModeUseCaseRef ref) =>
    GetThemeModeUseCase(ref.watch(settingsRepositoryProvider));

@riverpod
SetThemeModeUseCase setThemeModeUseCase(SetThemeModeUseCaseRef ref) =>
    SetThemeModeUseCase(ref.watch(settingsRepositoryProvider));

@riverpod
IsHapticEnabledUseCase isHapticEnabledUseCase(IsHapticEnabledUseCaseRef ref) =>
    IsHapticEnabledUseCase(ref.watch(settingsRepositoryProvider));

@riverpod
SetHapticEnabledUseCase setHapticEnabledUseCase(
  SetHapticEnabledUseCaseRef ref,
) => SetHapticEnabledUseCase(ref.watch(settingsRepositoryProvider));
