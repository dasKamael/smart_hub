import 'package:smart_hub/domain/lights/model/light_state.dart';
import 'package:smart_hub/domain/lights/model/rgb_color.dart';

/// The lights of one room of the floor plan; lights that are not placed share one extra room.
final class LightRoom {
  const LightRoom({required this.id, required this.name, required this.lights});

  static const notPlacedId = 'not-placed';

  final String id;
  final String name;
  final List<LightState> lights;

  List<LightState> get lightsOn => lights.where((light) => light.isOn).toList();

  bool get isOn => lightsOn.isNotEmpty;

  /// Average brightness of the lights that are on; 0 when all are off.
  int get brightnessPercent {
    final on = lightsOn;
    if (on.isEmpty) return 0;
    return (on.map((light) => light.brightnessPercent ?? 100).reduce((a, b) => a + b) / on.length).round();
  }

  /// Color of the first light that is on; warm white for lights without color.
  RgbColor? get color => lightsOn.map((light) => light.displayColor).nonNulls.firstOrNull;

  /// The different colors of the lights that are on, in light order – e.g. red and blue when the room is mixed.
  /// Nearly equal colors count once.
  List<RgbColor> get colors {
    final distinct = <RgbColor>[];
    for (final color in lightsOn.map((light) => light.displayColor).nonNulls) {
      final known = distinct.any(
        (other) =>
            (other.red - color.red).abs() + (other.green - color.green).abs() + (other.blue - color.blue).abs() < 40,
      );
      if (!known) distinct.add(color);
    }
    return distinct;
  }
}
