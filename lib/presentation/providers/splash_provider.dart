import 'package:atv_remote/domain/entities/tv_device.dart';
import 'package:atv_remote/presentation/providers/connection_provider.dart';
import 'package:atv_remote/presentation/providers/network_provider.dart';
import 'package:atv_remote/presentation/providers/saved_devices_provider.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'splash_provider.freezed.dart';
part 'splash_provider.g.dart';

@freezed
class SplashResult with _$SplashResult {
  const factory SplashResult.noWifi() = NoWifi;
  const factory SplashResult.reconnected(TvDevice device) = Reconnected;
  const factory SplashResult.readyToDiscover() = ReadyToDiscover;
}

@riverpod
class SplashNotifier extends _$SplashNotifier {
  @override
  Future<SplashResult> build() async {
    // Run all in parallel with minimum delay
    final results = await Future.wait([
      _checkWifi(),
      _loadSavedDevices(),
      Future.delayed(
        const Duration(milliseconds: 5000),
      ), // minimum display time
    ]);

    final hasWifi = results[0] as bool;
    final lastDevice = results[1] as TvDevice?;

    if (!hasWifi) return const SplashResult.noWifi();

    if (lastDevice != null) {
      // Attempt auto-reconnect with 3s timeout
      final reconnected = await _tryAutoReconnect(lastDevice);
      if (reconnected) return SplashResult.reconnected(lastDevice);
    }

    return const SplashResult.readyToDiscover();
  }

  Future<bool> _checkWifi() async {
    try {
      final status = await ref.read(wifiStatusProvider.future);
      return status;
    } catch (_) {
      return true; // Default to true if stream fails to avoid locking user
    }
  }

  Future<TvDevice?> _loadSavedDevices() async {
    try {
      final devices = await ref.read(savedDevicesNotifierProvider.future);
      if (devices.isNotEmpty) {
        return devices.first;
      }
    } catch (_) {
      // Ignore errors
    }
    return null;
  }

  Future<bool> _tryAutoReconnect(TvDevice device) async {
    try {
      final notifier = ref.read(connectionNotifierProvider.notifier);
      await notifier.connectToDevice(device);

      // Wait for state to change to connected, failed, or timeout (3 seconds)
      bool isConnected = false;
      for (var i = 0; i < 30; i++) {
        await Future.delayed(const Duration(milliseconds: 100));
        final state = ref.read(connectionNotifierProvider);

        state.maybeWhen(
          connected: (_) => isConnected = true,
          connectionFailed: (device, failure) => i = 30, // break loop
          disconnected: (device, reason) => i = 30, // break loop
          pinError: (device, left, msg) => i = 30, // break loop
          orElse: () {},
        );

        if (isConnected) break;
      }
      return isConnected;
    } catch (_) {
      return false;
    }
  }
}
