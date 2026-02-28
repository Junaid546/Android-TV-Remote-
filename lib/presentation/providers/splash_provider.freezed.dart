// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'splash_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$SplashResult {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() noWifi,
    required TResult Function(TvDevice device) reconnected,
    required TResult Function() readyToDiscover,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? noWifi,
    TResult? Function(TvDevice device)? reconnected,
    TResult? Function()? readyToDiscover,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? noWifi,
    TResult Function(TvDevice device)? reconnected,
    TResult Function()? readyToDiscover,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NoWifi value) noWifi,
    required TResult Function(Reconnected value) reconnected,
    required TResult Function(ReadyToDiscover value) readyToDiscover,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NoWifi value)? noWifi,
    TResult? Function(Reconnected value)? reconnected,
    TResult? Function(ReadyToDiscover value)? readyToDiscover,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NoWifi value)? noWifi,
    TResult Function(Reconnected value)? reconnected,
    TResult Function(ReadyToDiscover value)? readyToDiscover,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SplashResultCopyWith<$Res> {
  factory $SplashResultCopyWith(
    SplashResult value,
    $Res Function(SplashResult) then,
  ) = _$SplashResultCopyWithImpl<$Res, SplashResult>;
}

/// @nodoc
class _$SplashResultCopyWithImpl<$Res, $Val extends SplashResult>
    implements $SplashResultCopyWith<$Res> {
  _$SplashResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$NoWifiImplCopyWith<$Res> {
  factory _$$NoWifiImplCopyWith(
    _$NoWifiImpl value,
    $Res Function(_$NoWifiImpl) then,
  ) = __$$NoWifiImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$NoWifiImplCopyWithImpl<$Res>
    extends _$SplashResultCopyWithImpl<$Res, _$NoWifiImpl>
    implements _$$NoWifiImplCopyWith<$Res> {
  __$$NoWifiImplCopyWithImpl(
    _$NoWifiImpl _value,
    $Res Function(_$NoWifiImpl) _then,
  ) : super(_value, _then);
}

/// @nodoc

class _$NoWifiImpl implements NoWifi {
  const _$NoWifiImpl();

  @override
  String toString() {
    return 'SplashResult.noWifi()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$NoWifiImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() noWifi,
    required TResult Function(TvDevice device) reconnected,
    required TResult Function() readyToDiscover,
  }) {
    return noWifi();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? noWifi,
    TResult? Function(TvDevice device)? reconnected,
    TResult? Function()? readyToDiscover,
  }) {
    return noWifi?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? noWifi,
    TResult Function(TvDevice device)? reconnected,
    TResult Function()? readyToDiscover,
    required TResult orElse(),
  }) {
    if (noWifi != null) {
      return noWifi();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NoWifi value) noWifi,
    required TResult Function(Reconnected value) reconnected,
    required TResult Function(ReadyToDiscover value) readyToDiscover,
  }) {
    return noWifi(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NoWifi value)? noWifi,
    TResult? Function(Reconnected value)? reconnected,
    TResult? Function(ReadyToDiscover value)? readyToDiscover,
  }) {
    return noWifi?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NoWifi value)? noWifi,
    TResult Function(Reconnected value)? reconnected,
    TResult Function(ReadyToDiscover value)? readyToDiscover,
    required TResult orElse(),
  }) {
    if (noWifi != null) {
      return noWifi(this);
    }
    return orElse();
  }
}

abstract class NoWifi implements SplashResult {
  const factory NoWifi() = _$NoWifiImpl;
}

/// @nodoc
abstract class _$$ReconnectedImplCopyWith<$Res> {
  factory _$$ReconnectedImplCopyWith(
    _$ReconnectedImpl value,
    $Res Function(_$ReconnectedImpl) then,
  ) = __$$ReconnectedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({TvDevice device});

  $TvDeviceCopyWith<$Res> get device;
}

/// @nodoc
class __$$ReconnectedImplCopyWithImpl<$Res>
    extends _$SplashResultCopyWithImpl<$Res, _$ReconnectedImpl>
    implements _$$ReconnectedImplCopyWith<$Res> {
  __$$ReconnectedImplCopyWithImpl(
    _$ReconnectedImpl _value,
    $Res Function(_$ReconnectedImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? device = null}) {
    return _then(
      _$ReconnectedImpl(
        null == device
            ? _value.device
            : device // ignore: cast_nullable_to_non_nullable
                  as TvDevice,
      ),
    );
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

class _$ReconnectedImpl implements Reconnected {
  const _$ReconnectedImpl(this.device);

  @override
  final TvDevice device;

  @override
  String toString() {
    return 'SplashResult.reconnected(device: $device)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReconnectedImpl &&
            (identical(other.device, device) || other.device == device));
  }

  @override
  int get hashCode => Object.hash(runtimeType, device);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReconnectedImplCopyWith<_$ReconnectedImpl> get copyWith =>
      __$$ReconnectedImplCopyWithImpl<_$ReconnectedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() noWifi,
    required TResult Function(TvDevice device) reconnected,
    required TResult Function() readyToDiscover,
  }) {
    return reconnected(device);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? noWifi,
    TResult? Function(TvDevice device)? reconnected,
    TResult? Function()? readyToDiscover,
  }) {
    return reconnected?.call(device);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? noWifi,
    TResult Function(TvDevice device)? reconnected,
    TResult Function()? readyToDiscover,
    required TResult orElse(),
  }) {
    if (reconnected != null) {
      return reconnected(device);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NoWifi value) noWifi,
    required TResult Function(Reconnected value) reconnected,
    required TResult Function(ReadyToDiscover value) readyToDiscover,
  }) {
    return reconnected(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NoWifi value)? noWifi,
    TResult? Function(Reconnected value)? reconnected,
    TResult? Function(ReadyToDiscover value)? readyToDiscover,
  }) {
    return reconnected?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NoWifi value)? noWifi,
    TResult Function(Reconnected value)? reconnected,
    TResult Function(ReadyToDiscover value)? readyToDiscover,
    required TResult orElse(),
  }) {
    if (reconnected != null) {
      return reconnected(this);
    }
    return orElse();
  }
}

abstract class Reconnected implements SplashResult {
  const factory Reconnected(final TvDevice device) = _$ReconnectedImpl;

  TvDevice get device;
  @JsonKey(ignore: true)
  _$$ReconnectedImplCopyWith<_$ReconnectedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ReadyToDiscoverImplCopyWith<$Res> {
  factory _$$ReadyToDiscoverImplCopyWith(
    _$ReadyToDiscoverImpl value,
    $Res Function(_$ReadyToDiscoverImpl) then,
  ) = __$$ReadyToDiscoverImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ReadyToDiscoverImplCopyWithImpl<$Res>
    extends _$SplashResultCopyWithImpl<$Res, _$ReadyToDiscoverImpl>
    implements _$$ReadyToDiscoverImplCopyWith<$Res> {
  __$$ReadyToDiscoverImplCopyWithImpl(
    _$ReadyToDiscoverImpl _value,
    $Res Function(_$ReadyToDiscoverImpl) _then,
  ) : super(_value, _then);
}

/// @nodoc

class _$ReadyToDiscoverImpl implements ReadyToDiscover {
  const _$ReadyToDiscoverImpl();

  @override
  String toString() {
    return 'SplashResult.readyToDiscover()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ReadyToDiscoverImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() noWifi,
    required TResult Function(TvDevice device) reconnected,
    required TResult Function() readyToDiscover,
  }) {
    return readyToDiscover();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? noWifi,
    TResult? Function(TvDevice device)? reconnected,
    TResult? Function()? readyToDiscover,
  }) {
    return readyToDiscover?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? noWifi,
    TResult Function(TvDevice device)? reconnected,
    TResult Function()? readyToDiscover,
    required TResult orElse(),
  }) {
    if (readyToDiscover != null) {
      return readyToDiscover();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NoWifi value) noWifi,
    required TResult Function(Reconnected value) reconnected,
    required TResult Function(ReadyToDiscover value) readyToDiscover,
  }) {
    return readyToDiscover(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NoWifi value)? noWifi,
    TResult? Function(Reconnected value)? reconnected,
    TResult? Function(ReadyToDiscover value)? readyToDiscover,
  }) {
    return readyToDiscover?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NoWifi value)? noWifi,
    TResult Function(Reconnected value)? reconnected,
    TResult Function(ReadyToDiscover value)? readyToDiscover,
    required TResult orElse(),
  }) {
    if (readyToDiscover != null) {
      return readyToDiscover(this);
    }
    return orElse();
  }
}

abstract class ReadyToDiscover implements SplashResult {
  const factory ReadyToDiscover() = _$ReadyToDiscoverImpl;
}
