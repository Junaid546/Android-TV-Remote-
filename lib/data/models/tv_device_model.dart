import 'package:hive/hive.dart';
import 'package:atv_remote/domain/entities/tv_device.dart';

part 'tv_device_model.g.dart';

@HiveType(typeId: 0)
class TvDeviceModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String ipAddress;

  @HiveField(3)
  late int port;

  @HiveField(4)
  late bool isPaired;

  @HiveField(5)
  DateTime? lastConnected;

  @HiveField(6)
  String? certificateFingerprint;

  @HiveField(7)
  late int signalStrength;

  TvDevice toEntity() => TvDevice(
    id: id,
    name: name,
    ipAddress: ipAddress,
    port: port,
    isPaired: isPaired,
    lastConnected: lastConnected,
    certificateFingerprint: certificateFingerprint,
    signalStrength: signalStrength,
  );

  static TvDeviceModel fromEntity(TvDevice entity) => TvDeviceModel()
    ..id = entity.id
    ..name = entity.name
    ..ipAddress = entity.ipAddress
    ..port = entity.port
    ..isPaired = entity.isPaired
    ..lastConnected = entity.lastConnected
    ..certificateFingerprint = entity.certificateFingerprint
    ..signalStrength = entity.signalStrength;
}
