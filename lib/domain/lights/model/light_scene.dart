import 'package:smart_hub/domain/lights/model/rgb_color.dart';

/// A look for all lights of a room, independent of their brand (`README` → "Lights page").
///
/// Color lights take [color], white-only lights the matching [kelvin], dimmable lights the brightness.
final class LightScene {
  const LightScene({required this.name, required this.brightnessPercent, required this.color, required this.kelvin});

  static const relax = LightScene(name: 'Relax', brightnessPercent: 55, color: RgbColor(255, 179, 64), kelvin: 2700);
  static const read = LightScene(name: 'Read', brightnessPercent: 85, color: RgbColor(255, 224, 138), kelvin: 3500);
  static const focus = LightScene(name: 'Focus', brightnessPercent: 100, color: RgbColor(191, 227, 255), kelvin: 5500);
  static const night = LightScene(name: 'Night', brightnessPercent: 12, color: RgbColor(255, 159, 107), kelvin: 2200);

  static const all = [relax, read, focus, night];

  final String name;
  final int brightnessPercent;
  final RgbColor color;
  final int kelvin;
}
