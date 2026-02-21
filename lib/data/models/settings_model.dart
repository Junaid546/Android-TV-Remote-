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

  SettingsModel({
    this.hapticEnabled = true,
    this.themeMode = 'dark',
    this.appVersion = '',
  });
}
