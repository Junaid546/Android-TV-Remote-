import 'package:atv_remote/core/errors/failures.dart';
import 'package:atv_remote/data/datasources/local/hive_settings_datasource.dart';
import 'package:atv_remote/domain/repositories/settings_repository.dart';
import 'package:fpdart/fpdart.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final HiveSettingsDatasource _datasource;

  SettingsRepositoryImpl(this._datasource);

  @override
  Future<Either<Failure, bool>> isHapticEnabled() async {
    try {
      return Right(_datasource.hapticEnabled);
    } catch (e) {
      return Left(StorageFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setHapticEnabled(bool enabled) async {
    try {
      await _datasource.setHapticEnabled(enabled);
      return const Right(null);
    } catch (e) {
      return Left(StorageFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getThemeMode() async {
    try {
      return Right(_datasource.themeMode);
    } catch (e) {
      return Left(StorageFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> setThemeMode(String mode) async {
    try {
      await _datasource.setThemeMode(mode);
      return const Right(null);
    } catch (e) {
      return Left(StorageFailure(e.toString()));
    }
  }
}
