import 'package:atv_remote/core/theme/app_colors.dart';
import 'package:atv_remote/presentation/providers/connection_provider.dart';
import 'package:atv_remote/presentation/providers/saved_devices_provider.dart';
import 'package:atv_remote/presentation/providers/settings_provider.dart';
import 'package:atv_remote/presentation/screens/remote/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late final Future<PackageInfo> _packageInfoFuture;

  @override
  void initState() {
    super.initState();
    _packageInfoFuture = PackageInfo.fromPlatform();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsNotifierProvider);
    final connection = ref.watch(connectionNotifierProvider);
    final connectionNotifier = ref.read(connectionNotifierProvider.notifier);
    final savedDevicesAsync = ref.watch(savedDevicesNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                children: [
                  const _Header(),
                  const SizedBox(height: 14),
                  _SectionCard(
                    title: 'Connection',
                    children: [
                      _ActionRow(
                        icon: Icons.tv_rounded,
                        title: 'Active TV',
                        subtitle:
                            connection.device?.name ?? 'No active connection',
                        trailing: connection.isConnected
                            ? const _StatusPill(
                                label: 'Connected',
                                color: AppColors.success,
                              )
                            : const _StatusPill(
                                label: 'Disconnected',
                                color: AppColors.warning,
                              ),
                      ),
                      _ActionRow(
                        icon: Icons.refresh_rounded,
                        title: 'Reconnect',
                        subtitle: 'Re-establish remote session',
                        onTap: connection.device == null
                            ? null
                            : () => connectionNotifier.reconnectRemote(),
                      ),
                      _ActionRow(
                        icon: Icons.link_off_rounded,
                        title: 'Disconnect',
                        subtitle: 'End remote and pairing sessions',
                        onTap: connection.hasActiveSession
                            ? () async {
                                await connectionNotifier.disconnect();
                                if (!context.mounted) return;
                                context.go('/discovery');
                              }
                            : null,
                      ),
                      _ActionRow(
                        icon: Icons.wifi_find_rounded,
                        title: 'Manage TVs',
                        subtitle: 'Discover and connect to devices',
                        onTap: () => context.push('/discovery?manage=1'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _SectionCard(
                    title: 'Preferences',
                    children: [
                      _ToggleRow(
                        icon: Icons.vibration_rounded,
                        title: 'Haptic feedback',
                        subtitle: 'Vibrate when pressing remote controls',
                        value: settings.hapticEnabled,
                        onChanged: (value) => ref
                            .read(settingsNotifierProvider.notifier)
                            .setHaptic(value),
                      ),
                      _ToggleRow(
                        icon: Icons.sync_rounded,
                        title: 'Auto reconnect',
                        subtitle: 'Retry remote socket automatically on drop',
                        value: settings.autoReconnectEnabled,
                        onChanged: (value) => ref
                            .read(settingsNotifierProvider.notifier)
                            .setAutoReconnect(value),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _SectionCard(
                    title: 'Saved Devices',
                    children: [
                      savedDevicesAsync.when(
                        data: (devices) {
                          if (devices.isEmpty) {
                            return const _EmptyLabel(
                              label:
                                  'No saved TVs yet. Connect once to save one.',
                            );
                          }
                          return Column(
                            children: [
                              for (final device in devices)
                                _SavedDeviceRow(
                                  name: device.name,
                                  ip: device.ipAddress,
                                  onForget: () async {
                                    try {
                                      await ref
                                          .read(
                                            connectionNotifierProvider.notifier,
                                          )
                                          .forgetDevice(device);
                                      if (!context.mounted) return;
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            '${device.name} removed',
                                          ),
                                        ),
                                      );
                                    } catch (e) {
                                      if (!context.mounted) return;
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(e.toString()),
                                          backgroundColor: AppColors.error,
                                        ),
                                      );
                                    }
                                  },
                                ),
                            ],
                          );
                        },
                        loading: () => const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        error: (error, _) => _EmptyLabel(
                          label: 'Unable to load devices: $error',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _SectionCard(
                    title: 'Data & Privacy',
                    children: [
                      _ActionRow(
                        icon: Icons.delete_sweep_rounded,
                        title: 'Clear ADB configuration',
                        subtitle: 'Remove stored host and port values',
                        onTap: () => ref
                            .read(settingsNotifierProvider.notifier)
                            .clearAdbConfig(),
                      ),
                      _ActionRow(
                        icon: Icons.cleaning_services_rounded,
                        title: 'Reset app launch overrides',
                        subtitle: 'Restore default TV app package mappings',
                        onTap: settings.appPackageOverrides.isEmpty
                            ? null
                            : () async {
                                final notifier = ref.read(
                                  settingsNotifierProvider.notifier,
                                );
                                final keys = settings.appPackageOverrides.keys
                                    .toList();
                                for (final key in keys) {
                                  await notifier.setAppPackageOverride(key, '');
                                }
                              },
                      ),
                      _ActionRow(
                        icon: Icons.privacy_tip_outlined,
                        title: 'Privacy policy',
                        subtitle: 'View how the app handles data',
                        onTap: () => context.push('/privacy-policy'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _SectionCard(
                    title: 'About',
                    children: [
                      FutureBuilder<PackageInfo>(
                        future: _packageInfoFuture,
                        builder: (context, snapshot) {
                          final version = snapshot.hasData
                              ? 'v${snapshot.data!.version}+${snapshot.data!.buildNumber}'
                              : 'Loading...';
                          return _ActionRow(
                            icon: Icons.info_outline_rounded,
                            title: 'App version',
                            subtitle: version,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const BottomNavBar(currentIndex: 2),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 2),
      child: Text(
        'Settings',
        style: TextStyle(
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white10),
      ),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 6),
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
                fontSize: 12,
                letterSpacing: 0.7,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return Opacity(
      opacity: disabled ? 0.45 : 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 10),
          child: Row(
            children: [
              Icon(icon, color: AppColors.muted),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.onBackground,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: AppColors.muted.withValues(alpha: 0.85),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              trailing ??
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.muted,
                    size: 20,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: AppColors.muted),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.onBackground,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppColors.muted.withValues(alpha: 0.85),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.primary,
            activeTrackColor: AppColors.primary.withValues(alpha: 0.35),
          ),
        ],
      ),
    );
  }
}

class _SavedDeviceRow extends StatelessWidget {
  const _SavedDeviceRow({
    required this.name,
    required this.ip,
    required this.onForget,
  });

  final String name;
  final String ip;
  final VoidCallback onForget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.tv_rounded, color: AppColors.muted),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: AppColors.onBackground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  ip,
                  style: TextStyle(
                    color: AppColors.muted.withValues(alpha: 0.85),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onForget,
            child: const Text(
              'Forget',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyLabel extends StatelessWidget {
  const _EmptyLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      child: Text(
        label,
        style: TextStyle(
          color: AppColors.muted.withValues(alpha: 0.8),
          fontSize: 12,
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
