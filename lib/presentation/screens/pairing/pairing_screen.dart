import 'package:atv_remote/core/theme/app_colors.dart';
import 'package:atv_remote/core/utils/haptic_service.dart';
import 'package:atv_remote/core/utils/failure_mapper.dart';
import 'package:atv_remote/core/errors/failures.dart';
import 'package:atv_remote/domain/entities/pairing_status.dart';
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

  @override
  void dispose() {
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

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(connectionNotifierProvider);
    final pairingState = ref.watch(pairingScreenNotifierProvider);

    ref.listen(connectionNotifierProvider, (previous, next) {
      if (next is Connected) {
        context.go('/remote');
      } else if (next is Paired) {
        ref.read(saveDeviceUseCaseProvider)(next.device).then((_) {
          ref.read(savedDevicesNotifierProvider.notifier).refresh();
        });
      } else if (next is PinError) {
        ref
            .read(pairingScreenNotifierProvider.notifier)
            .handleError(WrongPinFailure(next.attemptsLeft));
        _pinController.clear();
        _triggerShake();
      } else if (next is ConnectionFailed) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.failure.userMessage),
            backgroundColor: AppColors.error,
          ),
        );
        Future.delayed(const Duration(seconds: 2), () {
          if (context.mounted) context.pop();
        });
      } else if (next is Disconnected && next.reason.contains('expired')) {
        context.pop();
      } else if (next is PinExpiredFailure) {
        context.pop();
      }
    });

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
            context.pop();
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
                                  keyboardType: TextInputType.number,
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
                  height: 56,
                  child: ElevatedButton(
                    onPressed:
                        pairingState.pin.length == 6 &&
                            !pairingState.isSubmitting
                        ? () {
                            HapticService.medium();
                            ref
                                .read(pairingScreenNotifierProvider.notifier)
                                .submitPin();
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: pairingState.isSubmitting
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Confirm',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
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
