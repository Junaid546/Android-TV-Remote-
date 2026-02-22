import 'package:atv_remote/core/constants/app_constants.dart';
import 'package:atv_remote/core/errors/failures.dart';
import 'package:atv_remote/data/datasources/native/pairing_native_datasource.dart';
import 'package:atv_remote/domain/entities/pairing_status.dart';
import 'package:atv_remote/domain/entities/tv_device.dart';
import 'package:atv_remote/domain/repositories/pairing_repository.dart';
import 'package:fpdart/fpdart.dart';

class PairingRepositoryImpl implements PairingRepository {
  final PairingNativeDataSource _nativeDataSource;
  TvDevice? _currentDevice;

  PairingRepositoryImpl(this._nativeDataSource);

  @override
  Stream<Either<Failure, PairingStatus>> get statusStream {
    return _nativeDataSource.pairingEventStream.map((event) {
      try {
        final type = event['type'] as String?;

        // Handle PIN_EXPIRY events (no 'state' key)
        if (type == 'PIN_EXPIRY') {
          final device = _currentDevice;
          if (device == null) return const Right(PairingStatus.idle());
          final seconds = event['seconds'] as int? ?? 60;
          return Right(PairingStatus.awaitingPin(device, seconds));
        }

        final state = event['state'] as String;
        final device = _currentDevice;

        switch (state) {
          case 'IDLE':
            return const Right(PairingStatus.idle());
          case 'CONNECTING':
            if (device == null) return const Right(PairingStatus.idle());
            return Right(PairingStatus.connecting(device));
          case 'AWAITING_PIN':
            if (device == null) return const Right(PairingStatus.idle());
            return Right(
              PairingStatus.awaitingPin(
                device,
                event['expiresInSeconds'] as int? ?? 60,
              ),
            );
          case 'SUCCESS':
            if (device == null) return const Right(PairingStatus.idle());
            return Right(PairingStatus.connected(device));
          case 'FAILED':
            final errorCode = event['errorCode'] as String?;
            final errorMessage =
                event['errorMessage'] as String? ?? 'Pairing failed';

            final failure = _mapErrorCode(errorCode, errorMessage);
            if (device != null) {
              return Right(PairingStatus.connectionFailed(device, failure));
            }
            return Left(failure);
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
      _currentDevice = device.copyWith(port: AppConstants.kPairingPort);
      await _nativeDataSource.startPairing(
        device.ipAddress,
        AppConstants.kPairingPort,
        device.name,
      );
      return const Right(null);
    } catch (e) {
      return Left(PairingFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> submitPin(String pin) async {
    try {
      await _nativeDataSource.submitPin(pin);
      return const Right(null);
    } catch (e) {
      return Left(PairingFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> disconnect() async {
    try {
      await _nativeDataSource.disconnect();
      _currentDevice = null;
      return const Right(null);
    } catch (e) {
      return Left(PairingFailure(e.toString()));
    }
  }

  Failure _mapErrorCode(String? code, String message) {
    if (code == null) return PairingFailure(message);

    switch (code) {
      case 'UNREACHABLE':
        return DeviceUnreachableFailure(
          _currentDevice?.ipAddress ?? '',
          _currentDevice?.port ?? 6466,
        );
      case 'WRONG_PIN':
        return const WrongPinFailure(
          0,
        ); // Native doesn't seem to pass attempts left yet
      case 'PIN_EXPIRED':
        return const PinExpiredFailure();
      default:
        return PairingFailure(message);
    }
  }
}
