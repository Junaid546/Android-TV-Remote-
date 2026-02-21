// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tv_device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TvDeviceImpl _$$TvDeviceImplFromJson(Map<String, dynamic> json) =>
    _$TvDeviceImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      ipAddress: json['ipAddress'] as String,
      port: (json['port'] as num?)?.toInt() ?? AppConstants.kRemotePort,
      isPaired: json['isPaired'] as bool? ?? false,
      lastConnected: json['lastConnected'] == null
          ? null
          : DateTime.parse(json['lastConnected'] as String),
      certificateFingerprint: json['certificateFingerprint'] as String?,
      signalStrength: (json['signalStrength'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$TvDeviceImplToJson(_$TvDeviceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'ipAddress': instance.ipAddress,
      'port': instance.port,
      'isPaired': instance.isPaired,
      'lastConnected': instance.lastConnected?.toIso8601String(),
      'certificateFingerprint': instance.certificateFingerprint,
      'signalStrength': instance.signalStrength,
    };
