import 'package:fpdart/fpdart.dart';
import 'package:atv_remote/core/errors/failures.dart';
import 'package:atv_remote/domain/entities/tv_device.dart';

abstract interface class DiscoveryRepository {
  Stream<Either<Failure, List<TvDevice>>> get deviceStream;
  Future<Either<Failure, void>> startDiscovery();
  Future<Either<Failure, void>> stopDiscovery();
  Future<Either<Failure, TvDevice>> addManualDevice(
    String ipAddress,
    String name,
  );
}
