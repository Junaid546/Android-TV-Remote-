// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_device_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SavedDeviceModelAdapter extends TypeAdapter<SavedDeviceModel> {
  @override
  final int typeId = 1;

  @override
  SavedDeviceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavedDeviceModel(
      id: fields[0] as String,
      name: fields[1] as String,
      ipAddress: fields[2] as String,
      port: fields[3] as int,
      isPaired: fields[4] as bool,
      lastConnected: fields[5] as DateTime,
      certificateFingerprint: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SavedDeviceModel obj) {
    writer
      ..writeByte(7)
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
      ..write(obj.certificateFingerprint);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedDeviceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
