// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pairing_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$PairingStatus {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() discoveryStarted,
    required TResult Function(List<TvDevice> devices) devicesFound,
    required TResult Function(TvDevice device) connecting,
    required TResult Function(TvDevice device, int expiresInSeconds)
        awaitingPin,
    required TResult Function(TvDevice device) pinVerified,
    required TResult Function(TvDevice device) paired,
    required TResult Function(TvDevice device) connected,
    required TResult Function(TvDevice device, int attempt) reconnecting,
    required TResult Function(TvDevice? lastDevice, String reason) disconnected,
    required TResult Function(TvDevice device, Failure failure)
        connectionFailed,
    required TResult Function(TvDevice device, int attemptsLeft, String message)
        pinError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? discoveryStarted,
    TResult? Function(List<TvDevice> devices)? devicesFound,
    TResult? Function(TvDevice device)? connecting,
    TResult? Function(TvDevice device, int expiresInSeconds)? awaitingPin,
    TResult? Function(TvDevice device)? pinVerified,
    TResult? Function(TvDevice device)? paired,
    TResult? Function(TvDevice device)? connected,
    TResult? Function(TvDevice device, int attempt)? reconnecting,
    TResult? Function(TvDevice? lastDevice, String reason)? disconnected,
    TResult? Function(TvDevice device, Failure failure)? connectionFailed,
    TResult? Function(TvDevice device, int attemptsLeft, String message)?
        pinError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? discoveryStarted,
    TResult Function(List<TvDevice> devices)? devicesFound,
    TResult Function(TvDevice device)? connecting,
    TResult Function(TvDevice device, int expiresInSeconds)? awaitingPin,
    TResult Function(TvDevice device)? pinVerified,
    TResult Function(TvDevice device)? paired,
    TResult Function(TvDevice device)? connected,
    TResult Function(TvDevice device, int attempt)? reconnecting,
    TResult Function(TvDevice? lastDevice, String reason)? disconnected,
    TResult Function(TvDevice device, Failure failure)? connectionFailed,
    TResult Function(TvDevice device, int attemptsLeft, String message)?
        pinError,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Idle value) idle,
    required TResult Function(DiscoveryStarted value) discoveryStarted,
    required TResult Function(DevicesFound value) devicesFound,
    required TResult Function(Connecting value) connecting,
    required TResult Function(AwaitingPin value) awaitingPin,
    required TResult Function(PinVerified value) pinVerified,
    required TResult Function(Paired value) paired,
    required TResult Function(Connected value) connected,
    required TResult Function(Reconnecting value) reconnecting,
    required TResult Function(Disconnected value) disconnected,
    required TResult Function(ConnectionFailed value) connectionFailed,
    required TResult Function(PinError value) pinError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Idle value)? idle,
    TResult? Function(DiscoveryStarted value)? discoveryStarted,
    TResult? Function(DevicesFound value)? devicesFound,
    TResult? Function(Connecting value)? connecting,
    TResult? Function(AwaitingPin value)? awaitingPin,
    TResult? Function(PinVerified value)? pinVerified,
    TResult? Function(Paired value)? paired,
    TResult? Function(Connected value)? connected,
    TResult? Function(Reconnecting value)? reconnecting,
    TResult? Function(Disconnected value)? disconnected,
    TResult? Function(ConnectionFailed value)? connectionFailed,
    TResult? Function(PinError value)? pinError,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Idle value)? idle,
    TResult Function(DiscoveryStarted value)? discoveryStarted,
    TResult Function(DevicesFound value)? devicesFound,
    TResult Function(Connecting value)? connecting,
    TResult Function(AwaitingPin value)? awaitingPin,
    TResult Function(PinVerified value)? pinVerified,
    TResult Function(Paired value)? paired,
    TResult Function(Connected value)? connected,
    TResult Function(Reconnecting value)? reconnecting,
    TResult Function(Disconnected value)? disconnected,
    TResult Function(ConnectionFailed value)? connectionFailed,
    TResult Function(PinError value)? pinError,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PairingStatusCopyWith<$Res> {
  factory $PairingStatusCopyWith(
          PairingStatus value, $Res Function(PairingStatus) then) =
      _$PairingStatusCopyWithImpl<$Res, PairingStatus>;
}

/// @nodoc
class _$PairingStatusCopyWithImpl<$Res, $Val extends PairingStatus>
    implements $PairingStatusCopyWith<$Res> {
  _$PairingStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$IdleCopyWith<$Res> {
  factory _$$IdleCopyWith(_$Idle value, $Res Function(_$Idle) then) =
      __$$IdleCopyWithImpl<$Res>;
}

/// @nodoc
class __$$IdleCopyWithImpl<$Res>
    extends _$PairingStatusCopyWithImpl<$Res, _$Idle>
    implements _$$IdleCopyWith<$Res> {
  __$$IdleCopyWithImpl(_$Idle _value, $Res Function(_$Idle) _then)
      : super(_value, _then);
}

/// @nodoc

class _$Idle implements Idle {
  const _$Idle();

  @override
  String toString() {
    return 'PairingStatus.idle()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$Idle);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() discoveryStarted,
    required TResult Function(List<TvDevice> devices) devicesFound,
    required TResult Function(TvDevice device) connecting,
    required TResult Function(TvDevice device, int expiresInSeconds)
        awaitingPin,
    required TResult Function(TvDevice device) pinVerified,
    required TResult Function(TvDevice device) paired,
    required TResult Function(TvDevice device) connected,
    required TResult Function(TvDevice device, int attempt) reconnecting,
    required TResult Function(TvDevice? lastDevice, String reason) disconnected,
    required TResult Function(TvDevice device, Failure failure)
        connectionFailed,
    required TResult Function(TvDevice device, int attemptsLeft, String message)
        pinError,
  }) {
    return idle();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? discoveryStarted,
    TResult? Function(List<TvDevice> devices)? devicesFound,
    TResult? Function(TvDevice device)? connecting,
    TResult? Function(TvDevice device, int expiresInSeconds)? awaitingPin,
    TResult? Function(TvDevice device)? pinVerified,
    TResult? Function(TvDevice device)? paired,
    TResult? Function(TvDevice device)? connected,
    TResult? Function(TvDevice device, int attempt)? reconnecting,
    TResult? Function(TvDevice? lastDevice, String reason)? disconnected,
    TResult? Function(TvDevice device, Failure failure)? connectionFailed,
    TResult? Function(TvDevice device, int attemptsLeft, String message)?
        pinError,
  }) {
    return idle?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? discoveryStarted,
    TResult Function(List<TvDevice> devices)? devicesFound,
    TResult Function(TvDevice device)? connecting,
    TResult Function(TvDevice device, int expiresInSeconds)? awaitingPin,
    TResult Function(TvDevice device)? pinVerified,
    TResult Function(TvDevice device)? paired,
    TResult Function(TvDevice device)? connected,
    TResult Function(TvDevice device, int attempt)? reconnecting,
    TResult Function(TvDevice? lastDevice, String reason)? disconnected,
    TResult Function(TvDevice device, Failure failure)? connectionFailed,
    TResult Function(TvDevice device, int attemptsLeft, String message)?
        pinError,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Idle value) idle,
    required TResult Function(DiscoveryStarted value) discoveryStarted,
    required TResult Function(DevicesFound value) devicesFound,
    required TResult Function(Connecting value) connecting,
    required TResult Function(AwaitingPin value) awaitingPin,
    required TResult Function(PinVerified value) pinVerified,
    required TResult Function(Paired value) paired,
    required TResult Function(Connected value) connected,
    required TResult Function(Reconnecting value) reconnecting,
    required TResult Function(Disconnected value) disconnected,
    required TResult Function(ConnectionFailed value) connectionFailed,
    required TResult Function(PinError value) pinError,
  }) {
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Idle value)? idle,
    TResult? Function(DiscoveryStarted value)? discoveryStarted,
    TResult? Function(DevicesFound value)? devicesFound,
    TResult? Function(Connecting value)? connecting,
    TResult? Function(AwaitingPin value)? awaitingPin,
    TResult? Function(PinVerified value)? pinVerified,
    TResult? Function(Paired value)? paired,
    TResult? Function(Connected value)? connected,
    TResult? Function(Reconnecting value)? reconnecting,
    TResult? Function(Disconnected value)? disconnected,
    TResult? Function(ConnectionFailed value)? connectionFailed,
    TResult? Function(PinError value)? pinError,
  }) {
    return idle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Idle value)? idle,
    TResult Function(DiscoveryStarted value)? discoveryStarted,
    TResult Function(DevicesFound value)? devicesFound,
    TResult Function(Connecting value)? connecting,
    TResult Function(AwaitingPin value)? awaitingPin,
    TResult Function(PinVerified value)? pinVerified,
    TResult Function(Paired value)? paired,
    TResult Function(Connected value)? connected,
    TResult Function(Reconnecting value)? reconnecting,
    TResult Function(Disconnected value)? disconnected,
    TResult Function(ConnectionFailed value)? connectionFailed,
    TResult Function(PinError value)? pinError,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(this);
    }
    return orElse();
  }
}

abstract class Idle implements PairingStatus {
  const factory Idle() = _$Idle;
}

/// @nodoc
abstract class _$$DiscoveryStartedCopyWith<$Res> {
  factory _$$DiscoveryStartedCopyWith(
          _$DiscoveryStarted value, $Res Function(_$DiscoveryStarted) then) =
      __$$DiscoveryStartedCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DiscoveryStartedCopyWithImpl<$Res>
    extends _$PairingStatusCopyWithImpl<$Res, _$DiscoveryStarted>
    implements _$$DiscoveryStartedCopyWith<$Res> {
  __$$DiscoveryStartedCopyWithImpl(
      _$DiscoveryStarted _value, $Res Function(_$DiscoveryStarted) _then)
      : super(_value, _then);
}

/// @nodoc

class _$DiscoveryStarted implements DiscoveryStarted {
  const _$DiscoveryStarted();

  @override
  String toString() {
    return 'PairingStatus.discoveryStarted()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$DiscoveryStarted);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() discoveryStarted,
    required TResult Function(List<TvDevice> devices) devicesFound,
    required TResult Function(TvDevice device) connecting,
    required TResult Function(TvDevice device, int expiresInSeconds)
        awaitingPin,
    required TResult Function(TvDevice device) pinVerified,
    required TResult Function(TvDevice device) paired,
    required TResult Function(TvDevice device) connected,
    required TResult Function(TvDevice device, int attempt) reconnecting,
    required TResult Function(TvDevice? lastDevice, String reason) disconnected,
    required TResult Function(TvDevice device, Failure failure)
        connectionFailed,
    required TResult Function(TvDevice device, int attemptsLeft, String message)
        pinError,
  }) {
    return discoveryStarted();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? discoveryStarted,
    TResult? Function(List<TvDevice> devices)? devicesFound,
    TResult? Function(TvDevice device)? connecting,
    TResult? Function(TvDevice device, int expiresInSeconds)? awaitingPin,
    TResult? Function(TvDevice device)? pinVerified,
    TResult? Function(TvDevice device)? paired,
    TResult? Function(TvDevice device)? connected,
    TResult? Function(TvDevice device, int attempt)? reconnecting,
    TResult? Function(TvDevice? lastDevice, String reason)? disconnected,
    TResult? Function(TvDevice device, Failure failure)? connectionFailed,
    TResult? Function(TvDevice device, int attemptsLeft, String message)?
        pinError,
  }) {
    return discoveryStarted?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? discoveryStarted,
    TResult Function(List<TvDevice> devices)? devicesFound,
    TResult Function(TvDevice device)? connecting,
    TResult Function(TvDevice device, int expiresInSeconds)? awaitingPin,
    TResult Function(TvDevice device)? pinVerified,
    TResult Function(TvDevice device)? paired,
    TResult Function(TvDevice device)? connected,
    TResult Function(TvDevice device, int attempt)? reconnecting,
    TResult Function(TvDevice? lastDevice, String reason)? disconnected,
    TResult Function(TvDevice device, Failure failure)? connectionFailed,
    TResult Function(TvDevice device, int attemptsLeft, String message)?
        pinError,
    required TResult orElse(),
  }) {
    if (discoveryStarted != null) {
      return discoveryStarted();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Idle value) idle,
    required TResult Function(DiscoveryStarted value) discoveryStarted,
    required TResult Function(DevicesFound value) devicesFound,
    required TResult Function(Connecting value) connecting,
    required TResult Function(AwaitingPin value) awaitingPin,
    required TResult Function(PinVerified value) pinVerified,
    required TResult Function(Paired value) paired,
    required TResult Function(Connected value) connected,
    required TResult Function(Reconnecting value) reconnecting,
    required TResult Function(Disconnected value) disconnected,
    required TResult Function(ConnectionFailed value) connectionFailed,
    required TResult Function(PinError value) pinError,
  }) {
    return discoveryStarted(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Idle value)? idle,
    TResult? Function(DiscoveryStarted value)? discoveryStarted,
    TResult? Function(DevicesFound value)? devicesFound,
    TResult? Function(Connecting value)? connecting,
    TResult? Function(AwaitingPin value)? awaitingPin,
    TResult? Function(PinVerified value)? pinVerified,
    TResult? Function(Paired value)? paired,
    TResult? Function(Connected value)? connected,
    TResult? Function(Reconnecting value)? reconnecting,
    TResult? Function(Disconnected value)? disconnected,
    TResult? Function(ConnectionFailed value)? connectionFailed,
    TResult? Function(PinError value)? pinError,
  }) {
    return discoveryStarted?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Idle value)? idle,
    TResult Function(DiscoveryStarted value)? discoveryStarted,
    TResult Function(DevicesFound value)? devicesFound,
    TResult Function(Connecting value)? connecting,
    TResult Function(AwaitingPin value)? awaitingPin,
    TResult Function(PinVerified value)? pinVerified,
    TResult Function(Paired value)? paired,
    TResult Function(Connected value)? connected,
    TResult Function(Reconnecting value)? reconnecting,
    TResult Function(Disconnected value)? disconnected,
    TResult Function(ConnectionFailed value)? connectionFailed,
    TResult Function(PinError value)? pinError,
    required TResult orElse(),
  }) {
    if (discoveryStarted != null) {
      return discoveryStarted(this);
    }
    return orElse();
  }
}

abstract class DiscoveryStarted implements PairingStatus {
  const factory DiscoveryStarted() = _$DiscoveryStarted;
}

/// @nodoc
abstract class _$$DevicesFoundCopyWith<$Res> {
  factory _$$DevicesFoundCopyWith(
          _$DevicesFound value, $Res Function(_$DevicesFound) then) =
      __$$DevicesFoundCopyWithImpl<$Res>;
  @useResult
  $Res call({List<TvDevice> devices});
}

/// @nodoc
class __$$DevicesFoundCopyWithImpl<$Res>
    extends _$PairingStatusCopyWithImpl<$Res, _$DevicesFound>
    implements _$$DevicesFoundCopyWith<$Res> {
  __$$DevicesFoundCopyWithImpl(
      _$DevicesFound _value, $Res Function(_$DevicesFound) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? devices = null,
  }) {
    return _then(_$DevicesFound(
      null == devices
          ? _value._devices
          : devices // ignore: cast_nullable_to_non_nullable
              as List<TvDevice>,
    ));
  }
}

/// @nodoc

class _$DevicesFound implements DevicesFound {
  const _$DevicesFound(final List<TvDevice> devices) : _devices = devices;

  final List<TvDevice> _devices;
  @override
  List<TvDevice> get devices {
    if (_devices is EqualUnmodifiableListView) return _devices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_devices);
  }

  @override
  String toString() {
    return 'PairingStatus.devicesFound(devices: $devices)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DevicesFound &&
            const DeepCollectionEquality().equals(other._devices, _devices));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_devices));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DevicesFoundCopyWith<_$DevicesFound> get copyWith =>
      __$$DevicesFoundCopyWithImpl<_$DevicesFound>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() discoveryStarted,
    required TResult Function(List<TvDevice> devices) devicesFound,
    required TResult Function(TvDevice device) connecting,
    required TResult Function(TvDevice device, int expiresInSeconds)
        awaitingPin,
    required TResult Function(TvDevice device) pinVerified,
    required TResult Function(TvDevice device) paired,
    required TResult Function(TvDevice device) connected,
    required TResult Function(TvDevice device, int attempt) reconnecting,
    required TResult Function(TvDevice? lastDevice, String reason) disconnected,
    required TResult Function(TvDevice device, Failure failure)
        connectionFailed,
    required TResult Function(TvDevice device, int attemptsLeft, String message)
        pinError,
  }) {
    return devicesFound(devices);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? discoveryStarted,
    TResult? Function(List<TvDevice> devices)? devicesFound,
    TResult? Function(TvDevice device)? connecting,
    TResult? Function(TvDevice device, int expiresInSeconds)? awaitingPin,
    TResult? Function(TvDevice device)? pinVerified,
    TResult? Function(TvDevice device)? paired,
    TResult? Function(TvDevice device)? connected,
    TResult? Function(TvDevice device, int attempt)? reconnecting,
    TResult? Function(TvDevice? lastDevice, String reason)? disconnected,
    TResult? Function(TvDevice device, Failure failure)? connectionFailed,
    TResult? Function(TvDevice device, int attemptsLeft, String message)?
        pinError,
  }) {
    return devicesFound?.call(devices);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? discoveryStarted,
    TResult Function(List<TvDevice> devices)? devicesFound,
    TResult Function(TvDevice device)? connecting,
    TResult Function(TvDevice device, int expiresInSeconds)? awaitingPin,
    TResult Function(TvDevice device)? pinVerified,
    TResult Function(TvDevice device)? paired,
    TResult Function(TvDevice device)? connected,
    TResult Function(TvDevice device, int attempt)? reconnecting,
    TResult Function(TvDevice? lastDevice, String reason)? disconnected,
    TResult Function(TvDevice device, Failure failure)? connectionFailed,
    TResult Function(TvDevice device, int attemptsLeft, String message)?
        pinError,
    required TResult orElse(),
  }) {
    if (devicesFound != null) {
      return devicesFound(devices);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Idle value) idle,
    required TResult Function(DiscoveryStarted value) discoveryStarted,
    required TResult Function(DevicesFound value) devicesFound,
    required TResult Function(Connecting value) connecting,
    required TResult Function(AwaitingPin value) awaitingPin,
    required TResult Function(PinVerified value) pinVerified,
    required TResult Function(Paired value) paired,
    required TResult Function(Connected value) connected,
    required TResult Function(Reconnecting value) reconnecting,
    required TResult Function(Disconnected value) disconnected,
    required TResult Function(ConnectionFailed value) connectionFailed,
    required TResult Function(PinError value) pinError,
  }) {
    return devicesFound(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Idle value)? idle,
    TResult? Function(DiscoveryStarted value)? discoveryStarted,
    TResult? Function(DevicesFound value)? devicesFound,
    TResult? Function(Connecting value)? connecting,
    TResult? Function(AwaitingPin value)? awaitingPin,
    TResult? Function(PinVerified value)? pinVerified,
    TResult? Function(Paired value)? paired,
    TResult? Function(Connected value)? connected,
    TResult? Function(Reconnecting value)? reconnecting,
    TResult? Function(Disconnected value)? disconnected,
    TResult? Function(ConnectionFailed value)? connectionFailed,
    TResult? Function(PinError value)? pinError,
  }) {
    return devicesFound?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Idle value)? idle,
    TResult Function(DiscoveryStarted value)? discoveryStarted,
    TResult Function(DevicesFound value)? devicesFound,
    TResult Function(Connecting value)? connecting,
    TResult Function(AwaitingPin value)? awaitingPin,
    TResult Function(PinVerified value)? pinVerified,
    TResult Function(Paired value)? paired,
    TResult Function(Connected value)? connected,
    TResult Function(Reconnecting value)? reconnecting,
    TResult Function(Disconnected value)? disconnected,
    TResult Function(ConnectionFailed value)? connectionFailed,
    TResult Function(PinError value)? pinError,
    required TResult orElse(),
  }) {
    if (devicesFound != null) {
      return devicesFound(this);
    }
    return orElse();
  }
}

abstract class DevicesFound implements PairingStatus {
  const factory DevicesFound(final List<TvDevice> devices) = _$DevicesFound;

  List<TvDevice> get devices;
  @JsonKey(ignore: true)
  _$$DevicesFoundCopyWith<_$DevicesFound> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ConnectingCopyWith<$Res> {
  factory _$$ConnectingCopyWith(
          _$Connecting value, $Res Function(_$Connecting) then) =
      __$$ConnectingCopyWithImpl<$Res>;
  @useResult
  $Res call({TvDevice device});

  $TvDeviceCopyWith<$Res> get device;
}

/// @nodoc
class __$$ConnectingCopyWithImpl<$Res>
    extends _$PairingStatusCopyWithImpl<$Res, _$Connecting>
    implements _$$ConnectingCopyWith<$Res> {
  __$$ConnectingCopyWithImpl(
      _$Connecting _value, $Res Function(_$Connecting) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? device = null,
  }) {
    return _then(_$Connecting(
      null == device
          ? _value.device
          : device // ignore: cast_nullable_to_non_nullable
              as TvDevice,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $TvDeviceCopyWith<$Res> get device {
    return $TvDeviceCopyWith<$Res>(_value.device, (value) {
      return _then(_value.copyWith(device: value));
    });
  }
}

/// @nodoc

class _$Connecting implements Connecting {
  const _$Connecting(this.device);

  @override
  final TvDevice device;

  @override
  String toString() {
    return 'PairingStatus.connecting(device: $device)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Connecting &&
            (identical(other.device, device) || other.device == device));
  }

  @override
  int get hashCode => Object.hash(runtimeType, device);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ConnectingCopyWith<_$Connecting> get copyWith =>
      __$$ConnectingCopyWithImpl<_$Connecting>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() discoveryStarted,
    required TResult Function(List<TvDevice> devices) devicesFound,
    required TResult Function(TvDevice device) connecting,
    required TResult Function(TvDevice device, int expiresInSeconds)
        awaitingPin,
    required TResult Function(TvDevice device) pinVerified,
    required TResult Function(TvDevice device) paired,
    required TResult Function(TvDevice device) connected,
    required TResult Function(TvDevice device, int attempt) reconnecting,
    required TResult Function(TvDevice? lastDevice, String reason) disconnected,
    required TResult Function(TvDevice device, Failure failure)
        connectionFailed,
    required TResult Function(TvDevice device, int attemptsLeft, String message)
        pinError,
  }) {
    return connecting(device);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? discoveryStarted,
    TResult? Function(List<TvDevice> devices)? devicesFound,
    TResult? Function(TvDevice device)? connecting,
    TResult? Function(TvDevice device, int expiresInSeconds)? awaitingPin,
    TResult? Function(TvDevice device)? pinVerified,
    TResult? Function(TvDevice device)? paired,
    TResult? Function(TvDevice device)? connected,
    TResult? Function(TvDevice device, int attempt)? reconnecting,
    TResult? Function(TvDevice? lastDevice, String reason)? disconnected,
    TResult? Function(TvDevice device, Failure failure)? connectionFailed,
    TResult? Function(TvDevice device, int attemptsLeft, String message)?
        pinError,
  }) {
    return connecting?.call(device);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? discoveryStarted,
    TResult Function(List<TvDevice> devices)? devicesFound,
    TResult Function(TvDevice device)? connecting,
    TResult Function(TvDevice device, int expiresInSeconds)? awaitingPin,
    TResult Function(TvDevice device)? pinVerified,
    TResult Function(TvDevice device)? paired,
    TResult Function(TvDevice device)? connected,
    TResult Function(TvDevice device, int attempt)? reconnecting,
    TResult Function(TvDevice? lastDevice, String reason)? disconnected,
    TResult Function(TvDevice device, Failure failure)? connectionFailed,
    TResult Function(TvDevice device, int attemptsLeft, String message)?
        pinError,
    required TResult orElse(),
  }) {
    if (connecting != null) {
      return connecting(device);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Idle value) idle,
    required TResult Function(DiscoveryStarted value) discoveryStarted,
    required TResult Function(DevicesFound value) devicesFound,
    required TResult Function(Connecting value) connecting,
    required TResult Function(AwaitingPin value) awaitingPin,
    required TResult Function(PinVerified value) pinVerified,
    required TResult Function(Paired value) paired,
    required TResult Function(Connected value) connected,
    required TResult Function(Reconnecting value) reconnecting,
    required TResult Function(Disconnected value) disconnected,
    required TResult Function(ConnectionFailed value) connectionFailed,
    required TResult Function(PinError value) pinError,
  }) {
    return connecting(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Idle value)? idle,
    TResult? Function(DiscoveryStarted value)? discoveryStarted,
    TResult? Function(DevicesFound value)? devicesFound,
    TResult? Function(Connecting value)? connecting,
    TResult? Function(AwaitingPin value)? awaitingPin,
    TResult? Function(PinVerified value)? pinVerified,
    TResult? Function(Paired value)? paired,
    TResult? Function(Connected value)? connected,
    TResult? Function(Reconnecting value)? reconnecting,
    TResult? Function(Disconnected value)? disconnected,
    TResult? Function(ConnectionFailed value)? connectionFailed,
    TResult? Function(PinError value)? pinError,
  }) {
    return connecting?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Idle value)? idle,
    TResult Function(DiscoveryStarted value)? discoveryStarted,
    TResult Function(DevicesFound value)? devicesFound,
    TResult Function(Connecting value)? connecting,
    TResult Function(AwaitingPin value)? awaitingPin,
    TResult Function(PinVerified value)? pinVerified,
    TResult Function(Paired value)? paired,
    TResult Function(Connected value)? connected,
    TResult Function(Reconnecting value)? reconnecting,
    TResult Function(Disconnected value)? disconnected,
    TResult Function(ConnectionFailed value)? connectionFailed,
    TResult Function(PinError value)? pinError,
    required TResult orElse(),
  }) {
    if (connecting != null) {
      return connecting(this);
    }
    return orElse();
  }
}

abstract class Connecting implements PairingStatus {
  const factory Connecting(final TvDevice device) = _$Connecting;

  TvDevice get device;
  @JsonKey(ignore: true)
  _$$ConnectingCopyWith<_$Connecting> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AwaitingPinCopyWith<$Res> {
  factory _$$AwaitingPinCopyWith(
          _$AwaitingPin value, $Res Function(_$AwaitingPin) then) =
      __$$AwaitingPinCopyWithImpl<$Res>;
  @useResult
  $Res call({TvDevice device, int expiresInSeconds});

  $TvDeviceCopyWith<$Res> get device;
}

/// @nodoc
class __$$AwaitingPinCopyWithImpl<$Res>
    extends _$PairingStatusCopyWithImpl<$Res, _$AwaitingPin>
    implements _$$AwaitingPinCopyWith<$Res> {
  __$$AwaitingPinCopyWithImpl(
      _$AwaitingPin _value, $Res Function(_$AwaitingPin) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? device = null,
    Object? expiresInSeconds = null,
  }) {
    return _then(_$AwaitingPin(
      null == device
          ? _value.device
          : device // ignore: cast_nullable_to_non_nullable
              as TvDevice,
      null == expiresInSeconds
          ? _value.expiresInSeconds
          : expiresInSeconds // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $TvDeviceCopyWith<$Res> get device {
    return $TvDeviceCopyWith<$Res>(_value.device, (value) {
      return _then(_value.copyWith(device: value));
    });
  }
}

/// @nodoc

class _$AwaitingPin implements AwaitingPin {
  const _$AwaitingPin(this.device, this.expiresInSeconds);

  @override
  final TvDevice device;
  @override
  final int expiresInSeconds;

  @override
  String toString() {
    return 'PairingStatus.awaitingPin(device: $device, expiresInSeconds: $expiresInSeconds)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AwaitingPin &&
            (identical(other.device, device) || other.device == device) &&
            (identical(other.expiresInSeconds, expiresInSeconds) ||
                other.expiresInSeconds == expiresInSeconds));
  }

  @override
  int get hashCode => Object.hash(runtimeType, device, expiresInSeconds);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AwaitingPinCopyWith<_$AwaitingPin> get copyWith =>
      __$$AwaitingPinCopyWithImpl<_$AwaitingPin>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() discoveryStarted,
    required TResult Function(List<TvDevice> devices) devicesFound,
    required TResult Function(TvDevice device) connecting,
    required TResult Function(TvDevice device, int expiresInSeconds)
        awaitingPin,
    required TResult Function(TvDevice device) pinVerified,
    required TResult Function(TvDevice device) paired,
    required TResult Function(TvDevice device) connected,
    required TResult Function(TvDevice device, int attempt) reconnecting,
    required TResult Function(TvDevice? lastDevice, String reason) disconnected,
    required TResult Function(TvDevice device, Failure failure)
        connectionFailed,
    required TResult Function(TvDevice device, int attemptsLeft, String message)
        pinError,
  }) {
    return awaitingPin(device, expiresInSeconds);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? discoveryStarted,
    TResult? Function(List<TvDevice> devices)? devicesFound,
    TResult? Function(TvDevice device)? connecting,
    TResult? Function(TvDevice device, int expiresInSeconds)? awaitingPin,
    TResult? Function(TvDevice device)? pinVerified,
    TResult? Function(TvDevice device)? paired,
    TResult? Function(TvDevice device)? connected,
    TResult? Function(TvDevice device, int attempt)? reconnecting,
    TResult? Function(TvDevice? lastDevice, String reason)? disconnected,
    TResult? Function(TvDevice device, Failure failure)? connectionFailed,
    TResult? Function(TvDevice device, int attemptsLeft, String message)?
        pinError,
  }) {
    return awaitingPin?.call(device, expiresInSeconds);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? discoveryStarted,
    TResult Function(List<TvDevice> devices)? devicesFound,
    TResult Function(TvDevice device)? connecting,
    TResult Function(TvDevice device, int expiresInSeconds)? awaitingPin,
    TResult Function(TvDevice device)? pinVerified,
    TResult Function(TvDevice device)? paired,
    TResult Function(TvDevice device)? connected,
    TResult Function(TvDevice device, int attempt)? reconnecting,
    TResult Function(TvDevice? lastDevice, String reason)? disconnected,
    TResult Function(TvDevice device, Failure failure)? connectionFailed,
    TResult Function(TvDevice device, int attemptsLeft, String message)?
        pinError,
    required TResult orElse(),
  }) {
    if (awaitingPin != null) {
      return awaitingPin(device, expiresInSeconds);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Idle value) idle,
    required TResult Function(DiscoveryStarted value) discoveryStarted,
    required TResult Function(DevicesFound value) devicesFound,
    required TResult Function(Connecting value) connecting,
    required TResult Function(AwaitingPin value) awaitingPin,
    required TResult Function(PinVerified value) pinVerified,
    required TResult Function(Paired value) paired,
    required TResult Function(Connected value) connected,
    required TResult Function(Reconnecting value) reconnecting,
    required TResult Function(Disconnected value) disconnected,
    required TResult Function(ConnectionFailed value) connectionFailed,
    required TResult Function(PinError value) pinError,
  }) {
    return awaitingPin(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Idle value)? idle,
    TResult? Function(DiscoveryStarted value)? discoveryStarted,
    TResult? Function(DevicesFound value)? devicesFound,
    TResult? Function(Connecting value)? connecting,
    TResult? Function(AwaitingPin value)? awaitingPin,
    TResult? Function(PinVerified value)? pinVerified,
    TResult? Function(Paired value)? paired,
    TResult? Function(Connected value)? connected,
    TResult? Function(Reconnecting value)? reconnecting,
    TResult? Function(Disconnected value)? disconnected,
    TResult? Function(ConnectionFailed value)? connectionFailed,
    TResult? Function(PinError value)? pinError,
  }) {
    return awaitingPin?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Idle value)? idle,
    TResult Function(DiscoveryStarted value)? discoveryStarted,
    TResult Function(DevicesFound value)? devicesFound,
    TResult Function(Connecting value)? connecting,
    TResult Function(AwaitingPin value)? awaitingPin,
    TResult Function(PinVerified value)? pinVerified,
    TResult Function(Paired value)? paired,
    TResult Function(Connected value)? connected,
    TResult Function(Reconnecting value)? reconnecting,
    TResult Function(Disconnected value)? disconnected,
    TResult Function(ConnectionFailed value)? connectionFailed,
    TResult Function(PinError value)? pinError,
    required TResult orElse(),
  }) {
    if (awaitingPin != null) {
      return awaitingPin(this);
    }
    return orElse();
  }
}

abstract class AwaitingPin implements PairingStatus {
  const factory AwaitingPin(final TvDevice device, final int expiresInSeconds) =
      _$AwaitingPin;

  TvDevice get device;
  int get expiresInSeconds;
  @JsonKey(ignore: true)
  _$$AwaitingPinCopyWith<_$AwaitingPin> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PinVerifiedCopyWith<$Res> {
  factory _$$PinVerifiedCopyWith(
          _$PinVerified value, $Res Function(_$PinVerified) then) =
      __$$PinVerifiedCopyWithImpl<$Res>;
  @useResult
  $Res call({TvDevice device});

  $TvDeviceCopyWith<$Res> get device;
}

/// @nodoc
class __$$PinVerifiedCopyWithImpl<$Res>
    extends _$PairingStatusCopyWithImpl<$Res, _$PinVerified>
    implements _$$PinVerifiedCopyWith<$Res> {
  __$$PinVerifiedCopyWithImpl(
      _$PinVerified _value, $Res Function(_$PinVerified) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? device = null,
  }) {
    return _then(_$PinVerified(
      null == device
          ? _value.device
          : device // ignore: cast_nullable_to_non_nullable
              as TvDevice,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $TvDeviceCopyWith<$Res> get device {
    return $TvDeviceCopyWith<$Res>(_value.device, (value) {
      return _then(_value.copyWith(device: value));
    });
  }
}

/// @nodoc

class _$PinVerified implements PinVerified {
  const _$PinVerified(this.device);

  @override
  final TvDevice device;

  @override
  String toString() {
    return 'PairingStatus.pinVerified(device: $device)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PinVerified &&
            (identical(other.device, device) || other.device == device));
  }

  @override
  int get hashCode => Object.hash(runtimeType, device);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PinVerifiedCopyWith<_$PinVerified> get copyWith =>
      __$$PinVerifiedCopyWithImpl<_$PinVerified>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() discoveryStarted,
    required TResult Function(List<TvDevice> devices) devicesFound,
    required TResult Function(TvDevice device) connecting,
    required TResult Function(TvDevice device, int expiresInSeconds)
        awaitingPin,
    required TResult Function(TvDevice device) pinVerified,
    required TResult Function(TvDevice device) paired,
    required TResult Function(TvDevice device) connected,
    required TResult Function(TvDevice device, int attempt) reconnecting,
    required TResult Function(TvDevice? lastDevice, String reason) disconnected,
    required TResult Function(TvDevice device, Failure failure)
        connectionFailed,
    required TResult Function(TvDevice device, int attemptsLeft, String message)
        pinError,
  }) {
    return pinVerified(device);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? discoveryStarted,
    TResult? Function(List<TvDevice> devices)? devicesFound,
    TResult? Function(TvDevice device)? connecting,
    TResult? Function(TvDevice device, int expiresInSeconds)? awaitingPin,
    TResult? Function(TvDevice device)? pinVerified,
    TResult? Function(TvDevice device)? paired,
    TResult? Function(TvDevice device)? connected,
    TResult? Function(TvDevice device, int attempt)? reconnecting,
    TResult? Function(TvDevice? lastDevice, String reason)? disconnected,
    TResult? Function(TvDevice device, Failure failure)? connectionFailed,
    TResult? Function(TvDevice device, int attemptsLeft, String message)?
        pinError,
  }) {
    return pinVerified?.call(device);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? discoveryStarted,
    TResult Function(List<TvDevice> devices)? devicesFound,
    TResult Function(TvDevice device)? connecting,
    TResult Function(TvDevice device, int expiresInSeconds)? awaitingPin,
    TResult Function(TvDevice device)? pinVerified,
    TResult Function(TvDevice device)? paired,
    TResult Function(TvDevice device)? connected,
    TResult Function(TvDevice device, int attempt)? reconnecting,
    TResult Function(TvDevice? lastDevice, String reason)? disconnected,
    TResult Function(TvDevice device, Failure failure)? connectionFailed,
    TResult Function(TvDevice device, int attemptsLeft, String message)?
        pinError,
    required TResult orElse(),
  }) {
    if (pinVerified != null) {
      return pinVerified(device);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Idle value) idle,
    required TResult Function(DiscoveryStarted value) discoveryStarted,
    required TResult Function(DevicesFound value) devicesFound,
    required TResult Function(Connecting value) connecting,
    required TResult Function(AwaitingPin value) awaitingPin,
    required TResult Function(PinVerified value) pinVerified,
    required TResult Function(Paired value) paired,
    required TResult Function(Connected value) connected,
    required TResult Function(Reconnecting value) reconnecting,
    required TResult Function(Disconnected value) disconnected,
    required TResult Function(ConnectionFailed value) connectionFailed,
    required TResult Function(PinError value) pinError,
  }) {
    return pinVerified(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Idle value)? idle,
    TResult? Function(DiscoveryStarted value)? discoveryStarted,
    TResult? Function(DevicesFound value)? devicesFound,
    TResult? Function(Connecting value)? connecting,
    TResult? Function(AwaitingPin value)? awaitingPin,
    TResult? Function(PinVerified value)? pinVerified,
    TResult? Function(Paired value)? paired,
    TResult? Function(Connected value)? connected,
    TResult? Function(Reconnecting value)? reconnecting,
    TResult? Function(Disconnected value)? disconnected,
    TResult? Function(ConnectionFailed value)? connectionFailed,
    TResult? Function(PinError value)? pinError,
  }) {
    return pinVerified?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Idle value)? idle,
    TResult Function(DiscoveryStarted value)? discoveryStarted,
    TResult Function(DevicesFound value)? devicesFound,
    TResult Function(Connecting value)? connecting,
    TResult Function(AwaitingPin value)? awaitingPin,
    TResult Function(PinVerified value)? pinVerified,
    TResult Function(Paired value)? paired,
    TResult Function(Connected value)? connected,
    TResult Function(Reconnecting value)? reconnecting,
    TResult Function(Disconnected value)? disconnected,
    TResult Function(ConnectionFailed value)? connectionFailed,
    TResult Function(PinError value)? pinError,
    required TResult orElse(),
  }) {
    if (pinVerified != null) {
      return pinVerified(this);
    }
    return orElse();
  }
}

abstract class PinVerified implements PairingStatus {
  const factory PinVerified(final TvDevice device) = _$PinVerified;

  TvDevice get device;
  @JsonKey(ignore: true)
  _$$PinVerifiedCopyWith<_$PinVerified> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PairedCopyWith<$Res> {
  factory _$$PairedCopyWith(_$Paired value, $Res Function(_$Paired) then) =
      __$$PairedCopyWithImpl<$Res>;
  @useResult
  $Res call({TvDevice device});

  $TvDeviceCopyWith<$Res> get device;
}

/// @nodoc
class __$$PairedCopyWithImpl<$Res>
    extends _$PairingStatusCopyWithImpl<$Res, _$Paired>
    implements _$$PairedCopyWith<$Res> {
  __$$PairedCopyWithImpl(_$Paired _value, $Res Function(_$Paired) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? device = null,
  }) {
    return _then(_$Paired(
      null == device
          ? _value.device
          : device // ignore: cast_nullable_to_non_nullable
              as TvDevice,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $TvDeviceCopyWith<$Res> get device {
    return $TvDeviceCopyWith<$Res>(_value.device, (value) {
      return _then(_value.copyWith(device: value));
    });
  }
}

/// @nodoc

class _$Paired implements Paired {
  const _$Paired(this.device);

  @override
  final TvDevice device;

  @override
  String toString() {
    return 'PairingStatus.paired(device: $device)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Paired &&
            (identical(other.device, device) || other.device == device));
  }

  @override
  int get hashCode => Object.hash(runtimeType, device);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PairedCopyWith<_$Paired> get copyWith =>
      __$$PairedCopyWithImpl<_$Paired>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() discoveryStarted,
    required TResult Function(List<TvDevice> devices) devicesFound,
    required TResult Function(TvDevice device) connecting,
    required TResult Function(TvDevice device, int expiresInSeconds)
        awaitingPin,
    required TResult Function(TvDevice device) pinVerified,
    required TResult Function(TvDevice device) paired,
    required TResult Function(TvDevice device) connected,
    required TResult Function(TvDevice device, int attempt) reconnecting,
    required TResult Function(TvDevice? lastDevice, String reason) disconnected,
    required TResult Function(TvDevice device, Failure failure)
        connectionFailed,
    required TResult Function(TvDevice device, int attemptsLeft, String message)
        pinError,
  }) {
    return paired(device);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? discoveryStarted,
    TResult? Function(List<TvDevice> devices)? devicesFound,
    TResult? Function(TvDevice device)? connecting,
    TResult? Function(TvDevice device, int expiresInSeconds)? awaitingPin,
    TResult? Function(TvDevice device)? pinVerified,
    TResult? Function(TvDevice device)? paired,
    TResult? Function(TvDevice device)? connected,
    TResult? Function(TvDevice device, int attempt)? reconnecting,
    TResult? Function(TvDevice? lastDevice, String reason)? disconnected,
    TResult? Function(TvDevice device, Failure failure)? connectionFailed,
    TResult? Function(TvDevice device, int attemptsLeft, String message)?
        pinError,
  }) {
    return paired?.call(device);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? discoveryStarted,
    TResult Function(List<TvDevice> devices)? devicesFound,
    TResult Function(TvDevice device)? connecting,
    TResult Function(TvDevice device, int expiresInSeconds)? awaitingPin,
    TResult Function(TvDevice device)? pinVerified,
    TResult Function(TvDevice device)? paired,
    TResult Function(TvDevice device)? connected,
    TResult Function(TvDevice device, int attempt)? reconnecting,
    TResult Function(TvDevice? lastDevice, String reason)? disconnected,
    TResult Function(TvDevice device, Failure failure)? connectionFailed,
    TResult Function(TvDevice device, int attemptsLeft, String message)?
        pinError,
    required TResult orElse(),
  }) {
    if (paired != null) {
      return paired(device);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Idle value) idle,
    required TResult Function(DiscoveryStarted value) discoveryStarted,
    required TResult Function(DevicesFound value) devicesFound,
    required TResult Function(Connecting value) connecting,
    required TResult Function(AwaitingPin value) awaitingPin,
    required TResult Function(PinVerified value) pinVerified,
    required TResult Function(Paired value) paired,
    required TResult Function(Connected value) connected,
    required TResult Function(Reconnecting value) reconnecting,
    required TResult Function(Disconnected value) disconnected,
    required TResult Function(ConnectionFailed value) connectionFailed,
    required TResult Function(PinError value) pinError,
  }) {
    return paired(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Idle value)? idle,
    TResult? Function(DiscoveryStarted value)? discoveryStarted,
    TResult? Function(DevicesFound value)? devicesFound,
    TResult? Function(Connecting value)? connecting,
    TResult? Function(AwaitingPin value)? awaitingPin,
    TResult? Function(PinVerified value)? pinVerified,
    TResult? Function(Paired value)? paired,
    TResult? Function(Connected value)? connected,
    TResult? Function(Reconnecting value)? reconnecting,
    TResult? Function(Disconnected value)? disconnected,
    TResult? Function(ConnectionFailed value)? connectionFailed,
    TResult? Function(PinError value)? pinError,
  }) {
    return paired?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Idle value)? idle,
    TResult Function(DiscoveryStarted value)? discoveryStarted,
    TResult Function(DevicesFound value)? devicesFound,
    TResult Function(Connecting value)? connecting,
    TResult Function(AwaitingPin value)? awaitingPin,
    TResult Function(PinVerified value)? pinVerified,
    TResult Function(Paired value)? paired,
    TResult Function(Connected value)? connected,
    TResult Function(Reconnecting value)? reconnecting,
    TResult Function(Disconnected value)? disconnected,
    TResult Function(ConnectionFailed value)? connectionFailed,
    TResult Function(PinError value)? pinError,
    required TResult orElse(),
  }) {
    if (paired != null) {
      return paired(this);
    }
    return orElse();
  }
}

abstract class Paired implements PairingStatus {
  const factory Paired(final TvDevice device) = _$Paired;

  TvDevice get device;
  @JsonKey(ignore: true)
  _$$PairedCopyWith<_$Paired> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ConnectedCopyWith<$Res> {
  factory _$$ConnectedCopyWith(
          _$Connected value, $Res Function(_$Connected) then) =
      __$$ConnectedCopyWithImpl<$Res>;
  @useResult
  $Res call({TvDevice device});

  $TvDeviceCopyWith<$Res> get device;
}

/// @nodoc
class __$$ConnectedCopyWithImpl<$Res>
    extends _$PairingStatusCopyWithImpl<$Res, _$Connected>
    implements _$$ConnectedCopyWith<$Res> {
  __$$ConnectedCopyWithImpl(
      _$Connected _value, $Res Function(_$Connected) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? device = null,
  }) {
    return _then(_$Connected(
      null == device
          ? _value.device
          : device // ignore: cast_nullable_to_non_nullable
              as TvDevice,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $TvDeviceCopyWith<$Res> get device {
    return $TvDeviceCopyWith<$Res>(_value.device, (value) {
      return _then(_value.copyWith(device: value));
    });
  }
}

/// @nodoc

class _$Connected implements Connected {
  const _$Connected(this.device);

  @override
  final TvDevice device;

  @override
  String toString() {
    return 'PairingStatus.connected(device: $device)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Connected &&
            (identical(other.device, device) || other.device == device));
  }

  @override
  int get hashCode => Object.hash(runtimeType, device);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ConnectedCopyWith<_$Connected> get copyWith =>
      __$$ConnectedCopyWithImpl<_$Connected>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() discoveryStarted,
    required TResult Function(List<TvDevice> devices) devicesFound,
    required TResult Function(TvDevice device) connecting,
    required TResult Function(TvDevice device, int expiresInSeconds)
        awaitingPin,
    required TResult Function(TvDevice device) pinVerified,
    required TResult Function(TvDevice device) paired,
    required TResult Function(TvDevice device) connected,
    required TResult Function(TvDevice device, int attempt) reconnecting,
    required TResult Function(TvDevice? lastDevice, String reason) disconnected,
    required TResult Function(TvDevice device, Failure failure)
        connectionFailed,
    required TResult Function(TvDevice device, int attemptsLeft, String message)
        pinError,
  }) {
    return connected(device);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? discoveryStarted,
    TResult? Function(List<TvDevice> devices)? devicesFound,
    TResult? Function(TvDevice device)? connecting,
    TResult? Function(TvDevice device, int expiresInSeconds)? awaitingPin,
    TResult? Function(TvDevice device)? pinVerified,
    TResult? Function(TvDevice device)? paired,
    TResult? Function(TvDevice device)? connected,
    TResult? Function(TvDevice device, int attempt)? reconnecting,
    TResult? Function(TvDevice? lastDevice, String reason)? disconnected,
    TResult? Function(TvDevice device, Failure failure)? connectionFailed,
    TResult? Function(TvDevice device, int attemptsLeft, String message)?
        pinError,
  }) {
    return connected?.call(device);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? discoveryStarted,
    TResult Function(List<TvDevice> devices)? devicesFound,
    TResult Function(TvDevice device)? connecting,
    TResult Function(TvDevice device, int expiresInSeconds)? awaitingPin,
    TResult Function(TvDevice device)? pinVerified,
    TResult Function(TvDevice device)? paired,
    TResult Function(TvDevice device)? connected,
    TResult Function(TvDevice device, int attempt)? reconnecting,
    TResult Function(TvDevice? lastDevice, String reason)? disconnected,
    TResult Function(TvDevice device, Failure failure)? connectionFailed,
    TResult Function(TvDevice device, int attemptsLeft, String message)?
        pinError,
    required TResult orElse(),
  }) {
    if (connected != null) {
      return connected(device);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Idle value) idle,
    required TResult Function(DiscoveryStarted value) discoveryStarted,
    required TResult Function(DevicesFound value) devicesFound,
    required TResult Function(Connecting value) connecting,
    required TResult Function(AwaitingPin value) awaitingPin,
    required TResult Function(PinVerified value) pinVerified,
    required TResult Function(Paired value) paired,
    required TResult Function(Connected value) connected,
    required TResult Function(Reconnecting value) reconnecting,
    required TResult Function(Disconnected value) disconnected,
    required TResult Function(ConnectionFailed value) connectionFailed,
    required TResult Function(PinError value) pinError,
  }) {
    return connected(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Idle value)? idle,
    TResult? Function(DiscoveryStarted value)? discoveryStarted,
    TResult? Function(DevicesFound value)? devicesFound,
    TResult? Function(Connecting value)? connecting,
    TResult? Function(AwaitingPin value)? awaitingPin,
    TResult? Function(PinVerified value)? pinVerified,
    TResult? Function(Paired value)? paired,
    TResult? Function(Connected value)? connected,
    TResult? Function(Reconnecting value)? reconnecting,
    TResult? Function(Disconnected value)? disconnected,
    TResult? Function(ConnectionFailed value)? connectionFailed,
    TResult? Function(PinError value)? pinError,
  }) {
    return connected?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Idle value)? idle,
    TResult Function(DiscoveryStarted value)? discoveryStarted,
    TResult Function(DevicesFound value)? devicesFound,
    TResult Function(Connecting value)? connecting,
    TResult Function(AwaitingPin value)? awaitingPin,
    TResult Function(PinVerified value)? pinVerified,
    TResult Function(Paired value)? paired,
    TResult Function(Connected value)? connected,
    TResult Function(Reconnecting value)? reconnecting,
    TResult Function(Disconnected value)? disconnected,
    TResult Function(ConnectionFailed value)? connectionFailed,
    TResult Function(PinError value)? pinError,
    required TResult orElse(),
  }) {
    if (connected != null) {
      return connected(this);
    }
    return orElse();
  }
}

abstract class Connected implements PairingStatus {
  const factory Connected(final TvDevice device) = _$Connected;

  TvDevice get device;
  @JsonKey(ignore: true)
  _$$ConnectedCopyWith<_$Connected> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ReconnectingCopyWith<$Res> {
  factory _$$ReconnectingCopyWith(
          _$Reconnecting value, $Res Function(_$Reconnecting) then) =
      __$$ReconnectingCopyWithImpl<$Res>;
  @useResult
  $Res call({TvDevice device, int attempt});

  $TvDeviceCopyWith<$Res> get device;
}

/// @nodoc
class __$$ReconnectingCopyWithImpl<$Res>
    extends _$PairingStatusCopyWithImpl<$Res, _$Reconnecting>
    implements _$$ReconnectingCopyWith<$Res> {
  __$$ReconnectingCopyWithImpl(
      _$Reconnecting _value, $Res Function(_$Reconnecting) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? device = null,
    Object? attempt = null,
  }) {
    return _then(_$Reconnecting(
      null == device
          ? _value.device
          : device // ignore: cast_nullable_to_non_nullable
              as TvDevice,
      null == attempt
          ? _value.attempt
          : attempt // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $TvDeviceCopyWith<$Res> get device {
    return $TvDeviceCopyWith<$Res>(_value.device, (value) {
      return _then(_value.copyWith(device: value));
    });
  }
}

/// @nodoc

class _$Reconnecting implements Reconnecting {
  const _$Reconnecting(this.device, this.attempt);

  @override
  final TvDevice device;
  @override
  final int attempt;

  @override
  String toString() {
    return 'PairingStatus.reconnecting(device: $device, attempt: $attempt)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Reconnecting &&
            (identical(other.device, device) || other.device == device) &&
            (identical(other.attempt, attempt) || other.attempt == attempt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, device, attempt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReconnectingCopyWith<_$Reconnecting> get copyWith =>
      __$$ReconnectingCopyWithImpl<_$Reconnecting>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() discoveryStarted,
    required TResult Function(List<TvDevice> devices) devicesFound,
    required TResult Function(TvDevice device) connecting,
    required TResult Function(TvDevice device, int expiresInSeconds)
        awaitingPin,
    required TResult Function(TvDevice device) pinVerified,
    required TResult Function(TvDevice device) paired,
    required TResult Function(TvDevice device) connected,
    required TResult Function(TvDevice device, int attempt) reconnecting,
    required TResult Function(TvDevice? lastDevice, String reason) disconnected,
    required TResult Function(TvDevice device, Failure failure)
        connectionFailed,
    required TResult Function(TvDevice device, int attemptsLeft, String message)
        pinError,
  }) {
    return reconnecting(device, attempt);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? discoveryStarted,
    TResult? Function(List<TvDevice> devices)? devicesFound,
    TResult? Function(TvDevice device)? connecting,
    TResult? Function(TvDevice device, int expiresInSeconds)? awaitingPin,
    TResult? Function(TvDevice device)? pinVerified,
    TResult? Function(TvDevice device)? paired,
    TResult? Function(TvDevice device)? connected,
    TResult? Function(TvDevice device, int attempt)? reconnecting,
    TResult? Function(TvDevice? lastDevice, String reason)? disconnected,
    TResult? Function(TvDevice device, Failure failure)? connectionFailed,
    TResult? Function(TvDevice device, int attemptsLeft, String message)?
        pinError,
  }) {
    return reconnecting?.call(device, attempt);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? discoveryStarted,
    TResult Function(List<TvDevice> devices)? devicesFound,
    TResult Function(TvDevice device)? connecting,
    TResult Function(TvDevice device, int expiresInSeconds)? awaitingPin,
    TResult Function(TvDevice device)? pinVerified,
    TResult Function(TvDevice device)? paired,
    TResult Function(TvDevice device)? connected,
    TResult Function(TvDevice device, int attempt)? reconnecting,
    TResult Function(TvDevice? lastDevice, String reason)? disconnected,
    TResult Function(TvDevice device, Failure failure)? connectionFailed,
    TResult Function(TvDevice device, int attemptsLeft, String message)?
        pinError,
    required TResult orElse(),
  }) {
    if (reconnecting != null) {
      return reconnecting(device, attempt);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Idle value) idle,
    required TResult Function(DiscoveryStarted value) discoveryStarted,
    required TResult Function(DevicesFound value) devicesFound,
    required TResult Function(Connecting value) connecting,
    required TResult Function(AwaitingPin value) awaitingPin,
    required TResult Function(PinVerified value) pinVerified,
    required TResult Function(Paired value) paired,
    required TResult Function(Connected value) connected,
    required TResult Function(Reconnecting value) reconnecting,
    required TResult Function(Disconnected value) disconnected,
    required TResult Function(ConnectionFailed value) connectionFailed,
    required TResult Function(PinError value) pinError,
  }) {
    return reconnecting(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Idle value)? idle,
    TResult? Function(DiscoveryStarted value)? discoveryStarted,
    TResult? Function(DevicesFound value)? devicesFound,
    TResult? Function(Connecting value)? connecting,
    TResult? Function(AwaitingPin value)? awaitingPin,
    TResult? Function(PinVerified value)? pinVerified,
    TResult? Function(Paired value)? paired,
    TResult? Function(Connected value)? connected,
    TResult? Function(Reconnecting value)? reconnecting,
    TResult? Function(Disconnected value)? disconnected,
    TResult? Function(ConnectionFailed value)? connectionFailed,
    TResult? Function(PinError value)? pinError,
  }) {
    return reconnecting?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Idle value)? idle,
    TResult Function(DiscoveryStarted value)? discoveryStarted,
    TResult Function(DevicesFound value)? devicesFound,
    TResult Function(Connecting value)? connecting,
    TResult Function(AwaitingPin value)? awaitingPin,
    TResult Function(PinVerified value)? pinVerified,
    TResult Function(Paired value)? paired,
    TResult Function(Connected value)? connected,
    TResult Function(Reconnecting value)? reconnecting,
    TResult Function(Disconnected value)? disconnected,
    TResult Function(ConnectionFailed value)? connectionFailed,
    TResult Function(PinError value)? pinError,
    required TResult orElse(),
  }) {
    if (reconnecting != null) {
      return reconnecting(this);
    }
    return orElse();
  }
}

abstract class Reconnecting implements PairingStatus {
  const factory Reconnecting(final TvDevice device, final int attempt) =
      _$Reconnecting;

  TvDevice get device;
  int get attempt;
  @JsonKey(ignore: true)
  _$$ReconnectingCopyWith<_$Reconnecting> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DisconnectedCopyWith<$Res> {
  factory _$$DisconnectedCopyWith(
          _$Disconnected value, $Res Function(_$Disconnected) then) =
      __$$DisconnectedCopyWithImpl<$Res>;
  @useResult
  $Res call({TvDevice? lastDevice, String reason});

  $TvDeviceCopyWith<$Res>? get lastDevice;
}

/// @nodoc
class __$$DisconnectedCopyWithImpl<$Res>
    extends _$PairingStatusCopyWithImpl<$Res, _$Disconnected>
    implements _$$DisconnectedCopyWith<$Res> {
  __$$DisconnectedCopyWithImpl(
      _$Disconnected _value, $Res Function(_$Disconnected) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lastDevice = freezed,
    Object? reason = null,
  }) {
    return _then(_$Disconnected(
      freezed == lastDevice
          ? _value.lastDevice
          : lastDevice // ignore: cast_nullable_to_non_nullable
              as TvDevice?,
      null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $TvDeviceCopyWith<$Res>? get lastDevice {
    if (_value.lastDevice == null) {
      return null;
    }

    return $TvDeviceCopyWith<$Res>(_value.lastDevice!, (value) {
      return _then(_value.copyWith(lastDevice: value));
    });
  }
}

/// @nodoc

class _$Disconnected implements Disconnected {
  const _$Disconnected(this.lastDevice, this.reason);

  @override
  final TvDevice? lastDevice;
  @override
  final String reason;

  @override
  String toString() {
    return 'PairingStatus.disconnected(lastDevice: $lastDevice, reason: $reason)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$Disconnected &&
            (identical(other.lastDevice, lastDevice) ||
                other.lastDevice == lastDevice) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @override
  int get hashCode => Object.hash(runtimeType, lastDevice, reason);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DisconnectedCopyWith<_$Disconnected> get copyWith =>
      __$$DisconnectedCopyWithImpl<_$Disconnected>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() discoveryStarted,
    required TResult Function(List<TvDevice> devices) devicesFound,
    required TResult Function(TvDevice device) connecting,
    required TResult Function(TvDevice device, int expiresInSeconds)
        awaitingPin,
    required TResult Function(TvDevice device) pinVerified,
    required TResult Function(TvDevice device) paired,
    required TResult Function(TvDevice device) connected,
    required TResult Function(TvDevice device, int attempt) reconnecting,
    required TResult Function(TvDevice? lastDevice, String reason) disconnected,
    required TResult Function(TvDevice device, Failure failure)
        connectionFailed,
    required TResult Function(TvDevice device, int attemptsLeft, String message)
        pinError,
  }) {
    return disconnected(lastDevice, reason);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? discoveryStarted,
    TResult? Function(List<TvDevice> devices)? devicesFound,
    TResult? Function(TvDevice device)? connecting,
    TResult? Function(TvDevice device, int expiresInSeconds)? awaitingPin,
    TResult? Function(TvDevice device)? pinVerified,
    TResult? Function(TvDevice device)? paired,
    TResult? Function(TvDevice device)? connected,
    TResult? Function(TvDevice device, int attempt)? reconnecting,
    TResult? Function(TvDevice? lastDevice, String reason)? disconnected,
    TResult? Function(TvDevice device, Failure failure)? connectionFailed,
    TResult? Function(TvDevice device, int attemptsLeft, String message)?
        pinError,
  }) {
    return disconnected?.call(lastDevice, reason);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? discoveryStarted,
    TResult Function(List<TvDevice> devices)? devicesFound,
    TResult Function(TvDevice device)? connecting,
    TResult Function(TvDevice device, int expiresInSeconds)? awaitingPin,
    TResult Function(TvDevice device)? pinVerified,
    TResult Function(TvDevice device)? paired,
    TResult Function(TvDevice device)? connected,
    TResult Function(TvDevice device, int attempt)? reconnecting,
    TResult Function(TvDevice? lastDevice, String reason)? disconnected,
    TResult Function(TvDevice device, Failure failure)? connectionFailed,
    TResult Function(TvDevice device, int attemptsLeft, String message)?
        pinError,
    required TResult orElse(),
  }) {
    if (disconnected != null) {
      return disconnected(lastDevice, reason);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Idle value) idle,
    required TResult Function(DiscoveryStarted value) discoveryStarted,
    required TResult Function(DevicesFound value) devicesFound,
    required TResult Function(Connecting value) connecting,
    required TResult Function(AwaitingPin value) awaitingPin,
    required TResult Function(PinVerified value) pinVerified,
    required TResult Function(Paired value) paired,
    required TResult Function(Connected value) connected,
    required TResult Function(Reconnecting value) reconnecting,
    required TResult Function(Disconnected value) disconnected,
    required TResult Function(ConnectionFailed value) connectionFailed,
    required TResult Function(PinError value) pinError,
  }) {
    return disconnected(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Idle value)? idle,
    TResult? Function(DiscoveryStarted value)? discoveryStarted,
    TResult? Function(DevicesFound value)? devicesFound,
    TResult? Function(Connecting value)? connecting,
    TResult? Function(AwaitingPin value)? awaitingPin,
    TResult? Function(PinVerified value)? pinVerified,
    TResult? Function(Paired value)? paired,
    TResult? Function(Connected value)? connected,
    TResult? Function(Reconnecting value)? reconnecting,
    TResult? Function(Disconnected value)? disconnected,
    TResult? Function(ConnectionFailed value)? connectionFailed,
    TResult? Function(PinError value)? pinError,
  }) {
    return disconnected?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Idle value)? idle,
    TResult Function(DiscoveryStarted value)? discoveryStarted,
    TResult Function(DevicesFound value)? devicesFound,
    TResult Function(Connecting value)? connecting,
    TResult Function(AwaitingPin value)? awaitingPin,
    TResult Function(PinVerified value)? pinVerified,
    TResult Function(Paired value)? paired,
    TResult Function(Connected value)? connected,
    TResult Function(Reconnecting value)? reconnecting,
    TResult Function(Disconnected value)? disconnected,
    TResult Function(ConnectionFailed value)? connectionFailed,
    TResult Function(PinError value)? pinError,
    required TResult orElse(),
  }) {
    if (disconnected != null) {
      return disconnected(this);
    }
    return orElse();
  }
}

abstract class Disconnected implements PairingStatus {
  const factory Disconnected(final TvDevice? lastDevice, final String reason) =
      _$Disconnected;

  TvDevice? get lastDevice;
  String get reason;
  @JsonKey(ignore: true)
  _$$DisconnectedCopyWith<_$Disconnected> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ConnectionFailedCopyWith<$Res> {
  factory _$$ConnectionFailedCopyWith(
          _$ConnectionFailed value, $Res Function(_$ConnectionFailed) then) =
      __$$ConnectionFailedCopyWithImpl<$Res>;
  @useResult
  $Res call({TvDevice device, Failure failure});

  $TvDeviceCopyWith<$Res> get device;
}

/// @nodoc
class __$$ConnectionFailedCopyWithImpl<$Res>
    extends _$PairingStatusCopyWithImpl<$Res, _$ConnectionFailed>
    implements _$$ConnectionFailedCopyWith<$Res> {
  __$$ConnectionFailedCopyWithImpl(
      _$ConnectionFailed _value, $Res Function(_$ConnectionFailed) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? device = null,
    Object? failure = null,
  }) {
    return _then(_$ConnectionFailed(
      null == device
          ? _value.device
          : device // ignore: cast_nullable_to_non_nullable
              as TvDevice,
      null == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Failure,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $TvDeviceCopyWith<$Res> get device {
    return $TvDeviceCopyWith<$Res>(_value.device, (value) {
      return _then(_value.copyWith(device: value));
    });
  }
}

/// @nodoc

class _$ConnectionFailed implements ConnectionFailed {
  const _$ConnectionFailed(this.device, this.failure);

  @override
  final TvDevice device;
  @override
  final Failure failure;

  @override
  String toString() {
    return 'PairingStatus.connectionFailed(device: $device, failure: $failure)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConnectionFailed &&
            (identical(other.device, device) || other.device == device) &&
            (identical(other.failure, failure) || other.failure == failure));
  }

  @override
  int get hashCode => Object.hash(runtimeType, device, failure);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ConnectionFailedCopyWith<_$ConnectionFailed> get copyWith =>
      __$$ConnectionFailedCopyWithImpl<_$ConnectionFailed>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() discoveryStarted,
    required TResult Function(List<TvDevice> devices) devicesFound,
    required TResult Function(TvDevice device) connecting,
    required TResult Function(TvDevice device, int expiresInSeconds)
        awaitingPin,
    required TResult Function(TvDevice device) pinVerified,
    required TResult Function(TvDevice device) paired,
    required TResult Function(TvDevice device) connected,
    required TResult Function(TvDevice device, int attempt) reconnecting,
    required TResult Function(TvDevice? lastDevice, String reason) disconnected,
    required TResult Function(TvDevice device, Failure failure)
        connectionFailed,
    required TResult Function(TvDevice device, int attemptsLeft, String message)
        pinError,
  }) {
    return connectionFailed(device, failure);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? discoveryStarted,
    TResult? Function(List<TvDevice> devices)? devicesFound,
    TResult? Function(TvDevice device)? connecting,
    TResult? Function(TvDevice device, int expiresInSeconds)? awaitingPin,
    TResult? Function(TvDevice device)? pinVerified,
    TResult? Function(TvDevice device)? paired,
    TResult? Function(TvDevice device)? connected,
    TResult? Function(TvDevice device, int attempt)? reconnecting,
    TResult? Function(TvDevice? lastDevice, String reason)? disconnected,
    TResult? Function(TvDevice device, Failure failure)? connectionFailed,
    TResult? Function(TvDevice device, int attemptsLeft, String message)?
        pinError,
  }) {
    return connectionFailed?.call(device, failure);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? discoveryStarted,
    TResult Function(List<TvDevice> devices)? devicesFound,
    TResult Function(TvDevice device)? connecting,
    TResult Function(TvDevice device, int expiresInSeconds)? awaitingPin,
    TResult Function(TvDevice device)? pinVerified,
    TResult Function(TvDevice device)? paired,
    TResult Function(TvDevice device)? connected,
    TResult Function(TvDevice device, int attempt)? reconnecting,
    TResult Function(TvDevice? lastDevice, String reason)? disconnected,
    TResult Function(TvDevice device, Failure failure)? connectionFailed,
    TResult Function(TvDevice device, int attemptsLeft, String message)?
        pinError,
    required TResult orElse(),
  }) {
    if (connectionFailed != null) {
      return connectionFailed(device, failure);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Idle value) idle,
    required TResult Function(DiscoveryStarted value) discoveryStarted,
    required TResult Function(DevicesFound value) devicesFound,
    required TResult Function(Connecting value) connecting,
    required TResult Function(AwaitingPin value) awaitingPin,
    required TResult Function(PinVerified value) pinVerified,
    required TResult Function(Paired value) paired,
    required TResult Function(Connected value) connected,
    required TResult Function(Reconnecting value) reconnecting,
    required TResult Function(Disconnected value) disconnected,
    required TResult Function(ConnectionFailed value) connectionFailed,
    required TResult Function(PinError value) pinError,
  }) {
    return connectionFailed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Idle value)? idle,
    TResult? Function(DiscoveryStarted value)? discoveryStarted,
    TResult? Function(DevicesFound value)? devicesFound,
    TResult? Function(Connecting value)? connecting,
    TResult? Function(AwaitingPin value)? awaitingPin,
    TResult? Function(PinVerified value)? pinVerified,
    TResult? Function(Paired value)? paired,
    TResult? Function(Connected value)? connected,
    TResult? Function(Reconnecting value)? reconnecting,
    TResult? Function(Disconnected value)? disconnected,
    TResult? Function(ConnectionFailed value)? connectionFailed,
    TResult? Function(PinError value)? pinError,
  }) {
    return connectionFailed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Idle value)? idle,
    TResult Function(DiscoveryStarted value)? discoveryStarted,
    TResult Function(DevicesFound value)? devicesFound,
    TResult Function(Connecting value)? connecting,
    TResult Function(AwaitingPin value)? awaitingPin,
    TResult Function(PinVerified value)? pinVerified,
    TResult Function(Paired value)? paired,
    TResult Function(Connected value)? connected,
    TResult Function(Reconnecting value)? reconnecting,
    TResult Function(Disconnected value)? disconnected,
    TResult Function(ConnectionFailed value)? connectionFailed,
    TResult Function(PinError value)? pinError,
    required TResult orElse(),
  }) {
    if (connectionFailed != null) {
      return connectionFailed(this);
    }
    return orElse();
  }
}

abstract class ConnectionFailed implements PairingStatus {
  const factory ConnectionFailed(final TvDevice device, final Failure failure) =
      _$ConnectionFailed;

  TvDevice get device;
  Failure get failure;
  @JsonKey(ignore: true)
  _$$ConnectionFailedCopyWith<_$ConnectionFailed> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PinErrorCopyWith<$Res> {
  factory _$$PinErrorCopyWith(
          _$PinError value, $Res Function(_$PinError) then) =
      __$$PinErrorCopyWithImpl<$Res>;
  @useResult
  $Res call({TvDevice device, int attemptsLeft, String message});

  $TvDeviceCopyWith<$Res> get device;
}

/// @nodoc
class __$$PinErrorCopyWithImpl<$Res>
    extends _$PairingStatusCopyWithImpl<$Res, _$PinError>
    implements _$$PinErrorCopyWith<$Res> {
  __$$PinErrorCopyWithImpl(_$PinError _value, $Res Function(_$PinError) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? device = null,
    Object? attemptsLeft = null,
    Object? message = null,
  }) {
    return _then(_$PinError(
      null == device
          ? _value.device
          : device // ignore: cast_nullable_to_non_nullable
              as TvDevice,
      null == attemptsLeft
          ? _value.attemptsLeft
          : attemptsLeft // ignore: cast_nullable_to_non_nullable
              as int,
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $TvDeviceCopyWith<$Res> get device {
    return $TvDeviceCopyWith<$Res>(_value.device, (value) {
      return _then(_value.copyWith(device: value));
    });
  }
}

/// @nodoc

class _$PinError implements PinError {
  const _$PinError(this.device, this.attemptsLeft, this.message);

  @override
  final TvDevice device;
  @override
  final int attemptsLeft;
  @override
  final String message;

  @override
  String toString() {
    return 'PairingStatus.pinError(device: $device, attemptsLeft: $attemptsLeft, message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PinError &&
            (identical(other.device, device) || other.device == device) &&
            (identical(other.attemptsLeft, attemptsLeft) ||
                other.attemptsLeft == attemptsLeft) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, device, attemptsLeft, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PinErrorCopyWith<_$PinError> get copyWith =>
      __$$PinErrorCopyWithImpl<_$PinError>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() idle,
    required TResult Function() discoveryStarted,
    required TResult Function(List<TvDevice> devices) devicesFound,
    required TResult Function(TvDevice device) connecting,
    required TResult Function(TvDevice device, int expiresInSeconds)
        awaitingPin,
    required TResult Function(TvDevice device) pinVerified,
    required TResult Function(TvDevice device) paired,
    required TResult Function(TvDevice device) connected,
    required TResult Function(TvDevice device, int attempt) reconnecting,
    required TResult Function(TvDevice? lastDevice, String reason) disconnected,
    required TResult Function(TvDevice device, Failure failure)
        connectionFailed,
    required TResult Function(TvDevice device, int attemptsLeft, String message)
        pinError,
  }) {
    return pinError(device, attemptsLeft, message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? idle,
    TResult? Function()? discoveryStarted,
    TResult? Function(List<TvDevice> devices)? devicesFound,
    TResult? Function(TvDevice device)? connecting,
    TResult? Function(TvDevice device, int expiresInSeconds)? awaitingPin,
    TResult? Function(TvDevice device)? pinVerified,
    TResult? Function(TvDevice device)? paired,
    TResult? Function(TvDevice device)? connected,
    TResult? Function(TvDevice device, int attempt)? reconnecting,
    TResult? Function(TvDevice? lastDevice, String reason)? disconnected,
    TResult? Function(TvDevice device, Failure failure)? connectionFailed,
    TResult? Function(TvDevice device, int attemptsLeft, String message)?
        pinError,
  }) {
    return pinError?.call(device, attemptsLeft, message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? idle,
    TResult Function()? discoveryStarted,
    TResult Function(List<TvDevice> devices)? devicesFound,
    TResult Function(TvDevice device)? connecting,
    TResult Function(TvDevice device, int expiresInSeconds)? awaitingPin,
    TResult Function(TvDevice device)? pinVerified,
    TResult Function(TvDevice device)? paired,
    TResult Function(TvDevice device)? connected,
    TResult Function(TvDevice device, int attempt)? reconnecting,
    TResult Function(TvDevice? lastDevice, String reason)? disconnected,
    TResult Function(TvDevice device, Failure failure)? connectionFailed,
    TResult Function(TvDevice device, int attemptsLeft, String message)?
        pinError,
    required TResult orElse(),
  }) {
    if (pinError != null) {
      return pinError(device, attemptsLeft, message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(Idle value) idle,
    required TResult Function(DiscoveryStarted value) discoveryStarted,
    required TResult Function(DevicesFound value) devicesFound,
    required TResult Function(Connecting value) connecting,
    required TResult Function(AwaitingPin value) awaitingPin,
    required TResult Function(PinVerified value) pinVerified,
    required TResult Function(Paired value) paired,
    required TResult Function(Connected value) connected,
    required TResult Function(Reconnecting value) reconnecting,
    required TResult Function(Disconnected value) disconnected,
    required TResult Function(ConnectionFailed value) connectionFailed,
    required TResult Function(PinError value) pinError,
  }) {
    return pinError(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(Idle value)? idle,
    TResult? Function(DiscoveryStarted value)? discoveryStarted,
    TResult? Function(DevicesFound value)? devicesFound,
    TResult? Function(Connecting value)? connecting,
    TResult? Function(AwaitingPin value)? awaitingPin,
    TResult? Function(PinVerified value)? pinVerified,
    TResult? Function(Paired value)? paired,
    TResult? Function(Connected value)? connected,
    TResult? Function(Reconnecting value)? reconnecting,
    TResult? Function(Disconnected value)? disconnected,
    TResult? Function(ConnectionFailed value)? connectionFailed,
    TResult? Function(PinError value)? pinError,
  }) {
    return pinError?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(Idle value)? idle,
    TResult Function(DiscoveryStarted value)? discoveryStarted,
    TResult Function(DevicesFound value)? devicesFound,
    TResult Function(Connecting value)? connecting,
    TResult Function(AwaitingPin value)? awaitingPin,
    TResult Function(PinVerified value)? pinVerified,
    TResult Function(Paired value)? paired,
    TResult Function(Connected value)? connected,
    TResult Function(Reconnecting value)? reconnecting,
    TResult Function(Disconnected value)? disconnected,
    TResult Function(ConnectionFailed value)? connectionFailed,
    TResult Function(PinError value)? pinError,
    required TResult orElse(),
  }) {
    if (pinError != null) {
      return pinError(this);
    }
    return orElse();
  }
}

abstract class PinError implements PairingStatus {
  const factory PinError(
          final TvDevice device, final int attemptsLeft, final String message) =
      _$PinError;

  TvDevice get device;
  int get attemptsLeft;
  String get message;
  @JsonKey(ignore: true)
  _$$PinErrorCopyWith<_$PinError> get copyWith =>
      throw _privateConstructorUsedError;
}
