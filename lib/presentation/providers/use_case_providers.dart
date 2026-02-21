import 'package:atv_remote/domain/usecases/device_storage_use_cases.dart';
import 'package:atv_remote/domain/usecases/discovery_use_cases.dart';
import 'package:atv_remote/domain/usecases/pairing_use_cases.dart';
import 'package:atv_remote/domain/usecases/remote_use_cases.dart';
import 'package:atv_remote/presentation/providers/data_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'use_case_providers.g.dart';

@riverpod
DeviceStorageUseCases deviceStorageUseCases(DeviceStorageUseCasesRef ref) =>
    DeviceStorageUseCases(ref.watch(deviceStorageRepositoryProvider));

@riverpod
DiscoveryUseCases discoveryUseCases(DiscoveryUseCasesRef ref) =>
    DiscoveryUseCases(ref.watch(discoveryRepositoryProvider));

@riverpod
PairingUseCases pairingUseCases(PairingUseCasesRef ref) =>
    PairingUseCases(ref.watch(pairingRepositoryProvider));

@riverpod
RemoteUseCases remoteUseCases(RemoteUseCasesRef ref) =>
    RemoteUseCases(ref.watch(remoteRepositoryProvider));
