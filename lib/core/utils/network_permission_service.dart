import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class NetworkPermissionService {
  const NetworkPermissionService._();

  static Future<bool> ensureRequiredPermissions() async {
    if (kIsWeb || !Platform.isAndroid) return true;

    final currentStatuses = await _readStatuses();
    if (_isSatisfied(currentStatuses)) return true;

    final requestedStatuses = await <Permission>[
      Permission.location,
      Permission.nearbyWifiDevices,
    ].request();

    return _isSatisfied(requestedStatuses);
  }

  static Future<Map<Permission, PermissionStatus>> _readStatuses() async {
    final locationStatus = await Permission.location.status;
    final nearbyWifiStatus = await Permission.nearbyWifiDevices.status;

    return {
      Permission.location: locationStatus,
      Permission.nearbyWifiDevices: nearbyWifiStatus,
    };
  }

  static bool _isSatisfied(Map<Permission, PermissionStatus> statuses) {
    final hasLocationPermission =
        statuses[Permission.location]?.isGranted ?? false;
    final hasNearbyWifiPermission =
        statuses[Permission.nearbyWifiDevices]?.isGranted ?? false;

    // On Android 12 and below, location is required for discovery.
    // On Android 13+, nearby Wi-Fi devices permission is used.
    return hasLocationPermission || hasNearbyWifiPermission;
  }
}
