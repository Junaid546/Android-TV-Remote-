import 'dart:async';

import 'package:atv_remote/core/theme/app_colors.dart';
import 'package:atv_remote/core/theme/app_spacing.dart';
import 'package:atv_remote/domain/entities/tv_device.dart';
import 'package:atv_remote/presentation/providers/discovery_provider.dart';
import 'package:atv_remote/presentation/providers/pairing_provider.dart';
import 'package:atv_remote/presentation/providers/use_case_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class DiscoveryScreen extends ConsumerStatefulWidget {
  const DiscoveryScreen({super.key});

  @override
  ConsumerState<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends ConsumerState<DiscoveryScreen> {
  @override
  void initState() {
    super.initState();
    // Start discovery automatically when entering the screen
    Future.microtask(
      () => ref.read(discoveryNotifierProvider.notifier).startDiscovery(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final discoveryState = ref.watch(discoveryNotifierProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Premium Header
          SliverAppBar.large(
            backgroundColor: AppColors.background,
            title: Text(
              'Discovery',
              style: Theme.of(
                context,
              ).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
            actions: [
              IconButton(
                onPressed: () => ref
                    .read(discoveryNotifierProvider.notifier)
                    .startDiscovery(),
                icon: const Icon(
                  Icons.refresh_rounded,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.s8),
            ],
          ),

          // Scanning Indicator
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.s24),
              child: _ScanningHeader(),
            ),
          ),

          // Device List
          discoveryState.when(
            data: (devices) {
              if (devices.isEmpty) {
                return SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyDiscoveryState(),
                );
              }
              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final device = devices[index];
                    return _DeviceListCard(device: device);
                  }, childCount: devices.length),
                ),
              );
            },
            loading: () => const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
            error: (error, stack) => SliverFillRemaining(
              child: Center(child: Text('Error: $error')),
            ),
          ),

          // Manual Entry Button
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.s24,
                vertical: AppSpacing.s48,
              ),
              child: OutlinedButton.icon(
                onPressed: () => _showManualEntryModal(context),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Add Device Manually'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(AppSpacing.s20),
                  side: BorderSide(
                    color: AppColors.primary.withAlpha(50),
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showManualEntryModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ManualEntrySheet(),
    );
  }
}

class _ManualEntrySheet extends ConsumerStatefulWidget {
  @override
  ConsumerState<_ManualEntrySheet> createState() => _ManualEntrySheetState();
}

class _ManualEntrySheetState extends ConsumerState<_ManualEntrySheet> {
  final _ipController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _ipController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Add Device Manually',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSpacing.s8),
            Text(
              'Enter the IP address of your Android TV.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.s32),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                hintText: 'Device Name (e.g. Living Room TV)',
                prefixIcon: Icon(Icons.label_rounded),
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppSpacing.s16),
            TextField(
              controller: _ipController,
              decoration: const InputDecoration(
                hintText: 'IP Address (e.g. 192.168.1.50)',
                prefixIcon: Icon(Icons.network_wifi_rounded),
              ),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(height: AppSpacing.s32),
            ElevatedButton(
              onPressed: _isLoading ? null : _handleSubmit,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.black,
                      ),
                    )
                  : const Text('Connect'),
            ),
            const SizedBox(height: AppSpacing.s16),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (_ipController.text.isEmpty) return;

    setState(() => _isLoading = true);

    final name = _nameController.text.isEmpty
        ? 'Android TV'
        : _nameController.text;

    final manualResult = await ref
        .read(addManualDeviceUseCaseProvider)
        .call(_ipController.text, name);

    setState(() => _isLoading = false);

    manualResult.fold(
      (l) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l.toString()))),
      (device) async {
        Navigator.pop(context);
        await ref
            .read(pairingNotifierProvider.notifier)
            .connectToDevice(device);
        if (mounted) {
          unawaited(context.push('/pairing'));
        }
      },
    );
  }
}

class _ScanningHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            )
            .animate(onPlay: (controller) => controller.repeat())
            .scale(
              begin: const Offset(1, 1),
              end: const Offset(2, 2),
              duration: 1000.ms,
              curve: Curves.easeOut,
            )
            .fadeOut(duration: 1000.ms),
        const SizedBox(width: AppSpacing.s16),
        Text(
          'Scanning for Android TV devices...',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.muted,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _DeviceListCard extends ConsumerWidget {
  final TvDevice device;

  const _DeviceListCard({required this.device});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.s16),
      child: InkWell(
        onTap: () async {
          // Initiate pairing and navigate
          await ref
              .read(pairingNotifierProvider.notifier)
              .connectToDevice(device);
          if (context.mounted) {
            unawaited(context.push('/pairing'));
          }
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.tv_rounded,
                  color: AppColors.primary,
                  size: 32,
                ),
              ),
              const SizedBox(width: AppSpacing.s20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      device.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      device.ipAddress,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(letterSpacing: 0.5),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.muted),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.1, end: 0);
  }
}

class _EmptyDiscoveryState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.wifi_find_rounded,
            size: 80,
            color: AppColors.muted.withAlpha(50),
          ),
          const SizedBox(height: AppSpacing.s24),
          Text(
            'No devices found yet',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: AppColors.muted),
          ),
          const SizedBox(height: AppSpacing.s8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Make sure your Android TV is on the same Wi-Fi network.',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
            ),
          ),
        ],
      ),
    );
  }
}
