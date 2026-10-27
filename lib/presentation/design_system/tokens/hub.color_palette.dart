import 'package:flutter/painting.dart';

/// Colors from the design handoff (`design/UI Library.dc.html` → "Farben").
abstract final class HubColorPalette {
  // Surfaces
  static const bg = Color(0xFF000000);
  static const surface = Color(0xFF1C1C1E);
  static const elevated = Color(0xFF2C2C2E);
  static const control = Color(0xFF3A3A3C);
  static const controlStrong = Color(0xFF48484A);
  static const selected = Color(0xFF636366);

  // Floor plan
  static const floor = Color(0xFF262628);
  static const wall = Color(0xFF636366);
  static const plantMarkerBg = Color(0xFF1E3524);

  // Text
  static const text = Color(0xFFFFFFFF);
  static const text2 = Color(0x99EBEBF5);
  static const text3 = Color(0x73EBEBF5);
  static const separator = Color(0x99545458);

  // Accent & status
  static const accent = Color(0xFF0A84FF);
  static const accentText = Color(0xFF409CFF);
  static const accentTint = Color(0x380A84FF);
  static const danger = Color(0xFFFF453A);
  static const dangerText = Color(0xFFFF6961);
  static const success = Color(0xFF30D158);
  static const playing = Color(0xFF1DB954);

  /// Fertilizing due.
  static const feed = Color(0xFFE0B04A);

  // Light presets
  static const lightWarm = Color(0xFFFFB340);
  static const lightSoft = Color(0xFFFFE08A);
  static const lightSunset = Color(0xFFFF9F6B);
  static const lightCool = Color(0xFFBFE3FF);
  static const lightViolet = Color(0xFFBF5AF2);

  static const lightPresets = [lightWarm, lightSoft, lightSunset, lightCool, lightViolet];

  // Glass (tab bar)
  static const glassFill = Color(0x1AFFFFFF);
  static const glassBorder = Color(0x42FFFFFF);
  static const glassHighlight = Color(0x4DFFFFFF);
  static const glassIndicator = Color(0x33FFFFFF);
  static const glassIndicatorHighlight = Color(0x73FFFFFF);
}
