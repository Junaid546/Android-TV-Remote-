// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'remote_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$RemoteState {
  TvDevice? get device => throw _privateConstructorUsedError;
  bool get isConnected => throw _privateConstructorUsedError;
  bool get isMuted => throw _privateConstructorUsedError;
  double get volume => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RemoteStateCopyWith<RemoteState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RemoteStateCopyWith<$Res> {
  factory $RemoteStateCopyWith(
          RemoteState value, $Res Function(RemoteState) then) =
      _$RemoteStateCopyWithImpl<$Res, RemoteState>;
  @useResult
  $Res call({TvDevice? device, bool isConnected, bool isMuted, double volume});

  $TvDeviceCopyWith<$Res>? get device;
}

/// @nodoc
class _$RemoteStateCopyWithImpl<$Res, $Val extends RemoteState>
    implements $RemoteStateCopyWith<$Res> {
  _$RemoteStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? device = freezed,
    Object? isConnected = null,
    Object? isMuted = null,
    Object? volume = null,
  }) {
    return _then(_value.copyWith(
      device: freezed == device
          ? _value.device
          : device // ignore: cast_nullable_to_non_nullable
              as TvDevice?,
      isConnected: null == isConnected
          ? _value.isConnected
          : isConnected // ignore: cast_nullable_to_non_nullable
              as bool,
      isMuted: null == isMuted
          ? _value.isMuted
          : isMuted // ignore: cast_nullable_to_non_nullable
              as bool,
      volume: null == volume
          ? _value.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $TvDeviceCopyWith<$Res>? get device {
    if (_value.device == null) {
      return null;
    }

    return $TvDeviceCopyWith<$Res>(_value.device!, (value) {
      return _then(_value.copyWith(device: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_RemoteStateCopyWith<$Res>
    implements $RemoteStateCopyWith<$Res> {
  factory _$$_RemoteStateCopyWith(
          _$_RemoteState value, $Res Function(_$_RemoteState) then) =
      __$$_RemoteStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({TvDevice? device, bool isConnected, bool isMuted, double volume});

  @override
  $TvDeviceCopyWith<$Res>? get device;
}

/// @nodoc
class __$$_RemoteStateCopyWithImpl<$Res>
    extends _$RemoteStateCopyWithImpl<$Res, _$_RemoteState>
    implements _$$_RemoteStateCopyWith<$Res> {
  __$$_RemoteStateCopyWithImpl(
      _$_RemoteState _value, $Res Function(_$_RemoteState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? device = freezed,
    Object? isConnected = null,
    Object? isMuted = null,
    Object? volume = null,
  }) {
    return _then(_$_RemoteState(
      device: freezed == device
          ? _value.device
          : device // ignore: cast_nullable_to_non_nullable
              as TvDevice?,
      isConnected: null == isConnected
          ? _value.isConnected
          : isConnected // ignore: cast_nullable_to_non_nullable
              as bool,
      isMuted: null == isMuted
          ? _value.isMuted
          : isMuted // ignore: cast_nullable_to_non_nullable
              as bool,
      volume: null == volume
          ? _value.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc

class _$_RemoteState implements _RemoteState {
  const _$_RemoteState(
      {this.device,
      this.isConnected = false,
      this.isMuted = false,
      this.volume = 0.5});

  @override
  final TvDevice? device;
  @override
  @JsonKey()
  final bool isConnected;
  @override
  @JsonKey()
  final bool isMuted;
  @override
  @JsonKey()
  final double volume;

  @override
  String toString() {
    return 'RemoteState(device: $device, isConnected: $isConnected, isMuted: $isMuted, volume: $volume)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_RemoteState &&
            (identical(other.device, device) || other.device == device) &&
            (identical(other.isConnected, isConnected) ||
                other.isConnected == isConnected) &&
            (identical(other.isMuted, isMuted) || other.isMuted == isMuted) &&
            (identical(other.volume, volume) || other.volume == volume));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, device, isConnected, isMuted, volume);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_RemoteStateCopyWith<_$_RemoteState> get copyWith =>
      __$$_RemoteStateCopyWithImpl<_$_RemoteState>(this, _$identity);
}

abstract class _RemoteState implements RemoteState {
  const factory _RemoteState(
      {final TvDevice? device,
      final bool isConnected,
      final bool isMuted,
      final double volume}) = _$_RemoteState;

  @override
  TvDevice? get device;
  @override
  bool get isConnected;
  @override
  bool get isMuted;
  @override
  double get volume;
  @override
  @JsonKey(ignore: true)
  _$$_RemoteStateCopyWith<_$_RemoteState> get copyWith =>
      throw _privateConstructorUsedError;
}
