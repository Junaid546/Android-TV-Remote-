import 'package:atv_remote/domain/entities/tv_device.dart';
import 'package:hive/hive.dart';

part 'saved_device_model.g.dart';

@HiveType(typeId: 1)
class SavedDeviceModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String ipAddress;

  @HiveField(3)
  final int port;

  @HiveField(4)
  final bool isPaired;

  @HiveField(5)
  final DateTime lastConnected;

  @HiveField(6)
  final String? certificateFingerprint;

  SavedDeviceModel({
    required this.id,
    required this.name,
    required this.ipAddress,
    required this.port,
    required this.isPaired,
    required this.lastConnected,
    this.certificateFingerprint,
  });

  factory SavedDeviceModel.fromEntity(TvDevice entity) {
    return SavedDeviceModel(
      id: entity.id,
      name: entity.name,
      ipAddress: entity.ipAddress,
      port: entity.port,
      isPaired: entity.isPaired,
      lastConnected: entity.lastConnected ?? DateTime.now(),
      certificateFingerprint: entity.certificateFingerprint,
    );
  }

  TvDevice toEntity() {
    return TvDevice(
      id: id,
      name: name,
      ipAddress: ipAddress,
      port: port,
      isPaired: isPaired,
      lastConnected: lastConnected,
      certificateFingerprint: certificateFingerprint,
    );
  }
}
