import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/lights/model/light_state.dart';
import 'package:smart_hub/domain/lights/model/rgb_color.dart';
import 'package:smart_hub/presentation/screens/lights/light_room.dart';

void main() {
  group('LightRoom', () {
    LightState light(String id, {bool on = true, int? brightness, RgbColor? color}) {
      return LightState(id: id, name: id, isOn: on, brightnessPercent: brightness, color: color);
    }

    test('Given lights that are on and off, when summarizing, then brightness is the average of those on', () {
      final room = LightRoom(
        id: 'kitchen',
        name: 'Kitchen',
        lights: [light('a', brightness: 40), light('b', brightness: 80), light('c', on: false)],
      );

      expect(room.isOn, isTrue);
      expect(room.lightsOn, hasLength(2));
      expect(room.brightnessPercent, 60);
    });

    test('Given only lights that are off, when summarizing, then the room is off at 0 %', () {
      final room = LightRoom(id: 'hall', name: 'Hall', lights: [light('a', on: false)]);

      expect(room.isOn, isFalse);
      expect(room.brightnessPercent, 0);
      expect(room.color, isNull);
    });

    test('Given a colored light that is on, when asking for the room color, then it is that color', () {
      final room = LightRoom(
        id: 'x',
        name: 'X',
        lights: [
          light('a', on: false, color: const RgbColor(1, 1, 1)),
          light('b', color: const RgbColor(9, 9, 9)),
        ],
      );

      expect(room.color, const RgbColor(9, 9, 9));
    });

    test(
      'Given a red, a blue and a nearly red light, when asking for the colors, then red and blue show once each',
      () {
        final room = LightRoom(
          id: 'office',
          name: 'Office',
          lights: [
            light('a', brightness: 100, color: const RgbColor(230, 50, 40)),
            light('b', brightness: 100, color: const RgbColor(60, 70, 240)),
            light('c', brightness: 100, color: const RgbColor(235, 55, 45)),
            light('d', on: false),
          ],
        );

        expect(room.colors, const [RgbColor(230, 50, 40), RgbColor(60, 70, 240)]);
      },
    );
  });
}
