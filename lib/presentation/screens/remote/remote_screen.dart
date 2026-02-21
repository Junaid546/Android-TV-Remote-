import 'package:atv_remote/core/constants/app_constants.dart';
import 'package:atv_remote/core/theme/app_colors.dart';
import 'package:atv_remote/core/theme/app_spacing.dart';
import 'package:atv_remote/domain/entities/remote_command.dart';
import 'package:atv_remote/presentation/providers/remote_provider.dart';
import 'package:atv_remote/presentation/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void _sendCommand(WidgetRef ref, int keyCode) {
  // Trigger haptics if enabled
  final settings = ref.read(settingsNotifierProvider).valueOrNull;
  if (settings?.hapticEnabled ?? true) {
    HapticFeedback.lightImpact();
  }

  ref
      .read(remoteNotifierProvider.notifier)
      .sendCommand(
        RemoteCommand.keyCommand(keyCode: keyCode, action: KeyAction.downUp),
      );
}

class RemoteScreen extends ConsumerWidget {
  const RemoteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remoteState = ref.watch(remoteNotifierProvider);

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
              title: remoteState.when(
                data: (s) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      s.device?.name ?? 'Not Connected',
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
                            color: s.isConnected
                                ? AppColors.primary
                                : AppColors.error,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          s.isConnected ? 'Connected' : 'Disconnected',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: AppColors.textSecondary,
                                letterSpacing: 1,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
                loading: () => const Text('Connecting...'),
                error: (_, __) => const Text('Connection Error'),
              ),
              centerTitle: true,
            ),
            actions: [
              IconButton(
                onPressed: () {},
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
                      _ControlButton(
                        icon: Icons.power_settings_new_rounded,
                        color: AppColors.error,
                        onPressed: () =>
                            _sendCommand(ref, AppConstants.kKeyPower),
                      ),
                      _ControlButton(
                        icon: Icons.input_rounded,
                        color: AppColors.textPrimary,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.s48),

                // D-Pad
                const _DPadSection(),

                const SizedBox(height: AppSpacing.s48),

                // Control Bar (Back, Home, Menu)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s24,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ActionButton(
                        icon: Icons.arrow_back_rounded,
                        label: 'Back',
                        onPressed: () =>
                            _sendCommand(ref, AppConstants.kKeyBack),
                      ),
                      _ActionButton(
                        icon: Icons.home_rounded,
                        label: 'Home',
                        onPressed: () =>
                            _sendCommand(ref, AppConstants.kKeyHome),
                      ),
                      _ActionButton(
                        icon: Icons.menu_rounded,
                        label: 'Menu',
                        onPressed: () =>
                            _sendCommand(ref, AppConstants.kKeyMenu),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.s48),

                // Volume Controls
                const _VolumeSection(),

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
                          color: AppColors.textSecondary,
                          letterSpacing: 1.2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.s16),
                const _ShortcutsSection(),

                const SizedBox(height: AppSpacing.s48),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _ControlButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.s16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withAlpha(25)),
        ),
        child: Icon(icon, color: color, size: 28),
      ),
    );
  }
}

class _DPadSection extends ConsumerWidget {
  const _DPadSection();

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
              onTap: () => _sendCommand(ref, AppConstants.kKeySelect),
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
            onPressed: () => _sendCommand(ref, AppConstants.kKeyUp),
          ),
          // Down
          _DPadButton(
            alignment: Alignment.bottomCenter,
            icon: Icons.keyboard_arrow_down_rounded,
            onPressed: () => _sendCommand(ref, AppConstants.kKeyDown),
          ),
          // Left
          _DPadButton(
            alignment: Alignment.centerLeft,
            icon: Icons.keyboard_arrow_left_rounded,
            onPressed: () => _sendCommand(ref, AppConstants.kKeyLeft),
          ),
          // Right
          _DPadButton(
            alignment: Alignment.centerRight,
            icon: Icons.keyboard_arrow_right_rounded,
            onPressed: () => _sendCommand(ref, AppConstants.kKeyRight),
          ),
        ],
      ),
    );
  }
}

class _DPadButton extends StatelessWidget {
  final Alignment alignment;
  final IconData icon;
  final VoidCallback onPressed;

  const _DPadButton({
    required this.alignment,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          width: 100,
          height: 100,
          child: Icon(icon, color: AppColors.textPrimary, size: 48),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ControlButton(
          icon: icon,
          color: AppColors.textSecondary,
          onPressed: onPressed,
        ),
        const SizedBox(height: AppSpacing.s8),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _VolumeSection extends ConsumerWidget {
  const _VolumeSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.s8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => _sendCommand(ref, AppConstants.kKeyVolumeDown),
              icon: const Icon(Icons.remove_rounded),
              color: AppColors.textPrimary,
            ),
            const SizedBox(width: AppSpacing.s16),
            const Icon(Icons.volume_up_rounded, color: AppColors.primary),
            const SizedBox(width: AppSpacing.s16),
            IconButton(
              onPressed: () => _sendCommand(ref, AppConstants.kKeyVolumeUp),
              icon: const Icon(Icons.add_rounded),
              color: AppColors.textPrimary,
            ),
          ],
        ),
      ),
    );
  }
}

class _ShortcutsSection extends StatelessWidget {
  const _ShortcutsSection();

  @override
  Widget build(BuildContext context) {
    final shortcuts = [
      {'name': 'Netflix', 'color': const Color(0xFFE50914)},
      {'name': 'YouTube', 'color': const Color(0xFFFF0000)},
      {'name': 'Disney+', 'color': const Color(0xFF006E99)},
      {'name': 'Prime', 'color': const Color(0xFF00A8E1)},
    ];

    return SizedBox(
      height: 60,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
        scrollDirection: Axis.horizontal,
        itemCount: shortcuts.length,
        itemBuilder: (context, index) {
          final item = shortcuts[index];
          return Container(
            margin: const EdgeInsets.only(right: AppSpacing.s12),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: (item['color'] as Color).withAlpha(40),
                foregroundColor: (item['color'] as Color),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: (item['color'] as Color).withAlpha(100),
                  ),
                ),
              ),
              child: Text(
                item['name'] as String,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          );
        },
      ),
    );
  }
}
