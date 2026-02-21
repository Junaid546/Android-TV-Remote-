import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:atv_remote/app/router.dart';
import 'package:atv_remote/core/theme/app_theme.dart';
import 'package:atv_remote/presentation/providers/settings_provider.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final settings = ref.watch(settingsNotifierProvider);

    return MaterialApp.router(
      title: 'ATV Remote',
      theme: settings.when(
        data: (s) => s.themeMode == 'dark' ? AppTheme.dark : AppTheme.light,
        loading: () => AppTheme.dark,
        error: (_, __) => AppTheme.dark,
      ),
      routerConfig: router,
    );
  }
}
