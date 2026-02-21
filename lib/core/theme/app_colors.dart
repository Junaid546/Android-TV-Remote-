import 'package:flutter/material.dart';

abstract final class AppColors {
  // From design system
  static const primary = Color(0xFFED572C); // accent orange
  static const primaryDark = Color(0xFFB83A18);
  static const primaryLight = Color(0xFFFF7A52);
  static const surface = Color(0xFF1A1A1A); // card surface
  static const surfaceElevated = Color(0xFF222222); // elevated card
  static const background = Color(0xFF111010); // deep dark
  static const backgroundSecondary = Color(0xFF161616);
  static const onBackground = Color(0xFFF5F5F5); // text on dark
  static const onSurface = Color(0xFFECECEC);
  static const muted = Color(0xFFABA6A5); // secondary text
  static const divider = Color(0xFF2A2A2A);
  static const border = Color(0xFF2A2A2A);
  static const error = Color(0xFFE53935);
  static const success = Color(0xFF43A047);
  static const warning = Color(0xFFFFB300);

  // Gradients
  static const glowGradient = [Color(0xFFED572C), Color(0xFF8B1A00)];
  static const buttonGradient = [Color(0xFF2A2A2A), Color(0xFF1A1A1A)];

  // Transparency
  static Color primaryWithOpacity(double opacity) =>
      primary.withValues(alpha: opacity);
  static Color surfaceWithOpacity(double opacity) =>
      surface.withValues(alpha: opacity);
}
