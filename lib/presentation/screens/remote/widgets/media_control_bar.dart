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

class MediaControlBar extends ConsumerWidget {
  const MediaControlBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ActionButton(
            icon: Icons.arrow_back_rounded,
            label: 'Back',
            onPressed: () =>
                _sendCommand(ref, AppConstants.kKeyBack.toString()),
          ),
          _ActionButton(
            icon: Icons.home_rounded,
            label: 'Home',
            onPressed: () =>
                _sendCommand(ref, AppConstants.kKeyHome.toString()),
          ),
          _ActionButton(
            icon: Icons.menu_rounded,
            label: 'Menu',
            onPressed: () =>
                _sendCommand(ref, AppConstants.kKeyMenu.toString()),
          ),
        ],
      ),
    );
  }
}

class ControlButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const ControlButton({
    super.key,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.s16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withAlpha(25)),
        ),
        child: Icon(icon, color: color, size: 28),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ControlButton(icon: icon, color: AppColors.muted, onPressed: onPressed),
        const SizedBox(height: AppSpacing.s8),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: AppColors.muted),
        ),
      ],
    );
  }
}
