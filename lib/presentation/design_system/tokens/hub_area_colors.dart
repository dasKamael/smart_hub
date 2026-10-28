import 'dart:math' as math;

import 'package:flutter/painting.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';

/// Each area of the hub has a color of its own, in its cards and in the glow behind its page. It follows the
/// area's state – gently, so the hub feels alive without getting colorful.
abstract final class HubAreaColors {
  /// Sage green; fresher once everything is watered, terracotta creeps in while a plant is overdue.
  static const plants = Color(0xFF6FA287);
  static const plantsWatered = Color(0xFF5FBF86);
  static const _terracotta = Color(0xFFC9775A);

  /// Warm amber while lights are on in their colors; a muted indigo when everything is off.
  static const lights = Color(0xFFE0A050);
  static const lightsOff = Color(0xFF4B4F8C);

  /// The overview: a calm lavender grey.
  static const home = Color(0xFF8E87B5);

  /// What you have taken on: a calm petrol while there is time, amber in the last days, terracotta once a day
  /// has passed.
  static const focus = Color(0xFF5A93A8);
  static const focusSoon = Color(0xFFE0B04A);
  static const focusOverdue = _terracotta;

  static const _faded = Color(0xFF6B7280);

  static Color plantsFor({required int overdue, required int dueToday}) {
    if (overdue > 0) return Color.lerp(plants, _terracotta, 0.3)!;
    return dueToday > 0 ? plants : plantsWatered;
  }

  /// Warmer the closer the days run out: a nudge, never a reproach, so it stops well short of the danger red.
  static Color focusFor({required int soon, required int overdue}) {
    if (overdue > 0) return Color.lerp(focus, focusOverdue, 0.4)!;
    return soon > 0 ? Color.lerp(focus, focusSoon, 0.25)! : focus;
  }

  /// The colors that are on, mixed by hue, pulled a little towards amber so it stays warm. The less the hues agree
  /// (e.g. green and magenta), the more it is amber – an RGB mean of them would only be grey.
  static Color lightsFor(List<Color> on) {
    if (on.isEmpty) return lightsOff;
    final hsl = [for (final color in on) HSLColor.fromColor(color)];
    double mean(double Function(HSLColor color) of) => hsl.map(of).reduce((a, b) => a + b) / hsl.length;
    final x = mean((c) => math.cos(c.hue * math.pi / 180));
    final y = mean((c) => math.sin(c.hue * math.pi / 180));
    // 1 when all hues are the same, 0 when they cancel out.
    final agreement = math.sqrt(x * x + y * y);
    final mix = HSLColor.fromAHSL(
      1,
      (math.atan2(y, x) * 180 / math.pi + 360) % 360,
      mean((c) => c.saturation),
      mean((c) => c.lightness),
    ).toColor();
    return Color.lerp(mix, lights, 0.3 + 0.7 * (1 - agreement))!;
  }

  /// The cover's color, paler while nothing plays.
  static Color musicFor(Color cover, {required bool playing}) => playing ? cover : Color.lerp(cover, _faded, 0.5)!;

  /// The white veil of tiles on a card ([HubColorPalette.elevated]) with a hint of the card's [tint].
  static Color veil(Color? tint) => switch (tint) {
    final tint? => Color.lerp(HubColorPalette.elevated, tint.withValues(alpha: HubColorPalette.elevated.a), 0.4)!,
    null => HubColorPalette.elevated,
  };

  /// The top left of a card in [tint]: a veil of the color over [base].
  static Color cardTop(Color tint, Color base, {double strength = 0.34}) {
    return Color.alphaBlend(tint.withValues(alpha: strength), base);
  }
}
