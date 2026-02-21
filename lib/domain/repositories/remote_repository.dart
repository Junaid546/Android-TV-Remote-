import 'package:fpdart/fpdart.dart';
import 'package:atv_remote/core/errors/failures.dart';
import 'package:atv_remote/domain/entities/remote_command.dart';
import 'package:atv_remote/domain/entities/tv_device.dart';

abstract interface class RemoteRepository {
  Future<Either<Failure, void>> connect(TvDevice device);
  Future<Either<Failure, void>> disconnect();
  Future<Either<Failure, void>> sendCommand(RemoteCommand command);
  Stream<Either<Failure, bool>> get connectionAlive;
}
