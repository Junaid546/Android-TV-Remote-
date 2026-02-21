import 'package:atv_remote/core/errors/failures.dart';
import 'package:atv_remote/domain/entities/tv_device.dart';
import 'package:atv_remote/domain/repositories/device_storage_repository.dart';
import 'package:fpdart/fpdart.dart';

class DeviceStorageUseCases {
  final DeviceStorageRepository _repository;

  DeviceStorageUseCases(this._repository);

  Future<Either<Failure, List<TvDevice>>> getSavedDevices() =>
      _repository.getSavedDevices();

  Future<Either<Failure, void>> saveDevice(TvDevice device) =>
      _repository.saveDevice(device);

  Future<Either<Failure, void>> removeDevice(String deviceId) =>
      _repository.removeDevice(deviceId);

  Future<Either<Failure, TvDevice?>> getLastConnectedDevice() =>
      _repository.getLastConnectedDevice();

  Future<Either<Failure, void>> updateDevice(TvDevice device) =>
      _repository.updateDevice(device);
}
