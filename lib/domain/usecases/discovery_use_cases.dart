import 'package:atv_remote/core/errors/failures.dart';
import 'package:atv_remote/domain/entities/tv_device.dart';
import 'package:atv_remote/domain/repositories/discovery_repository.dart';
import 'package:fpdart/fpdart.dart';

class StartDiscoveryUseCase {
  final DiscoveryRepository _repository;
  const StartDiscoveryUseCase(this._repository);

  Future<Either<Failure, void>> call() => _repository.startDiscovery();
}

class StopDiscoveryUseCase {
  final DiscoveryRepository _repository;
  const StopDiscoveryUseCase(this._repository);

  Future<Either<Failure, void>> call() => _repository.stopDiscovery();
}

class AddManualDeviceUseCase {
  final DiscoveryRepository _repository;
  const AddManualDeviceUseCase(this._repository);

  Future<Either<Failure, TvDevice>> call(String ip, String name) {
    if (!_isValidIpV4(ip)) {
      return Future.value(
        Left(NetworkFailure('Invalid IP address format: $ip')),
      );
    }
    return _repository.addManualDevice(ip, name);
  }

  bool _isValidIpV4(String ip) {
    final regExp = RegExp(
      r'^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$',
    );
    return regExp.hasMatch(ip);
  }
}

class DiscoveryDeviceStreamUseCase {
  final DiscoveryRepository _repository;
  const DiscoveryDeviceStreamUseCase(this._repository);

  Stream<Either<Failure, List<TvDevice>>> call() => _repository.deviceStream;
}
