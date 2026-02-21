import 'package:atv_remote/domain/entities/tv_device.dart';
import 'package:atv_remote/presentation/providers/use_case_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'discovery_provider.g.dart';

@riverpod
class DiscoveryNotifier extends _$DiscoveryNotifier {
  @override
  Stream<List<TvDevice>> build() async* {
    yield* ref
        .watch(discoveryDeviceStreamUseCaseProvider)
        .call()
        .map((result) => result.getOrElse((l) => []));
  }

  Future<void> startDiscovery() async {
    await ref.read(startDiscoveryUseCaseProvider).call();
  }

  Future<void> stopDiscovery() async {
    await ref.read(stopDiscoveryUseCaseProvider).call();
  }
}
