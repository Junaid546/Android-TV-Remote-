import 'package:atv_remote/data/models/settings_model.dart';
import 'package:atv_remote/presentation/providers/repository_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_provider.g.dart';

@Riverpod(keepAlive: true)
class SettingsNotifier extends _$SettingsNotifier {
  @override
  SettingsModel build() {
    return ref.read(hiveSettingsDatasourceProvider).getSettings();
  }

  Future<void> toggleHaptic() async {
    final current = state.hapticEnabled;
    state = state.copyWith(hapticEnabled: !current);
    await ref.read(hiveSettingsDatasourceProvider).saveSettings(state);
  }

  Future<void> toggleTheme() async {
    final newMode = state.themeMode == 'dark' ? 'light' : 'dark';
    state = state.copyWith(themeMode: newMode);
    await ref.read(hiveSettingsDatasourceProvider).saveSettings(state);
  }

  bool get hapticEnabled => state.hapticEnabled;
}
