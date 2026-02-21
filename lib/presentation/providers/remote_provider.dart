import 'package:atv_remote/core/constants/key_codes.dart';
import 'package:atv_remote/core/errors/failures.dart';
import 'package:atv_remote/domain/entities/remote_command.dart';
import 'package:atv_remote/presentation/providers/use_case_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'remote_provider.g.dart';

@Riverpod(keepAlive: true)
class RemoteNotifier extends _$RemoteNotifier {
  @override
  bool build() => false;

  Future<void> sendCommand(RemoteCommand command) async {
    final result = await ref.read(sendCommandUseCaseProvider)(command);
    result.fold(
      (failure) => ref.read(remoteErrorProvider.notifier).emit(failure),
      (_) {},
    );
  }

  Future<void> sendKey(
    String commandName, {
    KeyAction action = KeyAction.downUp,
  }) async {
    final keyCode = KeyCodes.fromName(commandName);
    if (keyCode == null) return;

    final command = RemoteCommand.keyCommand(keyCode: keyCode, action: action);
    await sendCommand(command);
  }
}

@riverpod
class RemoteError extends _$RemoteError {
  @override
  Failure? build() => null;

  void emit(Failure f) {
    state = f;
    Future.delayed(const Duration(seconds: 2), () => state = null);
  }
}
