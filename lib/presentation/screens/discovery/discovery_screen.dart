import 'dart:async';

import 'package:atv_remote/core/theme/app_colors.dart';
import 'package:atv_remote/core/theme/app_spacing.dart';
import 'package:atv_remote/core/utils/haptic_service.dart';
import 'package:atv_remote/core/utils/network_permission_service.dart';
import 'package:atv_remote/domain/entities/pairing_status.dart';
import 'package:atv_remote/domain/entities/tv_device.dart';
import 'package:atv_remote/presentation/providers/connection_provider.dart';
import 'package:atv_remote/presentation/providers/discovery_provider.dart';
import 'package:atv_remote/presentation/providers/network_provider.dart';
import 'package:atv_remote/presentation/providers/saved_devices_provider.dart';
import 'package:atv_remote/presentation/screens/discovery/widgets/connecting_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// Discovery Screen (main screen widget)
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class DiscoveryScreen extends ConsumerStatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  ConsumerState<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends ConsumerState<DiscoveryScreen> {
  Timer? _timeoutTimer;
  bool _timedOut = false;
  bool _isOverlayVisible = false;

  late final _discoveryNotifier = ref.read(discoveryNotifierProvider.notifier);

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(_startDiscoveryWithPermissionCheck());
    });
  }

  @override
  void dispose() {
    _removeOverlay();
    _timeoutTimer?.cancel();
    _discoveryNotifier.stopDiscovery();
    super.dispose();
  }

  void _scheduleTimeout() {
    _timeoutTimer?.cancel();
    _timedOut = false;
    _timeoutTimer = Timer(const Duration(seconds: 30), () {
      if (!mounted) return;
      final devices =
          ref.read(discoveryNotifierProvider).valueOrNull ?? const [];
      if (devices.isEmpty) {
        setState(() => _timedOut = true);
      }
    });
  }

  void _removeOverlay() {
    if (!mounted || !_isOverlayVisible) return;
    _isOverlayVisible = false;
    Navigator.of(context, rootNavigator: true).maybePop();
  }

  void _showOverlay(BuildContext context, TvDevice device) {
    if (_isOverlayVisible) return;
    _isOverlayVisible = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (_) => ConnectingOverlay(deviceName: device.name),
    ).whenComplete(() {
      _isOverlayVisible = false;
    });
  }

  Future<void> _pullToRefresh() async {
    _timeoutTimer?.cancel();
    setState(() => _timedOut = false);
    await _discoveryNotifier.stopDiscovery();
    if (!mounted) return;
    await _startDiscoveryWithPermissionCheck();
  }

  Future<void> _startDiscoveryWithPermissionCheck() async {
    final hasPermission =
        await NetworkPermissionService.ensureRequiredPermissions();
    if (!mounted) return;

    if (!hasPermission) {
      context.go('/network-error?returnTo=/discovery&type=permissionDenied');
      return;
    }

    await _discoveryNotifier.startDiscovery();
    if (!mounted) return;
    _scheduleTimeout();
  }

  @override
  Widget build(BuildContext context) {
    // â”€â”€ WiFi guard â”€â”€
    ref.listen<AsyncValue<bool>>(wifiStatusProvider, (_, next) {
      next.whenData((connected) {
        if (!connected && mounted) {
          context.go('/network-error?returnTo=/discovery');
        }
      });
    });

    // â”€â”€ Connection state reactions â”€â”€
    ref.listen<PairingStatus>(connectionNotifierProvider, (prev, next) {
      next.maybeWhen(
        connecting: (device) => _showOverlay(context, device),
        reconnecting: (device, _) => _showOverlay(context, device),
        awaitingPin: (device, _) {
          if (prev is AwaitingPin) return;
          _removeOverlay();
          if (mounted) {
            context.go('/pairing?deviceId=${device.id}');
          }
        },
        connected: (_) {
          _removeOverlay();
          if (mounted) context.go('/remote');
        },
        connectionFailed: (device, failure) {
          _removeOverlay();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: AppColors.surface,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                content: Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: AppColors.primary,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Could not connect to ${device.name}',
                        style: const TextStyle(
                          fontFamily: 'Satoshi',
                          fontSize: 13,
                          color: AppColors.onBackground,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
        idle: () => _removeOverlay(),
        orElse: () {},
      );
    });

    final discoveryState = ref.watch(discoveryNotifierProvider);
    final isLoading = discoveryState.isLoading;
    final discoveredDevices = discoveryState.valueOrNull ?? const [];
    final savedDevices =
        ref.watch(savedDevicesNotifierProvider).valueOrNull ?? const [];
    final savedByIp = {
      for (final d in savedDevices)
        if (d.ipAddress.isNotEmpty) d.ipAddress: d,
    };
    final devices = discoveredDevices
        .map((device) {
          final saved = savedByIp[device.ipAddress];
          if (saved == null) return device;
          return device.copyWith(
            id: saved.id,
            name: saved.name.isNotEmpty ? saved.name : device.name,
            isPaired: saved.isPaired,
            lastConnected: saved.lastConnected,
            certificateFingerprint: saved.certificateFingerprint,
          );
        })
        .toList(growable: false);
    final hasDevices = devices.isNotEmpty;
    final showEmpty = _timedOut && !hasDevices && !isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // â”€â”€ Top bar â”€â”€
            _TopBar(),

            // â”€â”€ Scan header (radar + status text) â”€â”€
            _ScanHeaderSection(
              isLoading: isLoading,
              deviceCount: devices.length,
              timedOut: showEmpty,
            ),

            // â”€â”€ Device list / empty state â”€â”€
            Expanded(
              child: RefreshIndicator(
                color: AppColors.primary,
                backgroundColor: AppColors.surface,
                onRefresh: _pullToRefresh,
                child: showEmpty
                    ? _EmptyState(onTryAgain: _pullToRefresh)
                    : _DeviceList(devices: devices, isLoading: isLoading),
              ),
            ),

            // â”€â”€ Manual IP button â”€â”€
            _ManualIpButton(),

            const SizedBox(height: AppSpacing.s12),
          ],
        ),
      ),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// Top bar
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s20,
        vertical: AppSpacing.s12,
      ),
      child: Row(
        children: [
          // Logo + app name
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.tv_rounded, color: Colors.white, size: 18),
          ),
          const SizedBox(width: AppSpacing.s8),
          const Text(
            'Remote',
            style: TextStyle(
              fontFamily: 'Satoshi',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.onBackground,
              letterSpacing: -0.2,
            ),
          ),
          const Spacer(),
          // Settings button
          _IconActionButton(
            icon: Icons.settings_outlined,
            onTap: (context) => context.push('/settings'),
          ),
        ],
      ),
    );
  }
}

class _IconActionButton extends StatefulWidget {
  final IconData icon;
  final void Function(BuildContext context) onTap;

  const _IconActionButton({required this.icon, required this.onTap});

  @override
  State<_IconActionButton> createState() => _IconActionButtonState();
}

class _IconActionButtonState extends State<_IconActionButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap(context);
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: _pressed
              ? AppColors.surface
              : AppColors.surface.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border, width: 0.8),
        ),
        child: Icon(
          widget.icon,
          color: _pressed ? AppColors.primary : AppColors.muted,
          size: 20,
        ),
      ),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// Scan header â€“ animation + status text
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _ScanHeaderSection extends StatelessWidget {
  final bool isLoading;
  final int deviceCount;
  final bool timedOut;

  const _ScanHeaderSection({
    required this.isLoading,
    required this.deviceCount,
    required this.timedOut,
  });

  String get _statusText {
    if (timedOut) return 'No TVs found';
    if (deviceCount > 0) {
      return deviceCount == 1 ? '1 TV found' : '$deviceCount TVs found';
    }
    return 'Scanning for TVs...';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _ScanAnimationWidget(
            isScanning: isLoading || (!timedOut && deviceCount == 0),
            stopped: timedOut || deviceCount > 0,
            success: deviceCount > 0,
          ),
          const SizedBox(height: AppSpacing.s16),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              _statusText,
              key: ValueKey(_statusText),
              style: TextStyle(
                fontFamily: 'Satoshi',
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppColors.muted.withValues(alpha: 0.85),
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// Radar scan animation widget
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _ScanAnimationWidget extends ConsumerStatefulWidget {
  final bool isScanning;
  final bool stopped;
  final bool success;

  const _ScanAnimationWidget({
    required this.isScanning,
    required this.stopped,
    required this.success,
  });

  @override
  ConsumerState<_ScanAnimationWidget> createState() =>
      _ScanAnimationWidgetState();
}

class _ScanAnimationWidgetState extends ConsumerState<_ScanAnimationWidget>
    with TickerProviderStateMixin {
  late final List<AnimationController> _ringControllers;
  late final List<Animation<double>> _ringAnimations;
  late final AnimationController _fadeOutCtrl;
  late final AnimationController _resultCtrl;

  static const _ringDelays = [
    Duration.zero,
    Duration(milliseconds: 666),
    Duration(milliseconds: 1333),
  ];

  @override
  void initState() {
    super.initState();

    _ringControllers = List.generate(
      3,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 2000),
      ),
    );

    _ringAnimations = _ringControllers.map((ctrl) {
      return Tween<double>(
        begin: 0,
        end: 1,
      ).animate(CurvedAnimation(parent: ctrl, curve: Curves.easeOut));
    }).toList();

    _fadeOutCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      value: 1.0,
    );

    _resultCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _startRings();
  }

  Future<void> _startRings() async {
    for (int i = 0; i < 3; i++) {
      await Future.delayed(_ringDelays[i]);
      if (mounted) {
        unawaited(_ringControllers[i].repeat());
      }
    }
  }

  Future<void> _stopRings() async {
    await _fadeOutCtrl.animateTo(0.0);
    for (final c in _ringControllers) {
      c.stop();
    }
    if (mounted) unawaited(_resultCtrl.forward());
  }

  @override
  void didUpdateWidget(_ScanAnimationWidget old) {
    super.didUpdateWidget(old);
    if (!old.stopped && widget.stopped) {
      _stopRings();
    } else if (old.stopped && !widget.stopped) {
      // restart
      _fadeOutCtrl.value = 1.0;
      _resultCtrl.reset();
      _startRings();
    }
  }

  @override
  void dispose() {
    for (final c in _ringControllers) {
      c.dispose();
    }
    _fadeOutCtrl.dispose();
    _resultCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 80,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Rings
          FadeTransition(
            opacity: _fadeOutCtrl,
            child: Stack(
              alignment: Alignment.center,
              children: List.generate(3, (i) {
                return AnimatedBuilder(
                  animation: _ringAnimations[i],
                  builder: (_, _) {
                    final t = _ringAnimations[i].value;
                    final radius = 8 + (72 * t);
                    final opacity = (0.6 * (1 - t)).clamp(0.0, 0.6);
                    return CustomPaint(
                      painter: _RingPainter(
                        radius: radius,
                        opacity: opacity,
                        color: AppColors.primary,
                      ),
                      size: const Size(80, 80),
                    );
                  },
                );
              }),
            ),
          ),
          // Center dot
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          // Result icon (check/X) when stopped
          FadeTransition(
            opacity: _resultCtrl,
            child: ScaleTransition(
              scale: CurvedAnimation(
                parent: _resultCtrl,
                curve: Curves.easeOutBack,
              ),
              child: widget.success
                  ? const Icon(
                      Icons.check_circle_rounded,
                      color: AppColors.primary,
                      size: 32,
                    )
                  : widget.stopped
                  ? Icon(
                      Icons.tv_off_rounded,
                      color: AppColors.muted.withValues(alpha: 0.6),
                      size: 32,
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double radius;
  final double opacity;
  final Color color;

  _RingPainter({
    required this.radius,
    required this.opacity,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.radius != radius || old.opacity != opacity;
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// Device list
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _DeviceList extends StatelessWidget {
  final List<TvDevice> devices;
  final bool isLoading;

  const _DeviceList({required this.devices, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    if (isLoading && devices.isEmpty) {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s20,
          vertical: AppSpacing.s8,
        ),
        itemCount: 3,
        itemBuilder: (_, _) => const _SkeletonTile(),
      );
    }

    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(
        left: AppSpacing.s20,
        right: AppSpacing.s20,
        top: AppSpacing.s8,
        bottom: 16,
      ),
      itemCount: devices.length,
      itemBuilder: (context, index) {
        return _DeviceTile(device: devices[index], index: index);
      },
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// Device tile
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _DeviceTile extends ConsumerWidget {
  final TvDevice device;
  final int index;

  const _DeviceTile({required this.device, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasPreviousConnected =
        device.lastConnected != null && !device.isPaired;
    final canForgetSavedDevice =
        device.isPaired ||
        device.lastConnected != null ||
        device.certificateFingerprint != null;

    return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.s12),
          child: GestureDetector(
            onTap: () async {
              unawaited(HapticService.light());
              await ref
                  .read(connectionNotifierProvider.notifier)
                  .connectToDevice(device);
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: device.isPaired
                      ? AppColors.primary.withValues(alpha: 0.3)
                      : AppColors.border,
                  width: 0.8,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s16,
                  vertical: AppSpacing.s16,
                ),
                child: Row(
                  children: [
                    // â”€â”€ Icon container â”€â”€
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: device.isPaired
                            ? const LinearGradient(
                                colors: AppColors.glowGradient,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        color: device.isPaired
                            ? null
                            : AppColors.surfaceElevated,
                      ),
                      child: Icon(
                        Icons.tv_rounded,
                        color: device.isPaired
                            ? Colors.white
                            : AppColors.muted.withValues(alpha: 0.7),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s12),

                    // â”€â”€ Name + IP â”€â”€
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            device.name,
                            style: const TextStyle(
                              fontFamily: 'Satoshi',
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.onBackground,
                              letterSpacing: -0.1,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                device.ipAddress,
                                style: TextStyle(
                                  fontFamily: 'Satoshi',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.muted.withValues(
                                    alpha: 0.75,
                                  ),
                                  letterSpacing: 0.3,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.s8),
                              // Signal dots
                              _SignalDots(strength: device.signalStrength),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s8),

                    // â”€â”€ Status badge â”€â”€
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (canForgetSavedDevice)
                          PopupMenuButton<String>(
                            icon: Icon(
                              Icons.more_vert_rounded,
                              color: AppColors.muted.withValues(alpha: 0.8),
                              size: 18,
                            ),
                            padding: EdgeInsets.zero,
                            color: AppColors.surfaceElevated,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            onSelected: (value) async {
                              if (value != 'forget') return;
                              try {
                                await ref
                                    .read(connectionNotifierProvider.notifier)
                                    .forgetDevice(device);
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${device.name} removed'),
                                  ),
                                );
                              } catch (e) {
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(e.toString()),
                                    backgroundColor: AppColors.error,
                                  ),
                                );
                              }
                            },
                            itemBuilder: (context) => const [
                              PopupMenuItem<String>(
                                value: 'forget',
                                child: Text('Remove saved device'),
                              ),
                            ],
                          ),
                        if (device.isPaired)
                          const _StatusBadge(label: 'Paired', filled: true)
                        else if (hasPreviousConnected)
                          const _StatusBadge(
                            label: 'Previously connected',
                            filled: false,
                          ),
                        const SizedBox(height: 4),
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: AppColors.muted,
                          size: 20,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        .animate(delay: Duration(milliseconds: index * 50))
        .fadeIn(duration: 350.ms)
        .slideY(begin: 0.15, end: 0, curve: Curves.easeOut);
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final bool filled;

  const _StatusBadge({required this.label, required this.filled});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: filled ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(100),
        border: filled
            ? null
            : Border.all(
                color: AppColors.muted.withValues(alpha: 0.4),
                width: 0.8,
              ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Satoshi',
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: filled ? Colors.white : AppColors.muted,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class _SignalDots extends StatelessWidget {
  final int strength; // 0â€“4

  const _SignalDots({required this.strength});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(4, (i) {
        final filled = i < strength;
        return Container(
          margin: const EdgeInsets.only(right: 2),
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: filled
                ? AppColors.primary.withValues(alpha: 0.9)
                : AppColors.muted.withValues(alpha: 0.25),
          ),
        );
      }),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// Skeleton tile shimmer
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _SkeletonTile extends StatelessWidget {
  const _SkeletonTile();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s12),
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border, width: 0.8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s16,
            vertical: AppSpacing.s16,
          ),
          child: Row(
            children: [
              // Icon skeleton
              Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  )
                  .animate(onPlay: (c) => c.repeat())
                  .shimmer(
                    duration: 1400.ms,
                    color: AppColors.muted.withValues(alpha: 0.08),
                  ),
              const SizedBox(width: AppSpacing.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                          height: 12,
                          width: 120,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceElevated,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        )
                        .animate(onPlay: (c) => c.repeat())
                        .shimmer(
                          duration: 1400.ms,
                          delay: 200.ms,
                          color: AppColors.muted.withValues(alpha: 0.08),
                        ),
                    const SizedBox(height: 6),
                    Container(
                          height: 10,
                          width: 80,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceElevated,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        )
                        .animate(onPlay: (c) => c.repeat())
                        .shimmer(
                          duration: 1400.ms,
                          delay: 400.ms,
                          color: AppColors.muted.withValues(alpha: 0.08),
                        ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// Empty state (timeout, no devices)
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _EmptyState extends StatelessWidget {
  final VoidCallback onTryAgain;

  const _EmptyState({required this.onTryAgain});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.35,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                    Icons.tv_off_rounded,
                    size: 60,
                    color: AppColors.muted.withValues(alpha: 0.4),
                  )
                  .animate()
                  .fadeIn(duration: 500.ms)
                  .scaleXY(begin: 0.8, curve: Curves.easeOutBack),
              const SizedBox(height: AppSpacing.s20),
              const Text(
                'No TVs found',
                style: TextStyle(
                  fontFamily: 'Satoshi',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.onBackground,
                  letterSpacing: -0.2,
                ),
              ).animate(delay: 100.ms).fadeIn(duration: 400.ms),
              const SizedBox(height: AppSpacing.s8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Text(
                  'Make sure your TV is on and connected to the same WiFi network.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Satoshi',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.muted.withValues(alpha: 0.75),
                    height: 1.6,
                  ),
                ).animate(delay: 200.ms).fadeIn(duration: 400.ms),
              ),
              const SizedBox(height: AppSpacing.s24),
              OutlinedButton(
                onPressed: onTryAgain,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary, width: 1.2),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s24,
                    vertical: AppSpacing.s12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Try Again',
                  style: TextStyle(
                    fontFamily: 'Satoshi',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ).animate(delay: 300.ms).fadeIn(duration: 400.ms),
            ],
          ),
        ),
      ],
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// Manual IP button
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _ManualIpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s8, top: AppSpacing.s4),
      child: TextButton.icon(
        onPressed: () => _showManualIpSheet(context),
        icon: const Icon(
          Icons.keyboard_rounded,
          color: AppColors.muted,
          size: 18,
        ),
        label: const Text(
          'Enter IP manually',
          style: TextStyle(
            fontFamily: 'Satoshi',
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.muted,
          ),
        ),
        style: TextButton.styleFrom(
          splashFactory: InkRipple.splashFactory,
          overlayColor: AppColors.primary.withValues(alpha: 0.08),
        ),
      ),
    );
  }

  void _showManualIpSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _ManualIpBottomSheet(),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// Manual IP bottom sheet
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _ManualIpBottomSheet extends ConsumerStatefulWidget {
  const _ManualIpBottomSheet();

  @override
  ConsumerState<_ManualIpBottomSheet> createState() =>
      _ManualIpBottomSheetState();
}

class _ManualIpBottomSheetState extends ConsumerState<_ManualIpBottomSheet> {
  final _ipCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  String? _ipError;
  bool _isLoading = false;

  static const _ipPattern =
      r'^((25[0-5]|2[0-4]\d|[01]?\d\d?)\.){3}(25[0-5]|2[0-4]\d|[01]?\d\d?)$';

  @override
  void dispose() {
    _ipCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  bool _validateIp(String ip) {
    return RegExp(_ipPattern).hasMatch(ip);
  }

  Future<void> _handleConnect() async {
    final ip = _ipCtrl.text.trim();

    if (!_validateIp(ip)) {
      setState(() => _ipError = 'Enter a valid IP address (e.g. 192.168.1.50)');
      return;
    }
    setState(() {
      _ipError = null;
      _isLoading = true;
    });

    final name = _nameCtrl.text.trim().isEmpty
        ? 'Android TV'
        : _nameCtrl.text.trim();

    await ref
        .read(discoveryNotifierProvider.notifier)
        .addManualDevice(ip, name);

    if (!mounted) return;

    final error = ref.read(discoveryErrorProvider);
    setState(() => _isLoading = false);

    if (error != null) {
      setState(() => _ipError = error.toString());
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(AppSpacing.s24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppSpacing.s20),
                decoration: BoxDecoration(
                  color: AppColors.muted.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Title
            const Text(
              'Enter TV IP Address',
              style: TextStyle(
                fontFamily: 'Satoshi',
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.onBackground,
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(height: AppSpacing.s4),

            // Subtitle
            Text(
              'Find IP: TV Settings â†’ About â†’ Status â†’ IP address',
              style: TextStyle(
                fontFamily: 'Satoshi',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.muted.withValues(alpha: 0.7),
                height: 1.5,
              ),
            ),
            const SizedBox(height: AppSpacing.s24),

            // IP field
            TextField(
              controller: _ipCtrl,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [_IpAddressFormatter()],
              style: const TextStyle(
                fontFamily: 'Satoshi',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.onBackground,
                letterSpacing: 0.5,
              ),
              decoration: InputDecoration(
                hintText: '192.168.1.X',
                hintStyle: TextStyle(
                  fontFamily: 'Satoshi',
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: AppColors.muted.withValues(alpha: 0.4),
                  letterSpacing: 0.5,
                ),
                errorText: _ipError,
                errorStyle: const TextStyle(
                  fontFamily: 'Satoshi',
                  fontSize: 12,
                  color: AppColors.error,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.border,
                    width: 0.8,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1.5,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.error,
                    width: 1.0,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.error,
                    width: 1.5,
                  ),
                ),
                filled: true,
                fillColor: AppColors.surfaceElevated,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s16,
                  vertical: AppSpacing.s16,
                ),
              ),
              onChanged: (_) {
                if (_ipError != null) setState(() => _ipError = null);
              },
            ),

            const SizedBox(height: AppSpacing.s12),

            // Device name field
            TextField(
              controller: _nameCtrl,
              style: const TextStyle(
                fontFamily: 'Satoshi',
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.onBackground,
              ),
              decoration: InputDecoration(
                hintText: 'Living Room TV (optional)',
                hintStyle: TextStyle(
                  fontFamily: 'Satoshi',
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: AppColors.muted.withValues(alpha: 0.4),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.border,
                    width: 0.8,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1.5,
                  ),
                ),
                filled: true,
                fillColor: AppColors.surfaceElevated,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s16,
                  vertical: AppSpacing.s16,
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.s20),

            // Connect button
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleConnect,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: AppColors.primary.withValues(
                    alpha: 0.5,
                  ),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Text(
                        'Connect',
                        style: TextStyle(
                          fontFamily: 'Satoshi',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: AppSpacing.s8),
          ],
        ),
      ),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// IP address input formatter
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

class _IpAddressFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    // Allow only digits and dots, max 15 chars  (e.g. "255.255.255.255")
    if (text.length > 15) return oldValue;
    final cleaned = text.replaceAll(RegExp(r'[^0-9.]'), '');
    if (cleaned == text) return newValue;
    return newValue.copyWith(text: cleaned);
  }
}
