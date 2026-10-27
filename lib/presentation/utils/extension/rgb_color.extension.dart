import 'dart:ui';

import 'package:smart_hub/domain/lights/model/rgb_color.dart';

extension RgbColorExtension on RgbColor {
  Color toColor() => Color(argb);
}
