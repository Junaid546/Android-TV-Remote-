import 'package:hive/hive.dart';

part 'settings_model.g.dart';

@HiveType(typeId: 1)
class SettingsModel extends HiveObject {
  @HiveField(0)
  bool hapticEnabled = true;

  @HiveField(1)
  String themeMode = 'dark';

  @HiveField(2)
  String appVersion = '';

  @HiveField(3)
  bool autoReconnectEnabled = true;

  @HiveField(4)
  String? adbHost;

  @HiveField(5)
  int adbConnectPort = 5555;

  @HiveField(6)
  int adbPairPort = 0;

  @HiveField(7)
  Map<String, String> appPackageOverrides = {};

  SettingsModel({
    this.hapticEnabled = true,
    this.themeMode = 'dark',
    this.appVersion = '',
    this.autoReconnectEnabled = true,
    this.adbHost,
    this.adbConnectPort = 5555,
    this.adbPairPort = 0,
    Map<String, String>? appPackageOverrides,
  }) : appPackageOverrides = appPackageOverrides ?? {};

  SettingsModel copyWith({
    bool? hapticEnabled,
    String? themeMode,
    String? appVersion,
    bool? autoReconnectEnabled,
    String? adbHost,
    int? adbConnectPort,
    int? adbPairPort,
    Map<String, String>? appPackageOverrides,
  }) {
    return SettingsModel(
      hapticEnabled: hapticEnabled ?? this.hapticEnabled,
      themeMode: themeMode ?? this.themeMode,
      appVersion: appVersion ?? this.appVersion,
      autoReconnectEnabled: autoReconnectEnabled ?? this.autoReconnectEnabled,
      adbHost: adbHost ?? this.adbHost,
      adbConnectPort: adbConnectPort ?? this.adbConnectPort,
      adbPairPort: adbPairPort ?? this.adbPairPort,
      appPackageOverrides: appPackageOverrides ?? this.appPackageOverrides,
    );
  }
}
