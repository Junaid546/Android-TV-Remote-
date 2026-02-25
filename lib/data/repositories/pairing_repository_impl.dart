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
  PairingStatus _lastStatus = const PairingStatus.idle();

  PairingRepositoryImpl(this._nativeDataSource);

  @override
  Stream<Either<Failure, PairingStatus>> get statusStream {
    return _nativeDataSource.pairingEventStream.map((event) {
      try {
        final type = event['type'] as String?;
        final device = _currentDevice;

        if (type == 'PIN_EXPIRY') {
          if (device == null) return const Right(PairingStatus.idle());
          final seconds = event['seconds'] as int? ?? 60;
          final status = PairingStatus.awaitingPin(device, seconds);
          _lastStatus = status;
          return Right(status);
        }

        final state = event['state'] as String?;
        PairingStatus? mappedStatus;

        switch (state) {
          case 'IDLE':
            mappedStatus = const PairingStatus.idle();
            break;
          case 'CONNECTING':
            if (device != null) {
              mappedStatus = PairingStatus.connecting(device);
            }
            break;
          case 'AWAITING_PIN':
            if (device != null) {
              mappedStatus = PairingStatus.awaitingPin(
                device,
                event['expiresInSeconds'] as int? ?? 60,
              );
            }
            break;
          case 'VERIFYING':
            if (device != null) {
              mappedStatus = PairingStatus.pinVerified(device);
            }
            break;
          case 'SUCCESS':
            if (device != null) {
              final normalized = _normalizeRemoteDevice(device);
              _currentDevice = normalized;
              mappedStatus = PairingStatus.paired(normalized);
            }
            break;
          case 'FAILED':
            final errorCode = event['errorCode'] as String?;
            final errorMessage =
                event['errorMessage'] as String? ?? 'Pairing failed';

            final failure = _mapErrorCode(errorCode, errorMessage);
            if (device != null) {
              mappedStatus = PairingStatus.connectionFailed(device, failure);
              break;
            }
            return Left(failure);
          default:
            break;
        }

        if (mappedStatus != null) {
          _lastStatus = mappedStatus;
          return Right(mappedStatus);
        }

        return Right(_lastStatus);
      } catch (e) {
        return Left(PairingFailure(e.toString()));
      }
    });
  }

  @override
  Future<Either<Failure, void>> connectToDevice(TvDevice device) async {
    try {
      _currentDevice = device.copyWith(port: AppConstants.kPairingPort);
      _lastStatus = PairingStatus.connecting(_currentDevice!);
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
      _lastStatus = const PairingStatus.idle();
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
      case 'BAD_CONFIGURATION':
        return const PairingFailure(
          'The TV rejected pairing configuration. Try reconnecting and pairing again.',
        );
      case 'PROTOCOL_TIMEOUT':
        return const PairingFailure(
          'Pairing timed out while waiting for TV response.',
        );
      case 'PROTOCOL_ERROR':
        return const PairingFailure(
          'Pairing protocol error. Please retry pairing.',
        );
      case 'INVALID_PIN_FORMAT':
        return const PairingFailure(
          'PIN must be 6 hexadecimal characters (0-9, A-F).',
        );
      default:
        return PairingFailure(message);
    }
  }

  TvDevice _normalizeRemoteDevice(TvDevice device) {
    return device.copyWith(port: AppConstants.kRemotePort, isPaired: true);
  }
}
