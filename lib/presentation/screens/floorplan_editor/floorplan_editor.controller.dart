import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/domain/floorplan/editing/plan_editing.util.dart';
import 'package:smart_hub/domain/floorplan/floorplan.service.dart';
import 'package:smart_hub/domain/floorplan/model/door_type.enum.dart';
import 'package:smart_hub/domain/floorplan/model/floor_plan.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/domain/floorplan/plan_geometry.util.dart';
import 'package:smart_hub/domain/floorplan/room_lookup.util.dart';
import 'package:smart_hub/presentation/screens/floorplan_editor/floorplan_editor.state.dart';

part 'floorplan_editor.controller.g.dart';

/// The floor plan editor: tools, selection, drawing and dragging, undo / redo. Every change is saved at once.
///
/// Positions come in plan centimeters. [cmPerPx] tells how many centimeters one pixel is at the current zoom, so
/// touch radii stay the same on screen.
@riverpod
class FloorplanEditorController extends _$FloorplanEditorController {
  static final _log = Logger('FloorplanEditorController');

  static const historyLimit = 50;

  // Touch radii in pixels.
  static const snapPx = 14.0;
  static const handlePx = 22.0;
  static const closePx = 22.0;
  static const wallPx = 24.0;

  _Drag? _drag;

  /// Room whose name is being typed; the typing counts as one step for undo.
  String? _renamingRoomId;

  @override
  FloorplanEditorState build() => FloorplanEditorState(plan: ref.read(floorPlanServiceProvider).requireValue);

  void selectTool(EditorTool tool) {
    _renamingRoomId = null;
    state = state.copyWith(
      tool: tool,
      draft: const [],
      rectangle: null,
      guideX: null,
      guideY: null,
      selection: tool == EditorTool.select ? state.selection : null,
    );
  }

  void select(EditorSelection? selection) {
    _renamingRoomId = null;
    state = state.copyWith(selection: selection, tool: EditorTool.select, draft: const []);
  }

  void tap(PlanPoint point, {required double cmPerPx}) {
    switch (state.tool) {
      case EditorTool.select:
        if (state.selectedRoom case final room?) {
          if (PlanEditingUtil.edgeMiddleAt(room.polygon, point, radius: handlePx * cmPerPx) case final edge?) {
            final middle = PlanEditingUtil.edgeMiddle(room.polygon, edge);
            final polygon = PlanEditingUtil.insertCorner(room.polygon, edge, middle);
            return _commit(PlanEditingUtil.withRoomPolygon(state.plan, room.id, polygon));
          }
        }
        final opening = PlanEditingUtil.openingAt(state.plan.doors, point, radius: handlePx * cmPerPx);
        final room = RoomLookupUtil.roomAt(state.plan, point);
        select(switch ((opening, room)) {
          (final opening?, _) => EditorSelection.opening(opening.id),
          (_, final room?) => EditorSelection.room(room.id),
          _ => null,
        });
      case EditorTool.room:
        if (PlanEditingUtil.closesDraft(state.draft, point, radius: closePx * cmPerPx)) return finishDraft();
        final corners = [...PlanEditingUtil.cornersOf(state.plan), ...state.draft];
        final snapped = PlanEditingUtil.snap(point, corners, radius: snapPx * cmPerPx).point;
        // A corner twice in a row would give a wall of no length.
        if (state.draft.lastOrNull == snapped) return;
        state = state.copyWith(draft: [...state.draft, snapped]);
      case EditorTool.rectangle:
        break;
      case EditorTool.door:
        _placeOpening(point, DoorType.door, cmPerPx);
      case EditorTool.window:
        _placeOpening(point, DoorType.window, cmPerPx);
    }
  }

  /// Removes the corner of the selected room under [point].
  void longPress(PlanPoint point, {required double cmPerPx}) {
    final room = state.selectedRoom;
    if (state.tool != EditorTool.select || room == null) return;
    final index = PlanEditingUtil.cornerAt(room.polygon, point, radius: handlePx * cmPerPx);
    final polygon = index == null ? null : PlanEditingUtil.removeCorner(room.polygon, index);
    if (polygon != null) _commit(PlanEditingUtil.withRoomPolygon(state.plan, room.id, polygon));
  }

  /// Starts dragging whatever is under [point]. Returns `false` when there is nothing to drag, so the view pans.
  bool startDrag(PlanPoint point, {required double cmPerPx}) {
    _renamingRoomId = null;
    final radius = handlePx * cmPerPx;
    if (state.tool == EditorTool.rectangle) {
      final start = _snap(point, cmPerPx);
      _drag = _RectangleDrag(start.point);
      return true;
    }
    if (state.tool != EditorTool.select) return false;

    if (state.selectedRoom case final room?) {
      if (PlanEditingUtil.cornerAt(room.polygon, point, radius: radius) case final index?) {
        _drag = _CornerDrag(state.plan, room.id, index);
        return true;
      }
      if (PlanEditingUtil.edgeMiddleAt(room.polygon, point, radius: radius) case final edge?) {
        _drag = _WallDrag(state.plan, room.id, edge, point);
        return true;
      }
    }
    if (state.selectedOpening case final opening?) {
      if (PlanEditingUtil.openingAt([opening], point, radius: radius) != null) {
        _drag = _OpeningDrag(state.plan, opening.id);
        return true;
      }
    }
    if (RoomLookupUtil.roomAt(state.plan, point) case final room?) {
      select(EditorSelection.room(room.id));
      _drag = _RoomDrag(state.plan, room.id, point);
      return true;
    }
    return false;
  }

  void updateDrag(PlanPoint point, {required double cmPerPx}) {
    switch (_drag) {
      case null:
        return;
      case final _RectangleDrag drag:
        final end = _snap(point, cmPerPx);
        state = state.copyWith(rectangle: [drag.start, end.point], guideX: end.guideX, guideY: end.guideY);
      // Drags are computed from the plan before the drag, so openings put back onto a wall do not drift.
      case final _CornerDrag drag:
        final room = drag.before.rooms.where((room) => room.id == drag.roomId).firstOrNull;
        if (room == null) return;
        final corners = PlanEditingUtil.cornersOf(drag.before, exceptRoomId: drag.roomId, exceptIndex: drag.index);
        final snapped = PlanEditingUtil.snap(point, corners, radius: snapPx * cmPerPx);
        final polygon = PlanEditingUtil.moveCorner(room.polygon, drag.index, snapped.point);
        _change(drag, PlanEditingUtil.withRoomPolygon(drag.before, drag.roomId, polygon));
        state = state.copyWith(guideX: snapped.guideX, guideY: snapped.guideY);
      case final _WallDrag drag:
        final room = drag.before.rooms.where((room) => room.id == drag.roomId).firstOrNull;
        if (room == null) return;
        final p = room.polygon[drag.index];
        final q = room.polygon[(drag.index + 1) % room.polygon.length];
        // The wall snaps with its first corner; corners moving along with it do not count.
        final corners = PlanEditingUtil.cornersOf(drag.before).where((corner) => corner != p && corner != q);
        final snapped = PlanEditingUtil.snap(p + (point - drag.start), corners, radius: snapPx * cmPerPx);
        _change(drag, PlanEditingUtil.moveWall(drag.before, drag.roomId, drag.index, snapped.point - p));
        state = state.copyWith(guideX: snapped.guideX, guideY: snapped.guideY);
      case final _RoomDrag drag:
        final delta = PlanEditingUtil.gridDelta(drag.start, point);
        if (delta == PlanPoint.zero && !drag.moved) return;
        _change(drag, PlanEditingUtil.moveRoom(drag.before, drag.roomId, delta));
      case final _OpeningDrag drag:
        final opening = drag.before.doors.where((door) => door.id == drag.openingId).firstOrNull;
        if (opening == null) return;
        _change(drag, _withOpening(PlanEditingUtil.slideOpening(drag.before, opening, point)));
    }
  }

  void endDrag() {
    final drag = _drag;
    _drag = null;
    if (drag is _RectangleDrag) {
      final [from, to] = state.rectangle ?? [drag.start, drag.start];
      state = state.copyWith(rectangle: null, guideX: null, guideY: null);
      if (PlanEditingUtil.rectangle(from, to) case final polygon?) _addRoom(polygon);
      return;
    }
    state = state.copyWith(guideX: null, guideY: null);
    if (drag is _EditDrag && drag.moved) _save();
  }

  /// Ends a drag that was interrupted, e.g. by a second finger: a rectangle being dragged is dropped, other changes
  /// are kept.
  void cancelDrag() {
    if (_drag is _RectangleDrag) {
      _drag = null;
      state = state.copyWith(rectangle: null, guideX: null, guideY: null);
      return;
    }
    endDrag();
  }

  /// Turns the drawn corners into a room.
  void finishDraft() {
    if (state.draft.length < 3 || PlanGeometryUtil.areaInSquareMeters(state.draft) == 0) return;
    _addRoom(state.draft);
  }

  void removeLastDraftCorner() {
    if (state.draft.isEmpty) return;
    state = state.copyWith(draft: state.draft.sublist(0, state.draft.length - 1));
  }

  void renameRoom(String name) {
    final room = state.selectedRoom;
    if (room == null) return;
    final plan = state.plan.copyWith(
      rooms: [for (final r in state.plan.rooms) r.id == room.id ? r.copyWith(name: name) : r],
    );
    if (_renamingRoomId == room.id) {
      state = state.copyWith(plan: plan);
      _save();
    } else {
      _commit(plan);
      _renamingRoomId = room.id;
    }
  }

  void setOpeningType(DoorType type) {
    final opening = state.selectedOpening;
    if (opening == null || opening.type == type) return;
    _commit(_withOpening(opening.copyWith(type: type)));
  }

  void setOpeningWidth(double width) {
    final opening = state.selectedOpening;
    if (opening == null) return;
    _commit(_withOpening(PlanEditingUtil.resizeOpening(state.plan, opening, width)));
  }

  void deleteSelection() {
    final plan = switch (state.selection) {
      EditorRoomSelection(:final roomId) => PlanEditingUtil.deleteRoom(state.plan, roomId),
      EditorOpeningSelection(:final openingId) => state.plan.copyWith(
        doors: [
          for (final door in state.plan.doors)
            if (door.id != openingId) door,
        ],
      ),
      null => null,
    };
    if (plan == null) return;
    _commit(plan);
    state = state.copyWith(selection: null);
  }

  void undo() {
    if (state.past.isEmpty) return;
    _renamingRoomId = null;
    state = state.copyWith(
      plan: state.past.last,
      past: state.past.sublist(0, state.past.length - 1),
      future: [state.plan, ...state.future],
      selection: null,
    );
    _save();
  }

  void redo() {
    if (state.future.isEmpty) return;
    _renamingRoomId = null;
    state = state.copyWith(
      plan: state.future.first,
      past: [...state.past, state.plan],
      future: state.future.sublist(1),
      selection: null,
    );
    _save();
  }

  /// The plan as editor JSON, e.g. to keep a copy.
  String exportJson() => ref.read(floorPlanServiceProvider.notifier).encode(state.plan);

  void _placeOpening(PlanPoint point, DoorType type, double cmPerPx) {
    final wall = PlanEditingUtil.wallAt(state.plan, point, radius: wallPx * cmPerPx);
    if (wall == null) return;
    final id = PlanEditingUtil.nextId('${type.name}-', state.plan.doors.map((door) => door.id));
    final opening = PlanEditingUtil.placeOpening(wall, id: id, type: type, width: PlanEditingUtil.defaultWidth(type));
    _commit(state.plan.copyWith(doors: [...state.plan.doors, opening]));
    state = state.copyWith(selection: EditorSelection.opening(id), tool: EditorTool.select);
  }

  void _addRoom(List<PlanPoint> polygon) {
    final id = PlanEditingUtil.nextId('room-', state.plan.rooms.map((room) => room.id));
    final room = Room(id: id, name: 'Room ${state.plan.rooms.length + 1}', polygon: polygon);
    _commit(state.plan.copyWith(rooms: [...state.plan.rooms, room]));
    state = state.copyWith(selection: EditorSelection.room(id), tool: EditorTool.select, draft: const []);
  }

  SnapResult _snap(PlanPoint point, double cmPerPx) =>
      PlanEditingUtil.snap(point, PlanEditingUtil.cornersOf(state.plan), radius: snapPx * cmPerPx);

  /// A drag step: the plan before the drag becomes one undo step on the first change.
  void _change(_EditDrag drag, FloorPlan plan) {
    if (!drag.moved) {
      drag.moved = true;
      state = state.copyWith(past: _pastWith(drag.before), future: const []);
    }
    state = state.copyWith(plan: plan);
  }

  /// [plan] becomes the current plan; the one before is one undo step.
  void _commit(FloorPlan plan, {bool save = true}) {
    _renamingRoomId = null;
    state = state.copyWith(plan: plan, past: _pastWith(state.plan), future: const []);
    if (save) _save();
  }

  List<FloorPlan> _pastWith(FloorPlan plan) {
    final past = [...state.past, plan];
    return past.length > historyLimit ? past.sublist(past.length - historyLimit) : past;
  }

  void _save() {
    ref.read(floorPlanServiceProvider.notifier).save(state.plan).catchError((Object error, StackTrace stack) {
      _log.warning('Saving the floor plan failed', error, stack);
    });
  }

  FloorPlan _withOpening(Door opening) =>
      state.plan.copyWith(doors: [for (final door in state.plan.doors) door.id == opening.id ? opening : door]);
}

sealed class _Drag {}

/// A drag that changes the plan.
sealed class _EditDrag extends _Drag {
  _EditDrag(this.before);

  /// The plan when the drag started.
  final FloorPlan before;

  /// Whether the drag changed the plan yet.
  var moved = false;
}

final class _CornerDrag extends _EditDrag {
  _CornerDrag(super.before, this.roomId, this.index);

  final String roomId;
  final int index;
}

final class _RoomDrag extends _EditDrag {
  _RoomDrag(super.before, this.roomId, this.start);

  final String roomId;
  final PlanPoint start;
}

final class _WallDrag extends _EditDrag {
  _WallDrag(super.before, this.roomId, this.index, this.start);

  final String roomId;

  /// The wall from this corner of the room to the next one.
  final int index;
  final PlanPoint start;
}

final class _OpeningDrag extends _EditDrag {
  _OpeningDrag(super.before, this.openingId);

  final String openingId;
}

final class _RectangleDrag extends _Drag {
  _RectangleDrag(this.start);

  final PlanPoint start;
}
