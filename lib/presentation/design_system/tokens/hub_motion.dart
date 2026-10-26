import 'package:flutter/animation.dart';

/// Animation spec from the design handoff ("Animation spec").
abstract final class HubMotion {
  /// Marker move, fan out, collapse – slight overshoot.
  static const move = Cubic(0.3, 1.25, 0.5, 1);
  static const moveDuration = Duration(milliseconds: 450);

  /// Scale: lift, drop target, pop.
  static const pop = Cubic(0.3, 1.5, 0.5, 1);
  static const popDuration = Duration(milliseconds: 380);

  /// Opacity, colors, shadows.
  static const fade = Curves.ease;
  static const fadeDuration = Duration(milliseconds: 220);

  /// Light glow on/off.
  static const glow = Curves.ease;
  static const glowDuration = Duration(milliseconds: 500);

  /// Tab indicator slide.
  static const tab = Cubic(0.3, 1.35, 0.5, 1);
  static const tabDuration = Duration(milliseconds: 450);

  /// Fan out stagger per group member.
  static const fanOutStagger = Duration(milliseconds: 35);
}
