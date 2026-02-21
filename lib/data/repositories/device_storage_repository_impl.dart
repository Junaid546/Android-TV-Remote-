import 'package:atv_remote/core/errors/failures.dart';
import 'package:atv_remote/data/datasources/local/hive_device_datasource.dart';
import 'package:atv_remote/data/models/saved_device_model.dart';
import 'package:atv_remote/domain/entities/tv_device.dart';
import 'package:atv_remote/domain/repositories/device_storage_repository.dart';
import 'package:fpdart/fpdart.dart';

class DeviceStorageRepositoryImpl implements DeviceStorageRepository {
  final HiveDeviceDatasource _datasource;

  DeviceStorageRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, List<TvDevice>>> getSavedDevices() async {
    try {
      final models = await _datasource.getAllDevices();
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(StorageFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveDevice(TvDevice device) async {
    try {
      await _datasource.saveDevice(SavedDeviceModel.fromEntity(device));
      return const Right(null);
    } catch (e) {
      return Left(StorageFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeDevice(String deviceId) async {
    try {
      await _datasource.deleteDevice(deviceId);
      return const Right(null);
    } catch (e) {
      return Left(StorageFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TvDevice?>> getLastConnectedDevice() async {
    try {
      final id = await _datasource.getLastConnectedDeviceId();
      if (id == null) return const Right(null);

      final model = await _datasource.getDevice(id);
      if (model == null) return const Right(null);

      return Right(model.toEntity());
    } catch (e) {
      return Left(StorageFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateDevice(TvDevice device) async {
    try {
      await _datasource.saveDevice(SavedDeviceModel.fromEntity(device));
      return const Right(null);
    } catch (e) {
      return Left(StorageFailure(e.toString()));
    }
  }
}
