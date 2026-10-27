import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:clock/clock.dart';
import 'package:smart_hub/common/utils/current_day.provider.dart';
import 'package:smart_hub/common/utils/throttler.dart';
import 'package:smart_hub/domain/floorplan/floorplan.service.dart';
import 'package:smart_hub/domain/floorplan/grouping.util.dart';
import 'package:smart_hub/domain/floorplan/model/device_kind.enum.dart';
import 'package:smart_hub/domain/floorplan/plan_geometry.util.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/domain/floorplan/model/placement.dart';
import 'package:smart_hub/domain/lights/light.service.dart';
import 'package:smart_hub/domain/lights/model/light_state.dart';
import 'package:smart_hub/domain/lights/model/rgb_color.dart';
import 'package:smart_hub/domain/music/model/speaker_state.dart';
import 'package:smart_hub/domain/music/speaker.service.dart';
import 'package:smart_hub/domain/plants/model/plant.dart';
import 'package:smart_hub/domain/plants/plants.service.dart';
import 'package:smart_hub/domain/plants/watering_due.util.dart';
import 'package:smart_hub/presentation/screens/floorplan/floorplan.state.dart';
import 'package:smart_hub/presentation/screens/floorplan/plan_device.dart';

part 'floorplan.controller.g.dart';

/// UI state of the floor plan (selection, visible layers) and the device commands of the inspector.
@riverpod
class FloorplanController extends _$FloorplanController {
  static final _log = Logger('FloorplanController');

  /// Slider updates are sent at most 5 times per second, plus the final value on release.
  static const sliderInterval = Duration(milliseconds: 200);

  final _throttlers = <String, Throttler>{};

  @override
  FloorplanState build() {
    ref.onDispose(() {
      for (final throttler in _throttlers.values) {
        throttler.dispose();
      }
    });
    // A pending position is done as soon as the stored placement reports it.
    ref.listen(placementServiceProvider, (_, next) {
      final stored = {
        for (final placement in next.value ?? const <Placement>[]) placement.deviceId: placement.position,
      };
      final pending = {...state.pendingPositions}..removeWhere((id, position) => stored[id] == position);
      if (pending.length != state.pendingPositions.length) state = state.copyWith(pendingPositions: pending);
    });
    return const FloorplanState();
  }

  void toggleLayer(PlanLayer layer) {
    final layers = {...state.layers};
    if (!layers.remove(layer)) layers.add(layer);
    state = state.copyWith(layers: layers);
  }

  /// Selects the room, or clears the selection when it is already selected. Also closes an open group.
  void tapRoom(String roomId) {
    state = state.copyWith(
      selection: state.selection == PlanSelection.room(roomId)
          ? const PlanSelection.none()
          : PlanSelection.room(roomId),
      openGroupKey: null,
    );
  }

  void tapDevice(String deviceId) => state = state.copyWith(selection: PlanSelection.device(deviceId));

  void clearSelection() => state = state.copyWith(selection: const PlanSelection.none(), openGroupKey: null);

  /// Fans out the group with [key] around its center.
  void openGroup(String key) => state = state.copyWith(openGroupKey: key);

  void closeGroup() => state = state.copyWith(openGroupKey: null);

  // Dragging

  void startDrag(PlanDevice device) {
    state = state.copyWith(
      drag: PlanDrag(deviceId: device.id, kind: device.kind, position: device.position),
    );
  }

  /// [position] is `null` while a device from the tray is outside of the plan.
  void updateDrag(PlanPoint? position) {
    final drag = state.drag;
    if (drag == null) return;
    final clamped = position == null ? null : _clampToPlan(position);
    final targetId = clamped == null
        ? null
        : GroupingUtil.dropTarget(drag.deviceId, clamped, _visiblePositions(except: drag.deviceId));
    state = state.copyWith(
      drag: drag.copyWith(position: clamped, targetId: targetId),
    );
  }

  /// Drops the device: onto the drop target if there is one, otherwise where it is. Outside of the plan nothing
  /// changes.
  Future<void> endDrag() async {
    final drag = state.drag;
    state = state.copyWith(drag: null);
    final position = drag?.position;
    if (drag == null || position == null) return;

    final target = drag.targetId == null ? null : _visiblePositions(except: drag.deviceId)[drag.targetId];
    final dropped = _clampToPlan(target == null ? position : GroupingUtil.dropPosition(target));
    state = state.copyWith(pendingPositions: {...state.pendingPositions, drag.deviceId: dropped});
    try {
      await ref.read(placementServiceProvider.notifier).place(drag.deviceId, drag.kind, dropped);
    } on Object catch (e) {
      _log.warning('Could not place ${drag.deviceId}: $e');
      if (ref.mounted) state = state.copyWith(pendingPositions: {...state.pendingPositions}..remove(drag.deviceId));
    }
  }

  void cancelDrag() => state = state.copyWith(drag: null);

  /// Positions of placed devices on visible layers, including just dropped ones.
  Map<String, PlanPoint> _visiblePositions({String? except}) {
    return {
      for (final placement in ref.read(placementServiceProvider).value ?? const <Placement>[])
        if (placement.deviceId != except && isLayerVisible(placement.kind, state.layers))
          placement.deviceId: state.pendingPositions[placement.deviceId] ?? placement.position,
    };
  }

  PlanPoint _clampToPlan(PlanPoint point) {
    final plan = ref.read(floorPlanServiceProvider).value;
    return plan == null ? point : PlanGeometryUtil.clampInside(point, PlanGeometryUtil.bounds(plan));
  }

  /// Moves the device back to the "not placed" tray.
  Future<void> removeDevice(String deviceId) async {
    await ref.read(placementServiceProvider.notifier).remove(deviceId);
    if (ref.mounted && state.selection == PlanSelection.device(deviceId)) clearSelection();
  }

  // Device commands. Failures are logged; the plan keeps showing the state the devices report.

  void setLightsOn(List<String> ids, {required bool on}) {
    _run('switch lights', ref.read(lightsServiceProvider.notifier).setOn(ids, on: on));
  }

  void changeBrightness(String id, int percent) => _throttler('brightness:$id')(() => _setBrightness(id, percent));

  void endBrightness(String id, int percent) => _throttler('brightness:$id').flush(() => _setBrightness(id, percent));

  void changeKelvin(String id, int kelvin) => _throttler('kelvin:$id')(() => _setKelvin(id, kelvin));

  void endKelvin(String id, int kelvin) => _throttler('kelvin:$id').flush(() => _setKelvin(id, kelvin));

  void setLightColor(String id, RgbColor color) {
    _run('set color', ref.read(lightsServiceProvider.notifier).setColor(id, color));
  }

  void playPause(String id) => _run('play/pause', ref.read(speakersServiceProvider.notifier).playPause(id));

  void changeVolume(String id, int percent) => _throttler('volume:$id')(() => _setVolume(id, percent));

  void endVolume(String id, int percent) => _throttler('volume:$id').flush(() => _setVolume(id, percent));

  void toggleGroup(SpeakerState speaker) {
    final service = ref.read(speakersServiceProvider.notifier);
    _run('change group', speaker.isGrouped ? service.leaveGroup(speaker.id) : service.joinPlayingGroup(speaker.id));
  }

  void waterPlants(List<String> ids) => _run('water plants', ref.read(plantsServiceProvider.notifier).water(ids));

  void undoWatering(String id) => _run('undo watering', ref.read(plantsServiceProvider.notifier).undoWatering(id));

  void _setBrightness(String id, int percent) {
    _run('set brightness', ref.read(lightsServiceProvider.notifier).setBrightness(id, percent));
  }

  void _setKelvin(String id, int kelvin) {
    _run('set color temperature', ref.read(lightsServiceProvider.notifier).setKelvin(id, kelvin));
  }

  void _setVolume(String id, int percent) {
    _run('set volume', ref.read(speakersServiceProvider.notifier).setVolume(id, percent));
  }

  Throttler _throttler(String key) => _throttlers.putIfAbsent(key, () => Throttler(sliderInterval));

  void _run(String action, Future<void> command) {
    unawaited(command.catchError((Object e) => _log.warning('Could not $action: $e')));
  }
}

bool isLayerVisible(DeviceKind kind, Set<PlanLayer> layers) {
  return layers.contains(switch (kind) {
    DeviceKind.light => PlanLayer.lights,
    DeviceKind.speaker => PlanLayer.speakers,
    DeviceKind.plant => PlanLayer.plants,
  });
}

/// Every device the hub knows, joined with its placement (or the position it was just dropped at).
@riverpod
List<PlanDevice> planDevices(Ref ref) {
  final today = ref.watch(currentDayProvider).value ?? clock.now();
  final positions = {
    for (final placement in ref.watch(placementServiceProvider).value ?? const <Placement>[])
      placement.deviceId: placement.position,
    ...ref.watch(floorplanControllerProvider.select((s) => s.pendingPositions)),
  };
  return [
    for (final light in ref.watch(lightsServiceProvider).value ?? const <LightState>[])
      PlanLight(light, position: positions[light.id]),
    for (final speaker in ref.watch(speakersServiceProvider).value ?? const <SpeakerState>[])
      PlanSpeaker(speaker, position: positions[speaker.id]),
    for (final plant in ref.watch(plantsServiceProvider).value ?? const <Plant>[])
      PlanPlant(
        plant,
        state: WateringDueUtil.stateOf(plant, today),
        dueInDays: WateringDueUtil.dueInDays(plant, today),
        position: positions[plant.id],
      ),
  ];
}

/// Groups of visible placed devices that stand close together. The dragged device never belongs to a group.
@riverpod
List<List<String>> planGroups(Ref ref) {
  final layers = ref.watch(floorplanControllerProvider.select((s) => s.layers));
  final draggedId = ref.watch(floorplanControllerProvider.select((s) => s.drag?.deviceId));
  return GroupingUtil.groups({
    for (final device in ref.watch(planDevicesProvider))
      if (device.id != draggedId && isLayerVisible(device.kind, layers)) device.id: ?device.position,
  });
}
