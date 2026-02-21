import 'package:atv_remote/presentation/screens/discovery/discovery_screen.dart';
import 'package:atv_remote/presentation/screens/pairing/pairing_screen.dart';
import 'package:atv_remote/presentation/screens/remote/remote_screen.dart';
import 'package:atv_remote/presentation/screens/settings/settings_screen.dart';
import 'package:atv_remote/presentation/screens/splash/splash_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

@riverpod
GoRouter router(RouterRef ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(
        path: '/discovery',
        builder: (context, state) => const DiscoveryScreen(),
      ),
      GoRoute(
        path: '/pairing',
        builder: (context, state) => const PairingScreen(),
      ),
      GoRoute(
        path: '/remote',
        builder: (context, state) => const RemoteScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
}
