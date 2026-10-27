import 'package:clock/clock.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/data/lights/room_scene.repository.dart';
import 'package:smart_hub/domain/lights/model/light_state.dart';
import 'package:smart_hub/domain/lights/model/room_scene.dart';
import 'package:smart_hub/domain/lights/scene.util.dart';

part 'room_scenes.service.g.dart';

/// The light scenes of every room: saved ones, or the templates until a room's scenes are changed. A room keeps at
/// least one and at most `SceneUtil.maxScenes` scenes.
///
/// This service is the only writer: it loads the scenes once and keeps them, so quick changes build on each other.
@Riverpod(keepAlive: true)
class RoomScenesService extends _$RoomScenesService {
  @override
  Future<Map<String, List<RoomScene>>> build() => ref.watch(roomSceneRepositoryProvider).loadAll();

  List<RoomScene> scenesOf(String roomId) => state.value?[roomId] ?? SceneUtil.templates(roomId);

  /// Saves how [lights] shine now as a new scene; `false` when the room has no room for another.
  Future<bool> addFromCurrent(String roomId, String name, List<LightState> lights) async {
    final scenes = scenesOf(roomId);
    if (scenes.length >= SceneUtil.maxScenes) return false;
    final id = '$roomId/${clock.now().microsecondsSinceEpoch}';
    await _save(roomId, [...scenes, SceneUtil.snapshot(id: id, roomId: roomId, name: name, lights: lights)]);
    return true;
  }

  /// Makes [scene] how [lights] shine now.
  Future<void> overwrite(RoomScene scene, List<LightState> lights) {
    final updated = SceneUtil.snapshot(id: scene.id, roomId: scene.roomId, name: scene.name, lights: lights);
    return _replace(scene, updated);
  }

  Future<void> rename(RoomScene scene, String name) => _replace(scene, scene.copyWith(name: name));

  /// Removes [scene]; the last scene of a room stays.
  Future<void> delete(RoomScene scene) async {
    final scenes = scenesOf(scene.roomId);
    if (scenes.length <= 1) return;
    await _save(scene.roomId, [
      for (final other in scenes)
        if (other.id != scene.id) other,
    ]);
  }

  Future<void> _replace(RoomScene scene, RoomScene updated) {
    return _save(scene.roomId, [for (final other in scenesOf(scene.roomId)) other.id == scene.id ? updated : other]);
  }

  /// Sets the new scenes at once, so quick changes build on each other.
  Future<void> _save(String roomId, List<RoomScene> scenes) {
    state = AsyncData({...?state.value, roomId: scenes});
    return ref.read(roomSceneRepositoryProvider).replaceRoom(roomId, scenes);
  }
}
