import 'dart:async';
import 'dart:ui';
import 'package:atv_remote/core/theme/app_colors.dart';
import 'package:atv_remote/presentation/providers/connection_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConnectingOverlay extends ConsumerStatefulWidget {
  final String deviceName;
  final VoidCallback? onCancel;

  const ConnectingOverlay({super.key, required this.deviceName, this.onCancel});

  @override
  ConsumerState<ConnectingOverlay> createState() => _ConnectingOverlayState();
}

class _ConnectingOverlayState extends ConsumerState<ConnectingOverlay> {
  int _statusIndex = 0;
  final List<String> _statuses = [
    'Connecting...',
    'Verifying...',
    'Establishing connection...',
  ];
  late Timer _statusTimer;
  late Timer _timeoutTimer;

  @override
  void initState() {
    super.initState();
    _statusTimer = Timer.periodic(2.seconds, (timer) {
      if (mounted) {
        setState(() {
          _statusIndex = (_statusIndex + 1) % _statuses.length;
        });
      }
    });

    _timeoutTimer = Timer(15.seconds, () {
      if (mounted) {
        // Simple way to handle timeout failure - the parent will listen to state changes
        // but we can also manually trigger a failure if needed.
        // However, the spec says "Never leave overlay hanging — always dismiss on terminal states".
        // The ConnectionNotifier should ideally handle timeouts, but we'll add a safety guard here.
        Navigator.of(context, rootNavigator: true).pop();
      }
    });
  }

  @override
  void dispose() {
    _statusTimer.cancel();
    _timeoutTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // Backdrop Blur
            _SafeBackdropFilter(
              sigmaX: 10,
              sigmaY: 10,
              child: Container(color: Colors.black.withValues(alpha: 0.75)),
            ),

            // Content Card
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border, width: 0.8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Animated Rings
                    _AnimatedRings(),

                    const SizedBox(height: 24),

                    // Status Text
                    SizedBox(
                      height: 24,
                      child: AnimatedSwitcher(
                        duration: 500.ms,
                        child: Text(
                          _statuses[_statusIndex],
                          key: ValueKey(_statuses[_statusIndex]),
                          style: const TextStyle(
                            fontFamily: 'Satoshi',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.onSurface,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Device Name
                    Text(
                      widget.deviceName,
                      style: TextStyle(
                        fontFamily: 'Satoshi',
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.muted.withValues(alpha: 0.8),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Cancel Button
                    TextButton(
                      onPressed: () {
                        widget.onCancel?.call();
                        ref
                            .read(connectionNotifierProvider.notifier)
                            .disconnect();
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontFamily: 'Satoshi',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.muted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedRings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Inner Ring
          const _Ring(
            size: 20,
            color: AppColors.primary,
            thickness: 2,
          ).animate(onPlay: (c) => c.repeat()).rotate(duration: 1000.ms),

          // Mid Ring
          _Ring(
                size: 40,
                color: AppColors.primaryWithOpacity(0.33),
                thickness: 2,
              )
              .animate(onPlay: (c) => c.repeat())
              .rotate(duration: 1500.ms, begin: 0.1),

          // Outer Ring
          _Ring(
                size: 60,
                color: AppColors.muted.withValues(alpha: 0.2),
                thickness: 2,
              )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .rotate(duration: 2000.ms),
        ],
      ),
    );
  }
}

class _Ring extends StatelessWidget {
  final double size;
  final Color color;
  final double thickness;

  const _Ring({
    required this.size,
    required this.color,
    required this.thickness,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: thickness),
      ),
      child: Center(
        child: Container(
          width: 4,
          height: 4,
          margin: EdgeInsets.only(bottom: size - 4),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
      ),
    );
  }
}

class _SafeBackdropFilter extends StatelessWidget {
  final double sigmaX;
  final double sigmaY;
  final Widget child;

  const _SafeBackdropFilter({
    required this.sigmaX,
    required this.sigmaY,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    try {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
        child: child,
      );
    } catch (e) {
      // Fallback for low-end devices or render errors
      return child;
    }
  }
}
