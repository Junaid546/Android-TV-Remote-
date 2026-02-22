import 'package:atv_remote/core/theme/app_colors.dart';
import 'package:atv_remote/core/theme/app_spacing.dart';
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
    await Future.delayed(const Duration(milliseconds: 500));
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
        // Show error, context.pop() after 2s
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              next.failure.userMessage,
            ), // Assuming failure.userMessage uses mapper
            backgroundColor: AppColors.error,
          ),
        );
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            // ignore: use_build_context_synchronously
            context.pop();
          }
        });
      } else if (next is Disconnected && next.reason.contains('expired')) {
        context.pop();
      } else if (next is PinExpiredFailure) {
        // Handles failure
        context.pop();
      }
    });

    // Update text controller if state was cleared
    if (pairingState.pin.isEmpty && _pinController.text.isNotEmpty) {
      _pinController.clear();
    }

    String appBarTitle = 'Pair Device';
    String? deviceName;
    String? deviceIp;

    status.maybeWhen(
      awaitingPin: (device, _) {
        deviceName = device.name;
        deviceIp = device.ipAddress;
        appBarTitle = 'Pair with ${device.name}';
      },
      connecting: (device) {
        deviceName = device.name;
        deviceIp = device.ipAddress;
        appBarTitle = 'Connecting...';
      },
      orElse: () {},
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(appBarTitle, maxLines: 1, overflow: TextOverflow.ellipsis),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            ref.read(connectionNotifierProvider.notifier).disconnect();
            context.pop();
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: AppSpacing.s32),

                // 1. TV Name area
                Container(
                      padding: const EdgeInsets.all(AppSpacing.s24),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withAlpha(25), // ~10% opacity
                        shape: BoxShape.circle,
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
                    .scale(
                      begin: const Offset(1, 1),
                      end: const Offset(1.05, 1.05),
                      duration: 2.seconds,
                    ),

                const SizedBox(height: AppSpacing.s24),
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
                    textAlign: TextAlign.center,
                  ),
                ],

                const SizedBox(height: AppSpacing.s48),

                // 2. Instruction text
                Text(
                  'A PIN is displayed on your TV screen.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  'Enter the PIN below to pair.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppSpacing.s48),

                // 3 & 4. PIN Input Row Stack
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
                          opacity: 0.0,
                          child: TextField(
                            controller: _pinController,
                            focusNode: _focusNode,
                            autofocus: true,
                            showCursor: false,
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                            onChanged: (value) {
                              ref
                                  .read(pairingScreenNotifierProvider.notifier)
                                  .updatePin(value);
                            },
                          ),
                        ),
                      ],
                    );

                    if (shouldShake) {
                      row = row
                          .animate(
                            onPlay: (controller) => controller.forward(from: 0),
                          )
                          .shakeX(hz: 8, amount: 8, duration: 500.ms);
                    }
                    return row;
                  },
                ),

                const SizedBox(height: AppSpacing.s16),

                // 5. Error state
                if (pairingState.errorMessage != null)
                  Text(
                    pairingState.errorMessage!,
                    style: const TextStyle(
                      color: AppColors.error,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn().slideY(),

                const SizedBox(height: AppSpacing.s48),

                // 6. PIN Expiry Timer
                const PinCountdownTimer(),

                const SizedBox(height: AppSpacing.s48),

                // 7. "Confirm" button
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
                      disabledBackgroundColor: AppColors.primary.withAlpha(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    child: pairingState.isSubmitting
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            'Confirm',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: AppSpacing.s32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
