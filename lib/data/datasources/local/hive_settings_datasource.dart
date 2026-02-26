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

  bool get autoReconnectEnabled => getSettings().autoReconnectEnabled;

  Future<void> setAutoReconnectEnabled(bool value) async {
    final settings = getSettings();
    settings.autoReconnectEnabled = value;
    await settings.save();
  }

  String? get adbHost => getSettings().adbHost;

  int get adbConnectPort => getSettings().adbConnectPort;

  int get adbPairPort => getSettings().adbPairPort;

  Future<void> setAdbConfig({
    required String host,
    required int connectPort,
    required int pairPort,
  }) async {
    final settings = getSettings();
    settings.adbHost = host;
    settings.adbConnectPort = connectPort;
    settings.adbPairPort = pairPort;
    await settings.save();
  }

  Future<void> clearAdbConfig() async {
    final settings = getSettings();
    settings.adbHost = null;
    settings.adbConnectPort = 5555;
    settings.adbPairPort = 0;
    await settings.save();
  }

  Map<String, String> get appPackageOverrides {
    return Map<String, String>.from(getSettings().appPackageOverrides);
  }

  String? getAppPackageOverride(String appId) {
    return getSettings().appPackageOverrides[appId];
  }

  Future<void> setAppPackageOverride(String appId, String packageName) async {
    final settings = getSettings();
    final overrides = Map<String, String>.from(settings.appPackageOverrides);
    final normalizedPackage = packageName.trim();
    if (normalizedPackage.isEmpty) {
      overrides.remove(appId);
    } else {
      overrides[appId] = normalizedPackage;
    }
    settings.appPackageOverrides = overrides;
    await settings.save();
  }
}
