import 'dart:math' as math;
import 'package:atv_remote/core/theme/app_colors.dart';
import 'package:atv_remote/core/errors/failures.dart';
import 'package:atv_remote/domain/entities/pairing_status.dart';
import 'package:atv_remote/presentation/providers/connection_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PinCountdownTimer extends ConsumerStatefulWidget {
  const PinCountdownTimer({super.key});

  @override
  ConsumerState<PinCountdownTimer> createState() => _PinCountdownTimerState();
}

class _PinCountdownTimerState extends ConsumerState<PinCountdownTimer>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  int _totalSeconds = 60;
  bool _isExpired = false;

  @override
  void initState() {
    super.initState();
  }

  void _initTimer(int seconds) {
    _totalSeconds = seconds;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: seconds),
    );
    _controller!.forward();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(connectionNotifierProvider);

    ref.listen(connectionNotifierProvider, (previous, next) {
      if (next is Disconnected && next.reason.contains('expired')) {
        if (mounted && !_isExpired) setState(() => _isExpired = true);
      }
      if (next is PinExpiredFailure) {
        // Just in case it emits Failure instead of PairingStatus
      }
    });

    if (status is AwaitingPin && _controller == null) {
      _initTimer(status.expiresInSeconds);
    }

    if (_isExpired) {
      return const Text(
        'PIN expired',
        style: TextStyle(
          color: AppColors.error,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    if (_controller == null) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _controller!,
      builder: (context, child) {
        final remainingSeconds =
            _totalSeconds - (_controller!.value * _totalSeconds).floor();
        final progress = 1.0 - _controller!.value;

        if (remainingSeconds <= 0 && !_isExpired) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _isExpired = true);
          });
        }

        final isWarning = progress <= 0.3 && progress > 0.1;
        final isError = progress <= 0.1;

        Color ringColor = AppColors.primary;
        if (isWarning) ringColor = Colors.amber;
        if (isError) ringColor = AppColors.error;

        Widget textWidget = Text(
          remainingSeconds.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold, // headlineMedium equivalent
            color: isError ? AppColors.error : Colors.white,
          ),
        );

        if (isError) {
          final pulseScale =
              1.0 + 0.2 * math.sin(_controller!.value * math.pi * 20);
          textWidget = Transform.scale(scale: pulseScale, child: textWidget);
        }

        return SizedBox(
          width: 80,
          height: 80,
          child: CustomPaint(
            painter: _TimerRingPainter(
              progress: progress,
              ringColor: ringColor,
            ),
            child: Center(child: textWidget),
          ),
        );
      },
    );
  }
}

class _TimerRingPainter extends CustomPainter {
  final double progress;
  final Color ringColor;

  _TimerRingPainter({required this.progress, required this.ringColor});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;

    final bgPaint = Paint()
      ..color = AppColors.divider
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(center, radius, bgPaint);

    final fgPaint = Paint()
      ..color = ringColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(_TimerRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.ringColor != ringColor;
  }
}
