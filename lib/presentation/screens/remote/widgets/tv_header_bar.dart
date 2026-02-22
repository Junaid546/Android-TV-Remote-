import 'package:atv_remote/core/theme/app_colors.dart';
import 'package:atv_remote/domain/entities/pairing_status.dart';
import 'package:atv_remote/presentation/providers/connection_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TvHeaderBar extends ConsumerStatefulWidget {
  const TvHeaderBar({super.key});

  @override
  ConsumerState<TvHeaderBar> createState() => _TvHeaderBarState();
}

class _TvHeaderBarState extends ConsumerState<TvHeaderBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
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
    final isConnected = connectionState is Connected;
    final device = connectionState.device;

    return SizedBox(
      height: 64,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // Left: Airplay pill badge
            _AirplayBadge(deviceName: device?.name),

            // Center: "Remote" title
            const Expanded(
              child: Center(
                child: Text(
                  'Remote',
                  style: TextStyle(
                    color: AppColors.muted,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ),

            // Right: Cast/WiFi icon with pulse if connected
            AnimatedBuilder(
              animation: _pulseAnim,
              builder: (context, child) {
                return Opacity(
                  opacity: isConnected ? _pulseAnim.value : 0.35,
                  child: child,
                );
              },
              child: IconButton(
                onPressed: () {},
                icon: Icon(
                  isConnected
                      ? Icons.cast_connected_rounded
                      : Icons.cast_rounded,
                  color: isConnected ? AppColors.primary : AppColors.muted,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AirplayBadge extends StatelessWidget {
  final String? deviceName;

  const _AirplayBadge({this.deviceName});

  @override
  Widget build(BuildContext context) {
    final label = deviceName != null ? deviceName! : 'Airplay';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.play_arrow_rounded,
            color: AppColors.muted,
            size: 13,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.onSurface,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.muted,
            size: 14,
          ),
        ],
      ),
    );
  }
}
