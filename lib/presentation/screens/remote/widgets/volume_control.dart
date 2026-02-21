import 'dart:async';

import 'package:atv_remote/core/constants/app_constants.dart';
import 'package:atv_remote/core/theme/app_colors.dart';
import 'package:atv_remote/core/theme/app_spacing.dart';
import 'package:atv_remote/presentation/providers/remote_provider.dart';
import 'package:atv_remote/presentation/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void _sendCommand(WidgetRef ref, String commandName) {
  final hapticEnabled = ref.read(settingsNotifierProvider).hapticEnabled;
  if (hapticEnabled) {
    HapticFeedback.lightImpact();
  }
  ref.read(remoteNotifierProvider.notifier).sendKey(commandName);
}

class VolumeControl extends ConsumerWidget {
  const VolumeControl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.s8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _VolumeButton(
              icon: Icons.remove_rounded,
              onPressed: () =>
                  _sendCommand(ref, AppConstants.kKeyVolumeDown.toString()),
            ),
            const SizedBox(width: AppSpacing.s16),
            const Icon(Icons.volume_up_rounded, color: AppColors.primary),
            const SizedBox(width: AppSpacing.s16),
            _VolumeButton(
              icon: Icons.add_rounded,
              onPressed: () =>
                  _sendCommand(ref, AppConstants.kKeyVolumeUp.toString()),
            ),
          ],
        ),
      ),
    );
  }
}

class _VolumeButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _VolumeButton({required this.icon, required this.onPressed});

  @override
  State<_VolumeButton> createState() => _VolumeButtonState();
}

class _VolumeButtonState extends State<_VolumeButton> {
  Timer? _initialTimer;
  Timer? _repeatTimer;
  bool _isPressed = false;

  void _start() {
    setState(() => _isPressed = true);
    widget.onPressed();
    _initialTimer = Timer(const Duration(milliseconds: 400), () {
      _repeatTimer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
        widget.onPressed();
      });
    });
  }

  void _stop() {
    setState(() => _isPressed = false);
    _initialTimer?.cancel();
    _repeatTimer?.cancel();
    _initialTimer = null;
    _repeatTimer = null;
  }

  @override
  void dispose() {
    _stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _start(),
      onTapUp: (_) => _stop(),
      onTapCancel: () => _stop(),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _isPressed
              ? AppColors.onBackground.withAlpha(20)
              : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(widget.icon, color: AppColors.onBackground),
      ),
    );
  }
}
