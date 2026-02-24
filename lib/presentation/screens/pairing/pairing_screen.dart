import 'dart:async';

import 'package:atv_remote/core/theme/app_colors.dart';
import 'package:atv_remote/core/utils/haptic_service.dart';
import 'package:atv_remote/core/utils/failure_mapper.dart';
import 'package:atv_remote/core/errors/failures.dart';
import 'package:atv_remote/domain/entities/pairing_status.dart';
import 'package:atv_remote/domain/entities/tv_device.dart';
import 'package:atv_remote/presentation/providers/connection_provider.dart';
import 'package:atv_remote/presentation/providers/saved_devices_provider.dart';
import 'package:atv_remote/presentation/providers/use_case_providers.dart';
import 'package:atv_remote/presentation/screens/pairing/pairing_screen_notifier.dart';
import 'package:atv_remote/presentation/screens/pairing/widgets/pin_countdown_timer.dart';
import 'package:atv_remote/presentation/screens/pairing/widgets/pin_input_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class PairingScreen extends ConsumerStatefulWidget {
  final String deviceId;

  const PairingScreen({super.key, required this.deviceId});

  @override
  ConsumerState<PairingScreen> createState() => _PairingScreenState();
}

class _PairingScreenState extends ConsumerState<PairingScreen> {
  final _pinController = TextEditingController();
  final _focusNode = FocusNode();
  final _shakeNotifier = ValueNotifier<bool>(false);
  ProviderSubscription<PairingStatus>? _connectionSubscription;
  Timer? _popTimer;

  @override
  void initState() {
    super.initState();
    _connectionSubscription = ref.listenManual<PairingStatus>(
      connectionNotifierProvider,
      _onConnectionChanged,
    );
  }

  @override
  void dispose() {
    _connectionSubscription?.close();
    _popTimer?.cancel();
    _pinController.dispose();
    _focusNode.dispose();
    _shakeNotifier.dispose();
    super.dispose();
  }

  void _triggerShake() async {
    _shakeNotifier.value = true;
    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) _shakeNotifier.value = false;
  }

  void _onConnectionChanged(PairingStatus? previous, PairingStatus next) {
    if (!mounted) return;
    if (next is Connected) {
      context.go('/remote');
    } else if (next is Paired) {
      unawaited(_handlePaired(next.device));
    } else if (next is PinError) {
      ref
          .read(pairingScreenNotifierProvider.notifier)
          .handleError(WrongPinFailure(next.attemptsLeft));
      _pinController.clear();
      _triggerShake();

      if (next.attemptsLeft == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification failed. Re-starting pairing...'),
            backgroundColor: AppColors.error,
          ),
        );
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted && context.mounted) context.go('/discovery');
        });
      }
    } else if (next is ConnectionFailed) {
      ref
          .read(pairingScreenNotifierProvider.notifier)
          .handleError(next.failure);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(next.failure.userMessage),
          backgroundColor: AppColors.error,
        ),
      );
      _popTimer?.cancel();
      _popTimer = Timer(const Duration(seconds: 2), () {
        if (mounted && context.mounted && context.canPop()) context.pop();
      });
    } else if (next is Disconnected && next.reason.contains('expired')) {
      if (context.canPop()) context.pop();
    }
  }

  Future<void> _handlePaired(TvDevice device) async {
    final saveDevice = ref.read(saveDeviceUseCaseProvider);
    final savedDevicesNotifier = ref.read(
      savedDevicesNotifierProvider.notifier,
    );
    await saveDevice(device);
    if (!mounted) return;
    await savedDevicesNotifier.refresh();
    if (!mounted) return;
    context.go('/remote');
  }

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(connectionNotifierProvider);
    final pairingState = ref.watch(pairingScreenNotifierProvider);

    if (pairingState.pin.isEmpty && _pinController.text.isNotEmpty) {
      _pinController.clear();
    }

    String title = 'Pair Device';
    String? deviceName;
    String? deviceIp;

    status.maybeWhen(
      awaitingPin: (device, _) {
        deviceName = device.name;
        deviceIp = device.ipAddress;
        title = 'Pair with ${device.name}';
      },
      connecting: (device) {
        deviceName = device.name;
        deviceIp = device.ipAddress;
        title = 'Connecting...';
      },
      orElse: () {},
    );

    // ── Auto-unfocus keyboard when submitting or done ──
    ref.listen<PairingScreenState>(pairingScreenNotifierProvider, (prev, next) {
      if (next.isSubmitting && !(prev?.isSubmitting ?? false)) {
        FocusScope.of(context).unfocus();
      }
    });

    ref.listen<PairingStatus>(connectionNotifierProvider, (prev, next) {
      if (next is Connected || next is Paired) {
        FocusScope.of(context).unfocus();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            ref.read(connectionNotifierProvider.notifier).disconnect();
            context.go('/discovery');
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 40),

                /// TV ICON (Subtle Glow)
                Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            AppColors.primary.withAlpha(40),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: const Icon(
                        Icons.tv_rounded,
                        size: 64,
                        color: AppColors.primary,
                      ),
                    )
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .fade(begin: 0.85, end: 1, duration: 2.seconds),

                const SizedBox(height: 20),

                if (deviceName != null) ...[
                  Text(
                    deviceName!,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    deviceIp ?? '',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppColors.muted),
                  ),
                ],

                const SizedBox(height: 36),

                /// Instruction
                Text(
                  'Enter the 6-digit code shown on your TV',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                /// PIN Section Card
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 28),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      ValueListenableBuilder<bool>(
                        valueListenable: _shakeNotifier,
                        builder: (context, shouldShake, child) {
                          Widget row = Stack(
                            alignment: Alignment.center,
                            children: [
                              PinInputRow(
                                pin: pairingState.pin,
                                hasError: pairingState.errorMessage != null,
                              ),
                              Opacity(
                                opacity: 0,
                                child: TextField(
                                  controller: _pinController,
                                  focusNode: _focusNode,
                                  autofocus: true,
                                  showCursor: false,
                                  keyboardType: TextInputType.text,
                                  maxLength: 6,
                                  onChanged: (value) {
                                    ref
                                        .read(
                                          pairingScreenNotifierProvider
                                              .notifier,
                                        )
                                        .updatePin(value);
                                  },
                                ),
                              ),
                            ],
                          );

                          if (shouldShake) {
                            row = row
                                .animate(
                                  onPlay: (controller) =>
                                      controller.forward(from: 0),
                                )
                                .shakeX(hz: 8, amount: 8, duration: 400.ms);
                          }

                          return row;
                        },
                      ),

                      const SizedBox(height: 12),

                      if (pairingState.errorMessage != null)
                        Text(
                          pairingState.errorMessage!,
                          style: const TextStyle(
                            color: AppColors.error,
                            fontSize: 12,
                          ),
                        ).animate().fadeIn(),
                    ],
                  ),
                ),

                const SizedBox(height: 48),

                const PinCountdownTimer(),

                const SizedBox(height: 24),

                /// Confirm Button
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child:
                      AnimatedContainer(
                            duration: 400.ms,
                            curve: Curves.easeOutCubic,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              gradient:
                                  pairingState.isSubmitting ||
                                      pairingState.pin.length != 6
                                  ? null
                                  : const LinearGradient(
                                      colors: [
                                        Color(0xFFFF8C00),
                                        Color(0xFFFF4500),
                                        Color(0xFFFF8C00),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                              color:
                                  pairingState.pin.length == 6 &&
                                      !pairingState.isSubmitting
                                  ? null
                                  : AppColors.surfaceElevated,
                              boxShadow:
                                  pairingState.pin.length == 6 &&
                                      !pairingState.isSubmitting
                                  ? [
                                      BoxShadow(
                                        color: const Color(
                                          0xFFFF4500,
                                        ).withAlpha(100),
                                        blurRadius: 20,
                                        spreadRadius: -2,
                                        offset: const Offset(0, 8),
                                      ),
                                    ]
                                  : [],
                            ),
                            child: ElevatedButton(
                              onPressed:
                                  pairingState.pin.length == 6 &&
                                      !pairingState.isSubmitting
                                  ? () {
                                      HapticService.heavy();
                                      ref
                                          .read(
                                            pairingScreenNotifierProvider
                                                .notifier,
                                          )
                                          .submitPin();
                                    }
                                  : null,
                              style:
                                  ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    foregroundColor: Colors.white,
                                    shadowColor: Colors.transparent,
                                    disabledBackgroundColor: Colors.transparent,
                                    padding: EdgeInsets.zero,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                  ).copyWith(
                                    overlayColor: WidgetStateProperty.all(
                                      Colors.white10,
                                    ),
                                  ),
                              child: AnimatedSwitcher(
                                duration: 300.ms,
                                transitionBuilder:
                                    (
                                      Widget child,
                                      Animation<double> animation,
                                    ) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: ScaleTransition(
                                          scale: animation,
                                          child: child,
                                        ),
                                      );
                                    },
                                child: pairingState.isSubmitting
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        key: ValueKey(
                                          pairingState.pin.length == 6,
                                        ),
                                        children: [
                                          Text(
                                            'Confirm',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 17,
                                              color:
                                                  pairingState.pin.length == 6
                                                  ? Colors.white
                                                  : AppColors.muted.withAlpha(
                                                      120,
                                                    ),
                                              letterSpacing: 1.2,
                                            ),
                                          ),
                                          if (pairingState.pin.length == 6) ...[
                                            const SizedBox(width: 8),
                                            const Icon(
                                                  Icons.arrow_forward_rounded,
                                                  size: 20,
                                                )
                                                .animate(
                                                  onPlay: (controller) =>
                                                      controller.repeat(),
                                                )
                                                .shimmer(
                                                  duration: 1500.ms,
                                                  color: Colors.white24,
                                                )
                                                .moveX(
                                                  begin: 0,
                                                  end: 4,
                                                  duration: 600.ms,
                                                  curve: Curves.easeInOut,
                                                ),
                                          ],
                                        ],
                                      ),
                              ),
                            ),
                          )
                          .animate(
                            target:
                                pairingState.pin.length == 6 &&
                                    !pairingState.isSubmitting
                                ? 1
                                : 0,
                          )
                          .shimmer(
                            duration: 2.seconds,
                            color: Colors.white.withAlpha(20),
                            angle: 0.7,
                          )
                          .scale(
                            begin: const Offset(1, 1),
                            end: const Offset(1.02, 1.02),
                            duration: 200.ms,
                          ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
