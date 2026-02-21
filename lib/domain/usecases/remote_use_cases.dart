import 'package:atv_remote/core/errors/failures.dart';
import 'package:atv_remote/domain/entities/remote_command.dart';
import 'package:atv_remote/domain/repositories/remote_repository.dart';
import 'package:fpdart/fpdart.dart';

class RemoteUseCases {
  final RemoteRepository _repository;

  RemoteUseCases(this._repository);

  Future<Either<Failure, void>> sendCommand(RemoteCommand command) =>
      _repository.sendCommand(command);

  Stream<Either<Failure, bool>> get connectionAlive =>
      _repository.connectionAlive;
}
