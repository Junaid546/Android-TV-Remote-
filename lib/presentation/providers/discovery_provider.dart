import 'dart:async';
import 'package:atv_remote/core/errors/failures.dart';
import 'package:atv_remote/domain/entities/tv_device.dart';
import 'package:atv_remote/presentation/providers/repository_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'discovery_provider.g.dart';

@Riverpod(keepAlive: true)
class DiscoveryNotifier extends _$DiscoveryNotifier {
  StreamSubscription? _subscription;

  @override
  AsyncValue<List<TvDevice>> build() {
    ref.onDispose(() {
      _subscription?.cancel();
      _stopDiscovery();
    });
    return const AsyncData([]);
  }

  Future<void> startDiscovery() async {
    state = const AsyncLoading();
    final repo = ref.read(discoveryRepositoryProvider);

    final startResult = await repo.startDiscovery();
    startResult.fold(
      (failure) => state = AsyncError(failure, StackTrace.current),
      (_) {
        _subscription = repo.deviceStream.listen(
          (either) => either.fold(
            (failure) => state = AsyncError(failure, StackTrace.current),
            (devices) => state = AsyncData(devices),
          ),
          onError: (e, s) => state = AsyncError(e, s),
        );
      },
    );
  }

  Future<void> stopDiscovery() => _stopDiscovery();

  Future<void> _stopDiscovery() async {
    await _subscription?.cancel();
    _subscription = null;
    await ref.read(discoveryRepositoryProvider).stopDiscovery();
  }

  Future<void> addManualDevice(String ip, String name) async {
    final result = await ref
        .read(discoveryRepositoryProvider)
        .addManualDevice(ip, name);
    result.fold((failure) => _emitError(failure), (device) {
      state.whenData((devices) {
        if (!devices.any((d) => d.ipAddress == ip)) {
          state = AsyncData([...devices, device]);
        }
      });
    });
  }

  void _emitError(Failure failure) {
    ref.read(discoveryErrorProvider.notifier).emit(failure);
  }
}

@riverpod
class DiscoveryError extends _$DiscoveryError {
  @override
  Failure? build() => null;

  void emit(Failure f) {
    state = f;
    Future.delayed(const Duration(seconds: 3), () => state = null);
  }

  void clear() => state = null;
}
