import 'dart:async';
import 'package:atv_remote/core/constants/app_constants.dart';
import 'package:atv_remote/core/errors/failures.dart';
import 'package:atv_remote/domain/entities/pairing_status.dart';
import 'package:atv_remote/domain/entities/remote_session_status.dart';
import 'package:atv_remote/domain/entities/tv_device.dart';
import 'package:atv_remote/presentation/providers/repository_providers.dart';
import 'package:atv_remote/presentation/providers/use_case_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connection_provider.g.dart';

@Riverpod(keepAlive: true)
class ConnectionNotifier extends _$ConnectionNotifier {
  StreamSubscription? _pairingSubscription;
  StreamSubscription? _remoteSubscription;
  TvDevice? _activeDevice;

  @override
  PairingStatus build() {
    ref.onDispose(() {
      _pairingSubscription?.cancel();
      _remoteSubscription?.cancel();
    });
    _listenToPairingEvents();
    _listenToRemoteEvents();
    return const PairingStatus.idle();
  }

  void _listenToPairingEvents() {
    final pairingRepo = ref.read(pairingRepositoryProvider);
    _pairingSubscription = pairingRepo.statusStream.listen(
      (either) => either.fold(
        (failure) => state = PairingStatus.connectionFailed(
          _activeDevice ??
              state.device ??
              const TvDevice(
                id: '',
                name: 'Unknown',
                ipAddress: '',
                port: AppConstants.kRemotePort,
              ),
          failure,
        ),
        _handlePairingStatus,
      ),
      onError: (e) => state = PairingStatus.connectionFailed(
        _activeDevice ??
            state.device ??
            const TvDevice(
              id: '',
              name: 'Unknown',
              ipAddress: '',
              port: AppConstants.kRemotePort,
            ),
        UnknownFailure(e.toString(), null),
      ),
    );
  }

  void _listenToRemoteEvents() {
    final useCase = ref.read(remoteConnectionStateStreamUseCaseProvider);
    _remoteSubscription = useCase().listen(
      (either) => either.fold((failure) {
        final device = _activeDevice ?? state.device;
        if (device == null) return;
        state = PairingStatus.connectionFailed(device, failure);
      }, _handleRemoteStatus),
      onError: (e) {
        final device = _activeDevice ?? state.device;
        if (device == null) return;
        state = PairingStatus.connectionFailed(
          device,
          UnknownFailure(e.toString(), null),
        );
      },
    );
  }

  void _handlePairingStatus(PairingStatus pairingStatus) {
    if (pairingStatus is Paired) {
      final device = _normalizeRemoteDevice(pairingStatus.device);
      _activeDevice = device;
      state = PairingStatus.paired(device);
      unawaited(_connectRemote(device));
      return;
    }

    if (pairingStatus is Connected) {
      _activeDevice = _normalizeRemoteDevice(pairingStatus.device);
    } else if (pairingStatus is Disconnected &&
        pairingStatus.lastDevice == null) {
      _activeDevice = null;
    }

    state = pairingStatus;
  }

  void _handleRemoteStatus(RemoteSessionStatus remoteStatus) {
    final device = _activeDevice ?? state.device;
    if (device == null) return;

    switch (remoteStatus) {
      case RemoteSessionConnecting():
        state = PairingStatus.reconnecting(device, 0);
      case RemoteSessionReconnecting():
        state = PairingStatus.reconnecting(device, remoteStatus.attempt);
      case RemoteSessionConnected():
        final normalized = _normalizeRemoteDevice(device);
        _activeDevice = normalized;
        state = PairingStatus.connected(normalized);
      case RemoteSessionFailed():
        state = PairingStatus.connectionFailed(
          device,
          PairingFailure(
            remoteStatus.reason.isEmpty
                ? 'Remote session failed. Please reconnect.'
                : remoteStatus.reason,
          ),
        );
      case RemoteSessionDisconnected():
        state = PairingStatus.disconnected(
          device,
          'Remote session disconnected',
        );
    }
  }

  Future<void> _connectRemote(TvDevice device) async {
    final normalized = _normalizeRemoteDevice(device);
    final result = await ref.read(connectRemoteUseCaseProvider)(normalized);
    result.fold(
      (failure) => state = PairingStatus.connectionFailed(normalized, failure),
      (_) {
        // State transitions are driven by remote event stream.
      },
    );
  }

  TvDevice _normalizeRemoteDevice(TvDevice device) {
    return device.copyWith(port: AppConstants.kRemotePort, isPaired: true);
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
    if (state is! AwaitingPin) {
      final device = state.device;
      if (device != null) {
        state = PairingStatus.connectionFailed(
          device,
          const PairingFailure(
            'Pairing session is not ready. Tap Retry pairing.',
          ),
        );
      }
      return;
    }

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

  Future<void> retryPairing() async {
    final device = state.device;
    if (device == null) return;
    await connectToDevice(device);
  }

  Future<void> reconnectRemote() async {
    final device = _activeDevice ?? state.device;
    if (device == null) return;
    final normalized = _normalizeRemoteDevice(device);
    _activeDevice = normalized;
    state = PairingStatus.reconnecting(normalized, 0);
    await _connectRemote(normalized);
  }

  Future<void> disconnect() async {
    await ref.read(disconnectUseCaseProvider)();
    await ref.read(disconnectRemoteUseCaseProvider)();
    _activeDevice = null;
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

  bool get isConnected => this is Connected;
  bool get hasActiveSession => maybeWhen(
    connecting: (_) => true,
    awaitingPin: (_, expiresInSeconds) => true,
    pinVerified: (_) => true,
    paired: (_) => true,
    connected: (_) => true,
    reconnecting: (_, attempt) => true,
    connectionFailed: (device, failure) =>
        device.id.isNotEmpty && device.ipAddress.isNotEmpty,
    pinError: (device, attemptsLeft, message) =>
        device.id.isNotEmpty && device.ipAddress.isNotEmpty,
    disconnected: (lastDevice, _) =>
        lastDevice != null &&
        lastDevice.id.isNotEmpty &&
        lastDevice.ipAddress.isNotEmpty,
    orElse: () => false,
  );
}
