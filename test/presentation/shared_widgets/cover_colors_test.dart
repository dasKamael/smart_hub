import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/presentation/shared_widgets/artwork.dart';
import 'package:smart_hub/presentation/shared_widgets/cover_colors.dart';

void main() {
  group('CoverColors', () {
    Uint8List pixels(List<(Color, int)> parts) {
      return Uint8List.fromList([
        for (final (color, count) in parts)
          for (var i = 0; i < count; i++) ...[
            (color.r * 255).round(),
            (color.g * 255).round(),
            (color.b * 255).round(),
            255,
          ],
      ]);
    }

    double hueOf(Color color) => HSVColor.fromColor(color).hue;

    test('Given a mostly red cover with some blue, when reading its colors, then red comes first, then blue', () {
      // When
      final colors = CoverColors.fromPixels(
        pixels([(const Color(0xFFD03020), 180), (const Color(0xFF2040C0), 60), (const Color(0xFF000000), 16)]),
      );

      // Then
      expect(colors, hasLength(3));
      expect(hueOf(colors[0]), closeTo(5, 10));
      expect(hueOf(colors[1]), closeTo(228, 12));
    });

    test('Given a gray cover, when reading its colors, then they are gray shades, dark enough for a background', () {
      // When
      final colors = CoverColors.fromPixels(pixels([(const Color(0xFFB0B0B0), 256)]));

      // Then
      expect(colors, hasLength(3));
      for (final color in colors) {
        final hsv = HSVColor.fromColor(color);
        expect(hsv.saturation, lessThan(0.05));
        expect(hsv.value, lessThanOrEqualTo(0.71), reason: 'clamped to 0.7, plus rounding to 8 bit');
      }
    });

    test('Given a black cover, when reading its colors, then the generated colors are used', () {
      expect(CoverColors.fromPixels(pixels([(const Color(0xFF000000), 256)])), CoverColors.ofSeed(''));
    });

    test(
      'Given a dark green cover, when picking its tint, then it stays green and is as bright as the cover colors',
      () {
        // When
        final tint = HSVColor.fromColor(
          CoverColors.tintFrom(
            CoverColors.fromPixels(pixels([(const Color(0xFF2E4A1E), 200), (const Color(0xFF8A6A50), 56)])).first,
          ),
        );

        // Then
        expect(tint.hue, inInclusiveRange(80, 140));
        expect(tint.saturation, inInclusiveRange(0.35, 0.65));
        expect(tint.value, closeTo(0.72, 0.01));
      },
    );

    test('Given a gray color, when picking its tint, then it stays gray', () {
      expect(HSVColor.fromColor(CoverColors.tintFrom(const Color(0xFF808080))).saturation, lessThan(0.05));
    });

    test('Given no cover image, when asking for its tint, then it is the color of the generated cover', () async {
      expect(await CoverColors.tintOf(null, seed: 'Safe With Me'), Artwork.colorOf('Safe With Me'));
    });
  });
}
