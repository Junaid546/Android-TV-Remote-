import 'dart:async';

import 'package:atv_remote/data/models/settings_model.dart';
import 'package:atv_remote/presentation/providers/repository_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_provider.g.dart';

@Riverpod(keepAlive: true)
class SettingsNotifier extends _$SettingsNotifier {
  @override
  SettingsModel build() {
    final settings = ref.read(hiveSettingsDatasourceProvider).getSettings();
    unawaited(_syncAutoReconnect(settings.autoReconnectEnabled));
    return settings;
  }

  Future<void> toggleHaptic() async {
    final current = state.hapticEnabled;
    state = state.copyWith(hapticEnabled: !current);
    await ref.read(hiveSettingsDatasourceProvider).saveSettings(state);
  }

  Future<void> setHaptic(bool enabled) async {
    state = state.copyWith(hapticEnabled: enabled);
    await ref.read(hiveSettingsDatasourceProvider).saveSettings(state);
  }

  Future<void> toggleTheme() async {
    final newMode = state.themeMode == 'dark' ? 'light' : 'dark';
    state = state.copyWith(themeMode: newMode);
    await ref.read(hiveSettingsDatasourceProvider).saveSettings(state);
  }

  Future<void> setThemeMode(String mode) async {
    if (mode != 'dark' && mode != 'light') return;
    state = state.copyWith(themeMode: mode);
    await ref.read(hiveSettingsDatasourceProvider).saveSettings(state);
  }

  Future<void> setAutoReconnect(bool value) async {
    state = state.copyWith(autoReconnectEnabled: value);
    await ref.read(hiveSettingsDatasourceProvider).saveSettings(state);
    await _syncAutoReconnect(value);
  }

  Future<void> saveAdbConfig({
    required String host,
    required int connectPort,
    required int pairPort,
  }) async {
    state = state.copyWith(
      adbHost: host,
      adbConnectPort: connectPort,
      adbPairPort: pairPort,
    );
    await ref.read(hiveSettingsDatasourceProvider).saveSettings(state);
  }

  Future<void> clearAdbConfig() async {
    state = state.copyWith(adbHost: null, adbConnectPort: 5555, adbPairPort: 0);
    await ref.read(hiveSettingsDatasourceProvider).saveSettings(state);
  }

  Future<void> setAppPackageOverride(String appId, String packageName) async {
    final updated = Map<String, String>.from(state.appPackageOverrides);
    final normalized = packageName.trim();
    if (normalized.isEmpty) {
      updated.remove(appId);
    } else {
      updated[appId] = normalized;
    }
    state = state.copyWith(appPackageOverrides: updated);
    await ref.read(hiveSettingsDatasourceProvider).saveSettings(state);
  }

  bool get hapticEnabled => state.hapticEnabled;

  Future<void> _syncAutoReconnect(bool value) async {
    try {
      await ref.read(remoteNativeDataSourceProvider).setAutoReconnect(value);
    } catch (_) {
      // Keep settings persisted even when the native channel is unavailable.
    }
  }
}
