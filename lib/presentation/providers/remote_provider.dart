import 'package:atv_remote/domain/entities/remote_command.dart';
import 'package:atv_remote/presentation/providers/pairing_provider.dart';
import 'package:atv_remote/presentation/providers/remote_state.dart';
import 'package:atv_remote/presentation/providers/use_case_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'remote_provider.g.dart';

@riverpod
class RemoteNotifier extends _$RemoteNotifier {
  @override
  Stream<RemoteState> build() async* {
    final pairingState = ref.watch(pairingNotifierProvider);
    final device = pairingState.valueOrNull?.maybeWhen(
      connecting: (d) => d,
      awaitingPin: (d, _) => d,
      pinVerified: (d) => d,
      paired: (d) => d,
      connected: (d) => d,
      reconnecting: (d, _) => d,
      connectionFailed: (d, _) => d,
      pinError: (d, _, __) => d,
      disconnected: (d, _) => d,
      orElse: () => null,
    );

    yield* ref
        .watch(remoteConnectionAliveStreamUseCaseProvider)
        .call()
        .map(
          (result) => RemoteState(
            device: device,
            isConnected: result.getOrElse((l) => false),
          ),
        );
  }

  Future<void> sendCommand(RemoteCommand command) async {
    await ref.read(sendCommandUseCaseProvider).call(command);
  }
}
