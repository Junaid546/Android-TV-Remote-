import 'package:atv_remote/data/models/settings_model.dart';
import 'package:hive/hive.dart';

class HiveSettingsDatasource {
  static const _boxName = 'settings';
  static const _settingsKey = 'app_settings';

  Box<SettingsModel> get _box => Hive.box<SettingsModel>(_boxName);

  SettingsModel getSettings() {
    final settings = _box.get(_settingsKey);
    if (settings == null) {
      final defaultSettings = SettingsModel();
      _box.put(_settingsKey, defaultSettings);
      return defaultSettings;
    }
    return settings;
  }

  Future<void> saveSettings(SettingsModel model) async {
    await _box.put(_settingsKey, model);
  }

  bool get hapticEnabled => getSettings().hapticEnabled;

  Future<void> setHapticEnabled(bool value) async {
    final settings = getSettings();
    settings.hapticEnabled = value;
    await settings.save();
  }

  String get themeMode => getSettings().themeMode;

  Future<void> setThemeMode(String mode) async {
    final settings = getSettings();
    settings.themeMode = mode;
    await settings.save();
  }
}
