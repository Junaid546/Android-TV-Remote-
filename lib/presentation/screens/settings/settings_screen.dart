import 'package:atv_remote/core/constants/app_constants.dart';
import 'package:atv_remote/core/theme/app_colors.dart';
import 'package:atv_remote/core/theme/app_spacing.dart';
import 'package:atv_remote/presentation/providers/settings_provider.dart';
import 'package:atv_remote/presentation/providers/saved_devices_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedDevicesAsync = ref.watch(savedDevicesNotifierProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar.large(
            title: Text('Settings'),
            backgroundColor: AppColors.background,
            surfaceTintColor: AppColors.background,
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.s16),
                  _buildSectionHeader(context, 'SAVED DEVICES'),
                  const SizedBox(height: AppSpacing.s16),
                ],
              ),
            ),
          ),

          savedDevicesAsync.when(
            data: (devices) => devices.isEmpty
                ? const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(AppSpacing.s48),
                        child: Text(
                          'No saved devices found.',
                          style: TextStyle(color: AppColors.muted),
                        ),
                      ),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final device = devices[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.s24,
                          vertical: AppSpacing.s8,
                        ),
                        child: _DeviceSettingsCard(
                          deviceName: device.name,
                          ipAddress: device.ipAddress,
                          onDelete: () => ref
                              .read(savedDevicesNotifierProvider.notifier)
                              .removeDevice(device.id),
                        ),
                      );
                    }, childCount: devices.length),
                  ),
            loading: () => const SliverToBoxAdapter(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, s) =>
                SliverToBoxAdapter(child: Center(child: Text('Error: $e'))),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.s24),
                  _buildSectionHeader(context, 'PREFERENCES'),
                  const SizedBox(height: AppSpacing.s16),
                  Builder(
                    builder: (context) {
                      final settings = ref.watch(settingsNotifierProvider);
                      return Column(
                        children: [
                          _buildPreferenceTile(
                            context,
                            Icons.vibration_rounded,
                            'Haptic Feedback',
                            'Vibrate on button press',
                            Switch(
                              value: settings.hapticEnabled,
                              onChanged: (val) => ref
                                  .read(settingsNotifierProvider.notifier)
                                  .toggleHaptic(),
                            ),
                          ),
                          _buildPreferenceTile(
                            context,
                            Icons.dark_mode_rounded,
                            'Dark Mode',
                            'Use dark theme throughout',
                            Switch(
                              value: settings.themeMode == 'dark',
                              onChanged: (val) => ref
                                  .read(settingsNotifierProvider.notifier)
                                  .toggleTheme(),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: AppSpacing.s24),

                  _buildSectionHeader(context, 'APP INFORMATION'),
                  const SizedBox(height: AppSpacing.s24),
                  _buildInfoTile(
                    context,
                    Icons.info_outline_rounded,
                    'Version',
                    '1.0.0',
                  ),
                  _buildInfoTile(
                    context,
                    Icons.code_rounded,
                    'Developer',
                    'Antigravity AI',
                  ),
                  _buildInfoTile(
                    context,
                    Icons.security_rounded,
                    'Privacy Policy',
                    'View Details',
                  ),

                  const SizedBox(height: AppSpacing.s64),
                  Center(
                    child: Text(
                      AppConstants.kAppName.toUpperCase(),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.muted,
                        letterSpacing: 4,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferenceTile(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    Widget trailing,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.s16),
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.muted, size: 20),
          const SizedBox(width: AppSpacing.s16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.onBackground,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: AppColors.muted, fontSize: 12),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: AppColors.primary,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildInfoTile(
    BuildContext context,
    IconData icon,
    String title,
    String value,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.s16),
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.muted, size: 20),
          const SizedBox(width: AppSpacing.s16),
          Text(title, style: const TextStyle(color: AppColors.muted)),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.onBackground,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _DeviceSettingsCard extends StatelessWidget {
  final String deviceName;
  final String ipAddress;
  final VoidCallback onDelete;

  const _DeviceSettingsCard({
    required this.deviceName,
    required this.ipAddress,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.tv_rounded, color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.s16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deviceName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  ipAddress,
                  style: const TextStyle(color: AppColors.muted, fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: AppColors.background,
                  title: const Text('Forget Device?'),
                  content: Text('Are you sure you want to remove $deviceName?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        onDelete();
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Forget',
                        style: TextStyle(color: AppColors.error),
                      ),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(
              Icons.delete_sweep_rounded,
              color: AppColors.error,
            ),
          ),
        ],
      ),
    );
  }
}
