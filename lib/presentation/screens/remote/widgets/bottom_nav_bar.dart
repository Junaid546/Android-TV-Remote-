import 'package:atv_remote/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  const BottomNavBar({super.key, this.currentIndex = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceElevated,
        border: Border(top: BorderSide(color: Colors.white10, width: 0.5)),
      ),
      child: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: Colors.transparent,
          indicatorColor: AppColors.primary.withValues(alpha: 0.1),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                color: AppColors.primary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              );
            }
            return const TextStyle(color: AppColors.muted, fontSize: 11);
          }),
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: AppColors.primary, size: 24);
            }
            return const IconThemeData(color: AppColors.muted, size: 24);
          }),
        ),
        child: NavigationBar(
          selectedIndex: currentIndex,
          elevation: 0,
          onDestinationSelected: (index) => _onNavigate(context, index),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.settings_remote_rounded),
              selectedIcon: Icon(Icons.settings_remote_rounded),
              label: 'Remote',
            ),
            NavigationDestination(
              icon: Icon(Icons.apps_rounded),
              selectedIcon: Icon(Icons.apps_rounded),
              label: 'Apps',
            ),
            NavigationDestination(
              icon: Icon(Icons.tv_rounded),
              selectedIcon: Icon(Icons.tv_rounded),
              label: 'TV',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_rounded),
              selectedIcon: Icon(Icons.settings_rounded),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }

  void _onNavigate(BuildContext context, int index) {
    if (index == currentIndex) return;
    switch (index) {
      case 0:
        context.go('/remote');
        break;
      case 1:
        context.go('/discovery');
        break;
      case 3:
        context.push('/settings');
        break;
    }
  }
}
