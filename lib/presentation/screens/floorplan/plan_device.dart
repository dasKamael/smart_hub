import 'package:smart_hub/domain/floorplan/model/device_kind.enum.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/domain/lights/model/light_state.dart';
import 'package:smart_hub/domain/music/model/speaker_state.dart';
import 'package:smart_hub/domain/plants/model/plant.dart';
import 'package:smart_hub/domain/plants/model/watering_state.enum.dart';

/// A device as the floor plan shows it: live state joined with its placement.
sealed class PlanDevice {
  const PlanDevice({this.position});

  /// `null` while the device is in the "not placed" tray.
  final PlanPoint? position;

  String get id;

  String get name;

  DeviceKind get kind;

  bool get isPlaced => position != null;

  /// The same device shown at [position], e.g. while it is dragged.
  PlanDevice withPosition(PlanPoint? position);
}

final class PlanLight extends PlanDevice {
  const PlanLight(this.light, {super.position});

  final LightState light;

  @override
  String get id => light.id;

  @override
  String get name => light.name;

  @override
  DeviceKind get kind => DeviceKind.light;

  @override
  PlanLight withPosition(PlanPoint? position) => PlanLight(light, position: position);
}

final class PlanSpeaker extends PlanDevice {
  const PlanSpeaker(this.speaker, {super.position});

  final SpeakerState speaker;

  @override
  String get id => speaker.id;

  @override
  String get name => speaker.name;

  @override
  DeviceKind get kind => DeviceKind.speaker;

  @override
  PlanSpeaker withPosition(PlanPoint? position) => PlanSpeaker(speaker, position: position);
}

final class PlanPlant extends PlanDevice {
  const PlanPlant(this.plant, {required this.state, required this.dueInDays, super.position});

  final Plant plant;
  final WateringState state;

  /// Days until the next watering; negative when overdue.
  final int dueInDays;

  @override
  String get id => plant.id;

  @override
  String get name => plant.name;

  @override
  DeviceKind get kind => DeviceKind.plant;

  @override
  PlanPlant withPosition(PlanPoint? position) {
    return PlanPlant(plant, state: state, dueInDays: dueInDays, position: position);
  }
}
