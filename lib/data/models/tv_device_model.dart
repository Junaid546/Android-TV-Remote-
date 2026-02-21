import 'package:atv_remote/domain/entities/tv_device.dart';
import 'package:hive/hive.dart';

part 'tv_device_model.g.dart';

@HiveType(typeId: 0)
class TvDeviceModel extends HiveObject {
  TvDeviceModel();

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
  String? lastConnectedIso;

  @HiveField(6)
  String? certificateFingerprint;

  @HiveField(7)
  late int signalStrength;

  TvDevice toEntity() {
    return TvDevice(
      id: id,
      name: name,
      ipAddress: ipAddress,
      port: port,
      isPaired: isPaired,
      lastConnected: lastConnectedIso != null
          ? DateTime.parse(lastConnectedIso!)
          : null,
      certificateFingerprint: certificateFingerprint,
      signalStrength: signalStrength,
    );
  }

  static TvDeviceModel fromEntity(TvDevice entity) {
    return TvDeviceModel()
      ..id = entity.id
      ..name = entity.name
      ..ipAddress = entity.ipAddress
      ..port = entity.port
      ..isPaired = entity.isPaired
      ..lastConnectedIso = entity.lastConnected?.toIso8601String()
      ..certificateFingerprint = entity.certificateFingerprint
      ..signalStrength = entity.signalStrength;
  }

  factory TvDeviceModel.fromMap(Map<String, dynamic> map) {
    final ip = map['ip'] as String? ?? map['ipAddress'] as String;
    final name = map['name'] as String;
    final id = map['id'] as String? ?? '$ip:$name';

    return TvDeviceModel()
      ..id = id
      ..name = name
      ..ipAddress = ip
      ..port = (map['port'] as num?)?.toInt() ?? 6466
      ..isPaired = map['isPaired'] as bool? ?? false
      ..lastConnectedIso = map['lastConnectedIso'] as String?
      ..certificateFingerprint = map['certificateFingerprint'] as String?
      ..signalStrength = (map['signalStrength'] as num?)?.toInt() ?? 0;
  }
}
