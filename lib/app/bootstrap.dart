import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:atv_remote/data/models/tv_device_model.dart';
import 'package:atv_remote/data/models/saved_device_model.dart';
import 'package:atv_remote/core/utils/logger.dart';

Future<ProviderContainer> bootstrap() async {
  try {
    // 1. Initialize Hive
    await Hive.initFlutter();

    // 2. Register Adapters
    Hive.registerAdapter(TvDeviceModelAdapter());
    Hive.registerAdapter(SavedDeviceModelAdapter());

    // 3. Open Boxes
    await Hive.openBox<TvDeviceModel>('devices');
    await Hive.openBox('settings');

    // 4. Set orientations
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return ProviderContainer();
  } on HiveError catch (e, stack) {
    logger.e('Hive initialization failed', error: e, stackTrace: stack);
    rethrow;
  } on PlatformException catch (e, stack) {
    logger.e('Platform operation failed', error: e, stackTrace: stack);
    rethrow;
  }
}
