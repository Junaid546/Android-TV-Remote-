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
    final useCase = ref.watch(remoteUseCasesProvider);
    final pairingState = ref.watch(pairingNotifierProvider);
    final device = pairingState.valueOrNull?.maybeWhen(
      idle: () => null,
      discoveryStarted: () => null,
      devicesFound: (_) => null,
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

    yield* useCase.connectionAlive.map(
      (alive) => RemoteState(
        device: device,
        isConnected: alive.getOrElse((l) => false),
      ),
    );
  }

  Future<void> sendCommand(RemoteCommand command) async {
    await ref.read(remoteUseCasesProvider).sendCommand(command);
  }
}
