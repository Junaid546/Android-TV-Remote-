import 'dart:async';
import 'package:atv_remote/core/errors/failures.dart';
import 'package:atv_remote/data/datasources/native/discovery_native_datasource.dart';
import 'package:atv_remote/domain/entities/tv_device.dart';
import 'package:atv_remote/domain/repositories/discovery_repository.dart';
import 'package:fpdart/fpdart.dart';

class DiscoveryRepositoryImpl implements DiscoveryRepository {
  final DiscoveryNativeDatasource _nativeDatasource;
  final _devicesController =
      StreamController<Either<Failure, List<TvDevice>>>.broadcast();
  final Map<String, TvDevice> _discoveredDevices = {};

  DiscoveryRepositoryImpl(this._nativeDatasource);

  @override
  Stream<Either<Failure, List<TvDevice>>> get deviceStream =>
      _devicesController.stream;

  @override
  Future<Either<Failure, void>> startDiscovery() async {
    try {
      _discoveredDevices.clear();
      _devicesController.add(Right(_discoveredDevices.values.toList()));

      await _nativeDatasource.startDiscovery();

      _nativeDatasource.discoveryStream.listen(
        (devices) {
          final tvDevices = devices.map((event) {
            return TvDevice(
              id: event['id'] as String,
              name: event['name'] as String,
              ipAddress: event['ip'] as String,
              port: event['port'] as int,
              isPaired: false,
              lastConnected: DateTime.now(),
            );
          }).toList();

          _devicesController.add(Right(tvDevices));
        },
        onError: (e) {
          _devicesController.add(Left(NetworkFailure(e.toString())));
        },
      );

      return const Right(null);
    } catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> stopDiscovery() async {
    try {
      await _nativeDatasource.stopDiscovery();
      return const Right(null);
    } catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TvDevice>> addManualDevice(
    String ipAddress,
    String name,
  ) async {
    try {
      final result = await _nativeDatasource.addManualDevice(ipAddress, name);
      final device = TvDevice(
        id: result['id'] as String,
        name: result['name'] as String,
        ipAddress: result['ip'] as String,
        port: result['port'] as int,
        isPaired: false,
        lastConnected: DateTime.now(),
      );
      return Right(device);
    } catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }
}
