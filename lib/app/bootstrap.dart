import 'dart:async';
import 'package:atv_remote/data/models/settings_model.dart';
import 'package:atv_remote/data/models/tv_device_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

const _enableProviderLogs = bool.fromEnvironment(
  'RIVERPOD_LOGS',
  defaultValue: false,
);

Future<ProviderContainer> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  final appDocDir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocDir.path);

  // Register Adapters
  Hive.registerAdapter(TvDeviceModelAdapter());
  Hive.registerAdapter(SettingsModelAdapter());

  // Open Boxes
  await Future.wait([
    Hive.openBox<TvDeviceModel>('devices'),
    Hive.openBox<SettingsModel>('settings'),
  ]);

  // Create ProviderContainer with overrides and observers
  final container = ProviderContainer(
    overrides: [],
    observers: [if (kDebugMode && _enableProviderLogs) _ProviderLogger()],
  );

  return container;
}

class _ProviderLogger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    if (!kDebugMode) return;
    final providerLabel = provider.name ?? provider.runtimeType.toString();
    if (providerLabel.startsWith('StreamProvider')) return;
    debugPrint('[Riverpod] $providerLabel: $newValue');
  }
}
