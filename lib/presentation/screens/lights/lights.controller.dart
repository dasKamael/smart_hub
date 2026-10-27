import 'dart:async';

import 'package:flutter/painting.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/domain/lights/model/rgb_color.dart';
import 'package:smart_hub/domain/lights/model/light_capability.enum.dart';
import 'package:smart_hub/presentation/utils/extension/rgb_color.extension.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_area_colors.dart';
import 'package:smart_hub/common/utils/throttler.dart';
import 'package:smart_hub/domain/floorplan/floorplan.service.dart';
import 'package:smart_hub/domain/floorplan/model/placement.dart';
import 'package:smart_hub/domain/floorplan/room_lookup.util.dart';
import 'package:smart_hub/domain/lights/light.service.dart';
import 'package:smart_hub/domain/lights/model/room_scene.dart';
import 'package:smart_hub/domain/lights/room_scenes.service.dart';
import 'package:smart_hub/domain/lights/scene.util.dart';
import 'package:smart_hub/domain/lights/model/light_state.dart';
import 'package:smart_hub/presentation/screens/lights/light_room.dart';
import 'package:smart_hub/presentation/screens/lights/lights.state.dart';

part 'lights.controller.g.dart';

/// Lights page: selected room and room wide commands.
@riverpod
class LightsController extends _$LightsController {
  static final _log = Logger('LightsController');
  static const sliderInterval = Duration(milliseconds: 200);

  final _throttlers = <String, Throttler>{};

  @override
  LightsPageState build() {
    ref.onDispose(() {
      for (final throttler in _throttlers.values) {
        throttler.dispose();
      }
    });
    return const LightsPageState();
  }

  void selectRoom(String roomId) => state = state.copyWith(selectedRoomId: roomId, openSceneId: null);

  void toggleRoom(LightRoom room) => _setOn(room.lights, on: !room.isOn);

  /// "All off" while any light is on, otherwise "All on".
  void toggleAll(List<LightRoom> rooms) {
    final lights = [for (final room in rooms) ...room.lights];
    _setOn(lights, on: !lights.any((light) => light.isOn));
  }

  void changeBrightness(LightRoom room, int percent) {
    _throttlers.putIfAbsent(room.id, () => Throttler(sliderInterval))(() => _setBrightness(room, percent));
  }

  void endBrightness(LightRoom room, int percent) {
    _throttlers.putIfAbsent(room.id, () => Throttler(sliderInterval)).flush(() => _setBrightness(room, percent));
  }

  /// Dims [lights] together, throttled while dragging.
  void changeBrightnessOf(List<LightState> lights, int percent) =>
      _wheel(lights, 'brightness')(() => _setBrightnessOf(lights, percent));

  void endBrightnessOf(List<LightState> lights, int percent) =>
      _wheel(lights, 'brightness').flush(() => _setBrightnessOf(lights, percent));

  void _setBrightnessOf(List<LightState> lights, int percent) {
    _run(
      'set brightness',
      ref.read(lightsServiceProvider.notifier).setBrightnessOf([for (final l in lights) l.id], percent),
    );
  }

  /// Colors [lights] while the wheel is dragged (throttled), and once more when it is let go.
  void changeColor(List<LightState> lights, RgbColor color) => _wheel(lights)(() => _setColor(lights, color));

  void endColor(List<LightState> lights, RgbColor color) => _wheel(lights).flush(() => _setColor(lights, color));

  void changeKelvin(List<LightState> lights, int kelvin) => _wheel(lights)(() => _setKelvin(lights, kelvin));

  void endKelvin(List<LightState> lights, int kelvin) => _wheel(lights).flush(() => _setKelvin(lights, kelvin));

  Throttler _wheel(List<LightState> lights, [String what = 'color']) {
    return _throttlers.putIfAbsent(
      '$what:${lights.map((light) => light.id).join(',')}',
      () => Throttler(sliderInterval),
    );
  }

  void _setColor(List<LightState> lights, RgbColor color) {
    final service = ref.read(lightsServiceProvider.notifier);
    _run(
      'set color',
      Future.wait([
        for (final light in lights)
          if (light.capabilities.contains(LightCapability.color)) service.setColor(light.id, color),
      ]),
    );
  }

  /// Each light gets the temperature as far as its range goes.
  void _setKelvin(List<LightState> lights, int kelvin) {
    final service = ref.read(lightsServiceProvider.notifier);
    _run(
      'set color temperature',
      Future.wait([
        for (final light in lights)
          if (light.capabilities.contains(LightCapability.colorTemperature))
            service.setKelvin(light.id, kelvin.clamp(light.minKelvin, light.maxKelvin)),
      ]),
    );
  }

  void applyScene(LightRoom room, RoomScene scene) {
    closeSceneOptions();
    _run('apply ${scene.name}', ref.read(lightsServiceProvider.notifier).applyScene(room.lights, scene));
  }

  /// Shows the options of a scene, or hides them when they are already shown.
  void toggleSceneOptions(RoomScene scene) {
    state = state.copyWith(openSceneId: state.openSceneId == scene.id ? null : scene.id);
  }

  void closeSceneOptions() => state = state.copyWith(openSceneId: null);

  /// Saves how the room shines now as a new scene.
  void addScene(LightRoom room, String name) {
    _run('add a scene', ref.read(roomScenesServiceProvider.notifier).addFromCurrent(room.id, name, room.lights));
  }

  void overwriteScene(LightRoom room, RoomScene scene) {
    closeSceneOptions();
    _run('save ${scene.name}', ref.read(roomScenesServiceProvider.notifier).overwrite(scene, room.lights));
  }

  void renameScene(RoomScene scene, String name) {
    closeSceneOptions();
    _run('rename ${scene.name}', ref.read(roomScenesServiceProvider.notifier).rename(scene, name));
  }

  void deleteScene(RoomScene scene) {
    closeSceneOptions();
    _run('delete ${scene.name}', ref.read(roomScenesServiceProvider.notifier).delete(scene));
  }

  void _setOn(List<LightState> lights, {required bool on}) {
    _run(
      'switch lights',
      ref.read(lightsServiceProvider.notifier).setOn([for (final light in lights) light.id], on: on),
    );
  }

  void _setBrightness(LightRoom room, int percent) {
    final dimmable = [for (final light in room.lights) light.id];
    _run('set brightness', ref.read(lightsServiceProvider.notifier).setBrightnessOf(dimmable, percent));
  }

  void _run(String action, Future<void> command) {
    unawaited(command.catchError((Object e) => _log.warning('Could not $action: $e')));
  }
}

/// Lights grouped by the room they stand in on the floor plan, in plan order. Lights that are not placed come last.
@riverpod
List<LightRoom> lightRooms(Ref ref) {
  final plan = ref.watch(floorPlanServiceProvider).value;
  final lights = ref.watch(lightsServiceProvider).value ?? const <LightState>[];
  final positions = {
    for (final placement in ref.watch(placementServiceProvider).value ?? const <Placement>[])
      placement.deviceId: placement.position,
  };
  if (plan == null) return const [];

  final byRoom = <String, List<LightState>>{};
  for (final light in lights) {
    final position = positions[light.id];
    final room = position == null ? null : RoomLookupUtil.roomAt(plan, position);
    byRoom.putIfAbsent(room?.id ?? LightRoom.notPlacedId, () => []).add(light);
  }
  return [
    for (final room in plan.rooms)
      if (byRoom[room.id] case final roomLights?) LightRoom(id: room.id, name: room.name, lights: roomLights),
    if (byRoom[LightRoom.notPlacedId] case final unplaced?)
      LightRoom(id: LightRoom.notPlacedId, name: 'Not placed', lights: unplaced),
  ];
}

/// The color of the lights area: the colors of the rooms that are on; indigo when all are off.
@riverpod
Color lightsTint(Ref ref) {
  return HubAreaColors.lightsFor([
    for (final room in ref.watch(lightRoomsProvider))
      if (room.isOn) room.color?.toColor() ?? HubColorPalette.lightWarm,
  ]);
}

/// The scenes of [roomId] with what each does there: its color for the dot and whether the room shows it now.
@riverpod
List<({RoomScene scene, Color color, bool active})> roomScenes(Ref ref, String roomId) {
  ref.watch(roomScenesServiceProvider);
  final room = ref.watch(lightRoomsProvider).where((room) => room.id == roomId).firstOrNull;
  final lights = room?.lights ?? const <LightState>[];
  return [
    for (final scene in ref.read(roomScenesServiceProvider.notifier).scenesOf(roomId))
      (scene: scene, color: SceneUtil.colorOf(lights, scene).toColor(), active: SceneUtil.isActive(lights, scene)),
  ];
}
