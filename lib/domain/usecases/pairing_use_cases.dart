import 'package:atv_remote/core/errors/failures.dart';
import 'package:atv_remote/domain/entities/pairing_status.dart';
import 'package:atv_remote/domain/entities/tv_device.dart';
import 'package:atv_remote/domain/repositories/device_storage_repository.dart';
import 'package:atv_remote/domain/repositories/pairing_repository.dart';
import 'package:fpdart/fpdart.dart';

class ConnectToDeviceUseCase {
  final PairingRepository _pairingRepo;
  final DeviceStorageRepository _storageRepo;

  const ConnectToDeviceUseCase(this._pairingRepo, this._storageRepo);

  Future<Either<Failure, void>> call(TvDevice device) async {
    final savedResult = await _storageRepo.getSavedDevices();
    final alreadyPaired = savedResult.fold(
      (_) => false,
      (devices) => devices.any((d) => d.id == device.id && d.isPaired),
    );

    return _pairingRepo.connectToDevice(
      device.copyWith(isPaired: alreadyPaired),
    );
  }
}

class SubmitPinUseCase {
  final PairingRepository _repository;
  const SubmitPinUseCase(this._repository);

  Future<Either<Failure, void>> call(String pin) => _repository.submitPin(pin);
}

class ForgetPairedDeviceUseCase {
  final PairingRepository _repository;
  const ForgetPairedDeviceUseCase(this._repository);

  Future<Either<Failure, void>> call(String ipAddress) =>
      _repository.forgetDevice(ipAddress);
}

class IsDevicePairedUseCase {
  final PairingRepository _repository;
  const IsDevicePairedUseCase(this._repository);

  Future<Either<Failure, bool>> call(String ipAddress) =>
      _repository.isDevicePaired(ipAddress);
}

class DisconnectUseCase {
  final PairingRepository _repository;
  const DisconnectUseCase(this._repository);

  Future<Either<Failure, void>> call() => _repository.disconnect();
}

class PairingStatusStreamUseCase {
  final PairingRepository _repository;
  const PairingStatusStreamUseCase(this._repository);

  Stream<Either<Failure, PairingStatus>> call() => _repository.statusStream;
}
