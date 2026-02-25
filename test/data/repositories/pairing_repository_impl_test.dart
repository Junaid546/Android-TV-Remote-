import 'dart:async';

import 'package:atv_remote/core/errors/failures.dart';
import 'package:atv_remote/core/constants/app_constants.dart';
import 'package:atv_remote/data/datasources/native/pairing_native_datasource.dart';
import 'package:atv_remote/data/repositories/pairing_repository_impl.dart';
import 'package:atv_remote/domain/entities/pairing_status.dart';
import 'package:atv_remote/domain/entities/tv_device.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakePairingNativeDataSource implements PairingNativeDataSource {
  final _controller = StreamController<Map<String, dynamic>>.broadcast();

  @override
  Stream<Map<String, dynamic>> get pairingEventStream => _controller.stream;

  @override
  Future<void> disconnect() async {}

  @override
  Future<void> startPairing(String ip, int port, String name) async {}

  @override
  Future<void> submitPin(String pin) async {}

  void emit(Map<String, dynamic> event) => _controller.add(event);

  Future<void> dispose() => _controller.close();
}

void main() {
  group('PairingRepositoryImpl status stream', () {
    late _FakePairingNativeDataSource native;
    late PairingRepositoryImpl repository;
    const device = TvDevice(
      id: '192.168.1.8',
      name: 'ATV R2',
      ipAddress: '192.168.1.8',
    );

    setUp(() async {
      native = _FakePairingNativeDataSource();
      repository = PairingRepositoryImpl(native);
      await repository.connectToDevice(device);
    });

    tearDown(() async {
      await native.dispose();
    });

    test('maps VERIFYING to pinVerified status', () async {
      final nextEvent = repository.statusStream.first;
      native.emit(const {'type': 'STATE', 'state': 'VERIFYING'});

      final either = await nextEvent;
      late PairingStatus status;
      either.match(
        (failure) => fail('Expected status, got failure: $failure'),
        (value) => status = value,
      );

      expect(status, isA<PinVerified>());
      final pinVerified = status as PinVerified;
      expect(pinVerified.device.ipAddress, device.ipAddress);
    });

    test('maps SUCCESS to paired status on remote port', () async {
      final nextEvent = repository.statusStream.first;
      native.emit(const {'type': 'STATE', 'state': 'SUCCESS'});

      final either = await nextEvent;
      late PairingStatus status;
      either.match(
        (failure) => fail('Expected status, got failure: $failure'),
        (value) => status = value,
      );

      expect(status, isA<Paired>());
      final paired = status as Paired;
      expect(paired.device.port, AppConstants.kRemotePort);
      expect(paired.device.isPaired, isTrue);
    });

    test('does not fall back to idle for unknown state', () async {
      final first = repository.statusStream.first;
      native.emit(const {'type': 'STATE', 'state': 'AWAITING_PIN'});
      await first;

      final second = repository.statusStream.first;
      native.emit(const {'type': 'STATE', 'state': 'SOME_NEW_STATE'});
      final either = await second;

      late PairingStatus status;
      either.match(
        (failure) => fail('Expected status, got failure: $failure'),
        (value) => status = value,
      );

      expect(status, isA<AwaitingPin>());
    });

    test('maps PROTOCOL_ERROR failure code', () async {
      final nextEvent = repository.statusStream.first;
      native.emit(const {
        'type': 'STATE',
        'state': 'FAILED',
        'errorCode': 'PROTOCOL_ERROR',
        'errorMessage': 'malformed message',
      });

      final either = await nextEvent;
      late PairingStatus status;
      either.match(
        (failure) => fail('Expected status, got failure: $failure'),
        (value) => status = value,
      );

      expect(status, isA<ConnectionFailed>());
      final failed = status as ConnectionFailed;
      expect(failed.failure, isA<PairingFailure>());
      expect(
        (failed.failure as PairingFailure).reason,
        'Pairing protocol error. Please retry pairing.',
      );
    });

    test('maps INVALID_PIN_FORMAT failure code', () async {
      final nextEvent = repository.statusStream.first;
      native.emit(const {
        'type': 'STATE',
        'state': 'FAILED',
        'errorCode': 'INVALID_PIN_FORMAT',
        'errorMessage': 'bad pin',
      });

      final either = await nextEvent;
      late PairingStatus status;
      either.match(
        (failure) => fail('Expected status, got failure: $failure'),
        (value) => status = value,
      );

      expect(status, isA<ConnectionFailed>());
      final failed = status as ConnectionFailed;
      expect(failed.failure, isA<PairingFailure>());
      expect(
        (failed.failure as PairingFailure).reason,
        'PIN must be 6 hexadecimal characters (0-9, A-F).',
      );
    });
  });
}
