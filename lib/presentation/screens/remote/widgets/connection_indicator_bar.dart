import 'package:atv_remote/core/theme/app_colors.dart';
import 'package:atv_remote/presentation/providers/connection_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConnectionIndicatorBar extends ConsumerStatefulWidget {
  const ConnectionIndicatorBar({super.key});

  @override
  ConsumerState<ConnectionIndicatorBar> createState() =>
      _ConnectionIndicatorBarState();
}

class _ConnectionIndicatorBarState extends ConsumerState<ConnectionIndicatorBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final connectionState = ref.watch(connectionNotifierProvider);

    return connectionState.maybeWhen(
      connected: (_) => const SizedBox.shrink(),
      reconnecting: (device, attempt) => AnimatedBuilder(
        animation: _pulseAnim,
        builder: (context, child) {
          return Opacity(opacity: _pulseAnim.value, child: child);
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.warning.withValues(alpha: 0.15),
            border: Border(
              bottom: BorderSide(
                color: AppColors.warning.withValues(alpha: 0.4),
                width: 1,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.warning,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Reconnecting… (attempt $attempt)',
                style: const TextStyle(
                  color: AppColors.warning,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
      orElse: () => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.12),
          border: Border(
            bottom: BorderSide(
              color: AppColors.error.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_rounded, color: AppColors.error, size: 14),
            SizedBox(width: 8),
            Text(
              'Disconnected',
              style: TextStyle(
                color: AppColors.error,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
