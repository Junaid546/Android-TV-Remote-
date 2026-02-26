import 'dart:async';

import 'package:atv_remote/core/errors/failures.dart';
import 'package:atv_remote/domain/entities/pairing_status.dart';
import 'package:atv_remote/domain/entities/remote_command.dart';
import 'package:atv_remote/domain/entities/remote_session_status.dart';
import 'package:atv_remote/domain/entities/tv_device.dart';
import 'package:atv_remote/domain/repositories/pairing_repository.dart';
import 'package:atv_remote/domain/repositories/remote_repository.dart';
import 'package:atv_remote/presentation/providers/repository_providers.dart';
import 'package:atv_remote/presentation/screens/remote/widgets/dpad_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';

class _SilentPairingRepository implements PairingRepository {
  final _controller =
      StreamController<Either<Failure, PairingStatus>>.broadcast();

  @override
  Stream<Either<Failure, PairingStatus>> get statusStream => _controller.stream;

  @override
  Future<Either<Failure, void>> connectToDevice(TvDevice device) async =>
      const Right(null);

  @override
  Future<Either<Failure, void>> disconnect() async => const Right(null);

  @override
  Future<Either<Failure, void>> submitPin(String pin) async =>
      const Right(null);

  @override
  Future<Either<Failure, void>> forgetDevice(String ipAddress) async =>
      const Right(null);

  @override
  Future<Either<Failure, bool>> isDevicePaired(String ipAddress) async =>
      const Right(false);

  Future<void> dispose() => _controller.close();
}

class _SilentRemoteRepository implements RemoteRepository {
  final _controller =
      StreamController<Either<Failure, RemoteSessionStatus>>.broadcast();

  @override
  Stream<Either<Failure, RemoteSessionStatus>> get connectionState =>
      _controller.stream;

  @override
  Stream<Either<Failure, bool>> get connectionAlive =>
      _controller.stream.map((either) {
        return either.map((status) => status is RemoteSessionConnected);
      });

  @override
  Future<Either<Failure, void>> connect(TvDevice device) async =>
      const Right(null);

  @override
  Future<Either<Failure, void>> disconnect() async => const Right(null);

  @override
  Future<Either<Failure, void>> sendCommand(RemoteCommand command) async =>
      const Right(null);

  Future<void> dispose() => _controller.close();
}

void main() {
  testWidgets('DpadControl does not overflow at 360dp width', (tester) async {
    final pairingRepository = _SilentPairingRepository();
    final remoteRepository = _SilentRemoteRepository();
    final view = tester.view;

    view.physicalSize = const Size(360, 800);
    view.devicePixelRatio = 1.0;
    addTearDown(() async {
      await pairingRepository.dispose();
      await remoteRepository.dispose();
      view.resetPhysicalSize();
      view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          pairingRepositoryProvider.overrideWithValue(pairingRepository),
          remoteRepositoryProvider.overrideWithValue(remoteRepository),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: DpadControl(),
            ),
          ),
        ),
      ),
    );

    await tester.pump();
    expect(find.byType(DpadControl), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
