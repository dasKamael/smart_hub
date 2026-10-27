import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smart_hub/domain/lights/model/rgb_color.dart';

part 'room_scene.freezed.dart';

/// A light scene of one room. Lights saved in [lights] get exactly that; any other light of the room gets the
/// scene's base values, adapted to what it can do (`SceneUtil.settingFor`).
@freezed
abstract class RoomScene with _$RoomScene {
  const factory RoomScene({
    required String id,
    required String roomId,
    required String name,
    required int brightnessPercent,
    required RgbColor color,
    required int kelvin,

    /// Per light id, for scenes saved from the room's current light.
    @Default(<String, SceneLight>{}) Map<String, SceneLight> lights,
  }) = _RoomScene;
}

/// What one light does in a scene: off, or on with a brightness and a color or a color temperature.
@freezed
abstract class SceneLight with _$SceneLight {
  const factory SceneLight({required bool on, int? brightnessPercent, RgbColor? color, int? kelvin}) = _SceneLight;
}
