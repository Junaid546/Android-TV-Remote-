import 'package:atv_remote/domain/entities/pairing_status.dart';
import 'package:atv_remote/presentation/providers/connection_provider.dart';
import 'package:atv_remote/presentation/providers/network_provider.dart';
import 'package:atv_remote/presentation/screens/apps/apps_screen.dart';
import 'package:atv_remote/presentation/screens/connection_error/connection_error_screen.dart';
import 'package:atv_remote/presentation/screens/discovery/discovery_screen.dart';
import 'package:atv_remote/presentation/screens/network_error/network_error_screen.dart';
import 'package:atv_remote/presentation/screens/pairing/pairing_screen.dart';
import 'package:atv_remote/presentation/screens/privacy/privacy_policy_screen.dart';
import 'package:atv_remote/presentation/screens/remote/remote_screen.dart';
import 'package:atv_remote/presentation/screens/settings/settings_screen.dart';
import 'package:atv_remote/presentation/screens/splash/splash_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

class RouterChangeNotifier extends ChangeNotifier {
  bool _hasWifi = true;
  bool _isConnected = false;
  bool _hasActiveSession = false;

  bool get hasWifi => _hasWifi;
  bool get isConnected => _isConnected;
  bool get hasActiveSession => _hasActiveSession;

  void update({
    required bool hasWifi,
    required bool isConnected,
    required bool hasActiveSession,
  }) {
    if (_hasWifi == hasWifi &&
        _isConnected == isConnected &&
        _hasActiveSession == hasActiveSession) {
      return;
    }
    _hasWifi = hasWifi;
    _isConnected = isConnected;
    _hasActiveSession = hasActiveSession;
    notifyListeners();
  }
}

@Riverpod(keepAlive: true)
RouterChangeNotifier routerListenable(RouterListenableRef ref) {
  final notifier = RouterChangeNotifier();

  void sync() {
    final wifiAsync = ref.read(wifiStatusProvider);
    final connectionState = ref.read(connectionNotifierProvider);

    notifier.update(
      hasWifi: wifiAsync.valueOrNull ?? true,
      isConnected: connectionState is Connected,
      hasActiveSession: connectionState.hasActiveSession,
    );
  }

  ref.listen<AsyncValue<bool>>(wifiStatusProvider, (prev, next) => sync());
  ref.listen<PairingStatus>(connectionNotifierProvider, (prev, next) => sync());

  sync();

  ref.onDispose(notifier.dispose);
  return notifier;
}

@Riverpod(keepAlive: true)
GoRouter appRouter(AppRouterRef ref) {
  final listenable = ref.watch(routerListenableProvider);

  final router = GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: false,
    refreshListenable: listenable,
    redirect: (context, state) {
      final isOnSplash = state.matchedLocation == '/splash';
      final isOnNetworkError = state.matchedLocation == '/network-error';
      final discoveryManageMode = state.uri.queryParameters['manage'] == '1';

      if (!listenable.hasWifi && !isOnSplash && !isOnNetworkError) {
        return '/network-error?returnTo=${state.matchedLocation}';
      }

      if (state.matchedLocation == '/discovery' &&
          listenable.isConnected &&
          !discoveryManageMode) {
        return '/remote';
      }

      if (state.matchedLocation == '/remote' && !listenable.hasActiveSession) {
        return '/discovery';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/network-error',
        builder: (context, state) => NetworkErrorScreen(
          returnTo: state.uri.queryParameters['returnTo'],
          errorTypeRaw: state.uri.queryParameters['type'],
        ),
      ),
      GoRoute(
        path: '/discovery',
        builder: (context, state) => const DiscoveryScreen(),
      ),
      GoRoute(
        path: '/pairing',
        builder: (context, state) => PairingScreen(
          deviceId: state.uri.queryParameters['deviceId'] ?? '',
        ),
      ),
      GoRoute(
        path: '/remote',
        builder: (context, state) => const RemoteScreen(),
      ),
      GoRoute(path: '/apps', builder: (context, state) => const AppsScreen()),
      GoRoute(
        path: '/connection-error',
        builder: (context, state) => const ConnectionErrorScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/privacy-policy',
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
    ],
  );

  ref.onDispose(router.dispose);
  return router;
}
