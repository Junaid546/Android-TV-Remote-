import 'package:atv_remote/core/errors/failures.dart';
import 'package:atv_remote/data/datasources/native/remote_native_datasource.dart';
import 'package:atv_remote/domain/entities/remote_command.dart';
import 'package:atv_remote/domain/repositories/remote_repository.dart';
import 'package:fpdart/fpdart.dart';

class RemoteRepositoryImpl implements RemoteRepository {
  final RemoteNativeDatasource _nativeDatasource;

  RemoteRepositoryImpl(this._nativeDatasource);

  @override
  Future<Either<Failure, void>> sendCommand(RemoteCommand command) async {
    try {
      await _nativeDatasource.sendCommand(command);
      return const Right(null);
    } catch (e) {
      return Left(CommandFailure('sendCommand', e.toString()));
    }
  }

  @override
  Stream<Either<Failure, bool>> get connectionAlive {
    return _nativeDatasource.connectionStatusStream.map((status) {
      return Right(status);
    });
  }
}
