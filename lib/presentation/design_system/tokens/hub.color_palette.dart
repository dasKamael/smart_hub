import 'package:flutter/painting.dart';

/// Colors from the design handoff (`design/UI Library.dc.html` → "Farben").
abstract final class HubColorPalette {
  // Surfaces
  /// Behind everything before the sky shows (`HubBackground`); a deep night blue instead of the handoff's black.
  static const bg = Color(0xFF0B0F17);

  /// Opaque, for dialogs and overlays; a night blue that matches the sky.
  static const surface = Color(0xFF1B2230);

  /// Tiles, buttons and controls on cards: white veils, so the sky tints them (the handoff's greys were opaque).
  static const elevated = Color(0x1FFFFFFF);
  static const control = Color(0x2EFFFFFF);
  static const controlStrong = Color(0x47FFFFFF);
  static const selected = Color(0xFF636366);

  /// Cards on the sky background: light enough that the sky shines through, with a fine edge.
  static const card = Color(0x1AFFFFFF);
  static const cardBorder = Color(0x14FFFFFF);

  // Floor plan
  /// Rooms of the plan, darker than the card around them.
  static const floor = Color(0x47000000);
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
