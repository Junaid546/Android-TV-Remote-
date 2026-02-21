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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

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
abstract class _$$IdleImplCopyWith<$Res> {
  factory _$$IdleImplCopyWith(
          _$IdleImpl value, $Res Function(_$IdleImpl) then) =
      __$$IdleImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$IdleImplCopyWithImpl<$Res>
    extends _$PairingStatusCopyWithImpl<$Res, _$IdleImpl>
    implements _$$IdleImplCopyWith<$Res> {
  __$$IdleImplCopyWithImpl(_$IdleImpl _value, $Res Function(_$IdleImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$IdleImpl implements Idle {
  const _$IdleImpl();

  @override
  String toString() {
    return 'PairingStatus.idle()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$IdleImpl);
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
  const factory Idle() = _$IdleImpl;
}

/// @nodoc
abstract class _$$DiscoveryStartedImplCopyWith<$Res> {
  factory _$$DiscoveryStartedImplCopyWith(_$DiscoveryStartedImpl value,
          $Res Function(_$DiscoveryStartedImpl) then) =
      __$$DiscoveryStartedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DiscoveryStartedImplCopyWithImpl<$Res>
    extends _$PairingStatusCopyWithImpl<$Res, _$DiscoveryStartedImpl>
    implements _$$DiscoveryStartedImplCopyWith<$Res> {
  __$$DiscoveryStartedImplCopyWithImpl(_$DiscoveryStartedImpl _value,
      $Res Function(_$DiscoveryStartedImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$DiscoveryStartedImpl implements DiscoveryStarted {
  const _$DiscoveryStartedImpl();

  @override
  String toString() {
    return 'PairingStatus.discoveryStarted()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$DiscoveryStartedImpl);
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
  const factory DiscoveryStarted() = _$DiscoveryStartedImpl;
}

/// @nodoc
abstract class _$$DevicesFoundImplCopyWith<$Res> {
  factory _$$DevicesFoundImplCopyWith(
          _$DevicesFoundImpl value, $Res Function(_$DevicesFoundImpl) then) =
      __$$DevicesFoundImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<TvDevice> devices});
}

/// @nodoc
class __$$DevicesFoundImplCopyWithImpl<$Res>
    extends _$PairingStatusCopyWithImpl<$Res, _$DevicesFoundImpl>
    implements _$$DevicesFoundImplCopyWith<$Res> {
  __$$DevicesFoundImplCopyWithImpl(
      _$DevicesFoundImpl _value, $Res Function(_$DevicesFoundImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? devices = null,
  }) {
    return _then(_$DevicesFoundImpl(
      null == devices
          ? _value._devices
          : devices // ignore: cast_nullable_to_non_nullable
              as List<TvDevice>,
    ));
  }
}

/// @nodoc

class _$DevicesFoundImpl implements DevicesFound {
  const _$DevicesFoundImpl(final List<TvDevice> devices) : _devices = devices;

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
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DevicesFoundImpl &&
            const DeepCollectionEquality().equals(other._devices, _devices));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_devices));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DevicesFoundImplCopyWith<_$DevicesFoundImpl> get copyWith =>
      __$$DevicesFoundImplCopyWithImpl<_$DevicesFoundImpl>(this, _$identity);

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
  const factory DevicesFound(final List<TvDevice> devices) = _$DevicesFoundImpl;

  List<TvDevice> get devices;
  @JsonKey(ignore: true)
  _$$DevicesFoundImplCopyWith<_$DevicesFoundImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ConnectingImplCopyWith<$Res> {
  factory _$$ConnectingImplCopyWith(
          _$ConnectingImpl value, $Res Function(_$ConnectingImpl) then) =
      __$$ConnectingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({TvDevice device});

  $TvDeviceCopyWith<$Res> get device;
}

/// @nodoc
class __$$ConnectingImplCopyWithImpl<$Res>
    extends _$PairingStatusCopyWithImpl<$Res, _$ConnectingImpl>
    implements _$$ConnectingImplCopyWith<$Res> {
  __$$ConnectingImplCopyWithImpl(
      _$ConnectingImpl _value, $Res Function(_$ConnectingImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? device = null,
  }) {
    return _then(_$ConnectingImpl(
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

class _$ConnectingImpl implements Connecting {
  const _$ConnectingImpl(this.device);

  @override
  final TvDevice device;

  @override
  String toString() {
    return 'PairingStatus.connecting(device: $device)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConnectingImpl &&
            (identical(other.device, device) || other.device == device));
  }

  @override
  int get hashCode => Object.hash(runtimeType, device);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ConnectingImplCopyWith<_$ConnectingImpl> get copyWith =>
      __$$ConnectingImplCopyWithImpl<_$ConnectingImpl>(this, _$identity);

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
  const factory Connecting(final TvDevice device) = _$ConnectingImpl;

  TvDevice get device;
  @JsonKey(ignore: true)
  _$$ConnectingImplCopyWith<_$ConnectingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AwaitingPinImplCopyWith<$Res> {
  factory _$$AwaitingPinImplCopyWith(
          _$AwaitingPinImpl value, $Res Function(_$AwaitingPinImpl) then) =
      __$$AwaitingPinImplCopyWithImpl<$Res>;
  @useResult
  $Res call({TvDevice device, int expiresInSeconds});

  $TvDeviceCopyWith<$Res> get device;
}

/// @nodoc
class __$$AwaitingPinImplCopyWithImpl<$Res>
    extends _$PairingStatusCopyWithImpl<$Res, _$AwaitingPinImpl>
    implements _$$AwaitingPinImplCopyWith<$Res> {
  __$$AwaitingPinImplCopyWithImpl(
      _$AwaitingPinImpl _value, $Res Function(_$AwaitingPinImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? device = null,
    Object? expiresInSeconds = null,
  }) {
    return _then(_$AwaitingPinImpl(
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

class _$AwaitingPinImpl implements AwaitingPin {
  const _$AwaitingPinImpl(this.device, this.expiresInSeconds);

  @override
  final TvDevice device;
  @override
  final int expiresInSeconds;

  @override
  String toString() {
    return 'PairingStatus.awaitingPin(device: $device, expiresInSeconds: $expiresInSeconds)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AwaitingPinImpl &&
            (identical(other.device, device) || other.device == device) &&
            (identical(other.expiresInSeconds, expiresInSeconds) ||
                other.expiresInSeconds == expiresInSeconds));
  }

  @override
  int get hashCode => Object.hash(runtimeType, device, expiresInSeconds);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AwaitingPinImplCopyWith<_$AwaitingPinImpl> get copyWith =>
      __$$AwaitingPinImplCopyWithImpl<_$AwaitingPinImpl>(this, _$identity);

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
      _$AwaitingPinImpl;

  TvDevice get device;
  int get expiresInSeconds;
  @JsonKey(ignore: true)
  _$$AwaitingPinImplCopyWith<_$AwaitingPinImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PinVerifiedImplCopyWith<$Res> {
  factory _$$PinVerifiedImplCopyWith(
          _$PinVerifiedImpl value, $Res Function(_$PinVerifiedImpl) then) =
      __$$PinVerifiedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({TvDevice device});

  $TvDeviceCopyWith<$Res> get device;
}

/// @nodoc
class __$$PinVerifiedImplCopyWithImpl<$Res>
    extends _$PairingStatusCopyWithImpl<$Res, _$PinVerifiedImpl>
    implements _$$PinVerifiedImplCopyWith<$Res> {
  __$$PinVerifiedImplCopyWithImpl(
      _$PinVerifiedImpl _value, $Res Function(_$PinVerifiedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? device = null,
  }) {
    return _then(_$PinVerifiedImpl(
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

class _$PinVerifiedImpl implements PinVerified {
  const _$PinVerifiedImpl(this.device);

  @override
  final TvDevice device;

  @override
  String toString() {
    return 'PairingStatus.pinVerified(device: $device)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PinVerifiedImpl &&
            (identical(other.device, device) || other.device == device));
  }

  @override
  int get hashCode => Object.hash(runtimeType, device);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PinVerifiedImplCopyWith<_$PinVerifiedImpl> get copyWith =>
      __$$PinVerifiedImplCopyWithImpl<_$PinVerifiedImpl>(this, _$identity);

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
  const factory PinVerified(final TvDevice device) = _$PinVerifiedImpl;

  TvDevice get device;
  @JsonKey(ignore: true)
  _$$PinVerifiedImplCopyWith<_$PinVerifiedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PairedImplCopyWith<$Res> {
  factory _$$PairedImplCopyWith(
          _$PairedImpl value, $Res Function(_$PairedImpl) then) =
      __$$PairedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({TvDevice device});

  $TvDeviceCopyWith<$Res> get device;
}

/// @nodoc
class __$$PairedImplCopyWithImpl<$Res>
    extends _$PairingStatusCopyWithImpl<$Res, _$PairedImpl>
    implements _$$PairedImplCopyWith<$Res> {
  __$$PairedImplCopyWithImpl(
      _$PairedImpl _value, $Res Function(_$PairedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? device = null,
  }) {
    return _then(_$PairedImpl(
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

class _$PairedImpl implements Paired {
  const _$PairedImpl(this.device);

  @override
  final TvDevice device;

  @override
  String toString() {
    return 'PairingStatus.paired(device: $device)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PairedImpl &&
            (identical(other.device, device) || other.device == device));
  }

  @override
  int get hashCode => Object.hash(runtimeType, device);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PairedImplCopyWith<_$PairedImpl> get copyWith =>
      __$$PairedImplCopyWithImpl<_$PairedImpl>(this, _$identity);

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
  const factory Paired(final TvDevice device) = _$PairedImpl;

  TvDevice get device;
  @JsonKey(ignore: true)
  _$$PairedImplCopyWith<_$PairedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ConnectedImplCopyWith<$Res> {
  factory _$$ConnectedImplCopyWith(
          _$ConnectedImpl value, $Res Function(_$ConnectedImpl) then) =
      __$$ConnectedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({TvDevice device});

  $TvDeviceCopyWith<$Res> get device;
}

/// @nodoc
class __$$ConnectedImplCopyWithImpl<$Res>
    extends _$PairingStatusCopyWithImpl<$Res, _$ConnectedImpl>
    implements _$$ConnectedImplCopyWith<$Res> {
  __$$ConnectedImplCopyWithImpl(
      _$ConnectedImpl _value, $Res Function(_$ConnectedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? device = null,
  }) {
    return _then(_$ConnectedImpl(
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

class _$ConnectedImpl implements Connected {
  const _$ConnectedImpl(this.device);

  @override
  final TvDevice device;

  @override
  String toString() {
    return 'PairingStatus.connected(device: $device)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConnectedImpl &&
            (identical(other.device, device) || other.device == device));
  }

  @override
  int get hashCode => Object.hash(runtimeType, device);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ConnectedImplCopyWith<_$ConnectedImpl> get copyWith =>
      __$$ConnectedImplCopyWithImpl<_$ConnectedImpl>(this, _$identity);

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
  const factory Connected(final TvDevice device) = _$ConnectedImpl;

  TvDevice get device;
  @JsonKey(ignore: true)
  _$$ConnectedImplCopyWith<_$ConnectedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ReconnectingImplCopyWith<$Res> {
  factory _$$ReconnectingImplCopyWith(
          _$ReconnectingImpl value, $Res Function(_$ReconnectingImpl) then) =
      __$$ReconnectingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({TvDevice device, int attempt});

  $TvDeviceCopyWith<$Res> get device;
}

/// @nodoc
class __$$ReconnectingImplCopyWithImpl<$Res>
    extends _$PairingStatusCopyWithImpl<$Res, _$ReconnectingImpl>
    implements _$$ReconnectingImplCopyWith<$Res> {
  __$$ReconnectingImplCopyWithImpl(
      _$ReconnectingImpl _value, $Res Function(_$ReconnectingImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? device = null,
    Object? attempt = null,
  }) {
    return _then(_$ReconnectingImpl(
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

class _$ReconnectingImpl implements Reconnecting {
  const _$ReconnectingImpl(this.device, this.attempt);

  @override
  final TvDevice device;
  @override
  final int attempt;

  @override
  String toString() {
    return 'PairingStatus.reconnecting(device: $device, attempt: $attempt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReconnectingImpl &&
            (identical(other.device, device) || other.device == device) &&
            (identical(other.attempt, attempt) || other.attempt == attempt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, device, attempt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReconnectingImplCopyWith<_$ReconnectingImpl> get copyWith =>
      __$$ReconnectingImplCopyWithImpl<_$ReconnectingImpl>(this, _$identity);

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
      _$ReconnectingImpl;

  TvDevice get device;
  int get attempt;
  @JsonKey(ignore: true)
  _$$ReconnectingImplCopyWith<_$ReconnectingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DisconnectedImplCopyWith<$Res> {
  factory _$$DisconnectedImplCopyWith(
          _$DisconnectedImpl value, $Res Function(_$DisconnectedImpl) then) =
      __$$DisconnectedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({TvDevice? lastDevice, String reason});

  $TvDeviceCopyWith<$Res>? get lastDevice;
}

/// @nodoc
class __$$DisconnectedImplCopyWithImpl<$Res>
    extends _$PairingStatusCopyWithImpl<$Res, _$DisconnectedImpl>
    implements _$$DisconnectedImplCopyWith<$Res> {
  __$$DisconnectedImplCopyWithImpl(
      _$DisconnectedImpl _value, $Res Function(_$DisconnectedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? lastDevice = freezed,
    Object? reason = null,
  }) {
    return _then(_$DisconnectedImpl(
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

class _$DisconnectedImpl implements Disconnected {
  const _$DisconnectedImpl(this.lastDevice, this.reason);

  @override
  final TvDevice? lastDevice;
  @override
  final String reason;

  @override
  String toString() {
    return 'PairingStatus.disconnected(lastDevice: $lastDevice, reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DisconnectedImpl &&
            (identical(other.lastDevice, lastDevice) ||
                other.lastDevice == lastDevice) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @override
  int get hashCode => Object.hash(runtimeType, lastDevice, reason);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DisconnectedImplCopyWith<_$DisconnectedImpl> get copyWith =>
      __$$DisconnectedImplCopyWithImpl<_$DisconnectedImpl>(this, _$identity);

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
      _$DisconnectedImpl;

  TvDevice? get lastDevice;
  String get reason;
  @JsonKey(ignore: true)
  _$$DisconnectedImplCopyWith<_$DisconnectedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ConnectionFailedImplCopyWith<$Res> {
  factory _$$ConnectionFailedImplCopyWith(_$ConnectionFailedImpl value,
          $Res Function(_$ConnectionFailedImpl) then) =
      __$$ConnectionFailedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({TvDevice device, Failure failure});

  $TvDeviceCopyWith<$Res> get device;
}

/// @nodoc
class __$$ConnectionFailedImplCopyWithImpl<$Res>
    extends _$PairingStatusCopyWithImpl<$Res, _$ConnectionFailedImpl>
    implements _$$ConnectionFailedImplCopyWith<$Res> {
  __$$ConnectionFailedImplCopyWithImpl(_$ConnectionFailedImpl _value,
      $Res Function(_$ConnectionFailedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? device = null,
    Object? failure = null,
  }) {
    return _then(_$ConnectionFailedImpl(
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

class _$ConnectionFailedImpl implements ConnectionFailed {
  const _$ConnectionFailedImpl(this.device, this.failure);

  @override
  final TvDevice device;
  @override
  final Failure failure;

  @override
  String toString() {
    return 'PairingStatus.connectionFailed(device: $device, failure: $failure)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConnectionFailedImpl &&
            (identical(other.device, device) || other.device == device) &&
            (identical(other.failure, failure) || other.failure == failure));
  }

  @override
  int get hashCode => Object.hash(runtimeType, device, failure);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ConnectionFailedImplCopyWith<_$ConnectionFailedImpl> get copyWith =>
      __$$ConnectionFailedImplCopyWithImpl<_$ConnectionFailedImpl>(
          this, _$identity);

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
      _$ConnectionFailedImpl;

  TvDevice get device;
  Failure get failure;
  @JsonKey(ignore: true)
  _$$ConnectionFailedImplCopyWith<_$ConnectionFailedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PinErrorImplCopyWith<$Res> {
  factory _$$PinErrorImplCopyWith(
          _$PinErrorImpl value, $Res Function(_$PinErrorImpl) then) =
      __$$PinErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({TvDevice device, int attemptsLeft, String message});

  $TvDeviceCopyWith<$Res> get device;
}

/// @nodoc
class __$$PinErrorImplCopyWithImpl<$Res>
    extends _$PairingStatusCopyWithImpl<$Res, _$PinErrorImpl>
    implements _$$PinErrorImplCopyWith<$Res> {
  __$$PinErrorImplCopyWithImpl(
      _$PinErrorImpl _value, $Res Function(_$PinErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? device = null,
    Object? attemptsLeft = null,
    Object? message = null,
  }) {
    return _then(_$PinErrorImpl(
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

class _$PinErrorImpl implements PinError {
  const _$PinErrorImpl(this.device, this.attemptsLeft, this.message);

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
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PinErrorImpl &&
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
  _$$PinErrorImplCopyWith<_$PinErrorImpl> get copyWith =>
      __$$PinErrorImplCopyWithImpl<_$PinErrorImpl>(this, _$identity);

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
      _$PinErrorImpl;

  TvDevice get device;
  int get attemptsLeft;
  String get message;
  @JsonKey(ignore: true)
  _$$PinErrorImplCopyWith<_$PinErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
