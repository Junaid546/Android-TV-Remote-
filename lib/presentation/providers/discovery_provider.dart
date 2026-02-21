import 'package:atv_remote/domain/entities/tv_device.dart';
import 'package:atv_remote/presentation/providers/use_case_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'discovery_provider.g.dart';

@riverpod
class DiscoveryNotifier extends _$DiscoveryNotifier {
  @override
  Stream<List<TvDevice>> build() async* {
    final useCase = ref.watch(discoveryUseCasesProvider);

    // Auto-start discovery when built? Usually yes for discovery screen.
    // However, we might want to trigger it manually.
    // For now, we'll just yield the device stream.

    yield* useCase.deviceStream.map((event) => event.getOrElse((l) => []));
  }

  Future<void> startDiscovery() async {
    await ref.read(discoveryUseCasesProvider).startDiscovery();
  }

  Future<void> stopDiscovery() async {
    await ref.read(discoveryUseCasesProvider).stopDiscovery();
  }
}
