import 'package:atv_remote/core/errors/failures.dart';
import 'package:atv_remote/domain/entities/tv_device.dart';
import 'package:atv_remote/domain/repositories/discovery_repository.dart';
import 'package:fpdart/fpdart.dart';

class DiscoveryUseCases {
  final DiscoveryRepository _repository;

  DiscoveryUseCases(this._repository);

  Stream<Either<Failure, List<TvDevice>>> get deviceStream =>
      _repository.deviceStream;

  Future<Either<Failure, void>> startDiscovery() =>
      _repository.startDiscovery();

  Future<Either<Failure, void>> stopDiscovery() => _repository.stopDiscovery();

  Future<Either<Failure, TvDevice>> addManualDevice(
    String ipAddress,
    String name,
  ) => _repository.addManualDevice(ipAddress, name);
}
