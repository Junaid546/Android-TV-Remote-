// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'remote_command.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RemoteCommand {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int keyCode, KeyAction action) keyCommand,
    required TResult Function(String text) textCommand,
    required TResult Function() wakeCommand,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int keyCode, KeyAction action)? keyCommand,
    TResult? Function(String text)? textCommand,
    TResult? Function()? wakeCommand,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int keyCode, KeyAction action)? keyCommand,
    TResult Function(String text)? textCommand,
    TResult Function()? wakeCommand,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(KeyCommand value) keyCommand,
    required TResult Function(TextCommand value) textCommand,
    required TResult Function(WakeCommand value) wakeCommand,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(KeyCommand value)? keyCommand,
    TResult? Function(TextCommand value)? textCommand,
    TResult? Function(WakeCommand value)? wakeCommand,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(KeyCommand value)? keyCommand,
    TResult Function(TextCommand value)? textCommand,
    TResult Function(WakeCommand value)? wakeCommand,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RemoteCommandCopyWith<$Res> {
  factory $RemoteCommandCopyWith(
          RemoteCommand value, $Res Function(RemoteCommand) then) =
      _$RemoteCommandCopyWithImpl<$Res, RemoteCommand>;
}

/// @nodoc
class _$RemoteCommandCopyWithImpl<$Res, $Val extends RemoteCommand>
    implements $RemoteCommandCopyWith<$Res> {
  _$RemoteCommandCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$KeyCommandImplCopyWith<$Res> {
  factory _$$KeyCommandImplCopyWith(
          _$KeyCommandImpl value, $Res Function(_$KeyCommandImpl) then) =
      __$$KeyCommandImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int keyCode, KeyAction action});
}

/// @nodoc
class __$$KeyCommandImplCopyWithImpl<$Res>
    extends _$RemoteCommandCopyWithImpl<$Res, _$KeyCommandImpl>
    implements _$$KeyCommandImplCopyWith<$Res> {
  __$$KeyCommandImplCopyWithImpl(
      _$KeyCommandImpl _value, $Res Function(_$KeyCommandImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? keyCode = null,
    Object? action = null,
  }) {
    return _then(_$KeyCommandImpl(
      keyCode: null == keyCode
          ? _value.keyCode
          : keyCode // ignore: cast_nullable_to_non_nullable
              as int,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as KeyAction,
    ));
  }
}

/// @nodoc

class _$KeyCommandImpl implements KeyCommand {
  const _$KeyCommandImpl({required this.keyCode, required this.action});

  @override
  final int keyCode;
  @override
  final KeyAction action;

  @override
  String toString() {
    return 'RemoteCommand.keyCommand(keyCode: $keyCode, action: $action)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$KeyCommandImpl &&
            (identical(other.keyCode, keyCode) || other.keyCode == keyCode) &&
            (identical(other.action, action) || other.action == action));
  }

  @override
  int get hashCode => Object.hash(runtimeType, keyCode, action);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$KeyCommandImplCopyWith<_$KeyCommandImpl> get copyWith =>
      __$$KeyCommandImplCopyWithImpl<_$KeyCommandImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int keyCode, KeyAction action) keyCommand,
    required TResult Function(String text) textCommand,
    required TResult Function() wakeCommand,
  }) {
    return keyCommand(keyCode, action);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int keyCode, KeyAction action)? keyCommand,
    TResult? Function(String text)? textCommand,
    TResult? Function()? wakeCommand,
  }) {
    return keyCommand?.call(keyCode, action);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int keyCode, KeyAction action)? keyCommand,
    TResult Function(String text)? textCommand,
    TResult Function()? wakeCommand,
    required TResult orElse(),
  }) {
    if (keyCommand != null) {
      return keyCommand(keyCode, action);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(KeyCommand value) keyCommand,
    required TResult Function(TextCommand value) textCommand,
    required TResult Function(WakeCommand value) wakeCommand,
  }) {
    return keyCommand(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(KeyCommand value)? keyCommand,
    TResult? Function(TextCommand value)? textCommand,
    TResult? Function(WakeCommand value)? wakeCommand,
  }) {
    return keyCommand?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(KeyCommand value)? keyCommand,
    TResult Function(TextCommand value)? textCommand,
    TResult Function(WakeCommand value)? wakeCommand,
    required TResult orElse(),
  }) {
    if (keyCommand != null) {
      return keyCommand(this);
    }
    return orElse();
  }
}

abstract class KeyCommand implements RemoteCommand {
  const factory KeyCommand(
      {required final int keyCode,
      required final KeyAction action}) = _$KeyCommandImpl;

  int get keyCode;
  KeyAction get action;
  @JsonKey(ignore: true)
  _$$KeyCommandImplCopyWith<_$KeyCommandImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TextCommandImplCopyWith<$Res> {
  factory _$$TextCommandImplCopyWith(
          _$TextCommandImpl value, $Res Function(_$TextCommandImpl) then) =
      __$$TextCommandImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String text});
}

/// @nodoc
class __$$TextCommandImplCopyWithImpl<$Res>
    extends _$RemoteCommandCopyWithImpl<$Res, _$TextCommandImpl>
    implements _$$TextCommandImplCopyWith<$Res> {
  __$$TextCommandImplCopyWithImpl(
      _$TextCommandImpl _value, $Res Function(_$TextCommandImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
  }) {
    return _then(_$TextCommandImpl(
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$TextCommandImpl implements TextCommand {
  const _$TextCommandImpl({required this.text});

  @override
  final String text;

  @override
  String toString() {
    return 'RemoteCommand.textCommand(text: $text)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TextCommandImpl &&
            (identical(other.text, text) || other.text == text));
  }

  @override
  int get hashCode => Object.hash(runtimeType, text);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TextCommandImplCopyWith<_$TextCommandImpl> get copyWith =>
      __$$TextCommandImplCopyWithImpl<_$TextCommandImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int keyCode, KeyAction action) keyCommand,
    required TResult Function(String text) textCommand,
    required TResult Function() wakeCommand,
  }) {
    return textCommand(text);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int keyCode, KeyAction action)? keyCommand,
    TResult? Function(String text)? textCommand,
    TResult? Function()? wakeCommand,
  }) {
    return textCommand?.call(text);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int keyCode, KeyAction action)? keyCommand,
    TResult Function(String text)? textCommand,
    TResult Function()? wakeCommand,
    required TResult orElse(),
  }) {
    if (textCommand != null) {
      return textCommand(text);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(KeyCommand value) keyCommand,
    required TResult Function(TextCommand value) textCommand,
    required TResult Function(WakeCommand value) wakeCommand,
  }) {
    return textCommand(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(KeyCommand value)? keyCommand,
    TResult? Function(TextCommand value)? textCommand,
    TResult? Function(WakeCommand value)? wakeCommand,
  }) {
    return textCommand?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(KeyCommand value)? keyCommand,
    TResult Function(TextCommand value)? textCommand,
    TResult Function(WakeCommand value)? wakeCommand,
    required TResult orElse(),
  }) {
    if (textCommand != null) {
      return textCommand(this);
    }
    return orElse();
  }
}

abstract class TextCommand implements RemoteCommand {
  const factory TextCommand({required final String text}) = _$TextCommandImpl;

  String get text;
  @JsonKey(ignore: true)
  _$$TextCommandImplCopyWith<_$TextCommandImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$WakeCommandImplCopyWith<$Res> {
  factory _$$WakeCommandImplCopyWith(
          _$WakeCommandImpl value, $Res Function(_$WakeCommandImpl) then) =
      __$$WakeCommandImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$WakeCommandImplCopyWithImpl<$Res>
    extends _$RemoteCommandCopyWithImpl<$Res, _$WakeCommandImpl>
    implements _$$WakeCommandImplCopyWith<$Res> {
  __$$WakeCommandImplCopyWithImpl(
      _$WakeCommandImpl _value, $Res Function(_$WakeCommandImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$WakeCommandImpl implements WakeCommand {
  const _$WakeCommandImpl();

  @override
  String toString() {
    return 'RemoteCommand.wakeCommand()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$WakeCommandImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int keyCode, KeyAction action) keyCommand,
    required TResult Function(String text) textCommand,
    required TResult Function() wakeCommand,
  }) {
    return wakeCommand();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int keyCode, KeyAction action)? keyCommand,
    TResult? Function(String text)? textCommand,
    TResult? Function()? wakeCommand,
  }) {
    return wakeCommand?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int keyCode, KeyAction action)? keyCommand,
    TResult Function(String text)? textCommand,
    TResult Function()? wakeCommand,
    required TResult orElse(),
  }) {
    if (wakeCommand != null) {
      return wakeCommand();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(KeyCommand value) keyCommand,
    required TResult Function(TextCommand value) textCommand,
    required TResult Function(WakeCommand value) wakeCommand,
  }) {
    return wakeCommand(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(KeyCommand value)? keyCommand,
    TResult? Function(TextCommand value)? textCommand,
    TResult? Function(WakeCommand value)? wakeCommand,
  }) {
    return wakeCommand?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(KeyCommand value)? keyCommand,
    TResult Function(TextCommand value)? textCommand,
    TResult Function(WakeCommand value)? wakeCommand,
    required TResult orElse(),
  }) {
    if (wakeCommand != null) {
      return wakeCommand(this);
    }
    return orElse();
  }
}

abstract class WakeCommand implements RemoteCommand {
  const factory WakeCommand() = _$WakeCommandImpl;
}
