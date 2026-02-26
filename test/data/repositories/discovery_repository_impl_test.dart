import 'dart:async';

import 'package:atv_remote/data/datasources/native/discovery_native_datasource.dart';
import 'package:atv_remote/data/repositories/discovery_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeDiscoveryNativeDataSource implements DiscoveryNativeDataSource {
  final _controller = StreamController<List<Map<String, dynamic>>>.broadcast();

  @override
  Stream<List<Map<String, dynamic>>> get discoveryStream => _controller.stream;

  @override
  Future<Map<String, dynamic>> addManualDevice(String ip, String name) async =>
      {'id': ip, 'name': name, 'ip': ip, 'port': 6466};

  @override
  Future<void> startDiscovery() async {}

  @override
  Future<void> stopDiscovery() async {}

  void emit(List<Map<String, dynamic>> devices) => _controller.add(devices);

  Future<void> dispose() => _controller.close();
}

void main() {
  group('DiscoveryRepositoryImpl', () {
    late _FakeDiscoveryNativeDataSource native;
    late DiscoveryRepositoryImpl repository;

    setUp(() {
      native = _FakeDiscoveryNativeDataSource();
      repository = DiscoveryRepositoryImpl(native);
    });

    tearDown(() async {
      await native.dispose();
    });

    test('maps discovered devices without lastConnected timestamp', () async {
      final next = repository.deviceStream.first;
      native.emit(const [
        {
          'id': '192.168.1.8',
          'name': 'ATV R2',
          'ip': '192.168.1.8',
          'port': 6466,
        },
      ]);

      final either = await next;
      either.match(
        (failure) => fail('Expected devices, got failure: $failure'),
        (devices) {
          expect(devices, hasLength(1));
          expect(devices.first.lastConnected, isNull);
          expect(devices.first.isPaired, isFalse);
        },
      );
    });

    test(
      'manual devices are created without lastConnected timestamp',
      () async {
        final result = await repository.addManualDevice(
          '192.168.1.77',
          'Manual',
        );

        result.match(
          (failure) => fail('Expected device, got failure: $failure'),
          (device) {
            expect(device.lastConnected, isNull);
            expect(device.isPaired, isFalse);
            expect(device.ipAddress, '192.168.1.77');
          },
        );
      },
    );
  });
}
