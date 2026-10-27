import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_sky.dart';

void main() {
  group('HubSky', () {
    test('Given midnight and 3 am, when reading the sky, then both are the same night', () {
      expect(HubSky.at(DateTime(2026, 10, 27, 0)), HubSky.at(DateTime(2026, 10, 27, 3)));
    });

    test('Given noon, when reading the sky, then it is lighter than at night', () {
      // Given / When
      final day = HubSky.at(DateTime(2026, 10, 27, 12)).top;
      final night = HubSky.at(DateTime(2026, 10, 27, 2)).top;

      // Then
      expect(day.computeLuminance(), greaterThan(night.computeLuminance()));
    });

    test('Given 6 am between night and dawn, when reading the sky, then it lies between both', () {
      // Given / When
      final night = HubSky.at(DateTime(2026, 10, 27, 5)).top;
      final dawn = HubSky.at(DateTime(2026, 10, 27, 7)).top;
      final between = HubSky.at(DateTime(2026, 10, 27, 6)).top;

      // Then
      expect(between, Color.lerp(night, dawn, 0.5));
    });
  });
}
