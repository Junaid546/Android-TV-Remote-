import 'package:atv_remote/domain/entities/tv_device.dart';
import 'package:atv_remote/presentation/providers/use_case_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'saved_devices_provider.g.dart';

@riverpod
class SavedDevicesNotifier extends _$SavedDevicesNotifier {
  @override
  Future<List<TvDevice>> build() async {
    final result = await ref.watch(getSavedDevicesUseCaseProvider).call();
    return result.getOrElse((l) => []);
  }

  Future<void> saveDevice(TvDevice device) async {
    state = const AsyncValue.loading();
    await ref.read(saveDeviceUseCaseProvider).call(device);
    ref.invalidateSelf();
  }

  Future<void> removeDevice(String deviceId) async {
    state = const AsyncValue.loading();
    await ref.read(removeDeviceUseCaseProvider).call(deviceId);
    ref.invalidateSelf();
  }

  Future<TvDevice?> getLastConnectedDevice() async {
    final result = await ref.read(getLastConnectedDeviceUseCaseProvider).call();
    return result.getOrElse((l) => null);
  }
}
