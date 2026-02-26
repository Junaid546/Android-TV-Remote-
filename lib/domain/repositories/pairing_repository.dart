import 'package:fpdart/fpdart.dart';
import 'package:atv_remote/core/errors/failures.dart';
import 'package:atv_remote/domain/entities/pairing_status.dart';
import 'package:atv_remote/domain/entities/tv_device.dart';

abstract interface class PairingRepository {
  Stream<Either<Failure, PairingStatus>> get statusStream;
  Future<Either<Failure, void>> connectToDevice(TvDevice device);
  Future<Either<Failure, void>> submitPin(String pin);
  Future<Either<Failure, void>> forgetDevice(String ipAddress);
  Future<Either<Failure, bool>> isDevicePaired(String ipAddress);
  Future<Either<Failure, void>> disconnect();
}
