import 'package:atv_remote/core/constants/key_codes.dart';
import 'package:atv_remote/core/errors/failures.dart';
import 'package:atv_remote/domain/entities/remote_command.dart';
import 'package:atv_remote/presentation/providers/repository_providers.dart';
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

class RemoteVolumeState {
  const RemoteVolumeState({
    required this.level,
    required this.max,
    required this.muted,
  });

  final int level;
  final int max;
  final bool muted;

  int get levelOnTen {
    if (max <= 0) return 0;
    return ((level / max) * 10).round().clamp(0, 10);
  }
}

final remoteVolumeStateStreamProvider = StreamProvider<RemoteVolumeState>((
  ref,
) {
  final dataSource = ref.watch(remoteNativeDataSourceProvider);
  return dataSource.volumeStateStream.map((event) {
    final level = (event['level'] as int?) ?? 0;
    final max = (event['max'] as int?) ?? 0;
    final muted = (event['muted'] as bool?) ?? false;
    return RemoteVolumeState(level: level, max: max, muted: muted);
  });
});

@riverpod
class RemoteError extends _$RemoteError {
  @override
  Failure? build() => null;

  void emit(Failure f) {
    state = f;
    Future.delayed(const Duration(seconds: 2), () => state = null);
  }
}
