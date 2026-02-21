import 'package:atv_remote/core/errors/failures.dart';
import 'package:atv_remote/domain/repositories/settings_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetThemeModeUseCase {
  final SettingsRepository _repository;
  const GetThemeModeUseCase(this._repository);

  Future<Either<Failure, String>> call() => _repository.getThemeMode();
}

class SetThemeModeUseCase {
  final SettingsRepository _repository;
  const SetThemeModeUseCase(this._repository);

  Future<Either<Failure, void>> call(String mode) =>
      _repository.setThemeMode(mode);
}

class IsHapticEnabledUseCase {
  final SettingsRepository _repository;
  const IsHapticEnabledUseCase(this._repository);

  Future<Either<Failure, bool>> call() => _repository.isHapticEnabled();
}

class SetHapticEnabledUseCase {
  final SettingsRepository _repository;
  const SetHapticEnabledUseCase(this._repository);

  Future<Either<Failure, void>> call(bool enabled) =>
      _repository.setHapticEnabled(enabled);
}
