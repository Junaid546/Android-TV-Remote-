import 'dart:async';
import 'package:atv_remote/core/errors/failures.dart';
import 'package:atv_remote/data/datasources/native/discovery_native_datasource.dart';
import 'package:atv_remote/domain/entities/tv_device.dart';
import 'package:atv_remote/domain/repositories/discovery_repository.dart';
import 'package:fpdart/fpdart.dart';

class DiscoveryRepositoryImpl implements DiscoveryRepository {
  final DiscoveryNativeDataSource _nativeDataSource;

  DiscoveryRepositoryImpl(this._nativeDataSource);

  @override
  Stream<Either<Failure, List<TvDevice>>> get deviceStream {
    return _nativeDataSource.discoveryStream
        .map<Either<Failure, List<TvDevice>>>((rawList) {
          try {
            final devices = rawList.map((m) {
              return TvDevice(
                id: m['id'] as String,
                name: m['name'] as String,
                ipAddress: m['ip'] as String,
                port: (m['port'] as num?)?.toInt() ?? 6466,
                isPaired: false,
              );
            }).toList();
            return Right(devices);
          } catch (e) {
            return Left(UnknownFailure(e.toString()));
          }
        })
        .handleError((e) {
          return Left(UnknownFailure(e.toString()));
        });
  }

  @override
  Future<Either<Failure, void>> startDiscovery() async {
    try {
      await _nativeDataSource.startDiscovery();
      return const Right(null);
    } catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> stopDiscovery() async {
    try {
      await _nativeDataSource.stopDiscovery();
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
      final result = await _nativeDataSource.addManualDevice(ipAddress, name);
      final device = TvDevice(
        id: result['id'] as String,
        name: result['name'] as String,
        ipAddress: result['ip'] as String,
        port: (result['port'] as num?)?.toInt() ?? 6466,
        isPaired: false,
      );
      return Right(device);
    } catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }
}
