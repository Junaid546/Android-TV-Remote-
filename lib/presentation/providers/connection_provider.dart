import 'dart:async';
import 'package:atv_remote/core/constants/app_constants.dart';
import 'package:atv_remote/core/errors/failures.dart';
import 'package:atv_remote/core/utils/failure_mapper.dart';
import 'package:atv_remote/domain/entities/pairing_status.dart';
import 'package:atv_remote/domain/entities/remote_session_status.dart';
import 'package:atv_remote/domain/entities/tv_device.dart';
import 'package:atv_remote/presentation/providers/repository_providers.dart';
import 'package:atv_remote/presentation/providers/saved_devices_provider.dart';
import 'package:atv_remote/presentation/providers/use_case_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'connection_provider.g.dart';

@Riverpod(keepAlive: true)
class ConnectionNotifier extends _$ConnectionNotifier {
  StreamSubscription? _pairingSubscription;
  StreamSubscription? _remoteSubscription;
  TvDevice? _activeDevice;
  bool _pairingFallbackInProgress = false;

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
        if (state is! Reconnecting) {
          state = PairingStatus.connecting(device);
        }
      case RemoteSessionReconnecting():
        final attempt = remoteStatus.attempt <= 0 ? 1 : remoteStatus.attempt;
        state = PairingStatus.reconnecting(device, attempt);
      case RemoteSessionConnected():
        final normalized = _normalizeRemoteDevice(device);
        _activeDevice = normalized;
        _pairingFallbackInProgress = false;
        state = PairingStatus.connected(normalized);
        unawaited(_persistConnectedDevice(normalized));
      case RemoteSessionFailed():
        if (remoteStatus.reason == 'REPAIRING_NEEDED' &&
            !_pairingFallbackInProgress) {
          _pairingFallbackInProgress = true;
          final fallback = device.copyWith(
            isPaired: false,
            port: AppConstants.kPairingPort,
          );
          _activeDevice = fallback;
          state = PairingStatus.connecting(fallback);
          unawaited(_startPairing(fallback));
          return;
        }

        state = PairingStatus.connectionFailed(
          device,
          PairingFailure(_mapRemoteFailureReason(remoteStatus.reason)),
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
    _pairingFallbackInProgress = false;
    final pairedOnNative = await _isPairedOnNative(device);
    if (!pairedOnNative) {
      final pairingTarget = device.copyWith(
        isPaired: false,
        port: AppConstants.kPairingPort,
      );
      _activeDevice = pairingTarget;
      await _startPairing(pairingTarget);
      return;
    }

    final remoteTarget = _normalizeRemoteDevice(device);
    _activeDevice = remoteTarget;
    state = PairingStatus.connecting(remoteTarget);
    await _connectRemote(remoteTarget);
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
    state = PairingStatus.connecting(normalized);
    await _connectRemote(normalized);
  }

  Future<void> disconnect() async {
    await ref.read(disconnectUseCaseProvider)();
    await ref.read(disconnectRemoteUseCaseProvider)();
    _pairingFallbackInProgress = false;
    _activeDevice = null;
    state = const PairingStatus.idle();
  }

  Future<void> forgetDevice(TvDevice device) async {
    final active = _activeDevice ?? state.device;
    if (active != null && active.ipAddress == device.ipAddress) {
      await disconnect();
    }

    final forgetResult = await ref.read(forgetPairedDeviceUseCaseProvider)(
      device.ipAddress,
    );
    final forgetFailure = forgetResult.fold((failure) => failure, (_) => null);
    if (forgetFailure != null) {
      throw forgetFailure.userMessage;
    }

    final removeResult = await ref.read(removeDeviceUseCaseProvider)(device.id);
    final removeFailure = removeResult.fold((failure) => failure, (_) => null);
    if (removeFailure != null) {
      throw removeFailure.userMessage;
    }

    ref.invalidate(savedDevicesNotifierProvider);
  }

  Future<void> _startPairing(TvDevice device) async {
    state = PairingStatus.connecting(device);
    final useCase = ref.read(connectToDeviceUseCaseProvider);

    final result = await useCase(device.copyWith(isPaired: false));
    result.fold(
      (failure) => state = PairingStatus.connectionFailed(device, failure),
      (_) {
        // State updates continue via native pairing stream.
      },
    );
  }

  Future<void> _persistConnectedDevice(TvDevice device) async {
    final withTimestamp = device.copyWith(lastConnected: DateTime.now());

    final updateResult = await ref.read(updateDeviceUseCaseProvider)(
      withTimestamp,
    );
    final shouldFallbackToSave = updateResult.fold((_) => true, (_) => false);
    if (shouldFallbackToSave) {
      await ref.read(saveDeviceUseCaseProvider)(withTimestamp);
    }

    ref.invalidate(savedDevicesNotifierProvider);
  }

  Future<bool> _isPairedOnNative(TvDevice device) async {
    if (!device.isPaired) return false;
    final result = await ref.read(isDevicePairedUseCaseProvider)(
      device.ipAddress,
    );
    return result.fold((_) => false, (paired) => paired);
  }

  String _mapRemoteFailureReason(String reason) {
    final normalized = reason.trim();
    if (normalized.isEmpty) {
      return 'Remote session failed. Please reconnect.';
    }
    switch (normalized) {
      case 'PROTOCOL_NEGOTIATION_TIMEOUT':
        return 'Remote protocol negotiation timed out. Try reconnecting.';
      case 'IDLE_TIMEOUT':
        return 'Connection timed out while idle. Trying to reconnect.';
      case 'REPAIRING_NEEDED':
        return 'Pairing is required again for this TV.';
      default:
        return normalized;
    }
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
