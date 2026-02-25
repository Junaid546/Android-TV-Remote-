import 'dart:async';

import 'package:atv_remote/core/constants/app_constants.dart';
import 'package:atv_remote/core/errors/failures.dart';
import 'package:atv_remote/domain/entities/pairing_status.dart';
import 'package:atv_remote/domain/entities/remote_command.dart';
import 'package:atv_remote/domain/entities/remote_session_status.dart';
import 'package:atv_remote/domain/entities/tv_device.dart';
import 'package:atv_remote/domain/repositories/pairing_repository.dart';
import 'package:atv_remote/domain/repositories/remote_repository.dart';
import 'package:atv_remote/presentation/providers/connection_provider.dart';
import 'package:atv_remote/presentation/providers/repository_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

class _FakePairingRepository implements PairingRepository {
  final _controller = StreamController<Either<Failure, PairingStatus>>.broadcast();

  @override
  Stream<Either<Failure, PairingStatus>> get statusStream => _controller.stream;

  @override
  Future<Either<Failure, void>> connectToDevice(TvDevice device) async =>
      const Right(null);

  @override
  Future<Either<Failure, void>> submitPin(String pin) async => const Right(null);

  @override
  Future<Either<Failure, void>> disconnect() async => const Right(null);

  void emitStatus(PairingStatus status) => _controller.add(Right(status));

  Future<void> dispose() => _controller.close();
}

class _FakeRemoteRepository implements RemoteRepository {
  final _controller =
      StreamController<Either<Failure, RemoteSessionStatus>>.broadcast();
  TvDevice? lastConnectDevice;

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
  Future<Either<Failure, void>> disconnect() async => const Right(null);

  @override
  Future<Either<Failure, void>> sendCommand(RemoteCommand command) async =>
      const Right(null);

  void emitState(RemoteSessionStatus status) => _controller.add(Right(status));

  Future<void> dispose() => _controller.close();
}

Future<void> _flush() async {
  await Future<void>.delayed(Duration.zero);
  await Future<void>.delayed(Duration.zero);
}

void main() {
  group('ConnectionNotifier orchestration', () {
    late _FakePairingRepository pairingRepository;
    late _FakeRemoteRepository remoteRepository;
    late ProviderContainer container;

    setUp(() {
      pairingRepository = _FakePairingRepository();
      remoteRepository = _FakeRemoteRepository();
      container = ProviderContainer(
        overrides: [
          pairingRepositoryProvider.overrideWithValue(pairingRepository),
          remoteRepositoryProvider.overrideWithValue(remoteRepository),
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

    test('remote FAILED and DISCONNECTED map to failure/disconnected', () async {
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
    });
  });
}
