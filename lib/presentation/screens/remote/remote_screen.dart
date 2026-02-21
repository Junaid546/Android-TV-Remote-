import 'package:atv_remote/core/constants/app_constants.dart';
import 'package:atv_remote/core/theme/app_colors.dart';
import 'package:atv_remote/core/theme/app_spacing.dart';
import 'package:atv_remote/presentation/providers/connection_provider.dart';
import 'package:atv_remote/presentation/providers/remote_provider.dart';
import 'package:atv_remote/presentation/providers/settings_provider.dart';
import 'package:atv_remote/presentation/screens/remote/widgets/channel_control.dart';
import 'package:atv_remote/presentation/screens/remote/widgets/dpad_control.dart';
import 'package:atv_remote/presentation/screens/remote/widgets/media_control_bar.dart';
import 'package:atv_remote/presentation/screens/remote/widgets/volume_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

void _sendCommand(WidgetRef ref, String commandName) {
  final hapticEnabled = ref.read(settingsNotifierProvider).hapticEnabled;
  if (hapticEnabled) {
    HapticFeedback.lightImpact();
  }
  ref.read(remoteNotifierProvider.notifier).sendKey(commandName);
}

class RemoteScreen extends ConsumerWidget {
  const RemoteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectionState = ref.watch(connectionNotifierProvider);
    final device = connectionState.device;
    final isConnected = ref
        .read(connectionNotifierProvider.notifier)
        .isConnected;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header with Device Info
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.background,
            flexibleSpace: FlexibleSpaceBar(
              title: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    device?.name ?? 'Not Connected',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isConnected
                              ? AppColors.primary
                              : AppColors.error,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isConnected ? 'Connected' : 'Disconnected',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.muted,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              centerTitle: true,
            ),
            actions: [
              IconButton(
                onPressed: () => context.push('/settings'),
                icon: const Icon(Icons.settings_rounded),
              ),
              const SizedBox(width: AppSpacing.s8),
            ],
          ),

          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.s24),
                // Power & Input
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s24,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ControlButton(
                        icon: Icons.power_settings_new_rounded,
                        color: AppColors.error,
                        onPressed: () => _sendCommand(
                          ref,
                          AppConstants.kKeyPower.toString(),
                        ),
                      ),
                      ControlButton(
                        icon: Icons.input_rounded,
                        color: AppColors.onBackground,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.s48),

                // D-Pad
                const DpadControl(),

                const SizedBox(height: AppSpacing.s48),

                // Control Bar (Back, Home, Menu)
                const MediaControlBar(),

                const SizedBox(height: AppSpacing.s48),

                // Volume Controls
                const VolumeControl(),

                const SizedBox(height: AppSpacing.s48),

                // App Shortcuts Title
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s24,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Fast Access',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.muted,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.s16),

                const ChannelControl(),

                const SizedBox(height: AppSpacing.s48),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
