import 'package:atv_remote/core/errors/failures.dart';
import 'package:atv_remote/domain/entities/remote_command.dart';
import 'package:atv_remote/domain/entities/tv_device.dart';
import 'package:atv_remote/domain/repositories/remote_repository.dart';
import 'package:fpdart/fpdart.dart';

class SendCommandUseCase {
  final RemoteRepository _repository;
  const SendCommandUseCase(this._repository);

  Future<Either<Failure, void>> call(RemoteCommand command) =>
      _repository.sendCommand(command);
}

class ConnectRemoteUseCase {
  final RemoteRepository _repository;
  const ConnectRemoteUseCase(this._repository);

  Future<Either<Failure, void>> call(TvDevice device) =>
      _repository.connect(device);
}

class DisconnectRemoteUseCase {
  final RemoteRepository _repository;
  const DisconnectRemoteUseCase(this._repository);

  Future<Either<Failure, void>> call() => _repository.disconnect();
}

class RemoteConnectionAliveStreamUseCase {
  final RemoteRepository _repository;
  const RemoteConnectionAliveStreamUseCase(this._repository);

  Stream<Either<Failure, bool>> call() => _repository.connectionAlive;
}
