import 'package:atv_remote/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          _Section(
            title: 'Overview',
            body:
                'This TV Remote app processes only the data needed to discover TVs, establish secure connections, and send your requested commands. We do not sell personal data.',
          ),
          _Section(
            title: 'Data We Store',
            body:
                'The app stores saved TV devices, pairing metadata, optional ADB configuration, and app preferences such as theme and haptics on your device.',
          ),
          _Section(
            title: 'Network Communication',
            body:
                'Commands are sent directly from your phone to your TV over your local network. Wireless debugging commands are executed only after you configure and approve ADB pairing.',
          ),
          _Section(
            title: 'Permissions',
            body:
                'Network and nearby device permissions are used to discover and connect to TVs on your local network. These permissions are not used for advertising or tracking.',
          ),
          _Section(
            title: 'Your Control',
            body:
                'You can remove saved devices, clear ADB configuration, and uninstall the app at any time. Doing so removes locally stored app data from your device.',
          ),
          _Section(
            title: 'Contact',
            body:
                'For privacy inquiries, contact your app distributor or support channel provided with your app release.',
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              body,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.78),
                fontSize: 12,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
