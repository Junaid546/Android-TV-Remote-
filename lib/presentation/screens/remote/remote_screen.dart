import 'package:atv_remote/core/theme/app_colors.dart';
import 'package:atv_remote/domain/entities/pairing_status.dart';
import 'package:atv_remote/presentation/providers/connection_provider.dart';
import 'package:atv_remote/presentation/screens/remote/widgets/bottom_controls_row.dart';
import 'package:atv_remote/presentation/screens/remote/widgets/bottom_nav_bar.dart';
import 'package:atv_remote/presentation/screens/remote/widgets/connection_indicator_bar.dart';
import 'package:atv_remote/presentation/screens/remote/widgets/dpad_control.dart';
import 'package:atv_remote/presentation/screens/remote/widgets/media_control_bar.dart';
import 'package:atv_remote/presentation/screens/remote/widgets/nav_buttons_row.dart';
import 'package:atv_remote/presentation/screens/remote/widgets/tv_header_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RemoteScreen extends ConsumerWidget {
  const RemoteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen for connection state changes to handle navigation or failures
    ref.listen<PairingStatus>(connectionNotifierProvider, (prev, next) {
      if (next is ConnectionFailed) {
        context.go('/connection-error');
      }
    });

    return const Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Fixed Header
            TvHeaderBar(),

            // Fixed Status Strip (under header)
            ConnectionIndicatorBar(),

            // Main Content - Scrollable to prevent overflow on small screens
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    DpadControl(),
                    SizedBox(height: 32),
                    NavButtonsRow(),
                    SizedBox(height: 32),
                    MediaControlBar(),
                    SizedBox(height: 32),
                    BottomControlsRow(),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Bottom Navigation
            BottomNavBar(currentIndex: 0),
          ],
        ),
      ),
    );
  }
}
