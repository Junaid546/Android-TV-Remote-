import 'package:atv_remote/core/theme/app_colors.dart';
import 'package:atv_remote/presentation/providers/connection_provider.dart';
import 'package:atv_remote/presentation/providers/remote_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavButtonsRow extends ConsumerWidget {
  const NavButtonsRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected = ref.watch(
      connectionNotifierProvider.select((s) => s.isConnected),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          _NavButton(
            label: 'BACK',
            onPressed: isConnected
                ? () => ref
                      .read(remoteNotifierProvider.notifier)
                      .sendKey('KEYCODE_BACK')
                : null,
          ),
          const SizedBox(width: 12),
          _NavButton(
            label: 'HOME',
            onPressed: isConnected
                ? () => ref
                      .read(remoteNotifierProvider.notifier)
                      .sendKey('KEYCODE_HOME')
                : null,
          ),
          const SizedBox(width: 12),
          _NavButton(
            label: 'EXIT',
            onPressed: isConnected
                ? () => ref
                      .read(remoteNotifierProvider.notifier)
                      .sendKey('KEYCODE_ESCAPE')
                : null,
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;

  const _NavButton({required this.label, this.onPressed});

  @override
  State<_NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<_NavButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null;

    return Expanded(
      child: GestureDetector(
        onTapDown: isDisabled ? null : (_) => setState(() => _isPressed = true),
        onTapUp: isDisabled
            ? null
            : (_) {
                setState(() => _isPressed = false);
                widget.onPressed!();
              },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          height: 52,
          decoration: BoxDecoration(
            color: _isPressed ? AppColors.surfaceElevated : AppColors.surface,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.white.withValues(alpha: _isPressed ? 0.1 : 0.05),
              width: 1.2,
            ),
          ),
          child: Center(
            child: Text(
              widget.label,
              style: TextStyle(
                color: isDisabled
                    ? AppColors.muted.withValues(alpha: 0.5)
                    : AppColors.onSurface,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
