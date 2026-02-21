import 'package:atv_remote/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class ChannelControl extends StatelessWidget {
  const ChannelControl({super.key});

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
