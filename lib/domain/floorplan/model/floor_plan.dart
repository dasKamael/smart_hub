import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smart_hub/domain/floorplan/model/door_type.enum.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';

part 'floor_plan.freezed.dart';

/// The apartment: rooms, solid walls and doors / openings. All coordinates in centimeters.
@freezed
abstract class FloorPlan with _$FloorPlan {
  const factory FloorPlan({required List<Room> rooms, @Default([]) List<Wall> walls, @Default([]) List<Door> doors}) =
      _FloorPlan;
}

@freezed
abstract class Room with _$Room {
  const factory Room({required String id, required String name, required List<PlanPoint> polygon}) = _Room;
}

@freezed
abstract class Wall with _$Wall {
  const factory Wall({required String id, required List<PlanPoint> polygon}) = _Wall;
}

@freezed
abstract class Door with _$Door {
  const factory Door({required String id, required DoorType type, required PlanPoint a, required PlanPoint b}) = _Door;
}
