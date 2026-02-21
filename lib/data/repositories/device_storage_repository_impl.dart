import 'package:atv_remote/core/errors/failures.dart';
import 'package:atv_remote/data/datasources/local/hive_device_datasource.dart';
import 'package:atv_remote/data/models/tv_device_model.dart';
import 'package:atv_remote/domain/entities/tv_device.dart';
import 'package:atv_remote/domain/repositories/device_storage_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive/hive.dart';

class DeviceStorageRepositoryImpl implements DeviceStorageRepository {
  final HiveDeviceDatasource _datasource;

  DeviceStorageRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, List<TvDevice>>> getSavedDevices() async {
    try {
      final models = await _datasource.getAllDevices();
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } on HiveError catch (e) {
      return Left(StorageFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveDevice(TvDevice device) async {
    try {
      await _datasource.saveDevice(TvDeviceModel.fromEntity(device));
      return const Right(null);
    } on HiveError catch (e) {
      return Left(StorageFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeDevice(String deviceId) async {
    try {
      await _datasource.removeDevice(deviceId);
      return const Right(null);
    } on HiveError catch (e) {
      return Left(StorageFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TvDevice?>> getLastConnectedDevice() async {
    try {
      final model = await _datasource.getLastConnected();
      return Right(model?.toEntity());
    } on HiveError catch (e) {
      return Left(StorageFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateDevice(TvDevice device) async {
    try {
      await _datasource.saveDevice(TvDeviceModel.fromEntity(device));
      return const Right(null);
    } on HiveError catch (e) {
      return Left(StorageFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
