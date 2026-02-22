import 'package:atv_remote/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class PinInputRow extends StatelessWidget {
  final String pin;
  final bool hasError;

  const PinInputRow({super.key, required this.pin, this.hasError = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (index) {
        final isFilled = index < pin.length;
        final isActive = index == pin.length;
        final digit = isFilled ? pin[index] : '';

        Color borderColor = AppColors.surfaceElevated;
        if (hasError) {
          borderColor = AppColors.error;
        } else if (isActive) {
          borderColor = AppColors.primary;
        }

        return Container(
          width: 48,
          height: 60,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: hasError ? AppColors.error.withAlpha(50) : AppColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor, width: 1.5),
            boxShadow: isActive && !hasError
                ? [
                    BoxShadow(
                      color: AppColors.primary.withAlpha(76), // ~0.3 opacity
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Text(
            digit,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }),
    );
  }
}
