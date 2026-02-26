import 'dart:async';

import 'package:atv_remote/core/constants/app_constants.dart';
import 'package:atv_remote/core/errors/failures.dart';
import 'package:atv_remote/domain/entities/pairing_status.dart';
import 'package:atv_remote/domain/entities/remote_command.dart';
import 'package:atv_remote/domain/entities/remote_session_status.dart';
import 'package:atv_remote/domain/entities/tv_device.dart';
import 'package:atv_remote/domain/repositories/device_storage_repository.dart';
import 'package:atv_remote/domain/repositories/pairing_repository.dart';
import 'package:atv_remote/domain/repositories/remote_repository.dart';
import 'package:atv_remote/presentation/providers/connection_provider.dart';
import 'package:atv_remote/presentation/providers/repository_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

class _FakePairingRepository implements PairingRepository {
  final _controller =
      StreamController<Either<Failure, PairingStatus>>.broadcast();
  final Set<String> pairedIps = <String>{};
  TvDevice? lastConnectDevice;
  int connectCalls = 0;
  int forgetCalls = 0;
  String? lastForgottenIp;

  @override
  Stream<Either<Failure, PairingStatus>> get statusStream => _controller.stream;

  @override
  Future<Either<Failure, void>> connectToDevice(TvDevice device) async {
    connectCalls++;
    lastConnectDevice = device;
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> submitPin(String pin) async =>
      const Right(null);

  @override
  Future<Either<Failure, void>> forgetDevice(String ipAddress) async {
    forgetCalls++;
    lastForgottenIp = ipAddress;
    pairedIps.remove(ipAddress);
    return const Right(null);
  }

  @override
  Future<Either<Failure, bool>> isDevicePaired(String ipAddress) async =>
      Right(pairedIps.contains(ipAddress));

  @override
  Future<Either<Failure, void>> disconnect() async => const Right(null);

  void emitStatus(PairingStatus status) => _controller.add(Right(status));

  Future<void> dispose() => _controller.close();
}

class _FakeRemoteRepository implements RemoteRepository {
  final _controller =
      StreamController<Either<Failure, RemoteSessionStatus>>.broadcast();
  TvDevice? lastConnectDevice;
  int disconnectCalls = 0;

  @override
  Stream<Either<Failure, RemoteSessionStatus>> get connectionState =>
      _controller.stream;

  @override
  Stream<Either<Failure, bool>> get connectionAlive =>
      _controller.stream.map((either) {
        return either.map((status) => status is RemoteSessionConnected);
      });

  @override
  Future<Either<Failure, void>> connect(TvDevice device) async {
    lastConnectDevice = device;
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> disconnect() async {
    disconnectCalls++;
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> sendCommand(RemoteCommand command) async =>
      const Right(null);

  void emitState(RemoteSessionStatus status) => _controller.add(Right(status));

  Future<void> dispose() => _controller.close();
}

class _FakeDeviceStorageRepository implements DeviceStorageRepository {
  final List<TvDevice> _devices = <TvDevice>[];
  String? lastRemovedId;

  @override
  Future<Either<Failure, List<TvDevice>>> getSavedDevices() async =>
      Right(List<TvDevice>.from(_devices));

  @override
  Future<Either<Failure, TvDevice?>> getLastConnectedDevice() async {
    if (_devices.isEmpty) return const Right(null);
    return Right(_devices.first);
  }

  @override
  Future<Either<Failure, void>> removeDevice(String deviceId) async {
    lastRemovedId = deviceId;
    _devices.removeWhere((d) => d.id == deviceId);
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> saveDevice(TvDevice device) async {
    _devices.removeWhere((d) => d.id == device.id);
    _devices.add(device);
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> updateDevice(TvDevice device) async {
    _devices.removeWhere((d) => d.id == device.id);
    _devices.add(device);
    return const Right(null);
  }
}

Future<void> _flush() async {
  await Future<void>.delayed(Duration.zero);
  await Future<void>.delayed(Duration.zero);
}

void main() {
  group('ConnectionNotifier orchestration', () {
    late _FakePairingRepository pairingRepository;
    late _FakeRemoteRepository remoteRepository;
    late _FakeDeviceStorageRepository deviceStorageRepository;
    late ProviderContainer container;

    setUp(() {
      pairingRepository = _FakePairingRepository();
      remoteRepository = _FakeRemoteRepository();
      deviceStorageRepository = _FakeDeviceStorageRepository();
      container = ProviderContainer(
        overrides: [
          pairingRepositoryProvider.overrideWithValue(pairingRepository),
          remoteRepositoryProvider.overrideWithValue(remoteRepository),
          deviceStorageRepositoryProvider.overrideWithValue(
            deviceStorageRepository,
          ),
        ],
      );
      container.read(connectionNotifierProvider);
    });

    tearDown(() async {
      await pairingRepository.dispose();
      await remoteRepository.dispose();
      container.dispose();
    });

    test('paired event triggers remote connect with remote port', () async {
      const pairedDevice = TvDevice(
        id: '192.168.1.8',
        name: 'ATV R2',
        ipAddress: '192.168.1.8',
        port: AppConstants.kPairingPort,
      );
      pairingRepository.emitStatus(const PairingStatus.paired(pairedDevice));

      await _flush();

      expect(remoteRepository.lastConnectDevice, isNotNull);
      expect(
        remoteRepository.lastConnectDevice!.port,
        AppConstants.kRemotePort,
      );
      expect(remoteRepository.lastConnectDevice!.isPaired, isTrue);
    });

    test('remote CONNECTED maps to PairingStatus.connected', () async {
      const device = TvDevice(
        id: '192.168.1.8',
        name: 'ATV R2',
        ipAddress: '192.168.1.8',
      );

      pairingRepository.emitStatus(const PairingStatus.paired(device));
      await _flush();
      remoteRepository.emitState(
        const RemoteSessionConnected('192.168.1.8', 'ATV R2'),
      );
      await _flush();

      final state = container.read(connectionNotifierProvider);
      expect(state, isA<Connected>());
      final connected = state as Connected;
      expect(connected.device.port, AppConstants.kRemotePort);
    });

    test('unsaved device starts pairing directly', () async {
      const device = TvDevice(
        id: '192.168.1.30',
        name: 'Bedroom TV',
        ipAddress: '192.168.1.30',
        isPaired: false,
      );

      await container
          .read(connectionNotifierProvider.notifier)
          .connectToDevice(device);
      await _flush();

      expect(pairingRepository.connectCalls, 1);
      expect(pairingRepository.lastConnectDevice, isNotNull);
      expect(
        pairingRepository.lastConnectDevice!.port,
        AppConstants.kPairingPort,
      );
      expect(remoteRepository.lastConnectDevice, isNull);
      expect(container.read(connectionNotifierProvider), isA<Connecting>());
    });

    test('saved paired device connects remote first', () async {
      const device = TvDevice(
        id: '192.168.1.8',
        name: 'ATV R2',
        ipAddress: '192.168.1.8',
        isPaired: true,
      );
      pairingRepository.pairedIps.add(device.ipAddress);

      await container
          .read(connectionNotifierProvider.notifier)
          .connectToDevice(device);
      await _flush();

      expect(remoteRepository.lastConnectDevice, isNotNull);
      expect(
        remoteRepository.lastConnectDevice!.port,
        AppConstants.kRemotePort,
      );
      expect(pairingRepository.connectCalls, 0);
    });

    test('repairing needed fallback starts pairing', () async {
      const device = TvDevice(
        id: '192.168.1.8',
        name: 'ATV R2',
        ipAddress: '192.168.1.8',
        isPaired: true,
      );
      pairingRepository.pairedIps.add(device.ipAddress);

      await container
          .read(connectionNotifierProvider.notifier)
          .connectToDevice(device);
      await _flush();

      remoteRepository.emitState(
        const RemoteSessionFailed('192.168.1.8', 'REPAIRING_NEEDED'),
      );
      await _flush();

      expect(pairingRepository.connectCalls, 1);
      expect(
        pairingRepository.lastConnectDevice?.port,
        AppConstants.kPairingPort,
      );
      expect(container.read(connectionNotifierProvider), isA<Connecting>());
    });

    test('forgetDevice clears native pair and local saved record', () async {
      const device = TvDevice(
        id: '192.168.1.8',
        name: 'ATV R2',
        ipAddress: '192.168.1.8',
        isPaired: true,
      );
      pairingRepository.pairedIps.add(device.ipAddress);
      await deviceStorageRepository.saveDevice(device);

      pairingRepository.emitStatus(const PairingStatus.paired(device));
      await _flush();
      remoteRepository.emitState(
        const RemoteSessionConnected('192.168.1.8', 'ATV R2'),
      );
      await _flush();

      await container
          .read(connectionNotifierProvider.notifier)
          .forgetDevice(device);

      expect(pairingRepository.forgetCalls, 1);
      expect(pairingRepository.lastForgottenIp, device.ipAddress);
      expect(deviceStorageRepository.lastRemovedId, device.id);
      expect(remoteRepository.disconnectCalls, 1);
    });

    test(
      'remote FAILED and DISCONNECTED map to failure/disconnected',
      () async {
        const device = TvDevice(
          id: '192.168.1.8',
          name: 'ATV R2',
          ipAddress: '192.168.1.8',
        );

        pairingRepository.emitStatus(const PairingStatus.paired(device));
        await _flush();
        remoteRepository.emitState(
          const RemoteSessionFailed('192.168.1.8', 'Socket closed'),
        );
        await _flush();

        var state = container.read(connectionNotifierProvider);
        expect(state, isA<ConnectionFailed>());

        remoteRepository.emitState(const RemoteSessionDisconnected());
        await _flush();

        state = container.read(connectionNotifierProvider);
        expect(state, isA<Disconnected>());
      },
    );
  });
}
