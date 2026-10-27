import 'dart:math' as math;

import 'package:smart_hub/domain/lights/model/rgb_color.dart';

abstract final class ColorTemperatureUtil {
  /// Approximate sRGB color of white light at [kelvin] (Tanner Helland's fit, valid for 1000–40000 K).
  static RgbColor toRgb(int kelvin) {
    final t = kelvin.clamp(1000, 40000) / 100;
    final double red;
    final double green;
    final double blue;
    if (t <= 66) {
      red = 255;
      green = 99.4708025861 * math.log(t) - 161.1195681661;
      blue = t <= 19 ? 0 : 138.5177312231 * math.log(t - 10) - 305.0447927307;
    } else {
      red = 329.698727446 * math.pow(t - 60, -0.1332047592);
      green = 288.1221695283 * math.pow(t - 60, -0.0755148492);
      blue = 255;
    }
    int channel(double value) => value.round().clamp(0, 255);
    return RgbColor(channel(red), channel(green), channel(blue));
  }
}
