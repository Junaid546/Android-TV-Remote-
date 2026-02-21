import 'package:atv_remote/core/errors/failures.dart';
import 'package:atv_remote/data/datasources/native/remote_native_datasource.dart';
import 'package:atv_remote/domain/entities/remote_command.dart';
import 'package:atv_remote/domain/entities/tv_device.dart';
import 'package:atv_remote/domain/repositories/remote_repository.dart';
import 'package:fpdart/fpdart.dart';

class RemoteRepositoryImpl implements RemoteRepository {
  final RemoteNativeDataSource _nativeDataSource;

  RemoteRepositoryImpl(this._nativeDataSource);

  @override
  Stream<Either<Failure, bool>> get connectionAlive {
    return _nativeDataSource.connectionStateStream
        .map<Either<Failure, bool>>((event) {
          try {
            final state = event['state'] as String;
            return Right(state == 'CONNECTED');
          } catch (e) {
            return Left(UnknownFailure(e.toString()));
          }
        })
        .handleError((e) {
          return Left(UnknownFailure(e.toString()));
        });
  }

  @override
  Future<Either<Failure, void>> connect(TvDevice device) async {
    try {
      await _nativeDataSource.connect(
        device.ipAddress,
        device.name,
        device.port,
      );
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendCommand(RemoteCommand command) async {
    try {
      command.when(
        keyCommand: (keyCode, action) {
          final direction = _mapAction(action);
          _nativeDataSource.sendKey(keyCode, direction);
        },
        textCommand: (text) {
          // Future expansion
        },
        wakeCommand: () {
          // Future expansion
        },
      );
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> disconnect() async {
    try {
      await _nativeDataSource.disconnect();
      return const Right(null);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  int _mapAction(KeyAction action) {
    switch (action) {
      case KeyAction.down:
        return 1;
      case KeyAction.up:
        return 2;
      case KeyAction.downUp:
        return 3;
    }
  }
}
