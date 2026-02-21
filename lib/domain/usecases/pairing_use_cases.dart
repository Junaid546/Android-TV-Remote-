import 'package:atv_remote/core/errors/failures.dart';
import 'package:atv_remote/domain/entities/pairing_status.dart';
import 'package:atv_remote/domain/entities/tv_device.dart';
import 'package:atv_remote/domain/repositories/pairing_repository.dart';
import 'package:fpdart/fpdart.dart';

class PairingUseCases {
  final PairingRepository _repository;

  PairingUseCases(this._repository);

  Stream<Either<Failure, PairingStatus>> get statusStream =>
      _repository.statusStream;

  Future<Either<Failure, void>> connectToDevice(TvDevice device) =>
      _repository.connectToDevice(device);

  Future<Either<Failure, void>> submitPin(String pin) =>
      _repository.submitPin(pin);

  Future<Either<Failure, void>> disconnect() => _repository.disconnect();
}
