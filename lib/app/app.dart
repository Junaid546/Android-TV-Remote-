import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:atv_remote/app/router.dart';
import 'package:atv_remote/core/theme/app_theme.dart';
import 'package:atv_remote/core/utils/haptic_service.dart';
import 'package:atv_remote/presentation/providers/settings_provider.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.read(appRouterProvider);
    final themeMode = ref.watch(
      settingsNotifierProvider.select((settings) => settings.themeMode),
    );
    final hapticEnabled = ref.watch(
      settingsNotifierProvider.select((settings) => settings.hapticEnabled),
    );
    HapticService.setEnabled(hapticEnabled);
    return MaterialApp.router(
      title: 'TV Remote',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode == 'dark' ? ThemeMode.dark : ThemeMode.light,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.noScaling),
          child: child!,
        );
      },
    );
  }
}
