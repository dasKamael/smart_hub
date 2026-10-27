import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/lights/color_temperature.util.dart';

void main() {
  group('ColorTemperatureUtil.toRgb', () {
    test('Given warm white, when converting, then red dominates and blue is low', () {
      final rgb = ColorTemperatureUtil.toRgb(2200);

      expect(rgb.red, 255);
      expect(rgb.blue, lessThan(100));
    });

    test('Given daylight 6500 K, when converting, then it is close to white', () {
      final rgb = ColorTemperatureUtil.toRgb(6500);

      expect(rgb.red, greaterThan(240));
      expect(rgb.green, greaterThan(240));
      expect(rgb.blue, greaterThan(240));
    });

    test('Given cold light, when converting, then blue dominates', () {
      final rgb = ColorTemperatureUtil.toRgb(12000);

      expect(rgb.blue, 255);
      expect(rgb.red, lessThan(rgb.blue));
    });

    test('Given out of range values, when converting, then they are clamped', () {
      expect(ColorTemperatureUtil.toRgb(10), ColorTemperatureUtil.toRgb(1000));
      expect(ColorTemperatureUtil.toRgb(99999), ColorTemperatureUtil.toRgb(40000));
    });
  });
}
