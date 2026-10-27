import 'package:flutter/painting.dart';

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

  static const _faded = Color(0xFF6B7280);

  static Color plantsFor({required int overdue, required int dueToday}) {
    if (overdue > 0) return Color.lerp(plants, _terracotta, 0.3)!;
    return dueToday > 0 ? plants : plantsWatered;
  }

  /// The mean of the colors that are on, pulled a little towards amber so it stays warm.
  static Color lightsFor(List<Color> on) {
    if (on.isEmpty) return lightsOff;
    double mean(double Function(Color color) channel) => on.map(channel).reduce((a, b) => a + b) / on.length;
    final mix = Color.from(alpha: 1, red: mean((c) => c.r), green: mean((c) => c.g), blue: mean((c) => c.b));
    return Color.lerp(mix, lights, 0.3)!;
  }

  /// The cover's color, paler while nothing plays.
  static Color musicFor(Color cover, {required bool playing}) => playing ? cover : Color.lerp(cover, _faded, 0.5)!;

  /// The top left of a card in [tint]: a veil of the color over [base].
  static Color cardTop(Color tint, Color base, {double strength = 0.34}) {
    return Color.alphaBlend(tint.withValues(alpha: strength), base);
  }
}
