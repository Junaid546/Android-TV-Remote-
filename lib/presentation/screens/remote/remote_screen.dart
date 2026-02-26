import 'dart:async';

import 'package:atv_remote/core/theme/app_colors.dart';
import 'package:atv_remote/domain/entities/pairing_status.dart';
import 'package:atv_remote/presentation/providers/connection_provider.dart';
import 'package:atv_remote/presentation/providers/remote_provider.dart';
import 'package:atv_remote/presentation/screens/remote/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RemoteScreen extends ConsumerStatefulWidget {
  const RemoteScreen({super.key});

  @override
  ConsumerState<RemoteScreen> createState() => _RemoteScreenState();
}

class _RemoteScreenState extends ConsumerState<RemoteScreen> {
  int _volumePreview = 6;
  bool _volumeMutedPreview = false;

  void _sendKey(String keyCode) {
    ref.read(remoteNotifierProvider.notifier).sendKey(keyCode);
  }

  void _sendVolume(bool up) {
    _sendKey(up ? 'KEYCODE_VOLUME_UP' : 'KEYCODE_VOLUME_DOWN');
    setState(() {
      _volumePreview = (_volumePreview + (up ? 1 : -1)).clamp(0, 10);
      if (_volumePreview > 0) {
        _volumeMutedPreview = false;
      }
    });
  }

  void _sendMute() {
    _sendKey('KEYCODE_VOLUME_MUTE');
    setState(() {
      _volumeMutedPreview = !_volumeMutedPreview;
    });
  }

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(connectionNotifierProvider);
    final remoteVolume = ref.watch(remoteVolumeStateStreamProvider).valueOrNull;
    final isConnected = status.isConnected;
    final deviceName = status.device?.name ?? 'No TV Connected';
    final volumePreview = remoteVolume?.levelOnTen ?? _volumePreview;
    final volumeMuted = remoteVolume?.muted ?? _volumeMutedPreview;
    final volumeLabel = remoteVolume != null
        ? '${remoteVolume.level}/${remoteVolume.max}'
        : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 2),
              child: Row(
                children: [
                  _TopActionButton(
                    icon: Icons.arrow_back_rounded,
                    tooltip: 'Return',
                    onTap: () {
                      if (context.canPop()) {
                        context.pop();
                        return;
                      }
                      context.go('/discovery');
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
                child: _RemoteShell(
                  isConnected: isConnected,
                  deviceName: deviceName,
                  onMenu: () => context.push('/discovery?manage=1'),
                  onReconnect: !isConnected && status.device != null
                      ? () => ref
                            .read(connectionNotifierProvider.notifier)
                            .reconnectRemote()
                      : null,
                  onPower: isConnected ? () => _sendKey('KEYCODE_POWER') : null,
                  onHome: isConnected ? () => _sendKey('KEYCODE_HOME') : null,
                  onBack: isConnected ? () => _sendKey('KEYCODE_BACK') : null,
                  onMute: isConnected ? _sendMute : null,
                  onColorMenu: isConnected
                      ? () => _showQuickActions(context)
                      : null,
                  onVolumeUp: isConnected ? () => _sendVolume(true) : null,
                  onVolumeDown: isConnected ? () => _sendVolume(false) : null,
                  onDpadUp: isConnected
                      ? () => _sendKey('KEYCODE_DPAD_UP')
                      : null,
                  onDpadDown: isConnected
                      ? () => _sendKey('KEYCODE_DPAD_DOWN')
                      : null,
                  onDpadLeft: isConnected
                      ? () => _sendKey('KEYCODE_DPAD_LEFT')
                      : null,
                  onDpadRight: isConnected
                      ? () => _sendKey('KEYCODE_DPAD_RIGHT')
                      : null,
                  onOk: isConnected
                      ? () => _sendKey('KEYCODE_DPAD_CENTER')
                      : null,
                  volumePreview: volumePreview,
                  volumeMuted: volumeMuted,
                  volumeLabel: volumeLabel,
                  connectionStatus: status,
                ),
              ),
            ),
            const BottomNavBar(currentIndex: 0),
          ],
        ),
      ),
    );
  }

  Future<void> _showQuickActions(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 38,
                height: 4,
                margin: const EdgeInsets.only(bottom: 18),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              _ActionTile(
                icon: Icons.subtitles_rounded,
                title: 'Captions',
                onTap: () {
                  Navigator.of(context).pop();
                  _sendKey('KEYCODE_CAPTIONS');
                },
              ),
              _ActionTile(
                icon: Icons.input_rounded,
                title: 'Input',
                onTap: () {
                  Navigator.of(context).pop();
                  _sendKey('KEYCODE_TV_INPUT');
                },
              ),
              _ActionTile(
                icon: Icons.settings_rounded,
                title: 'Settings',
                onTap: () {
                  Navigator.of(context).pop();
                  _sendKey('KEYCODE_SETTINGS');
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RemoteShell extends StatelessWidget {
  const _RemoteShell({
    required this.isConnected,
    required this.deviceName,
    required this.onMenu,
    required this.onReconnect,
    required this.onPower,
    required this.onHome,
    required this.onBack,
    required this.onMute,
    required this.onColorMenu,
    required this.onVolumeUp,
    required this.onVolumeDown,
    required this.onDpadUp,
    required this.onDpadDown,
    required this.onDpadLeft,
    required this.onDpadRight,
    required this.onOk,
    required this.volumePreview,
    required this.volumeMuted,
    required this.volumeLabel,
    required this.connectionStatus,
  });

  final bool isConnected;
  final String deviceName;
  final VoidCallback onMenu;
  final VoidCallback? onReconnect;
  final VoidCallback? onPower;
  final VoidCallback? onHome;
  final VoidCallback? onBack;
  final VoidCallback? onMute;
  final VoidCallback? onColorMenu;
  final VoidCallback? onVolumeUp;
  final VoidCallback? onVolumeDown;
  final VoidCallback? onDpadUp;
  final VoidCallback? onDpadDown;
  final VoidCallback? onDpadLeft;
  final VoidCallback? onDpadRight;
  final VoidCallback? onOk;
  final int volumePreview;
  final bool volumeMuted;
  final String? volumeLabel;
  final PairingStatus connectionStatus;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(56),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1C1D20), Color(0xFF141417)],
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
          width: 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.55),
            blurRadius: 36,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
        child: Column(
          children: [
            Row(
              children: [
                _CircleActionButton(
                  icon: Icons.menu_rounded,
                  onPressed: onMenu,
                  size: 58,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        isConnected ? 'CONNECTED TO' : 'REMOTE STATUS',
                        style: TextStyle(
                          color: const Color(0xFF8F939A).withValues(alpha: 0.9),
                          letterSpacing: 2.3,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        deviceName,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.95),
                          fontSize: 33,
                          fontWeight: FontWeight.w600,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 58),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _CircleActionButton(
                  icon: Icons.power_settings_new_rounded,
                  iconColor: const Color(0xFFFF7A1A),
                  onPressed: onPower,
                ),
                _CircleActionButton(
                  icon: Icons.home_rounded,
                  onPressed: onHome,
                ),
              ],
            ),
            const SizedBox(height: 22),
            _DpadRing(
              onUp: onDpadUp,
              onDown: onDpadDown,
              onLeft: onDpadLeft,
              onRight: onDpadRight,
              onOk: onOk,
            ),
            const SizedBox(height: 18),
            const _PagerDots(),
            const SizedBox(height: 18),
            _VolumePill(
              level: volumePreview,
              isMuted: volumeMuted,
              label: volumeLabel,
              onMinus: onVolumeDown,
              onPlus: onVolumeUp,
            ),
            const SizedBox(height: 22),
            _CircleActionButton(
              onPressed: onColorMenu,
              size: 86,
              child: const _ColorGlyph(),
            ),
            const SizedBox(height: 26),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _CircleActionButton(
                  icon: Icons.arrow_back_rounded,
                  onPressed: onBack,
                ),
                _CircleActionButton(
                  icon: Icons.volume_off_rounded,
                  onPressed: onMute,
                ),
              ],
            ),
            const SizedBox(height: 8),
            _StatusLine(status: connectionStatus, onReconnect: onReconnect),
          ],
        ),
      ),
    );
  }
}

class _DpadRing extends StatelessWidget {
  const _DpadRing({
    required this.onUp,
    required this.onDown,
    required this.onLeft,
    required this.onRight,
    required this.onOk,
  });

  final VoidCallback? onUp;
  final VoidCallback? onDown;
  final VoidCallback? onLeft;
  final VoidCallback? onRight;
  final VoidCallback? onOk;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.maxWidth.clamp(240.0, 460.0).toDouble();
        final centerSize = size * 0.34;

        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF15171B),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.35),
                      blurRadius: 34,
                      offset: const Offset(0, 18),
                    ),
                  ],
                ),
              ),
              _RingDirectionButton(
                alignment: Alignment.topCenter,
                icon: Icons.keyboard_arrow_up_rounded,
                onPressed: onUp,
              ),
              _RingDirectionButton(
                alignment: Alignment.bottomCenter,
                icon: Icons.keyboard_arrow_down_rounded,
                onPressed: onDown,
              ),
              _RingDirectionButton(
                alignment: Alignment.centerLeft,
                icon: Icons.keyboard_arrow_left_rounded,
                onPressed: onLeft,
              ),
              _RingDirectionButton(
                alignment: Alignment.centerRight,
                icon: Icons.keyboard_arrow_right_rounded,
                onPressed: onRight,
              ),
              _CircleActionButton(
                size: centerSize,
                onPressed: onOk,
                label: 'OK',
                textStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.78),
                  fontWeight: FontWeight.w700,
                  fontSize: centerSize * 0.25,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RingDirectionButton extends StatelessWidget {
  const _RingDirectionButton({
    required this.alignment,
    required this.icon,
    required this.onPressed,
  });

  final Alignment alignment;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: _CircleActionButton(
        size: 84,
        onPressed: onPressed,
        icon: icon,
        fillColor: Colors.transparent,
        borderColor: Colors.transparent,
        iconColor: const Color(0xFFADB0B5),
        enableHold: true,
      ),
    );
  }
}

class _PagerDots extends StatelessWidget {
  const _PagerDots();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _Dot(active: false),
        _Dot(active: false),
        _Dot(active: true),
        _Dot(active: true),
        _Dot(active: true),
        _Dot(active: true),
        _Dot(active: false),
        _Dot(active: false),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? const Color(0xFFFF7A1A) : const Color(0xFF3A3D42),
      ),
    );
  }
}

class _VolumePill extends StatelessWidget {
  const _VolumePill({
    required this.level,
    required this.isMuted,
    required this.label,
    required this.onMinus,
    required this.onPlus,
  });

  final int level;
  final bool isMuted;
  final String? label;
  final VoidCallback? onMinus;
  final VoidCallback? onPlus;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34),
        color: const Color(0xFF17191E),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          _CircleActionButton(
            icon: Icons.remove_rounded,
            size: 46,
            onPressed: onMinus,
            enableHold: true,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 4,
                color: const Color(0xFF3B3F46),
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: isMuted ? 0 : (level / 10).clamp(0.0, 1.0),
                  child: Container(color: const Color(0xFFFF6F1F)),
                ),
              ),
            ),
          ),
          if (label != null) ...[
            const SizedBox(width: 8),
            Text(
              isMuted ? 'MUTE' : label!,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.62),
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          const SizedBox(width: 10),
          _CircleActionButton(
            icon: Icons.add_rounded,
            size: 46,
            onPressed: onPlus,
            enableHold: true,
          ),
        ],
      ),
    );
  }
}

class _ColorGlyph extends StatelessWidget {
  const _ColorGlyph();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        _MiniColorDot(Color(0xFF2A7EEA)),
        _MiniColorDot(Color(0xFFE64545)),
        _MiniColorDot(Color(0xFFFFB11B)),
        _MiniColorDot(Color(0xFF46AF4A)),
      ],
    );
  }
}

class _MiniColorDot extends StatelessWidget {
  const _MiniColorDot(this.color);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

class _StatusLine extends StatelessWidget {
  const _StatusLine({required this.status, this.onReconnect});

  final PairingStatus status;
  final VoidCallback? onReconnect;

  @override
  Widget build(BuildContext context) {
    final statusText = status.map(
      idle: (_) => 'Not connected',
      discoveryStarted: (_) => 'Scanning for TVs',
      devicesFound: (_) => 'TVs found',
      connecting: (_) => 'Connecting',
      awaitingPin: (_) => 'Awaiting pairing PIN',
      pinVerified: (_) => 'PIN verified',
      paired: (_) => 'Finishing connection',
      connected: (_) => 'Connected',
      reconnecting: (value) => value.attempt <= 0
          ? 'Reconnecting'
          : 'Reconnecting (${value.attempt})',
      disconnected: (_) => 'Disconnected',
      connectionFailed: (_) => 'Connection failed',
      pinError: (_) => 'Invalid PIN',
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          statusText,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.42),
            fontSize: 11,
            letterSpacing: 0.2,
          ),
        ),
        if (onReconnect != null &&
            (status is Disconnected || status is ConnectionFailed)) ...[
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onReconnect,
            child: Text(
              'Reconnect',
              style: TextStyle(
                color: AppColors.primary.withValues(alpha: 0.95),
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _CircleActionButton extends StatefulWidget {
  const _CircleActionButton({
    this.icon,
    this.label,
    this.child,
    this.textStyle,
    this.iconColor,
    this.fillColor,
    this.borderColor,
    this.onPressed,
    this.enableHold = false,
    this.size = 74,
  }) : assert(icon != null || label != null || child != null);

  final IconData? icon;
  final String? label;
  final Widget? child;
  final TextStyle? textStyle;
  final Color? iconColor;
  final Color? fillColor;
  final Color? borderColor;
  final VoidCallback? onPressed;
  final bool enableHold;
  final double size;

  @override
  State<_CircleActionButton> createState() => _CircleActionButtonState();
}

class _CircleActionButtonState extends State<_CircleActionButton> {
  Timer? _holdStart;
  Timer? _holdRepeat;
  bool _pressed = false;

  void _startPress() {
    if (widget.onPressed == null) return;
    setState(() => _pressed = true);
    widget.onPressed!.call();

    if (!widget.enableHold) return;

    _holdStart = Timer(const Duration(milliseconds: 350), () {
      _holdRepeat = Timer.periodic(const Duration(milliseconds: 130), (_) {
        widget.onPressed?.call();
      });
    });
  }

  void _endPress() {
    setState(() => _pressed = false);
    _holdStart?.cancel();
    _holdRepeat?.cancel();
    _holdStart = null;
    _holdRepeat = null;
  }

  @override
  void dispose() {
    _holdStart?.cancel();
    _holdRepeat?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final disabled = widget.onPressed == null;
    final fill = widget.fillColor ?? const Color(0xFF14161B);
    final border = widget.borderColor ?? Colors.white.withValues(alpha: 0.04);

    return Opacity(
      opacity: disabled ? 0.34 : 1,
      child: GestureDetector(
        onTapDown: disabled ? null : (_) => _startPress(),
        onTapUp: disabled ? null : (_) => _endPress(),
        onTapCancel: disabled ? null : _endPress,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 110),
          scale: _pressed ? 0.92 : 1,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: fill,
              border: Border.all(color: border, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.42),
                  blurRadius: _pressed ? 8 : 14,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: Center(
              child:
                  widget.child ??
                  (widget.icon != null
                      ? Icon(
                          widget.icon,
                          color: widget.iconColor ?? const Color(0xFFA8B1C2),
                          size: widget.size * 0.42,
                        )
                      : Text(
                          widget.label!,
                          style:
                              widget.textStyle ??
                              const TextStyle(
                                color: Color(0xFFA8B1C2),
                                fontWeight: FontWeight.w700,
                                fontSize: 20,
                              ),
                        )),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: AppColors.muted),
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.onBackground,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      tileColor: AppColors.surfaceElevated,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14),
    );
  }
}

class _TopActionButton extends StatelessWidget {
  const _TopActionButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFF17191E),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Icon(icon, color: const Color(0xFFA8B1C2), size: 22),
        ),
      ),
    );
  }
}
