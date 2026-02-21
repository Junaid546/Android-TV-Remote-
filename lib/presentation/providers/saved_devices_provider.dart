import 'package:atv_remote/domain/entities/tv_device.dart';
import 'package:atv_remote/presentation/providers/use_case_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'saved_devices_provider.g.dart';

@riverpod
class SavedDevicesNotifier extends _$SavedDevicesNotifier {
  @override
  Future<List<TvDevice>> build() async {
    final result = await ref.read(getSavedDevicesUseCaseProvider)();
    return result.fold((f) => throw f, (devices) => devices);
  }

  Future<void> removeDevice(String deviceId) async {
    final result = await ref.read(removeDeviceUseCaseProvider)(deviceId);
    result.fold((_) {}, (_) => ref.invalidateSelf());
  }

  Future<void> refresh() => ref.invalidateSelf() as Future<void>;
}
