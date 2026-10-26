import 'package:flutter/painting.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';

/// Type scale from the design handoff (size / weight / letter spacing).
abstract final class HubTextStyles {
  static const display = TextStyle(
    color: HubColorPalette.text,
    fontSize: 46,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.5,
    height: 1.1,
  );
  static const pageTitle = TextStyle(
    color: HubColorPalette.text,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.6,
    height: 1.2,
  );
  static const sectionTitle = TextStyle(
    color: HubColorPalette.text,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.4,
    height: 1.2,
  );
  static const widgetTitle = TextStyle(
    color: HubColorPalette.text,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.25,
  );
  static const body = TextStyle(color: HubColorPalette.text, fontSize: 17, fontWeight: FontWeight.w600, height: 1.3);
  static const secondary = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: HubColorPalette.text2,
    height: 1.3,
  );
  static const label = TextStyle(color: HubColorPalette.text, fontSize: 13, fontWeight: FontWeight.w600, height: 1.3);
  static const micro = TextStyle(
    color: HubColorPalette.text,
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.4,
    height: 1.3,
  );
}

extension HubTextStyleExtension on TextStyle {
  /// Numbers (times, percentages, progress) always use tabular figures so they do not jump.
  TextStyle get tabular => copyWith(fontFeatures: const [FontFeature.tabularFigures()]);
}
