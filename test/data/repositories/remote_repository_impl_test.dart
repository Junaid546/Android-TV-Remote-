import 'dart:async';

import 'package:atv_remote/core/errors/failures.dart';
import 'package:atv_remote/data/datasources/native/remote_native_datasource.dart';
import 'package:atv_remote/data/repositories/remote_repository_impl.dart';
import 'package:atv_remote/domain/entities/remote_session_status.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRemoteNativeDataSource implements RemoteNativeDataSource {
  final _controller = StreamController<Map<String, dynamic>>.broadcast();
  final _volumeController = StreamController<Map<String, dynamic>>.broadcast();

  @override
  Stream<Map<String, dynamic>> get connectionStateStream => _controller.stream;

  @override
  Stream<Map<String, dynamic>> get volumeStateStream =>
      _volumeController.stream;

  @override
  Future<void> connect(String ip, String name, int port) async {}

  @override
  Future<void> disconnect() async {}

  @override
  Future<void> sendKey(int keyCode, int direction) async {}

  @override
  Future<void> setAutoReconnect(bool enabled) async {}

  void emit(Map<String, dynamic> event) => _controller.add(event);

  Future<void> dispose() async {
    await _controller.close();
    await _volumeController.close();
  }
}

void main() {
  group('RemoteRepositoryImpl connection state mapping', () {
    late _FakeRemoteNativeDataSource native;
    late RemoteRepositoryImpl repository;

    setUp(() {
      native = _FakeRemoteNativeDataSource();
      repository = RemoteRepositoryImpl(native);
    });

    tearDown(() async {
      await native.dispose();
    });

    test('maps CONNECTED state', () async {
      final next = repository.connectionState.first;
      native.emit(const {
        'state': 'CONNECTED',
        'ip': '192.168.1.8',
        'name': 'TV',
      });

      final either = await next;
      either.match(
        (failure) => fail('Expected status, got failure: $failure'),
        (status) {
          expect(status, isA<RemoteSessionConnected>());
          final connected = status as RemoteSessionConnected;
          expect(connected.deviceIp, '192.168.1.8');
          expect(connected.deviceName, 'TV');
        },
      );
    });

    test('maps RECONNECTING state', () async {
      final next = repository.connectionState.first;
      native.emit(const {
        'state': 'RECONNECTING',
        'ip': '192.168.1.8',
        'attempt': 2,
        'maxAttempts': 5,
      });

      final either = await next;
      either.match(
        (failure) => fail('Expected status, got failure: $failure'),
        (status) {
          expect(status, isA<RemoteSessionReconnecting>());
          final reconnecting = status as RemoteSessionReconnecting;
          expect(reconnecting.attempt, 2);
          expect(reconnecting.maxAttempts, 5);
        },
      );
    });

    test('maps FAILED state', () async {
      final next = repository.connectionState.first;
      native.emit(const {
        'state': 'FAILED',
        'ip': '192.168.1.8',
        'reason': 'Socket closed',
      });

      final either = await next;
      either.match(
        (failure) => fail('Expected status, got failure: $failure'),
        (status) {
          expect(status, isA<RemoteSessionFailed>());
          final failed = status as RemoteSessionFailed;
          expect(failed.reason, 'Socket closed');
        },
      );
    });

    test('maps unknown state to failure', () async {
      final next = repository.connectionState.first;
      native.emit(const {'state': 'SOMETHING_NEW'});

      final either = await next;
      either.match((failure) {
        expect(failure, isA<UnknownFailure>());
        expect(
          (failure as UnknownFailure).message,
          contains('Unknown remote connection state'),
        );
      }, (status) => fail('Expected failure, got status: $status'));
    });
  });
}
