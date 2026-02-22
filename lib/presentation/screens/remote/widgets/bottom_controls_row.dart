import 'package:atv_remote/core/theme/app_colors.dart';
import 'package:atv_remote/presentation/providers/connection_provider.dart';
import 'package:atv_remote/presentation/providers/remote_provider.dart';
import 'package:atv_remote/presentation/screens/remote/widgets/keyboard_sheet.dart';
import 'package:atv_remote/presentation/screens/remote/widgets/remote_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class BottomControlsRow extends ConsumerWidget {
  const BottomControlsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected = ref.watch(
      connectionNotifierProvider.select((s) => s.isConnected),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Keyboard Button
          _ControlButton(
            icon: Icons.keyboard_rounded,
            label: 'Keyboard',
            onPressed: isConnected ? () => _showKeyboard(context) : null,
          ),

          // Power Toggle
          const _PowerToggle(),

          // Settings Gear
          _ControlButton(
            icon: Icons.settings_rounded,
            label: 'Settings',
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
    );
  }

  void _showKeyboard(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const KeyboardSheet(),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  const _ControlButton({
    required this.icon,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RemoteButton(
          icon: Icon(icon),
          style: RemoteButtonStyle.normal,
          onPressed: onPressed,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(color: AppColors.muted, fontSize: 11),
        ),
      ],
    );
  }
}

class _PowerToggle extends ConsumerStatefulWidget {
  const _PowerToggle();

  @override
  ConsumerState<_PowerToggle> createState() => _PowerToggleState();
}

class _PowerToggleState extends ConsumerState<_PowerToggle> {
  bool _isOn = true;

  @override
  Widget build(BuildContext context) {
    final isConnected = ref.watch(
      connectionNotifierProvider.select((s) => s.isConnected),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: isConnected ? _handleToggle : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 70,
            height: 36,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: _isOn
                  ? AppColors.primary.withValues(alpha: 0.2)
                  : AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _isOn
                    ? AppColors.primary
                    : Colors.white.withValues(alpha: 0.1),
                width: 1.5,
              ),
            ),
            child: Stack(
              children: [
                AnimatedAlign(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutBack,
                  alignment: _isOn
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: _isOn
                          ? AppColors.primary
                          : AppColors.muted.withValues(alpha: 0.4),
                      shape: BoxShape.circle,
                      boxShadow: _isOn
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.4),
                                blurRadius: 8,
                              ),
                            ]
                          : [],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.power_settings_new_rounded,
                        color: _isOn ? Colors.white : AppColors.muted,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'On • Off',
          style: TextStyle(color: AppColors.muted, fontSize: 11),
        ),
      ],
    );
  }

  void _handleToggle() {
    if (_isOn) {
      // Confirm power off
      showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: const Text('Power Off?'),
          content: const Text('Are you sure you want to turn off the TV?'),
          actions: [
            CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                _sendPower();
                Navigator.pop(context);
              },
              child: const Text('Power Off'),
            ),
          ],
        ),
      );
    } else {
      _sendPower();
    }
  }

  void _sendPower() {
    ref.read(remoteNotifierProvider.notifier).sendKey('KEYCODE_POWER');
    setState(() => _isOn = !_isOn);
  }
}
