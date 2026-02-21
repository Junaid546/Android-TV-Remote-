import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_command.freezed.dart';

enum KeyAction { down, up, downUp }

@freezed
sealed class RemoteCommand with _$RemoteCommand {
  const factory RemoteCommand.keyCommand({
    required int keyCode,
    required KeyAction action,
  }) = KeyCommand;

  const factory RemoteCommand.textCommand({required String text}) = TextCommand;

  const factory RemoteCommand.wakeCommand() = WakeCommand;
}
