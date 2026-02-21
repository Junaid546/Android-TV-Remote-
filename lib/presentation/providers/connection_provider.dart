import 'dart:async';
import 'package:atv_remote/core/errors/failures.dart';
import 'package:atv_remote/domain/entities/pairing_status.dart';
import 'package:atv_remote/domain/entities/tv_device.dart';
import 'package:atv_remote/presentation/providers/repository_providers.dart';
import 'package:atv_remote/presentation/providers/use_case_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connection_provider.g.dart';

@Riverpod(keepAlive: true)
class ConnectionNotifier extends _$ConnectionNotifier {
  StreamSubscription? _pairingSubscription;

  @override
  PairingStatus build() {
    ref.onDispose(() {
      _pairingSubscription?.cancel();
    });
    _listenToNativeEvents();
    return const PairingStatus.idle();
  }

  void _listenToNativeEvents() {
    final pairingRepo = ref.read(pairingRepositoryProvider);
    _pairingSubscription = pairingRepo.statusStream.listen(
      (either) => either.fold(
        (failure) => state = PairingStatus.connectionFailed(
          state.device ??
              const TvDevice(id: '', name: 'Unknown', ipAddress: ''),
          failure,
        ),
        (status) => state = status,
      ),
      onError: (e) => state = PairingStatus.connectionFailed(
        state.device ?? const TvDevice(id: '', name: 'Unknown', ipAddress: ''),
        UnknownFailure(e.toString(), null),
      ),
    );
  }

  Future<void> connectToDevice(TvDevice device) async {
    state = PairingStatus.connecting(device);
    final useCase = ref.read(connectToDeviceUseCaseProvider);

    final result = await useCase(device);
    result.fold(
      (failure) => state = PairingStatus.connectionFailed(device, failure),
      (_) {
        /* state updated via stream subscription */
      },
    );
  }

  Future<void> submitPin(String pin) async {
    final useCase = ref.read(submitPinUseCaseProvider);
    final result = await useCase(pin);
    result.fold(
      (failure) => state = PairingStatus.pinError(
        state.device ?? const TvDevice(id: '', name: 'Unknown', ipAddress: ''),
        3,
        failure.toString(),
      ),
      (_) {
        /* state updated via stream */
      },
    );
  }

  Future<void> disconnect() async {
    await ref.read(disconnectUseCaseProvider)();
    state = const PairingStatus.idle();
  }

  bool get isConnected => state is Connected;
  TvDevice? get connectedDevice => state.device;
}

extension PairingStatusX on PairingStatus {
  TvDevice? get device => maybeWhen(
    connecting: (d) => d,
    awaitingPin: (d, _) => d,
    pinVerified: (d) => d,
    paired: (d) => d,
    connected: (d) => d,
    reconnecting: (d, _) => d,
    connectionFailed: (d, _) => d,
    pinError: (d, left, msg) => d,
    disconnected: (d, _) => d,
    orElse: () => null,
  );
}
