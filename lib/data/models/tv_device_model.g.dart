// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tv_device_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TvDeviceModelAdapter extends TypeAdapter<TvDeviceModel> {
  @override
  final int typeId = 0;

  @override
  TvDeviceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TvDeviceModel()
      ..id = fields[0] as String
      ..name = fields[1] as String
      ..ipAddress = fields[2] as String
      ..port = fields[3] as int
      ..isPaired = fields[4] as bool
      ..lastConnected = fields[5] as DateTime?
      ..certificateFingerprint = fields[6] as String?
      ..signalStrength = fields[7] as int;
  }

  @override
  void write(BinaryWriter writer, TvDeviceModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.ipAddress)
      ..writeByte(3)
      ..write(obj.port)
      ..writeByte(4)
      ..write(obj.isPaired)
      ..writeByte(5)
      ..write(obj.lastConnected)
      ..writeByte(6)
      ..write(obj.certificateFingerprint)
      ..writeByte(7)
      ..write(obj.signalStrength);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TvDeviceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
