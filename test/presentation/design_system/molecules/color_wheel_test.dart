import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/presentation/design_system/molecules/color_wheel.dart';

void main() {
  group('ColorWheelScale', () {
    test(
      'Given a place on the wheel, when reading its color and placing that color again, then it is the same place',
      () {
        for (final place in const [Offset(60, 160), Offset(250, 90), Offset(200, 260), Offset(160, 100)]) {
          final color = ColorWheelScale.colorAt(place, 320);
          expect((ColorWheelScale.positionOf(color, 320) - place).distance, lessThan(6), reason: '$place');
        }
      },
    );

    test('Given the middle, when reading its color, then it is white', () {
      expect(ColorWheelScale.colorAt(const Offset(160, 160), 320), const Color(0xFFFFFFFF));
    });
  });

  group('WhiteWheelScale', () {
    final scale = WhiteWheelScale(minKelvin: 2200, maxKelvin: 6500, colorOf: (_) => const Color(0xFFFFFFFF));

    test('Given warm white near the lower end, when placing it, then it sits low inside the wheel', () {
      expect(scale.heightOf(2700, 300), inInclusiveRange(250, 276));
    });

    test('Given the coolest white, when placing it, then it stays inside at the top', () {
      expect(scale.heightOf(6500, 300), 24);
    });
  });
}
