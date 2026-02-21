import 'package:atv_remote/core/errors/failures.dart';
import 'package:atv_remote/data/datasources/native/pairing_native_datasource.dart';
import 'package:atv_remote/domain/entities/pairing_status.dart';
import 'package:atv_remote/domain/entities/tv_device.dart';
import 'package:atv_remote/domain/repositories/pairing_repository.dart';
import 'package:fpdart/fpdart.dart';

class PairingRepositoryImpl implements PairingRepository {
  final PairingNativeDatasource _nativeDatasource;
  TvDevice? _currentDevice;

  PairingRepositoryImpl(this._nativeDatasource);

  @override
  Stream<Either<Failure, PairingStatus>> get statusStream {
    return _nativeDatasource.pairingStatusStream.map((event) {
      try {
        final type = event['type'] as String;
        final device = _currentDevice;

        switch (type) {
          case 'idle':
            return const Right(PairingStatus.idle());
          case 'connecting':
            if (device == null) return const Right(PairingStatus.idle());
            return Right(PairingStatus.connecting(device));
          case 'awaitingPin':
            if (device == null) return const Right(PairingStatus.idle());
            return Right(
              PairingStatus.awaitingPin(device, event['expires'] as int? ?? 60),
            );
          case 'paired':
            if (device == null) return const Right(PairingStatus.idle());
            return Right(PairingStatus.paired(device));
          case 'connected':
            if (device == null) return const Right(PairingStatus.idle());
            return Right(PairingStatus.connected(device));
          case 'error':
            return Left(
              PairingFailure(
                event['message'] as String? ?? 'Unknown pairing error',
              ),
            );
          default:
            return const Right(PairingStatus.idle());
        }
      } catch (e) {
        return Left(PairingFailure(e.toString()));
      }
    });
  }

  @override
  Future<Either<Failure, void>> connectToDevice(TvDevice device) async {
    try {
      _currentDevice = device;
      await _nativeDatasource.startPairing(device.ipAddress, device.port);
      return const Right(null);
    } catch (e) {
      return Left(PairingFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> submitPin(String pin) async {
    try {
      await _nativeDatasource.submitPin(pin);
      return const Right(null);
    } catch (e) {
      return Left(PairingFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> disconnect() async {
    try {
      await _nativeDatasource.disconnect();
      _currentDevice = null;
      return const Right(null);
    } catch (e) {
      return Left(PairingFailure(e.toString()));
    }
  }
}
