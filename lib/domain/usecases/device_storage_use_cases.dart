import 'package:atv_remote/core/errors/failures.dart';
import 'package:atv_remote/domain/entities/tv_device.dart';
import 'package:atv_remote/domain/repositories/device_storage_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetSavedDevicesUseCase {
  final DeviceStorageRepository _repository;
  const GetSavedDevicesUseCase(this._repository);

  Future<Either<Failure, List<TvDevice>>> call() =>
      _repository.getSavedDevices();
}

class SaveDeviceUseCase {
  final DeviceStorageRepository _repository;
  const SaveDeviceUseCase(this._repository);

  Future<Either<Failure, void>> call(TvDevice device) =>
      _repository.saveDevice(device);
}

class RemoveDeviceUseCase {
  final DeviceStorageRepository _repository;
  const RemoveDeviceUseCase(this._repository);

  Future<Either<Failure, void>> call(String deviceId) =>
      _repository.removeDevice(deviceId);
}

class GetLastConnectedDeviceUseCase {
  final DeviceStorageRepository _repository;
  const GetLastConnectedDeviceUseCase(this._repository);

  Future<Either<Failure, TvDevice?>> call() =>
      _repository.getLastConnectedDevice();
}

class UpdateDeviceUseCase {
  final DeviceStorageRepository _repository;
  const UpdateDeviceUseCase(this._repository);

  Future<Either<Failure, void>> call(TvDevice device) =>
      _repository.updateDevice(device);
}
