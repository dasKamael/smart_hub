import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smart_hub/domain/floorplan/model/door_type.enum.dart';
import 'package:smart_hub/domain/floorplan/model/furniture_kind.enum.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/domain/floorplan/model/room_type.enum.dart';

part 'home_layout.freezed.dart';

/// The apartment as it is drawn: walls between junctions, openings hanging on walls, named rooms and furniture.
/// All lengths in centimeters.
///
/// Rooms are not stored as outlines: a room is a closed area of walls, found by the point [LayoutRoom.anchor]
/// inside it. The floor plan the rest of the app works with (`FloorPlan`) is derived from this.
@freezed
abstract class HomeLayout with _$HomeLayout {
  const factory HomeLayout({
    @Default([]) List<LayoutNode> nodes,
    @Default([]) List<LayoutWall> walls,
    @Default([]) List<LayoutOpening> openings,
    @Default([]) List<LayoutRoom> rooms,
    @Default([]) List<Furniture> furniture,
  }) = _HomeLayout;
}

/// A point where walls meet or end.
@freezed
abstract class LayoutNode with _$LayoutNode {
  const factory LayoutNode({required String id, required PlanPoint position}) = _LayoutNode;
}

/// A straight wall between two junctions. Its line is the middle of the wall; [thickness] spreads to both sides.
@freezed
abstract class LayoutWall with _$LayoutWall {
  const factory LayoutWall({
    required String id,
    required String from,
    required String to,
    @Default(LayoutWall.innerThickness) double thickness,
  }) = _LayoutWall;

  const LayoutWall._();

  static const innerThickness = 10.0;
  static const outerThickness = 24.0;
}

/// A door, opening or window in a wall: its middle lies [offset] from the wall's first junction.
@freezed
abstract class LayoutOpening with _$LayoutOpening {
  const factory LayoutOpening({
    required String id,
    required String wallId,
    required DoorType type,
    required double offset,
    required double width,

    /// Door swing, 0–3: which side the hinge is on and to which side of the wall the door opens.
    @Default(0) int swing,
  }) = _LayoutOpening;
}

/// Name and use of the room around [anchor].
@freezed
abstract class LayoutRoom with _$LayoutRoom {
  const factory LayoutRoom({
    required String id,
    required String name,
    @Default(RoomType.other) RoomType type,
    required PlanPoint anchor,
  }) = _LayoutRoom;
}

/// A piece of furniture: [position] is its middle, [rotation] in degrees clockwise (0: its back faces up / north).
@freezed
abstract class Furniture with _$Furniture {
  const factory Furniture({
    required String id,
    required FurnitureKind kind,
    required PlanPoint position,
    @Default(0) double rotation,
    required double width,
    required double depth,
  }) = _Furniture;
}
