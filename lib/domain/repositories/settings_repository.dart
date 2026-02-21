import 'package:atv_remote/core/errors/failures.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class SettingsRepository {
  Future<Either<Failure, bool>> isHapticEnabled();
  Future<Either<Failure, void>> setHapticEnabled(bool enabled);
  Future<Either<Failure, String>> getThemeMode();
  Future<Either<Failure, void>> setThemeMode(String mode);
}
