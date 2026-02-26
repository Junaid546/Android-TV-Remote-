// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsModelAdapter extends TypeAdapter<SettingsModel> {
  @override
  final int typeId = 1;

  @override
  SettingsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SettingsModel(
      hapticEnabled: fields[0] as bool? ?? true,
      themeMode: fields[1] as String? ?? 'dark',
      appVersion: fields[2] as String? ?? '',
      autoReconnectEnabled: fields[3] as bool? ?? true,
      adbHost: fields[4] as String?,
      adbConnectPort: fields[5] as int? ?? 5555,
      adbPairPort: fields[6] as int? ?? 0,
      appPackageOverrides:
          (fields[7] as Map?)?.map(
            (key, value) => MapEntry('$key', '$value'),
          ) ??
          <String, String>{},
    );
  }

  @override
  void write(BinaryWriter writer, SettingsModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.hapticEnabled)
      ..writeByte(1)
      ..write(obj.themeMode)
      ..writeByte(2)
      ..write(obj.appVersion)
      ..writeByte(3)
      ..write(obj.autoReconnectEnabled)
      ..writeByte(4)
      ..write(obj.adbHost)
      ..writeByte(5)
      ..write(obj.adbConnectPort)
      ..writeByte(6)
      ..write(obj.adbPairPort)
      ..writeByte(7)
      ..write(obj.appPackageOverrides);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
