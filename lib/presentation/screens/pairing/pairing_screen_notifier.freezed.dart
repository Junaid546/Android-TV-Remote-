// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pairing_screen_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PairingScreenState {
  String get pin => throw _privateConstructorUsedError;
  bool get isSubmitting => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  int get attemptsLeft => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PairingScreenStateCopyWith<PairingScreenState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PairingScreenStateCopyWith<$Res> {
  factory $PairingScreenStateCopyWith(
    PairingScreenState value,
    $Res Function(PairingScreenState) then,
  ) = _$PairingScreenStateCopyWithImpl<$Res, PairingScreenState>;
  @useResult
  $Res call({
    String pin,
    bool isSubmitting,
    String? errorMessage,
    int attemptsLeft,
  });
}

/// @nodoc
class _$PairingScreenStateCopyWithImpl<$Res, $Val extends PairingScreenState>
    implements $PairingScreenStateCopyWith<$Res> {
  _$PairingScreenStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pin = null,
    Object? isSubmitting = null,
    Object? errorMessage = freezed,
    Object? attemptsLeft = null,
  }) {
    return _then(
      _value.copyWith(
            pin: null == pin
                ? _value.pin
                : pin // ignore: cast_nullable_to_non_nullable
                      as String,
            isSubmitting: null == isSubmitting
                ? _value.isSubmitting
                : isSubmitting // ignore: cast_nullable_to_non_nullable
                      as bool,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
            attemptsLeft: null == attemptsLeft
                ? _value.attemptsLeft
                : attemptsLeft // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PairingScreenStateImplCopyWith<$Res>
    implements $PairingScreenStateCopyWith<$Res> {
  factory _$$PairingScreenStateImplCopyWith(
    _$PairingScreenStateImpl value,
    $Res Function(_$PairingScreenStateImpl) then,
  ) = __$$PairingScreenStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String pin,
    bool isSubmitting,
    String? errorMessage,
    int attemptsLeft,
  });
}

/// @nodoc
class __$$PairingScreenStateImplCopyWithImpl<$Res>
    extends _$PairingScreenStateCopyWithImpl<$Res, _$PairingScreenStateImpl>
    implements _$$PairingScreenStateImplCopyWith<$Res> {
  __$$PairingScreenStateImplCopyWithImpl(
    _$PairingScreenStateImpl _value,
    $Res Function(_$PairingScreenStateImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pin = null,
    Object? isSubmitting = null,
    Object? errorMessage = freezed,
    Object? attemptsLeft = null,
  }) {
    return _then(
      _$PairingScreenStateImpl(
        pin: null == pin
            ? _value.pin
            : pin // ignore: cast_nullable_to_non_nullable
                  as String,
        isSubmitting: null == isSubmitting
            ? _value.isSubmitting
            : isSubmitting // ignore: cast_nullable_to_non_nullable
                  as bool,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
        attemptsLeft: null == attemptsLeft
            ? _value.attemptsLeft
            : attemptsLeft // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$PairingScreenStateImpl implements _PairingScreenState {
  const _$PairingScreenStateImpl({
    required this.pin,
    required this.isSubmitting,
    this.errorMessage,
    required this.attemptsLeft,
  });

  @override
  final String pin;
  @override
  final bool isSubmitting;
  @override
  final String? errorMessage;
  @override
  final int attemptsLeft;

  @override
  String toString() {
    return 'PairingScreenState(pin: $pin, isSubmitting: $isSubmitting, errorMessage: $errorMessage, attemptsLeft: $attemptsLeft)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PairingScreenStateImpl &&
            (identical(other.pin, pin) || other.pin == pin) &&
            (identical(other.isSubmitting, isSubmitting) ||
                other.isSubmitting == isSubmitting) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.attemptsLeft, attemptsLeft) ||
                other.attemptsLeft == attemptsLeft));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, pin, isSubmitting, errorMessage, attemptsLeft);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PairingScreenStateImplCopyWith<_$PairingScreenStateImpl> get copyWith =>
      __$$PairingScreenStateImplCopyWithImpl<_$PairingScreenStateImpl>(
        this,
        _$identity,
      );
}

abstract class _PairingScreenState implements PairingScreenState {
  const factory _PairingScreenState({
    required final String pin,
    required final bool isSubmitting,
    final String? errorMessage,
    required final int attemptsLeft,
  }) = _$PairingScreenStateImpl;

  @override
  String get pin;
  @override
  bool get isSubmitting;
  @override
  String? get errorMessage;
  @override
  int get attemptsLeft;
  @override
  @JsonKey(ignore: true)
  _$$PairingScreenStateImplCopyWith<_$PairingScreenStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
