import 'package:atv_remote/domain/usecases/device_storage_use_cases.dart';
import 'package:atv_remote/domain/usecases/discovery_use_cases.dart';
import 'package:atv_remote/domain/usecases/pairing_use_cases.dart';
import 'package:atv_remote/domain/usecases/remote_use_cases.dart';
import 'package:atv_remote/domain/usecases/settings_use_cases.dart';
import 'package:atv_remote/presentation/providers/repository_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'use_case_providers.g.dart';

// Device Storage Use Cases
@Riverpod(keepAlive: true)
GetSavedDevicesUseCase getSavedDevicesUseCase(Ref ref) =>
    GetSavedDevicesUseCase(ref.watch(deviceStorageRepositoryProvider));

@Riverpod(keepAlive: true)
SaveDeviceUseCase saveDeviceUseCase(Ref ref) =>
    SaveDeviceUseCase(ref.watch(deviceStorageRepositoryProvider));

@Riverpod(keepAlive: true)
RemoveDeviceUseCase removeDeviceUseCase(Ref ref) =>
    RemoveDeviceUseCase(ref.watch(deviceStorageRepositoryProvider));

@Riverpod(keepAlive: true)
GetLastConnectedDeviceUseCase getLastConnectedDeviceUseCase(Ref ref) =>
    GetLastConnectedDeviceUseCase(ref.watch(deviceStorageRepositoryProvider));

@Riverpod(keepAlive: true)
UpdateDeviceUseCase updateDeviceUseCase(Ref ref) =>
    UpdateDeviceUseCase(ref.watch(deviceStorageRepositoryProvider));

// Discovery Use Cases
@Riverpod(keepAlive: true)
StartDiscoveryUseCase startDiscoveryUseCase(Ref ref) =>
    StartDiscoveryUseCase(ref.watch(discoveryRepositoryProvider));

@Riverpod(keepAlive: true)
StopDiscoveryUseCase stopDiscoveryUseCase(Ref ref) =>
    StopDiscoveryUseCase(ref.watch(discoveryRepositoryProvider));

@Riverpod(keepAlive: true)
AddManualDeviceUseCase addManualDeviceUseCase(Ref ref) =>
    AddManualDeviceUseCase(ref.watch(discoveryRepositoryProvider));

@Riverpod(keepAlive: true)
DiscoveryDeviceStreamUseCase discoveryDeviceStreamUseCase(Ref ref) =>
    DiscoveryDeviceStreamUseCase(ref.watch(discoveryRepositoryProvider));

// Pairing Use Cases
@Riverpod(keepAlive: true)
ConnectToDeviceUseCase connectToDeviceUseCase(Ref ref) =>
    ConnectToDeviceUseCase(
      ref.watch(pairingRepositoryProvider),
      ref.watch(deviceStorageRepositoryProvider),
    );

@Riverpod(keepAlive: true)
SubmitPinUseCase submitPinUseCase(Ref ref) =>
    SubmitPinUseCase(ref.watch(pairingRepositoryProvider));

@Riverpod(keepAlive: true)
DisconnectUseCase disconnectUseCase(Ref ref) =>
    DisconnectUseCase(ref.watch(pairingRepositoryProvider));

@Riverpod(keepAlive: true)
PairingStatusStreamUseCase pairingStatusStreamUseCase(Ref ref) =>
    PairingStatusStreamUseCase(ref.watch(pairingRepositoryProvider));

// Remote Use Cases
@Riverpod(keepAlive: true)
SendCommandUseCase sendCommandUseCase(Ref ref) =>
    SendCommandUseCase(ref.watch(remoteRepositoryProvider));

@Riverpod(keepAlive: true)
ConnectRemoteUseCase connectRemoteUseCase(Ref ref) =>
    ConnectRemoteUseCase(ref.watch(remoteRepositoryProvider));

@Riverpod(keepAlive: true)
DisconnectRemoteUseCase disconnectRemoteUseCase(Ref ref) =>
    DisconnectRemoteUseCase(ref.watch(remoteRepositoryProvider));

@Riverpod(keepAlive: true)
RemoteConnectionAliveStreamUseCase remoteConnectionAliveStreamUseCase(
  Ref ref,
) => RemoteConnectionAliveStreamUseCase(ref.watch(remoteRepositoryProvider));

// Settings Use Cases
@Riverpod(keepAlive: true)
GetThemeModeUseCase getThemeModeUseCase(Ref ref) =>
    GetThemeModeUseCase(ref.watch(settingsRepositoryProvider));

@Riverpod(keepAlive: true)
SetThemeModeUseCase setThemeModeUseCase(Ref ref) =>
    SetThemeModeUseCase(ref.watch(settingsRepositoryProvider));

@Riverpod(keepAlive: true)
IsHapticEnabledUseCase isHapticEnabledUseCase(Ref ref) =>
    IsHapticEnabledUseCase(ref.watch(settingsRepositoryProvider));

@Riverpod(keepAlive: true)
SetHapticEnabledUseCase setHapticEnabledUseCase(Ref ref) =>
    SetHapticEnabledUseCase(ref.watch(settingsRepositoryProvider));
