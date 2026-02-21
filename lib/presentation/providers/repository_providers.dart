import 'package:atv_remote/data/datasources/local/hive_device_datasource.dart';
import 'package:atv_remote/data/datasources/native/discovery_native_datasource.dart';
import 'package:atv_remote/data/datasources/native/network_native_datasource.dart';
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
import 'package:atv_remote/data/repositories/settings_repository_impl.dart';
import 'package:atv_remote/domain/repositories/settings_repository.dart';
import 'package:atv_remote/data/datasources/local/hive_settings_datasource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repository_providers.g.dart';

// -----------------------------------------------------------------------------
// Data Sources
// -----------------------------------------------------------------------------

@Riverpod(keepAlive: true)
DiscoveryNativeDataSource discoveryNativeDataSource(Ref ref) =>
    DiscoveryNativeDataSourceImpl();

@Riverpod(keepAlive: true)
PairingNativeDataSource pairingNativeDataSource(Ref ref) =>
    PairingNativeDataSourceImpl();

@Riverpod(keepAlive: true)
RemoteNativeDataSource remoteNativeDataSource(Ref ref) =>
    RemoteNativeDataSourceImpl();

@Riverpod(keepAlive: true)
HiveDeviceDatasource hiveDeviceDatasource(Ref ref) => HiveDeviceDatasource();

@Riverpod(keepAlive: true)
NetworkNativeDataSource networkNativeDataSource(Ref ref) =>
    NetworkNativeDataSourceImpl();

@Riverpod(keepAlive: true)
HiveSettingsDatasource hiveSettingsDatasource(Ref ref) =>
    HiveSettingsDatasource();

// -----------------------------------------------------------------------------
// Repositories
// -----------------------------------------------------------------------------

@Riverpod(keepAlive: true)
DeviceStorageRepository deviceStorageRepository(Ref ref) =>
    DeviceStorageRepositoryImpl(ref.watch(hiveDeviceDatasourceProvider));

@Riverpod(keepAlive: true)
DiscoveryRepository discoveryRepository(Ref ref) =>
    DiscoveryRepositoryImpl(ref.watch(discoveryNativeDataSourceProvider));

@Riverpod(keepAlive: true)
PairingRepository pairingRepository(Ref ref) =>
    PairingRepositoryImpl(ref.watch(pairingNativeDataSourceProvider));

@Riverpod(keepAlive: true)
RemoteRepository remoteRepository(Ref ref) =>
    RemoteRepositoryImpl(ref.watch(remoteNativeDataSourceProvider));

@Riverpod(keepAlive: true)
SettingsRepository settingsRepository(Ref ref) =>
    SettingsRepositoryImpl(ref.watch(hiveSettingsDatasourceProvider));
