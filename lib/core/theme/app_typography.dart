import 'package:flutter/material.dart';
import 'package:atv_remote/core/theme/app_colors.dart';

abstract final class AppTypography {
  static const _satoshi = 'Satoshi';

  static const displayLarge = TextStyle(
    fontFamily: _satoshi,
    fontWeight: FontWeight.w700,
    fontSize: 32,
    color: AppColors.onBackground,
    letterSpacing: -0.5,
  );
  static const displayMedium = TextStyle(
    fontFamily: _satoshi,
    fontWeight: FontWeight.w700,
    fontSize: 24,
    color: AppColors.onBackground,
    letterSpacing: -0.3,
  );
  static const titleLarge = TextStyle(
    fontFamily: _satoshi,
    fontWeight: FontWeight.w600,
    fontSize: 20,
    color: AppColors.onBackground,
  );
  static const titleMedium = TextStyle(
    fontFamily: _satoshi,
    fontWeight: FontWeight.w500,
    fontSize: 16,
    color: AppColors.onBackground,
  );
  static const bodyLarge = TextStyle(
    fontFamily: _satoshi,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    color: AppColors.onBackground,
    height: 1.5,
  );
  static const bodyMedium = TextStyle(
    fontFamily: _satoshi,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: AppColors.muted,
    height: 1.4,
  );
  static const labelLarge = TextStyle(
    fontFamily: _satoshi,
    fontWeight: FontWeight.w600,
    fontSize: 13,
    color: AppColors.onBackground,
    letterSpacing: 0.3,
  );
  static const caption = TextStyle(
    fontFamily: _satoshi,
    fontWeight: FontWeight.w400,
    fontSize: 11,
    color: AppColors.muted,
    letterSpacing: 0.5,
  );
}
