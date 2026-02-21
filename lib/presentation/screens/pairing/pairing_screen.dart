import 'package:atv_remote/core/theme/app_colors.dart';
import 'package:atv_remote/core/theme/app_spacing.dart';
import 'package:atv_remote/domain/entities/pairing_status.dart';
import 'package:atv_remote/presentation/providers/connection_provider.dart';
import 'package:atv_remote/presentation/providers/saved_devices_provider.dart';
import 'package:atv_remote/presentation/providers/use_case_providers.dart';
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

  @override
  void dispose() {
    _pinController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(connectionNotifierProvider);

    // Listen for success to navigate and save
    ref.listen(connectionNotifierProvider, (previous, next) {
      if (next is Paired) {
        // Save the device locally using use case directly or refresh provider
        ref.read(saveDeviceUseCaseProvider)(next.device).then((_) {
          ref.read(savedDevicesNotifierProvider.notifier).refresh();
        });
        // Navigate to Remote
        context.go('/remote');
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            ref.read(connectionNotifierProvider.notifier).disconnect();
            context.pop();
          },
          icon: const Icon(Icons.close_rounded),
        ),
      ),
      body: _buildStatusBody(context, status),
    );
  }

  Widget _buildStatusBody(BuildContext context, PairingStatus status) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.s32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon/Status Illustration
          _buildStatusIcon(status),
          const SizedBox(height: AppSpacing.s48),

          // Message
          Text(
            _getStatusMessage(status),
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.s16),
          Text(
            _getStatusSubtitle(status),
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppColors.muted),
          ),

          const SizedBox(height: AppSpacing.s48),

          // Interaction Area (e.g. PIN input)
          if (status is AwaitingPin) ...[
            TextField(
              controller: _pinController,
              focusNode: _focusNode,
              autofocus: true,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 20,
              ),
              maxLength: 6,
              decoration: InputDecoration(
                counterText: '',
                hintText: '000000',
                hintStyle: TextStyle(color: AppColors.muted.withAlpha(50)),
              ),
              onChanged: (value) {
                if (value.length == 6) {
                  _submitPin(value);
                }
              },
            ),
            const SizedBox(height: AppSpacing.s32),
            ElevatedButton(
              onPressed: () => _submitPin(_pinController.text),
              child: const Text('Pair Device'),
            ),
          ],

          if (status is ConnectionFailed || status is PinError) ...[
            ElevatedButton(
              onPressed: () {
                _pinController.clear();
                // We might need to restart connecting, but the notifier logic depends on how it's implemented.
                // For now, go back to discovery.
                context.pop();
              },
              child: const Text('Try Again'),
            ),
          ],

          if (status is Connecting) ...[
            const CircularProgressIndicator(color: AppColors.primary),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusIcon(PairingStatus status) {
    IconData iconData = Icons.bluetooth_searching_rounded;
    Color color = AppColors.primary;

    if (status is AwaitingPin) {
      iconData = Icons.pin_rounded;
    } else if (status is Paired || status is Connected) {
      iconData = Icons.done_all_rounded;
      color = AppColors.success;
    } else if (status is ConnectionFailed || status is PinError) {
      iconData = Icons.error_outline_rounded;
      color = AppColors.error;
    }

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        shape: BoxShape.circle,
      ),
      child: Icon(iconData, size: 80, color: color),
    ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack);
  }

  String _getStatusMessage(PairingStatus status) {
    return status.when(
      idle: () => 'Ready to Pair',
      discoveryStarted: () => 'Discovering...',
      devicesFound: (devices) => 'Devices Found',
      connecting: (device) => 'Connecting to ${device.name}',
      awaitingPin: (device, expires) => 'Enter PIN',
      pinVerified: (device) => 'PIN Verified!',
      paired: (device) => 'Successfully Paired!',
      connected: (device) => 'Connected',
      reconnecting: (device, attempt) => 'Reconnecting...',
      disconnected: (last, reason) => 'Disconnected',
      connectionFailed: (device, failure) => 'Connection Failed',
      pinError: (device, left, msg) => 'Invalid PIN',
    );
  }

  String _getStatusSubtitle(PairingStatus status) {
    return status.when(
      idle: () => 'Select a device to start pairing.',
      discoveryStarted: () => 'Searching for devices...',
      devicesFound: (devices) => 'Found ${devices.length} devices.',
      connecting: (device) => 'Establishing a secure connection...',
      awaitingPin: (device, expires) =>
          'A ${device.name} will show a PIN code. Please enter it here.',
      pinVerified: (device) => 'Waiting for authentication...',
      paired: (device) => 'Redirecting you to the remote...',
      connected: (device) => 'Ready to control.',
      reconnecting: (device, attempt) =>
          'Connection lost. Retrying ($attempt)...',
      disconnected: (last, reason) => reason,
      connectionFailed: (device, failure) => failure.toString(),
      pinError: (device, left, msg) => msg,
    );
  }

  void _submitPin(String pin) {
    if (pin.length < 4) return;
    ref.read(connectionNotifierProvider.notifier).submitPin(pin);
  }
}
