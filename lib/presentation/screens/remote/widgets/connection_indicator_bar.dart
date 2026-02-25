import 'package:atv_remote/core/errors/failures.dart';
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
      reconnecting: (_, attempt) => _buildStatusBar(
        color: AppColors.warning,
        text: attempt <= 0
            ? 'Establishing remote session...'
            : 'Reconnecting... (attempt $attempt)',
        pulse: true,
        showReconnectAction: attempt <= 0,
      ),
      paired: (_) => _buildStatusBar(
        color: AppColors.warning,
        text: 'Finalizing remote connection...',
        pulse: true,
        showReconnectAction: false,
      ),
      connectionFailed: (_, failure) => _buildStatusBar(
        color: AppColors.error,
        text: _failureMessage(failure),
        pulse: false,
        showReconnectAction: true,
      ),
      disconnected: (_, reason) => _buildStatusBar(
        color: AppColors.error,
        text: reason.isEmpty ? 'Remote disconnected' : reason,
        pulse: false,
        showReconnectAction: true,
      ),
      orElse: () => _buildStatusBar(
        color: AppColors.warning,
        text: 'Waiting for remote connection...',
        pulse: true,
        showReconnectAction: false,
      ),
    );
  }

  String _failureMessage(Failure failure) {
    if (failure is PairingFailure && failure.reason.isNotEmpty) {
      return failure.reason;
    }
    return failure.toString();
  }

  Widget _buildStatusBar({
    required Color color,
    required String text,
    required bool pulse,
    required bool showReconnectAction,
  }) {
    final child = Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        border: Border(
          bottom: BorderSide(color: color.withValues(alpha: 0.32), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (pulse) ...[
            const SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 8),
          ] else ...[
            Icon(Icons.wifi_off_rounded, color: color, size: 14),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              text,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (showReconnectAction) ...[
            const SizedBox(width: 8),
            TextButton(
              onPressed: () {
                ref.read(connectionNotifierProvider.notifier).reconnectRemote();
              },
              style: TextButton.styleFrom(
                foregroundColor: color,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: const Size(0, 24),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('Reconnect'),
            ),
          ],
        ],
      ),
    );

    if (!pulse) return child;
    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (context, widget) {
        return Opacity(opacity: _pulseAnim.value, child: widget);
      },
      child: child,
    );
  }
}
