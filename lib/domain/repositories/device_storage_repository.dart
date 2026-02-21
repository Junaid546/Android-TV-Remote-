import 'package:fpdart/fpdart.dart';
import 'package:atv_remote/core/errors/failures.dart';
import 'package:atv_remote/domain/entities/tv_device.dart';

abstract interface class DeviceStorageRepository {
  Future<Either<Failure, List<TvDevice>>> getSavedDevices();
  Future<Either<Failure, void>> saveDevice(TvDevice device);
  Future<Either<Failure, void>> removeDevice(String deviceId);
  Future<Either<Failure, TvDevice?>> getLastConnectedDevice();
  Future<Either<Failure, void>> updateDevice(TvDevice device);
}
