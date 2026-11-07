import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smart_hub/domain/floorplan/model/floor_plan.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';

part 'floorplan_editor.state.freezed.dart';

enum EditorTool { select, room, rectangle, door, window }

@freezed
sealed class EditorSelection with _$EditorSelection {
  const factory EditorSelection.room(String roomId) = EditorRoomSelection;

  /// A door, opening or window.
  const factory EditorSelection.opening(String openingId) = EditorOpeningSelection;
}

@freezed
abstract class FloorplanEditorState with _$FloorplanEditorState {
  const factory FloorplanEditorState({
    required FloorPlan plan,
    @Default(EditorTool.select) EditorTool tool,
    EditorSelection? selection,

    /// Corners of the room being drawn with [EditorTool.room].
    @Default([]) List<PlanPoint> draft,

    /// Rectangle being dragged with [EditorTool.rectangle].
    List<PlanPoint>? rectangle,

    /// Lines through corners the dragged point is aligned with.
    double? guideX,
    double? guideY,

    /// Earlier plans for undo (oldest first) and undone plans for redo (next first).
    @Default([]) List<FloorPlan> past,
    @Default([]) List<FloorPlan> future,
  }) = _FloorplanEditorState;

  const FloorplanEditorState._();

  Room? get selectedRoom => switch (selection) {
    EditorRoomSelection(:final roomId) => plan.rooms.where((room) => room.id == roomId).firstOrNull,
    _ => null,
  };

  Door? get selectedOpening => switch (selection) {
    EditorOpeningSelection(:final openingId) => plan.doors.where((door) => door.id == openingId).firstOrNull,
    _ => null,
  };
}
