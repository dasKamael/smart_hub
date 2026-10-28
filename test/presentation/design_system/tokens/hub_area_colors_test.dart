import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_area_colors.dart';

void main() {
  group('HubAreaColors', () {
    test('Given plants, when one is overdue, then the color warms up, and when all are watered it freshens', () {
      // When
      final overdue = HubAreaColors.plantsFor(overdue: 1, dueToday: 0);
      final due = HubAreaColors.plantsFor(overdue: 0, dueToday: 2);
      final watered = HubAreaColors.plantsFor(overdue: 0, dueToday: 0);

      // Then
      expect(overdue.r, greaterThan(due.r));
      expect((due, watered), (HubAreaColors.plants, HubAreaColors.plantsWatered));
    });

    test('Given no light on, when coloring the lights area, then it is the indigo for off', () {
      expect(HubAreaColors.lightsFor(const []), HubAreaColors.lightsOff);
    });

    test('Given one violet light, when coloring the lights area, then it is violet, a bit warmer', () {
      // Given
      const violet = Color(0xFFBF5AF2);

      // When
      final color = HubAreaColors.lightsFor(const [violet, violet]);

      // Then
      expect(color.toARGB32(), Color.lerp(violet, HubAreaColors.lights, 0.3)!.toARGB32());
    });

    test('Given a green and a magenta light, when coloring the lights area, '
        'then it is the warm amber instead of a grey mix', () {
      // When
      final color = HubAreaColors.lightsFor(const [Color(0xFF00FF00), Color(0xFFFF00FF)]);

      // Then
      expect(color.toARGB32(), HubAreaColors.lights.toARGB32());
    });

    test('Given a green and a teal light, when coloring the lights area, '
        'then it is a saturated hue between them, not a grey', () {
      // When
      final color = HSLColor.fromColor(HubAreaColors.lightsFor(const [Color(0xFF33CC33), Color(0xFF33CCCC)]));

      // Then
      expect(color.saturation, greaterThan(0.3));
      expect(color.hue, inInclusiveRange(60, 180));
    });

    test('Given a paused track, when coloring the music area, then the cover color is paler', () {
      // Given
      const cover = Color(0xFFC76B4A);

      // When / Then
      expect(HubAreaColors.musicFor(cover, playing: true), cover);
      expect(HubAreaColors.musicFor(cover, playing: false), isNot(cover));
    });
  });
}
