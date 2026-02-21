import 'package:atv_remote/data/models/saved_device_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDeviceDatasource {
  static const String boxName = 'saved_devices';
  static const String lastConnectedKey = 'last_connected_device_id';

  Future<Box<SavedDeviceModel>> _openBox() async {
    return await Hive.openBox<SavedDeviceModel>(boxName);
  }

  Future<void> saveDevice(SavedDeviceModel device) async {
    final box = await _openBox();
    await box.put(device.id, device);
  }

  Future<SavedDeviceModel?> getDevice(String id) async {
    final box = await _openBox();
    return box.get(id);
  }

  Future<List<SavedDeviceModel>> getAllDevices() async {
    final box = await _openBox();
    return box.values.toList()
      ..sort((a, b) => b.lastConnected.compareTo(a.lastConnected));
  }

  Future<void> deleteDevice(String id) async {
    final box = await _openBox();
    await box.delete(id);
  }

  Future<void> updateLastConnected(String id) async {
    final box = await _openBox();
    final device = box.get(id);
    if (device != null) {
      final updated = SavedDeviceModel(
        id: device.id,
        name: device.name,
        ipAddress: device.ipAddress,
        port: device.port,
        isPaired: device.isPaired,
        certificateFingerprint: device.certificateFingerprint,
        lastConnected: DateTime.now(),
      );
      await box.put(id, updated);

      final settingsBox = await Hive.openBox('settings');
      await settingsBox.put(lastConnectedKey, id);
    }
  }

  Future<String?> getLastConnectedDeviceId() async {
    final settingsBox = await Hive.openBox('settings');
    return settingsBox.get(lastConnectedKey) as String?;
  }
}
