import 'dart:math' as math;

import 'package:atv_remote/core/theme/app_colors.dart';
import 'package:atv_remote/presentation/providers/splash_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
    final screenWidth = MediaQuery.of(context).size.width;

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
              AppColors.background.withValues(alpha: 0.95),
              AppColors.primary.withValues(alpha: 0.08),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Multi-layer animated background
              Positioned(
                top: -screenHeight * 0.2,
                left: -screenWidth * 0.3,
                child: const _AnimatedGlowOrb(
                  size: 500,
                  opacity: 0.15,
                  duration: 4000,
                ),
              ),
              Positioned(
                bottom: -screenHeight * 0.15,
                right: -screenWidth * 0.25,
                child: const _AnimatedGlowOrb(
                  size: 400,
                  opacity: 0.12,
                  duration: 5000,
                  delay: 500,
                ),
              ),
              Positioned(
                top: screenHeight * 0.2,
                right: screenWidth * 0.1,
                child: const _AnimatedGlowOrb(
                  size: 250,
                  opacity: 0.08,
                  duration: 3500,
                  delay: 1000,
                ),
              ),
              // Floating particles
              const _ParticleBackground(),

              // Main content with enhanced animations
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Spacer(flex: 3),
                  _AppIconWidget(),
                  SizedBox(height: 56),
                  _BrandText(),
                  SizedBox(height: 20),
                  _SubtitleText(),
                  Spacer(flex: 3),
                  _EnhancedLoadingIndicator(),
                  SizedBox(height: 48),
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

class _AnimatedGlowOrb extends StatelessWidget {
  final double size;
  final double opacity;
  final int duration;
  final int delay;

  const _AnimatedGlowOrb({
    this.size = 350,
    this.opacity = 0.25,
    this.duration = 3000,
    this.delay = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 0.9,
              colors: [
                AppColors.primary.withValues(alpha: opacity),
                AppColors.primary.withValues(alpha: opacity * 0.4),
                Colors.transparent,
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: opacity * 0.3),
                blurRadius: 80,
                spreadRadius: 20,
              ),
            ],
          ),
        )
        .animate(
          delay: Duration(milliseconds: delay),
          onPlay: (c) => c.repeat(reverse: true),
        )
        .scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1.1, 1.1),
          duration: Duration(milliseconds: duration),
          curve: Curves.easeInOutSine,
        )
        .fade(
          begin: 0.4,
          end: opacity > 0.12 ? 0.8 : 0.6,
          duration: Duration(milliseconds: (duration * 0.7).toInt()),
          curve: Curves.easeInOut,
        );
  }
}

class _ParticleBackground extends StatefulWidget {
  const _ParticleBackground();

  @override
  State<_ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<_ParticleBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: _ParticlePainter(
            progress: _controller.value,
            screenWidth: screenWidth,
            screenHeight: screenHeight,
          ),
          size: Size(screenWidth, screenHeight),
        );
      },
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final double progress;
  final double screenWidth;
  final double screenHeight;

  _ParticlePainter({
    required this.progress,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.05)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);

    // Draw floating particles
    for (int i = 0; i < 8; i++) {
      final x =
          (screenWidth * 0.5 + math.sin((progress + i) * 2 * 3.14159) * 150);
      final y =
          (screenHeight * 0.3 +
          math.cos((progress * 1.5 + i) * 2 * 3.14159) * 100);
      canvas.drawCircle(Offset(x, y), 2 + (i % 3) * 0.5, paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter oldDelegate) => true;
}

class _AppIconWidget extends StatelessWidget {
  const _AppIconWidget();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Animated ring background
        Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
            )
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .scale(
              begin: const Offset(0.9, 0.9),
              end: const Offset(1.1, 1.1),
              duration: 2000.ms,
              curve: Curves.easeInOutQuad,
            )
            .fade(begin: 1.0, end: 0.3, duration: 1500.ms),

        // Main icon container with gradient
        Container(
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
                    color: AppColors.primary.withValues(alpha: 0.5),
                    blurRadius: 50,
                    spreadRadius: 10,
                    offset: const Offset(0, 15),
                  ),
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    blurRadius: 30,
                    spreadRadius: -8,
                    offset: const Offset(0, -8),
                  ),
                  // Inner glow
                  BoxShadow(
                    color: AppColors.primaryLight.withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Icon with animation
                  Icon(
                    Icons.settings_remote_rounded,
                    size: 60,
                    color: AppColors.onBackground.withValues(alpha: 0.95),
                  ),
                  // WiFi indicator with pulse
                  Positioned(
                    top: 20,
                    right: 30,
                    child:
                        Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.success.withValues(alpha: 0.2),
                                border: Border.all(
                                  color: AppColors.success.withValues(
                                    alpha: 0.6,
                                  ),
                                  width: 1.5,
                                ),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.wifi_rounded,
                                  size: 14,
                                  color: AppColors.success,
                                ),
                              ),
                            )
                            .animate(onPlay: (c) => c.repeat())
                            .scale(
                              begin: const Offset(0.9, 0.9),
                              end: const Offset(1.15, 1.15),
                              duration: 1500.ms,
                              curve: Curves.easeInOut,
                            )
                            .fade(begin: 0.8, end: 0.4, duration: 1500.ms),
                  ),
                ],
              ),
            )
            .animate()
            .fadeIn(duration: 900.ms, curve: Curves.easeOut)
            .scaleXY(
              begin: 0.4,
              end: 1.0,
              curve: Curves.easeOutBack,
              duration: 1000.ms,
            )
            .then()
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .moveY(
              begin: 0,
              end: 8,
              duration: 2500.ms,
              curve: Curves.easeInOutSine,
            ),
      ],
    );
  }
}

class _BrandText extends StatelessWidget {
  const _BrandText();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryLight,
                    AppColors.primary,
                    AppColors.primary.withValues(alpha: 0.7),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ).createShader(bounds);
              },
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.onBackground,
                    height: 1.2,
                    letterSpacing: -0.5,
                    fontWeight: FontWeight.w400,
                  ),
                  children: const [
                    TextSpan(
                      text: 'Smart TV\n',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 32,
                      ),
                    ),
                    TextSpan(
                      text: 'Remote Control',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 42,
                        letterSpacing: -1,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .animate(delay: 300.ms)
            .fadeIn(duration: 700.ms, curve: Curves.easeOut)
            .slideY(
              begin: 0.3,
              end: 0,
              curve: Curves.easeOutCubic,
              duration: 700.ms,
            ),
      ],
    );
  }
}

class _SubtitleText extends StatelessWidget {
  const _SubtitleText();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child:
          Text(
                'Seamlessly connect and navigate your Android TV with elegance',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.muted.withValues(alpha: 0.75),
                  height: 1.6,
                  letterSpacing: 0.3,
                  fontWeight: FontWeight.w400,
                  fontSize: 14.5,
                ),
              )
              .animate(delay: 550.ms)
              .fadeIn(duration: 700.ms, curve: Curves.easeOut)
              .slideY(
                begin: 0.2,
                end: 0,
                curve: Curves.easeOutCubic,
                duration: 700.ms,
              ),
    );
  }
}

class _EnhancedLoadingIndicator extends StatelessWidget {
  const _EnhancedLoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Animated dot indicators
        SizedBox(
          height: 32,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child:
                    Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary.withValues(alpha: 0.3),
                          ),
                        )
                        .animate(
                          delay: Duration(milliseconds: 200 * index),
                          onPlay: (c) => c.repeat(),
                        )
                        .scale(
                          begin: const Offset(0.5, 0.5),
                          end: const Offset(1.0, 1.0),
                          duration: 600.ms,
                          curve: Curves.easeInOut,
                        )
                        .then()
                        .scaleXY(
                          begin: 1.0,
                          end: 0.5,
                          duration: 600.ms,
                          curve: Curves.easeInOut,
                        ),
              ),
            ),
          ),
        ).animate(delay: 800.ms).fadeIn(duration: 500.ms),
        const SizedBox(height: 12),
        Text(
          'Initializing...',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.muted.withValues(alpha: 0.5),
            letterSpacing: 1.5,
            fontWeight: FontWeight.w500,
          ),
        ).animate(delay: 800.ms).fadeIn(duration: 500.ms),
      ],
    );
  }
}

class _VersionText extends StatelessWidget {
  const _VersionText();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 15,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.success,
                ),
              )
              .animate(onPlay: (c) => c.repeat())
              .scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1.2, 1.2),
                duration: 1200.ms,
                curve: Curves.easeInOut,
              ),
          const SizedBox(width: 10),
          Text(
            'v1.0.0 - Ready',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.muted.withValues(alpha: 0.7),
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ).animate(delay: 1200.ms).fadeIn(duration: 600.ms);
  }
}
