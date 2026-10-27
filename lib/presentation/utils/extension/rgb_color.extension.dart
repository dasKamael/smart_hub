import 'dart:ui';

import 'package:smart_hub/domain/lights/model/rgb_color.dart';

extension RgbColorExtension on RgbColor {
  Color toColor() => Color(argb);
}

extension ColorToRgbExtension on Color {
  RgbColor toRgb() => RgbColor((r * 255).round(), (g * 255).round(), (b * 255).round());
}
