import 'dart:async';

import 'package:atv_remote/core/errors/exceptions.dart';
import 'package:atv_remote/data/datasources/native/adb_native_datasource.dart';
import 'package:atv_remote/presentation/providers/adb_provider.dart';
import 'package:atv_remote/presentation/providers/repository_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAdbNativeDataSource implements AdbNativeDataSource {
  final _stateController = StreamController<Map<String, dynamic>>.broadcast();
  int pairCalls = 0;
  int connectCalls = 0;
  Exception? pairError;
  Exception? connectError;
  Completer<void>? pairGate;

  @override
  Stream<Map<String, dynamic>> get stateStream => _stateController.stream;

  @override
  Future<void> pair(String host, int port, String pairingCode) async {
    pairCalls++;
    if (pairGate != null) {
      await pairGate!.future;
    }
    if (pairError != null) throw pairError!;
  }

  @override
  Future<void> connect(String host, int port) async {
    connectCalls++;
    if (connectError != null) throw connectError!;
  }

  @override
  Future<void> disconnect() async {}

  @override
  Future<String> runShell(String command) async => '';

  @override
  Future<Map<String, dynamic>> launchApp(
    String packageName, {
    String? activityName,
    bool playStoreFallback = true,
  }) async => const {};

  void emit(Map<String, dynamic> event) => _stateController.add(event);

  Future<void> dispose() => _stateController.close();
}

void main() {
  group('AdbNotifier', () {
    late _FakeAdbNativeDataSource native;
    late ProviderContainer container;

    setUp(() {
      native = _FakeAdbNativeDataSource();
      container = ProviderContainer(
        overrides: [adbNativeDataSourceProvider.overrideWithValue(native)],
      );
    });

    tearDown(() async {
      await native.dispose();
      container.dispose();
    });

    test('maps native stream updates into provider state', () async {
      container.read(adbNotifierProvider);
      native.emit(const {
        'state': 'CONNECTED',
        'host': '192.168.1.8',
        'port': 5555,
      });
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);

      final state = container.read(adbNotifierProvider);
      expect(state.connectionState, 'CONNECTED');
      expect(state.host, '192.168.1.8');
      expect(state.port, 5555);
      expect(state.isBusy, isFalse);
    });

    test('pairing failure surfaces friendly reason', () async {
      native.pairError = const NativeChannelException(
        'PAIR_FAILED',
        'Pair code rejected by TV',
      );

      await expectLater(
        container
            .read(adbNotifierProvider.notifier)
            .pair(host: '192.168.1.8', port: 37123, pairingCode: '123456'),
        throwsA(isA<NativeChannelException>()),
      );
      await Future<void>.delayed(Duration.zero);

      final state = container.read(adbNotifierProvider);
      expect(state.connectionState, 'FAILED');
      expect(state.reason, 'Pair code rejected by TV');
      expect(state.isBusy, isFalse);
    });

    test('busy guard prevents overlapping pair requests', () async {
      native.pairGate = Completer<void>();
      unawaited(
        container
            .read(adbNotifierProvider.notifier)
            .pair(host: '192.168.1.8', port: 37123, pairingCode: '123456'),
      );
      await Future<void>.delayed(Duration.zero);

      await container
          .read(adbNotifierProvider.notifier)
          .pair(host: '192.168.1.8', port: 37123, pairingCode: '123456');

      expect(native.pairCalls, 1);
      native.pairGate!.complete();
      await Future<void>.delayed(Duration.zero);
    });
  });
}
