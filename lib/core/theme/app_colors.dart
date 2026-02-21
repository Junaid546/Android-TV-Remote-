import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  // Brand Colors
  static const primary = Color(0xFF00E5FF); // Electric Cyan
  static const secondary = Color(0xFF651FFF); // Deep Indigo
  static const accent = Color(0xFFFF4081); // Pink Accent

  // Backgrounds & Surfaces
  static const background = Color(0xFF0A0A0B); // Deep Rich Black
  static const surface = Color(0xFF161618); // Elevated Surface
  static const surfaceLight = Color(0xFF222224); // Lighter Surface
  static const surfaceDark = Color(0xFF0E0E10); // Subtle contrast

  // Glassmorphism / Overlays
  static const glass = Color(0x1AFFFFFF);
  static const glassDark = Color(0x33000000);

  // Status Colors
  static const error = Color(0xFFFF5252);
  static const success = Color(0xFF00E676);
  static const warning = Color(0xFFFFD740);
  static const info = Color(0xFF40C4FF);

  // Text Colors
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFFB0B0B5);
  static const textDisabled = Color(0xFF626266);
}
