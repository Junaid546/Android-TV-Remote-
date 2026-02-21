// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tv_device.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

TvDevice _$TvDeviceFromJson(Map<String, dynamic> json) {
  return _TvDevice.fromJson(json);
}

/// @nodoc
mixin _$TvDevice {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get ipAddress => throw _privateConstructorUsedError;
  int get port => throw _privateConstructorUsedError;
  bool get isPaired => throw _privateConstructorUsedError;
  DateTime? get lastConnected => throw _privateConstructorUsedError;
  String? get certificateFingerprint => throw _privateConstructorUsedError;
  int get signalStrength => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TvDeviceCopyWith<TvDevice> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TvDeviceCopyWith<$Res> {
  factory $TvDeviceCopyWith(TvDevice value, $Res Function(TvDevice) then) =
      _$TvDeviceCopyWithImpl<$Res, TvDevice>;
  @useResult
  $Res call(
      {String id,
      String name,
      String ipAddress,
      int port,
      bool isPaired,
      DateTime? lastConnected,
      String? certificateFingerprint,
      int signalStrength});
}

/// @nodoc
class _$TvDeviceCopyWithImpl<$Res, $Val extends TvDevice>
    implements $TvDeviceCopyWith<$Res> {
  _$TvDeviceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? ipAddress = null,
    Object? port = null,
    Object? isPaired = null,
    Object? lastConnected = freezed,
    Object? certificateFingerprint = freezed,
    Object? signalStrength = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      ipAddress: null == ipAddress
          ? _value.ipAddress
          : ipAddress // ignore: cast_nullable_to_non_nullable
              as String,
      port: null == port
          ? _value.port
          : port // ignore: cast_nullable_to_non_nullable
              as int,
      isPaired: null == isPaired
          ? _value.isPaired
          : isPaired // ignore: cast_nullable_to_non_nullable
              as bool,
      lastConnected: freezed == lastConnected
          ? _value.lastConnected
          : lastConnected // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      certificateFingerprint: freezed == certificateFingerprint
          ? _value.certificateFingerprint
          : certificateFingerprint // ignore: cast_nullable_to_non_nullable
              as String?,
      signalStrength: null == signalStrength
          ? _value.signalStrength
          : signalStrength // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_TvDeviceCopyWith<$Res> implements $TvDeviceCopyWith<$Res> {
  factory _$$_TvDeviceCopyWith(
          _$_TvDevice value, $Res Function(_$_TvDevice) then) =
      __$$_TvDeviceCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String ipAddress,
      int port,
      bool isPaired,
      DateTime? lastConnected,
      String? certificateFingerprint,
      int signalStrength});
}

/// @nodoc
class __$$_TvDeviceCopyWithImpl<$Res>
    extends _$TvDeviceCopyWithImpl<$Res, _$_TvDevice>
    implements _$$_TvDeviceCopyWith<$Res> {
  __$$_TvDeviceCopyWithImpl(
      _$_TvDevice _value, $Res Function(_$_TvDevice) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? ipAddress = null,
    Object? port = null,
    Object? isPaired = null,
    Object? lastConnected = freezed,
    Object? certificateFingerprint = freezed,
    Object? signalStrength = null,
  }) {
    return _then(_$_TvDevice(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      ipAddress: null == ipAddress
          ? _value.ipAddress
          : ipAddress // ignore: cast_nullable_to_non_nullable
              as String,
      port: null == port
          ? _value.port
          : port // ignore: cast_nullable_to_non_nullable
              as int,
      isPaired: null == isPaired
          ? _value.isPaired
          : isPaired // ignore: cast_nullable_to_non_nullable
              as bool,
      lastConnected: freezed == lastConnected
          ? _value.lastConnected
          : lastConnected // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      certificateFingerprint: freezed == certificateFingerprint
          ? _value.certificateFingerprint
          : certificateFingerprint // ignore: cast_nullable_to_non_nullable
              as String?,
      signalStrength: null == signalStrength
          ? _value.signalStrength
          : signalStrength // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_TvDevice implements _TvDevice {
  const _$_TvDevice(
      {required this.id,
      required this.name,
      required this.ipAddress,
      this.port = AppConstants.kRemotePort,
      this.isPaired = false,
      this.lastConnected,
      this.certificateFingerprint,
      this.signalStrength = 0});

  factory _$_TvDevice.fromJson(Map<String, dynamic> json) =>
      _$$_TvDeviceFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String ipAddress;
  @override
  @JsonKey()
  final int port;
  @override
  @JsonKey()
  final bool isPaired;
  @override
  final DateTime? lastConnected;
  @override
  final String? certificateFingerprint;
  @override
  @JsonKey()
  final int signalStrength;

  @override
  String toString() {
    return 'TvDevice(id: $id, name: $name, ipAddress: $ipAddress, port: $port, isPaired: $isPaired, lastConnected: $lastConnected, certificateFingerprint: $certificateFingerprint, signalStrength: $signalStrength)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_TvDevice &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.ipAddress, ipAddress) ||
                other.ipAddress == ipAddress) &&
            (identical(other.port, port) || other.port == port) &&
            (identical(other.isPaired, isPaired) ||
                other.isPaired == isPaired) &&
            (identical(other.lastConnected, lastConnected) ||
                other.lastConnected == lastConnected) &&
            (identical(other.certificateFingerprint, certificateFingerprint) ||
                other.certificateFingerprint == certificateFingerprint) &&
            (identical(other.signalStrength, signalStrength) ||
                other.signalStrength == signalStrength));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, ipAddress, port,
      isPaired, lastConnected, certificateFingerprint, signalStrength);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_TvDeviceCopyWith<_$_TvDevice> get copyWith =>
      __$$_TvDeviceCopyWithImpl<_$_TvDevice>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_TvDeviceToJson(
      this,
    );
  }
}

abstract class _TvDevice implements TvDevice {
  const factory _TvDevice(
      {required final String id,
      required final String name,
      required final String ipAddress,
      final int port,
      final bool isPaired,
      final DateTime? lastConnected,
      final String? certificateFingerprint,
      final int signalStrength}) = _$_TvDevice;

  factory _TvDevice.fromJson(Map<String, dynamic> json) = _$_TvDevice.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get ipAddress;
  @override
  int get port;
  @override
  bool get isPaired;
  @override
  DateTime? get lastConnected;
  @override
  String? get certificateFingerprint;
  @override
  int get signalStrength;
  @override
  @JsonKey(ignore: true)
  _$$_TvDeviceCopyWith<_$_TvDevice> get copyWith =>
      throw _privateConstructorUsedError;
}
