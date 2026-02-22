import 'dart:async';
import 'dart:math' as math;

import 'package:atv_remote/core/theme/app_colors.dart';
import 'package:atv_remote/presentation/providers/connection_provider.dart';
import 'package:atv_remote/presentation/providers/remote_provider.dart';
import 'package:atv_remote/presentation/screens/remote/widgets/remote_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DpadControl extends ConsumerStatefulWidget {
  const DpadControl({super.key});

  @override
  ConsumerState<DpadControl> createState() => _DpadControlState();
}

class _DpadControlState extends ConsumerState<DpadControl>
    with SingleTickerProviderStateMixin {
  late final AnimationController _glowController;
  late final Animation<double> _glowPulse;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _glowPulse = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  void _sendKey(String keyCode) {
    ref.read(remoteNotifierProvider.notifier).sendKey(keyCode);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isConnected = ref.watch(
      connectionNotifierProvider.select((s) => s.isConnected),
    );
    final ringSize = math.min(screenWidth * 0.65, 260.0);
    final okSize = ringSize * 0.35;

    return Center(
      child: SizedBox(
        width: screenWidth * 0.9,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Left Side: Volume Controls
            _SideColumn(
              children: [
                RemoteButton(
                  icon: const Icon(Icons.add_rounded),
                  size: 44,
                  onPressed: isConnected
                      ? () => _sendKey('KEYCODE_VOLUME_UP')
                      : null,
                ),
                const SizedBox(height: 12),
                const Icon(
                  Icons.volume_up_rounded,
                  color: AppColors.muted,
                  size: 16,
                ),
                const SizedBox(height: 12),
                RemoteButton(
                  icon: const Icon(Icons.remove_rounded),
                  size: 44,
                  onPressed: isConnected
                      ? () => _sendKey('KEYCODE_VOLUME_DOWN')
                      : null,
                ),
              ],
            ),

            const SizedBox(width: 20),

            // Center: Circular D-Pad
            Stack(
              alignment: Alignment.center,
              children: [
                // Layer 1: The Ring
                Container(
                  width: ringSize,
                  height: ringSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surface,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.05),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.4),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                ),

                // Layer 2: Direction Icons (Visual only, wrapping in buttons later)
                _DirectionButton(
                  alignment: Alignment.topCenter,
                  icon: Icons.keyboard_arrow_up_rounded,
                  ringSize: ringSize,
                  onPressed: isConnected
                      ? () => _sendKey('KEYCODE_DPAD_UP')
                      : null,
                ),
                _DirectionButton(
                  alignment: Alignment.bottomCenter,
                  icon: Icons.keyboard_arrow_down_rounded,
                  ringSize: ringSize,
                  onPressed: isConnected
                      ? () => _sendKey('KEYCODE_DPAD_DOWN')
                      : null,
                ),
                _DirectionButton(
                  alignment: Alignment.centerLeft,
                  icon: Icons.keyboard_arrow_left_rounded,
                  ringSize: ringSize,
                  onPressed: isConnected
                      ? () => _sendKey('KEYCODE_DPAD_LEFT')
                      : null,
                ),
                _DirectionButton(
                  alignment: Alignment.centerRight,
                  icon: Icons.keyboard_arrow_right_rounded,
                  ringSize: ringSize,
                  onPressed: isConnected
                      ? () => _sendKey('KEYCODE_DPAD_RIGHT')
                      : null,
                ),

                // Layer 3: Center OK Button
                AnimatedBuilder(
                  animation: _glowPulse,
                  builder: (context, child) {
                    final glowOpacity = isConnected
                        ? (0.3 + (_glowPulse.value * 0.3))
                        : 0.0;
                    return Container(
                      width: okSize,
                      height: okSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(
                              alpha: glowOpacity,
                            ),
                            blurRadius: 25,
                            spreadRadius: 8,
                          ),
                        ],
                      ),
                      child: child,
                    );
                  },
                  child: RemoteButton(
                    label: 'OK',
                    size: okSize,
                    style: RemoteButtonStyle.primary,
                    enableLongPress: true,
                    onPressed: isConnected
                        ? () => _sendKey('KEYCODE_DPAD_CENTER')
                        : null,
                  ),
                ),
              ],
            ),

            const SizedBox(width: 20),

            // Right Side: Channel Controls
            _SideColumn(
              children: [
                RemoteButton(
                  icon: const Icon(Icons.keyboard_arrow_up_rounded),
                  size: 44,
                  onPressed: isConnected
                      ? () => _sendKey('KEYCODE_CHANNEL_UP')
                      : null,
                ),
                const SizedBox(height: 12),
                const Text(
                  'CH',
                  style: TextStyle(
                    color: AppColors.muted,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                RemoteButton(
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  size: 44,
                  onPressed: isConnected
                      ? () => _sendKey('KEYCODE_CHANNEL_DOWN')
                      : null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SideColumn extends StatelessWidget {
  final List<Widget> children;
  const _SideColumn({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(children: children),
    );
  }
}

class _DirectionButton extends StatefulWidget {
  final Alignment alignment;
  final IconData icon;
  final double ringSize;
  final VoidCallback? onPressed;

  const _DirectionButton({
    required this.alignment,
    required this.icon,
    required this.ringSize,
    this.onPressed,
  });

  @override
  State<_DirectionButton> createState() => _DirectionButtonState();
}

class _DirectionButtonState extends State<_DirectionButton> {
  Timer? _longPressTimer;
  Timer? _repeatTimer;
  bool _isPressed = false;

  void _startPress() {
    if (widget.onPressed == null) return;
    setState(() => _isPressed = true);
    widget.onPressed!();

    _longPressTimer = Timer(const Duration(milliseconds: 400), () {
      _repeatTimer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
        widget.onPressed!();
      });
    });
  }

  void _stopPress() {
    setState(() => _isPressed = false);
    _longPressTimer?.cancel();
    _repeatTimer?.cancel();
  }

  @override
  void dispose() {
    _longPressTimer?.cancel();
    _repeatTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final buttonSize = widget.ringSize * 0.35;

    return Align(
      alignment: widget.alignment,
      child: GestureDetector(
        onTapDown: (_) => _startPress(),
        onTapUp: (_) => _stopPress(),
        onTapCancel: () => _stopPress(),
        behavior: HitTestBehavior.opaque,
        child: AnimatedScale(
          scale: _isPressed ? 0.9 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: Container(
            width: buttonSize,
            height: buttonSize,
            color: Colors.transparent, // Capture taps
            child: Icon(
              widget.icon,
              color: _isPressed ? AppColors.primary : AppColors.muted,
              size: 32,
            ),
          ),
        ),
      ),
    );
  }
}
