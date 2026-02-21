import 'package:atv_remote/domain/entities/pairing_status.dart';
import 'package:atv_remote/presentation/providers/connection_provider.dart';
import 'package:atv_remote/presentation/providers/network_provider.dart';
import 'package:atv_remote/presentation/screens/connection_error/connection_error_screen.dart';
import 'package:atv_remote/presentation/screens/discovery/discovery_screen.dart';
import 'package:atv_remote/presentation/screens/network_error/network_error_screen.dart';
import 'package:atv_remote/presentation/screens/pairing/pairing_screen.dart';
import 'package:atv_remote/presentation/screens/remote/remote_screen.dart';
import 'package:atv_remote/presentation/screens/settings/settings_screen.dart';
import 'package:atv_remote/presentation/screens/splash/splash_screen.dart';
import 'package:flutter/foundation.dart';
// ignore: unnecessary_import — flutter_riverpod re-exports Ref but not ChangeNotifier
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

// ─────────────────────────────────────────────────────────────────────────────
// RouterChangeNotifier
//
// A plain ChangeNotifier that holds the routing-relevant state.
// Riverpod drives this object from the outside (see routerListenableProvider).
// GoRouter holds a reference to this notifier via refreshListenable, so it
// re-evaluates redirect() ONLY when notifyListeners() is called — without
// ever recreating the GoRouter instance itself.
// ─────────────────────────────────────────────────────────────────────────────

class RouterChangeNotifier extends ChangeNotifier {
  bool _hasWifi = true;
  bool _isConnected = false;

  bool get hasWifi => _hasWifi;
  bool get isConnected => _isConnected;

  void update({required bool hasWifi, required bool isConnected}) {
    if (hasWifi == _hasWifi && isConnected == _isConnected) return;
    _hasWifi = hasWifi;
    _isConnected = isConnected;
    notifyListeners();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// routerListenableProvider
//
// Keeps the RouterChangeNotifier alive, and watches the Riverpod providers
// that affect routing. When they change it calls .update(), which triggers
// GoRouter's refreshListenable without rebuilding the router itself.
// ─────────────────────────────────────────────────────────────────────────────

@Riverpod(keepAlive: true)
RouterChangeNotifier routerListenable(RouterListenableRef ref) {
  final notifier = RouterChangeNotifier();

  // Keep a reference so we can always update from within _listen closures below
  void sync() {
    final wifiAsync = ref.read(wifiStatusProvider);
    final connectionState = ref.read(connectionNotifierProvider);

    notifier.update(
      hasWifi: wifiAsync.valueOrNull ?? true,
      isConnected: connectionState is Connected,
    );
  }

  // Listen — fires every time the value changes, does NOT cause a rebuild here
  ref.listen<AsyncValue<bool>>(wifiStatusProvider, (prev, next) => sync());
  ref.listen<PairingStatus>(connectionNotifierProvider, (prev, next) => sync());

  // Initial sync
  sync();

  ref.onDispose(notifier.dispose);
  return notifier;
}

// ─────────────────────────────────────────────────────────────────────────────
// appRouter
//
// Created ONCE (keepAlive: true). Uses refreshListenable instead of ref.watch,
// so state changes trigger redirect re-evaluation, not router recreation.
// ─────────────────────────────────────────────────────────────────────────────

@Riverpod(keepAlive: true)
GoRouter appRouter(AppRouterRef ref) {
  final listenable = ref.watch(routerListenableProvider);

  final router = GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: kDebugMode,
    refreshListenable: listenable,
    redirect: (context, state) {
      final isOnSplash = state.matchedLocation == '/splash';
      final isOnNetworkError = state.matchedLocation == '/network-error';

      // Guard: no WiFi → go to network-error screen
      if (!listenable.hasWifi && !isOnSplash && !isOnNetworkError) {
        return '/network-error?returnTo=${state.matchedLocation}';
      }

      // Guard: already connected → skip discovery, go to remote
      if (state.matchedLocation == '/discovery' && listenable.isConnected) {
        return '/remote';
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
      GoRoute(
        path: '/connection-error',
        builder: (context, state) => const ConnectionErrorScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );

  ref.onDispose(router.dispose);
  return router;
}
