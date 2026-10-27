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

    test('Given a violet and an orange light, when coloring the lights area, then it mixes them, a bit warmer', () {
      // When
      final color = HubAreaColors.lightsFor(const [Color(0xFFBF5AF2), Color(0xFFFF9F6B)]);

      // Then
      final mix = Color.from(
        alpha: 1,
        red: (0xBF / 255 + 1) / 2,
        green: (0x5A + 0x9F) / 2 / 255,
        blue: (0xF2 + 0x6B) / 2 / 255,
      );
      expect(color, Color.lerp(mix, HubAreaColors.lights, 0.3));
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
