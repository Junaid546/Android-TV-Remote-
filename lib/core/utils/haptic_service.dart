import 'package:flutter/services.dart';

class HapticService {
  static bool enabled = true;

  static void setEnabled(bool value) {
    enabled = value;
  }

  static Future<void> light() async {
    if (!enabled) return;
    await HapticFeedback.lightImpact();
  }

  static Future<void> medium() async {
    if (!enabled) return;
    await HapticFeedback.mediumImpact();
  }

  static Future<void> heavy() async {
    if (!enabled) return;
    await HapticFeedback.heavyImpact();
  }

  static Future<void> selection() async {
    if (!enabled) return;
    await HapticFeedback.selectionClick();
  }

  static Future<void> error() async {
    if (!enabled) return;
    await HapticFeedback.vibrate();
  }
}
