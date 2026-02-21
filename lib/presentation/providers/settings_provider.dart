import 'package:atv_remote/presentation/providers/use_case_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_provider.g.dart';

class SettingsState {
  final bool hapticEnabled;
  final String themeMode;

  SettingsState({required this.hapticEnabled, required this.themeMode});

  SettingsState copyWith({bool? hapticEnabled, String? themeMode}) {
    return SettingsState(
      hapticEnabled: hapticEnabled ?? this.hapticEnabled,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}

@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  @override
  Future<SettingsState> build() async {
    final haptic = await ref.watch(isHapticEnabledUseCaseProvider).call();
    final theme = await ref.watch(getThemeModeUseCaseProvider).call();

    return SettingsState(
      hapticEnabled: haptic.getOrElse((l) => true),
      themeMode: theme.getOrElse((l) => 'dark'),
    );
  }

  Future<void> toggleHaptic(bool value) async {
    await ref.read(setHapticEnabledUseCaseProvider).call(value);
    state = AsyncData(state.value!.copyWith(hapticEnabled: value));
  }

  Future<void> setThemeMode(String mode) async {
    await ref.read(setThemeModeUseCaseProvider).call(mode);
    state = AsyncData(state.value!.copyWith(themeMode: mode));
  }
}
