import 'dart:async';
import 'dart:math' as math;

import 'package:atv_remote/core/theme/app_colors.dart';
import 'package:atv_remote/presentation/providers/network_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

// ─────────────────────────────────────────────
// Error type enum
// ─────────────────────────────────────────────

enum NetworkErrorType { noWifi, permissionDenied, networkSwitched }

NetworkErrorType _parseErrorType(String? raw) {
  switch (raw) {
    case 'permissionDenied':
      return NetworkErrorType.permissionDenied;
    case 'networkSwitched':
      return NetworkErrorType.networkSwitched;
    default:
      return NetworkErrorType.noWifi;
  }
}

// ─────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────

class NetworkErrorScreen extends ConsumerStatefulWidget {
  final String? returnTo;
  final String? errorTypeRaw;

  const NetworkErrorScreen({super.key, this.returnTo, this.errorTypeRaw});

  @override
  ConsumerState<NetworkErrorScreen> createState() => _NetworkErrorScreenState();
}

class _NetworkErrorScreenState extends ConsumerState<NetworkErrorScreen> {
  late NetworkErrorType _errorType;
  bool _isRetrying = false;
  bool _isPolling = false;
  Timer? _retryTimer;
  DateTime? _lastRetryTime;

  @override
  void initState() {
    super.initState();
    _errorType = _parseErrorType(widget.errorTypeRaw);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    _startPolling();
  }

  @override
  void dispose() {
    _retryTimer?.cancel();
    super.dispose();
  }

  void _startPolling() {
    _retryTimer?.cancel();
    _retryTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted) return;
      setState(() => _isPolling = true);
      // The wifiStatusProvider stream drives the listener in build().
      // Mark polling false after a short visual moment.
      Future.delayed(const Duration(milliseconds: 900), () {
        if (mounted) setState(() => _isPolling = false);
      });
    });
  }

  Future<void> _onRetry() async {
    // Enforce minimum 1s between retries
    final now = DateTime.now();
    if (_lastRetryTime != null &&
        now.difference(_lastRetryTime!) < const Duration(seconds: 1)) {
      return;
    }
    _lastRetryTime = now;

    setState(() => _isRetrying = true);
    // Give Riverpod stream a moment to re-emit, then clear state
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) setState(() => _isRetrying = false);
  }

  Future<void> _onOpenSettings() async {
    await openAppSettings();
  }

  String get _headline {
    switch (_errorType) {
      case NetworkErrorType.permissionDenied:
        return 'Permission Required';
      case NetworkErrorType.networkSwitched:
        return 'Network Changed';
      case NetworkErrorType.noWifi:
        return 'No WiFi Connection';
    }
  }

  String get _subtext {
    switch (_errorType) {
      case NetworkErrorType.noWifi:
        return 'Connect your phone to a WiFi network to find and control your TV.';
      case NetworkErrorType.permissionDenied:
        return 'Network permission is required to discover TVs on your local network.';
      case NetworkErrorType.networkSwitched:
        return 'Your WiFi network changed. Reconnecting may be required.';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Auto-navigate when WiFi is restored
    ref.listen(wifiStatusProvider, (_, next) {
      next.whenData((connected) {
        if (connected && mounted) {
          // Never go back to /remote directly — reconnect is needed
          final destination =
              (widget.returnTo == '/remote' || widget.returnTo == null)
              ? '/discovery'
              : widget.returnTo!;
          context.go(destination);
        }
      });
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // ── Animated WiFi icon ──
              const _WifiSearchingIcon()
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .scaleXY(
                    begin: 0.7,
                    end: 1.0,
                    curve: Curves.easeOutBack,
                    duration: 600.ms,
                  ),

              const SizedBox(height: 40),

              // ── Headline ──
              Text(
                    _headline,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Satoshi',
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onBackground,
                      letterSpacing: -0.3,
                      height: 1.2,
                    ),
                  )
                  .animate(delay: 150.ms)
                  .fadeIn(duration: 500.ms)
                  .slideY(begin: 0.15, end: 0, curve: Curves.easeOutCubic),

              const SizedBox(height: 14),

              // ── Subtext ──
              Text(
                    _subtext,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Satoshi',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.muted.withValues(alpha: 0.85),
                      height: 1.6,
                    ),
                  )
                  .animate(delay: 280.ms)
                  .fadeIn(duration: 500.ms)
                  .slideY(begin: 0.15, end: 0, curve: Curves.easeOutCubic),

              const Spacer(flex: 2),

              // ── Retry button ──
              _RetryButton(isLoading: _isRetrying, onPressed: _onRetry)
                  .animate(delay: 420.ms)
                  .fadeIn(duration: 500.ms)
                  .slideY(begin: 0.2, end: 0, curve: Curves.easeOutCubic),

              const SizedBox(height: 16),

              // ── Open Settings button ──
              _OpenSettingsButton(
                onPressed: _onOpenSettings,
              ).animate(delay: 520.ms).fadeIn(duration: 500.ms),

              const SizedBox(height: 40),

              // ── Checking status ──
              AnimatedOpacity(
                opacity: _isPolling ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Text(
                  'Checking connection…',
                  style: TextStyle(
                    fontFamily: 'Satoshi',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.muted.withValues(alpha: 0.55),
                    letterSpacing: 0.3,
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Animated WiFi searching icon
// ─────────────────────────────────────────────

class _WifiSearchingIcon extends StatelessWidget {
  const _WifiSearchingIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 32,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Center(
        child: SizedBox(
          width: 80,
          height: 80,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // Arc 3 — outer: delay 600ms
              const Positioned.fill(
                child: _AnimatedArc(
                  strokeWidth: 2.5,
                  padding: 0,
                  color: AppColors.muted,
                  delay: Duration(milliseconds: 600),
                ),
              ),
              // Arc 2 — mid: delay 300ms
              const Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: _AnimatedArc(
                    strokeWidth: 2.5,
                    padding: 0,
                    color: AppColors.muted,
                    delay: Duration(milliseconds: 300),
                  ),
                ),
              ),
              // Arc 1 — inner: delay 0ms
              const Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: _AnimatedArc(
                    strokeWidth: 2.5,
                    padding: 0,
                    color: AppColors.muted,
                    delay: Duration(),
                  ),
                ),
              ),
              // Center dot — primary color, no animation
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedArc extends StatelessWidget {
  final double strokeWidth;
  final double padding;
  final Color color;
  final Duration delay;

  const _AnimatedArc({
    required this.strokeWidth,
    required this.padding,
    required this.color,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return const Opacity(opacity: 0)
        .animate(onPlay: (c) => c.repeat(), delay: delay)
        .custom(
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeInOut,
          builder: (context, value, child) {
            // value goes 0→1 over duration; convert to a sine pulse 0→1→0
            final pulse = math.sin(value * math.pi);
            return CustomPaint(
              painter: _WifiArcPainter(
                color: color.withValues(alpha: pulse.clamp(0.0, 1.0)),
                strokeWidth: strokeWidth,
              ),
              child: child,
            );
          },
        );
  }
}

class _WifiArcPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;

  _WifiArcPainter({required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height - 8);
    final radius = size.width / 2;
    // Draw arc: 210° to 330° → top half of a circle (upward-facing wifi arc)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi * 1.2, // start: ~216°
      -math.pi * 0.4, // sweep: ~144° arc (top)
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_WifiArcPainter old) =>
      old.color != color || old.strokeWidth != strokeWidth;
}

// ─────────────────────────────────────────────
// Retry button with loading state + scale animation
// ─────────────────────────────────────────────

class _RetryButton extends StatefulWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const _RetryButton({required this.isLoading, required this.onPressed});

  @override
  State<_RetryButton> createState() => _RetryButtonState();
}

class _RetryButtonState extends State<_RetryButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scaleCtrl;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnim = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _scaleCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    await _scaleCtrl.forward();
    await _scaleCtrl.reverse();
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnim,
      child: GestureDetector(
        onTap: widget.isLoading ? null : _handleTap,
        child: Container(
          height: 56,
          width: double.infinity,
          decoration: BoxDecoration(
            color: widget.isLoading
                ? AppColors.primary.withValues(alpha: 0.65)
                : AppColors.primary,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.35),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: widget.isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.onBackground,
                      ),
                    ),
                  )
                : const Text(
                    'Retry',
                    style: TextStyle(
                      fontFamily: 'Satoshi',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onBackground,
                      letterSpacing: 0.3,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Open Settings secondary button
// ─────────────────────────────────────────────

class _OpenSettingsButton extends StatefulWidget {
  final VoidCallback onPressed;

  const _OpenSettingsButton({required this.onPressed});

  @override
  State<_OpenSettingsButton> createState() => _OpenSettingsButtonState();
}

class _OpenSettingsButtonState extends State<_OpenSettingsButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Text(
          'Open WiFi Settings',
          style: TextStyle(
            fontFamily: 'Satoshi',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: _pressed ? AppColors.primaryLight : AppColors.primary,
            decoration: _pressed
                ? TextDecoration.underline
                : TextDecoration.none,
            decorationColor: AppColors.primaryLight,
          ),
        ),
      ),
    );
  }
}
