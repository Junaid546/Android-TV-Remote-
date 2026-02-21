import 'package:atv_remote/data/models/tv_device_model.dart';
import 'package:hive/hive.dart';

class HiveDeviceDatasource {
  static const _boxName = 'devices';
  Box<TvDeviceModel> get _box => Hive.box<TvDeviceModel>(_boxName);

  Future<List<TvDeviceModel>> getAllDevices() async {
    return _box.values.toList()..sort(
      (a, b) => (b.lastConnectedIso ?? '').compareTo(a.lastConnectedIso ?? ''),
    );
  }

  Future<void> saveDevice(TvDeviceModel model) async {
    await _box.put(model.id, model);
  }

  Future<void> removeDevice(String id) async {
    await _box.delete(id);
  }

  Future<TvDeviceModel?> getDeviceById(String id) async {
    return _box.get(id);
  }

  Future<TvDeviceModel?> getLastConnected() async {
    final all = await getAllDevices();
    return all.isNotEmpty ? all.first : null;
  }

  Future<void> updateLastConnected(String id) async {
    final device = _box.get(id);
    if (device != null) {
      device.lastConnectedIso = DateTime.now().toIso8601String();
      await device.save();
    }
  }

  Future<void> markAsPaired(String id, String? fingerprint) async {
    final device = _box.get(id);
    if (device != null) {
      device.isPaired = true;
      device.certificateFingerprint = fingerprint;
      await device.save();
    }
  }
}
