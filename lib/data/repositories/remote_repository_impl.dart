import 'package:atv_remote/core/errors/failures.dart';
import 'package:atv_remote/data/datasources/native/remote_native_datasource.dart';
import 'package:atv_remote/domain/entities/remote_command.dart';
import 'package:atv_remote/domain/entities/remote_session_status.dart';
import 'package:atv_remote/domain/entities/tv_device.dart';
import 'package:atv_remote/domain/repositories/remote_repository.dart';
import 'package:fpdart/fpdart.dart';

class RemoteRepositoryImpl implements RemoteRepository {
  final RemoteNativeDataSource _nativeDataSource;

  RemoteRepositoryImpl(this._nativeDataSource);

  @override
  Stream<Either<Failure, RemoteSessionStatus>> get connectionState {
    return _nativeDataSource.connectionStateStream
        .map<Either<Failure, RemoteSessionStatus>>((event) {
          try {
            final state = event['state'] as String?;
            final ip = (event['ip'] ?? event['deviceIp'] ?? '') as String;
            final name =
                (event['name'] ?? event['deviceName'] ?? 'TV') as String;
            final attempt = (event['attempt'] as int?) ?? 0;
            final maxAttempts = (event['maxAttempts'] as int?) ?? 0;
            final reason =
                (event['reason'] as String?) ?? 'Remote session failed';

            switch (state) {
              case 'DISCONNECTED':
                return const Right(RemoteSessionDisconnected());
              case 'CONNECTING':
                return Right(RemoteSessionConnecting(ip));
              case 'CONNECTED':
                return Right(RemoteSessionConnected(ip, name));
              case 'RECONNECTING':
                return Right(
                  RemoteSessionReconnecting(ip, attempt, maxAttempts),
                );
              case 'FAILED':
                return Right(RemoteSessionFailed(ip, reason));
              default:
                return Left(
                  UnknownFailure('Unknown remote connection state: $state'),
                );
            }
          } catch (e) {
            return Left(UnknownFailure(e.toString()));
          }
        })
        .handleError((e) {
          return Left(UnknownFailure(e.toString()));
        });
  }

  @override
  Stream<Either<Failure, bool>> get connectionAlive =>
      connectionState.map((either) {
        return either.map((status) => status is RemoteSessionConnected);
      });

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
