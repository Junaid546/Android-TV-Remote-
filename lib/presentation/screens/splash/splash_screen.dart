import 'package:atv_remote/core/theme/app_colors.dart';
import 'package:atv_remote/presentation/providers/saved_devices_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Artificial delay for branding
    await Future.delayed(const Duration(milliseconds: 2500));

    if (!mounted) return;

    // Check if we have any saved devices
    final savedDevices = await ref
        .read(savedDevicesNotifierProvider.notifier)
        .build();

    if (!mounted) return;

    if (savedDevices.isNotEmpty) {
      // For now, go to Remote if we have devices, or Discovery to pick one
      // We could also try to auto-connect to the last one
      context.go('/discovery');
    } else {
      context.go('/discovery');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.background, AppColors.surfaceDark],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated Logo
            Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(25),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primary.withAlpha(50),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.tv_rounded,
                    size: 80,
                    color: AppColors.primary,
                  ),
                )
                .animate()
                .scale(duration: 800.ms, curve: Curves.easeOutBack)
                .fadeIn(duration: 600.ms)
                .shimmer(
                  delay: 1000.ms,
                  duration: 1500.ms,
                  color: AppColors.primary.withAlpha(100),
                ),

            const SizedBox(height: 32),

            // App Name
            Text(
                  'ATV REMOTE',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 4,
                  ),
                )
                .animate()
                .fadeIn(delay: 400.ms, duration: 800.ms)
                .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad),

            const SizedBox(height: 8),

            // Subtitle
            Text(
              'Smart Connectivity. Seamless Control.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                letterSpacing: 1.2,
              ),
            ).animate().fadeIn(delay: 800.ms, duration: 800.ms),
          ],
        ),
      ),
    );
  }
}
