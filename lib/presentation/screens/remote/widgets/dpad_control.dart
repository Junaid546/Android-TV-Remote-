import 'dart:async';

import 'package:atv_remote/core/constants/app_constants.dart';
import 'package:atv_remote/core/theme/app_colors.dart';
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

class DpadControl extends ConsumerWidget {
  const DpadControl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 280,
      height: 280,
      decoration: BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withAlpha(10), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            blurRadius: 30,
            spreadRadius: 10,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Center Select
          Align(
            alignment: Alignment.center,
            child: InkWell(
              onTap: () =>
                  _sendCommand(ref, AppConstants.kKeySelect.toString()),
              borderRadius: BorderRadius.circular(40),
              child: Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.circle_rounded,
                  color: Colors.black,
                  size: 40,
                ),
              ),
            ),
          ),
          // Up
          _DPadButton(
            alignment: Alignment.topCenter,
            icon: Icons.keyboard_arrow_up_rounded,
            onPressed: () => _sendCommand(ref, AppConstants.kKeyUp.toString()),
          ),
          // Down
          _DPadButton(
            alignment: Alignment.bottomCenter,
            icon: Icons.keyboard_arrow_down_rounded,
            onPressed: () =>
                _sendCommand(ref, AppConstants.kKeyDown.toString()),
          ),
          // Left
          _DPadButton(
            alignment: Alignment.centerLeft,
            icon: Icons.keyboard_arrow_left_rounded,
            onPressed: () =>
                _sendCommand(ref, AppConstants.kKeyLeft.toString()),
          ),
          // Right
          _DPadButton(
            alignment: Alignment.centerRight,
            icon: Icons.keyboard_arrow_right_rounded,
            onPressed: () =>
                _sendCommand(ref, AppConstants.kKeyRight.toString()),
          ),
        ],
      ),
    );
  }
}

class _DPadButton extends StatefulWidget {
  final Alignment alignment;
  final IconData icon;
  final VoidCallback onPressed;

  const _DPadButton({
    required this.alignment,
    required this.icon,
    required this.onPressed,
  });

  @override
  State<_DPadButton> createState() => _DPadButtonState();
}

class _DPadButtonState extends State<_DPadButton> {
  Timer? _initialTimer;
  Timer? _repeatTimer;

  void _start() {
    widget.onPressed();
    _initialTimer = Timer(const Duration(milliseconds: 300), () {
      _repeatTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        widget.onPressed();
      });
    });
  }

  void _stop() {
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
    return Align(
      alignment: widget.alignment,
      child: GestureDetector(
        onTapDown: (_) => _start(),
        onTapUp: (_) => _stop(),
        onTapCancel: () => _stop(),
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: 100,
          height: 100,
          child: Icon(widget.icon, color: AppColors.onBackground, size: 48),
        ),
      ),
    );
  }
}
