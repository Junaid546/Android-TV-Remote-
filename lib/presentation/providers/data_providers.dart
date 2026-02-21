import 'package:atv_remote/data/datasources/local/hive_device_datasource.dart';
import 'package:atv_remote/data/datasources/native/discovery_native_datasource.dart';
import 'package:atv_remote/data/datasources/native/pairing_native_datasource.dart';
import 'package:atv_remote/data/datasources/native/remote_native_datasource.dart';
import 'package:atv_remote/data/repositories/device_storage_repository_impl.dart';
import 'package:atv_remote/data/repositories/discovery_repository_impl.dart';
import 'package:atv_remote/data/repositories/pairing_repository_impl.dart';
import 'package:atv_remote/data/repositories/remote_repository_impl.dart';
import 'package:atv_remote/domain/repositories/device_storage_repository.dart';
import 'package:atv_remote/domain/repositories/discovery_repository.dart';
import 'package:atv_remote/domain/repositories/pairing_repository.dart';
import 'package:atv_remote/domain/repositories/remote_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'data_providers.g.dart';

// Data Sources
@riverpod
HiveDeviceDatasource hiveDeviceDatasource(HiveDeviceDatasourceRef ref) =>
    HiveDeviceDatasource();

@riverpod
DiscoveryNativeDatasource discoveryNativeDatasource(
  DiscoveryNativeDatasourceRef ref,
) => DiscoveryNativeDatasource();

@riverpod
PairingNativeDatasource pairingNativeDatasource(
  PairingNativeDatasourceRef ref,
) => PairingNativeDatasource();

@riverpod
RemoteNativeDatasource remoteNativeDatasource(RemoteNativeDatasourceRef ref) =>
    RemoteNativeDatasource();

// Repositories
@riverpod
DeviceStorageRepository deviceStorageRepository(
  DeviceStorageRepositoryRef ref,
) => DeviceStorageRepositoryImpl(ref.watch(hiveDeviceDatasourceProvider));

@riverpod
DiscoveryRepository discoveryRepository(DiscoveryRepositoryRef ref) =>
    DiscoveryRepositoryImpl(ref.watch(discoveryNativeDatasourceProvider));

@riverpod
PairingRepository pairingRepository(PairingRepositoryRef ref) =>
    PairingRepositoryImpl(ref.watch(pairingNativeDatasourceProvider));

@riverpod
RemoteRepository remoteRepository(RemoteRepositoryRef ref) =>
    RemoteRepositoryImpl(ref.watch(remoteNativeDatasourceProvider));
