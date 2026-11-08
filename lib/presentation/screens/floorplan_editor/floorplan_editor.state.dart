import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smart_hub/domain/floorplan/model/furniture_kind.enum.dart';
import 'package:smart_hub/domain/floorplan/model/home_layout.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';

part 'floorplan_editor.state.freezed.dart';

/// Tools stay picked until another one is: several rooms, walls or doors in a row need no extra taps.
enum EditorTool { select, room, wall, door, window, opening, furniture }

@freezed
sealed class EditorSelection with _$EditorSelection {
  const factory EditorSelection.room(String roomId) = EditorRoomSelection;

  const factory EditorSelection.wall(String wallId) = EditorWallSelection;

  /// A door, opening or window.
  const factory EditorSelection.opening(String openingId) = EditorOpeningSelection;

  const factory EditorSelection.furniture(String furnitureId) = EditorFurnitureSelection;
}

@freezed
abstract class FloorplanEditorState with _$FloorplanEditorState {
  const factory FloorplanEditorState({
    required HomeLayout layout,
    @Default(EditorTool.select) EditorTool tool,

    /// What the furniture tool puts down.
    @Default(FurnitureKind.bed) FurnitureKind furnitureKind,
    EditorSelection? selection,

    /// Corners of the walls being drawn with [EditorTool.wall]; the last one is where the next wall starts.
    @Default([]) List<PlanPoint> chain,

    /// Rectangle being dragged with [EditorTool.room], two opposite corners.
    List<PlanPoint>? rectangle,

    /// Opening being dragged along a wall, from where the finger went down to where it is.
    List<PlanPoint>? openingDraft,

    /// Lines through junctions the dragged point is aligned with.
    double? guideX,
    double? guideY,

    /// Shows the apartment in 3D instead of the plan to edit.
    @Default(false) bool preview,

    /// Earlier layouts for undo (oldest first) and undone layouts for redo (next first).
    @Default([]) List<HomeLayout> past,
    @Default([]) List<HomeLayout> future,
  }) = _FloorplanEditorState;

  const FloorplanEditorState._();

  LayoutRoom? get selectedRoom => switch (selection) {
    EditorRoomSelection(:final roomId) => layout.rooms.where((room) => room.id == roomId).firstOrNull,
    _ => null,
  };

  LayoutWall? get selectedWall => switch (selection) {
    EditorWallSelection(:final wallId) => layout.walls.where((wall) => wall.id == wallId).firstOrNull,
    _ => null,
  };

  LayoutOpening? get selectedOpening => switch (selection) {
    EditorOpeningSelection(:final openingId) => layout.openings.where((opening) => opening.id == openingId).firstOrNull,
    _ => null,
  };

  Furniture? get selectedFurniture => switch (selection) {
    EditorFurnitureSelection(:final furnitureId) =>
      layout.furniture.where((item) => item.id == furnitureId).firstOrNull,
    _ => null,
  };
}
