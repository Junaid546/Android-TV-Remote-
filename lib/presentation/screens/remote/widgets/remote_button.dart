import 'dart:async';

import 'package:atv_remote/core/utils/haptic_service.dart';
import 'package:atv_remote/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

enum RemoteButtonStyle { normal, primary, ghost, danger }

class RemoteButton extends StatefulWidget {
  final Widget? icon;
  final String? label;
  final VoidCallback? onPressed;
  final double size;
  final bool isActive;
  final RemoteButtonStyle style;
  final bool enableLongPress;

  const RemoteButton({
    super.key,
    this.icon,
    this.label,
    this.onPressed,
    this.size = 48,
    this.isActive = false,
    this.style = RemoteButtonStyle.normal,
    this.enableLongPress = false,
  }) : assert(icon != null || label != null, 'Provide icon or label');

  @override
  State<RemoteButton> createState() => _RemoteButtonState();
}

class _RemoteButtonState extends State<RemoteButton> {
  bool _pressed = false;
  bool _longPressing = false;
  bool _debouncing = false;
  Timer? _debounceTimer;
  Timer? _longPressInitialTimer;
  Timer? _longPressRepeatTimer;

  void _onTapDown(TapDownDetails _) {
    if (widget.onPressed == null) return;
    setState(() => _pressed = true);
    if (widget.enableLongPress) {
      _startLongPress();
    }
  }

  void _onTapUp(TapUpDetails _) {
    if (widget.onPressed == null) return;
    setState(() => _pressed = false);
    if (!_longPressing) {
      _fire();
    }
    _stopLongPress();
  }

  void _onTapCancel() {
    setState(() => _pressed = false);
    _stopLongPress();
  }

  void _startLongPress() {
    _longPressInitialTimer = Timer(const Duration(milliseconds: 400), () {
      _longPressing = true;
      _longPressRepeatTimer = Timer.periodic(
        const Duration(milliseconds: 300),
        (timer) {
          _fire();
        },
      );
    });
  }

  void _stopLongPress() {
    _longPressInitialTimer?.cancel();
    _longPressRepeatTimer?.cancel();
    _longPressing = false;
  }

  void _fire() {
    if (_debouncing && !_longPressing) return;
    _debouncing = true;
    HapticService.light();
    widget.onPressed?.call();
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 100), () {
      _debouncing = false;
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _stopLongPress();
    super.dispose();
  }

  Color get _bgColor {
    switch (widget.style) {
      case RemoteButtonStyle.normal:
        return AppColors.surface;
      case RemoteButtonStyle.primary:
        return AppColors.primary;
      case RemoteButtonStyle.ghost:
        return Colors.transparent;
      case RemoteButtonStyle.danger:
        return const Color(0xFF3A1010);
    }
  }

  Color get _fgColor {
    switch (widget.style) {
      case RemoteButtonStyle.normal:
        return AppColors.muted;
      case RemoteButtonStyle.primary:
        return Colors.white;
      case RemoteButtonStyle.ghost:
        return AppColors.muted;
      case RemoteButtonStyle.danger:
        return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null;

    return Opacity(
      opacity: isDisabled ? 0.35 : 1.0,
      child: GestureDetector(
        onTapDown: isDisabled ? null : _onTapDown,
        onTapUp: isDisabled ? null : _onTapUp,
        onTapCancel: isDisabled ? null : _onTapCancel,
        child: AnimatedScale(
          scale: _pressed ? 0.88 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: _bgColor,
              shape: BoxShape.circle,
              border: widget.isActive
                  ? Border.all(color: AppColors.primary, width: 2)
                  : widget.style == RemoteButtonStyle.normal
                  ? Border.all(
                      color: Colors.white.withValues(alpha: 0.06),
                      width: 1,
                    )
                  : null,
              boxShadow: widget.style == RemoteButtonStyle.primary
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: widget.icon != null
                  ? IconTheme(
                      data: IconThemeData(
                        color: _fgColor,
                        size: widget.size * 0.45,
                      ),
                      child: widget.icon!,
                    )
                  : Text(
                      widget.label!,
                      style: TextStyle(
                        color: _fgColor,
                        fontSize: widget.size * 0.25,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
