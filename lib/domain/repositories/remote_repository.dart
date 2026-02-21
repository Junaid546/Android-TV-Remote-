import 'package:fpdart/fpdart.dart';
import 'package:atv_remote/core/errors/failures.dart';
import 'package:atv_remote/domain/entities/remote_command.dart';

abstract interface class RemoteRepository {
  Future<Either<Failure, void>> sendCommand(RemoteCommand command);
  Stream<Either<Failure, bool>> get connectionAlive;
}
