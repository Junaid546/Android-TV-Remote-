import 'package:atv_remote/domain/entities/tv_device.dart';
import 'package:atv_remote/presentation/providers/use_case_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'saved_devices_provider.g.dart';

@riverpod
class SavedDevicesNotifier extends _$SavedDevicesNotifier {
  @override
  Future<List<TvDevice>> build() async {
    final useCase = ref.watch(deviceStorageUseCasesProvider);
    final result = await useCase.getSavedDevices();
    return result.getOrElse((l) => []);
  }

  Future<void> saveDevice(TvDevice device) async {
    state = const AsyncValue.loading();
    final useCase = ref.read(deviceStorageUseCasesProvider);
    await useCase.saveDevice(device);
    ref.invalidateSelf();
  }

  Future<void> removeDevice(String deviceId) async {
    state = const AsyncValue.loading();
    final useCase = ref.read(deviceStorageUseCasesProvider);
    await useCase.removeDevice(deviceId);
    ref.invalidateSelf();
  }

  Future<TvDevice?> getLastConnectedDevice() async {
    final useCase = ref.read(deviceStorageUseCasesProvider);
    final result = await useCase.getLastConnectedDevice();
    return result.getOrElse((l) => null);
  }
}
