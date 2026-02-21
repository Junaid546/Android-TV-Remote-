import 'package:atv_remote/domain/entities/pairing_status.dart';
import 'package:atv_remote/domain/entities/tv_device.dart';
import 'package:atv_remote/presentation/providers/use_case_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pairing_provider.g.dart';

@riverpod
class PairingNotifier extends _$PairingNotifier {
  @override
  Stream<PairingStatus> build() async* {
    yield* ref
        .watch(pairingStatusStreamUseCaseProvider)
        .call()
        .map((event) => event.getOrElse((l) => const PairingStatus.idle()));
  }

  Future<void> connectToDevice(TvDevice device) async {
    await ref.read(connectToDeviceUseCaseProvider).call(device);
  }

  Future<void> submitPin(String pin) async {
    await ref.read(submitPinUseCaseProvider).call(pin);
  }

  Future<void> disconnect() async {
    await ref.read(disconnectUseCaseProvider).call();
  }
}
