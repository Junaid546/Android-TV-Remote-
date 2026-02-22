import 'package:atv_remote/core/theme/app_colors.dart';
import 'package:atv_remote/presentation/providers/splash_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Transparent status bar with light icons
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    // Listen to splash initialization result
    ref.listen(splashNotifierProvider, (previous, next) {
      next.when(
        data: (result) {
          result.when(
            noWifi: () => context.go('/network-error'),
            reconnected: (_) => context.go('/remote'),
            readyToDiscover: () => context.go('/discovery'),
          );
        },
        error: (err, stack) {
          // Fallback on error to not get stuck
          context.go('/discovery');
        },
        loading: () {},
      );
    });

    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.background,
              AppColors.background.withValues(alpha: 0.8),
              AppColors.primary.withValues(alpha: 0.15),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Subtle background animated shapes
              Positioned(
                top: screenHeight * 0.15,
                child: const _GlowBackground(),
              ),
              Positioned(
                bottom: screenHeight * 0.1,
                right: -50,
                child: const _GlowBackground(size: 200, opacity: 0.15),
              ),
              // Main content
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Spacer(flex: 3),
                  _AppIconWidget(),
                  SizedBox(height: 56),
                  _BrandText(),
                  SizedBox(height: 16),
                  _SubtitleText(),
                  Spacer(flex: 4),
                  _VersionText(),
                  SizedBox(height: 24),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GlowBackground extends StatelessWidget {
  final double size;
  final double opacity;

  const _GlowBackground({this.size = 350, this.opacity = 0.25});

  @override
  Widget build(BuildContext context) {
    return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 0.8,
              colors: [
                AppColors.primary.withValues(alpha: opacity),
                Colors.transparent,
              ],
            ),
          ),
        )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .scale(
          begin: const Offset(0.85, 0.85),
          end: const Offset(1.15, 1.15),
          duration: 3000.ms,
          curve: Curves.easeInOutSine,
        )
        .fade(begin: 0.5, end: 1.0, duration: 2000.ms, curve: Curves.easeInOut);
  }
}

class _AppIconWidget extends StatelessWidget {
  const _AppIconWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primaryLight, AppColors.primary],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.4),
                blurRadius: 40,
                spreadRadius: 8,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: AppColors.primaryLight.withValues(alpha: 0.2),
                blurRadius: 20,
                spreadRadius: -5,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // A stacked layers icon representing the app
              Icon(
                Icons.settings_remote_rounded,
                size: 56,
                color: AppColors.onBackground.withValues(alpha: 0.95),
              ),
              const Positioned(
                top: 22,
                right: 32,
                child: Icon(
                  Icons.wifi_rounded,
                  size: 20,
                  color: AppColors.onBackground,
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 800.ms)
        .scaleXY(begin: 0.5, end: 1.0, curve: Curves.easeOutBack)
        .then()
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .shimmer(duration: 2500.ms, color: Colors.white24)
        .moveY(
          begin: -5,
          end: 5,
          duration: 2500.ms,
          curve: Curves.easeInOutSine,
        );
  }
}

class _BrandText extends StatelessWidget {
  const _BrandText();

  @override
  Widget build(BuildContext context) {
    return RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: AppColors.onBackground,
              height: 1.2,
              letterSpacing: -0.5,
            ),
            children: const [
              TextSpan(
                text: 'Smart TV\n',
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
              TextSpan(
                text: 'Remote Control',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
            ],
          ),
        )
        .animate(delay: 400.ms)
        .fadeIn(duration: 600.ms, curve: Curves.easeOut)
        .slideY(begin: 0.2, end: 0, curve: Curves.easeOutCubic);
  }
}

class _SubtitleText extends StatelessWidget {
  const _SubtitleText();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child:
          Text(
                'Seamlessly connect and navigate your Android TV with elegance.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.muted.withValues(alpha: 0.8),
                  height: 1.5,
                  letterSpacing: 0.2,
                ),
              )
              .animate(delay: 600.ms)
              .fadeIn(duration: 600.ms)
              .slideY(begin: 0.2, end: 0, curve: Curves.easeOutCubic),
    );
  }
}

class _VersionText extends StatelessWidget {
  const _VersionText();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.1)),
      ),
      child: Text(
        'v1.0.0',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: AppColors.muted.withValues(alpha: 0.6),
          letterSpacing: 3,
          fontWeight: FontWeight.w600,
        ),
      ),
    ).animate(delay: 1000.ms).fadeIn(duration: 800.ms);
  }
}
