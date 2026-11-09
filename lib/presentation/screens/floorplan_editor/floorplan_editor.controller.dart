import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/domain/floorplan/editing/furniture_editing.util.dart';
import 'package:smart_hub/domain/floorplan/editing/layout_editing.util.dart';
import 'package:smart_hub/domain/floorplan/floorplan.service.dart';
import 'package:smart_hub/domain/floorplan/furnishing.util.dart';
import 'package:smart_hub/domain/floorplan/layout_graph.util.dart';
import 'package:smart_hub/domain/floorplan/layout_rooms.util.dart';
import 'package:smart_hub/domain/floorplan/model/door_type.enum.dart';
import 'package:smart_hub/domain/floorplan/model/furniture_kind.enum.dart';
import 'package:smart_hub/domain/floorplan/model/home_layout.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/domain/floorplan/model/room_type.enum.dart';
import 'package:smart_hub/domain/floorplan/plan_geometry.util.dart';
import 'package:smart_hub/presentation/screens/floorplan_editor/floorplan_editor.state.dart';

part 'floorplan_editor.controller.g.dart';

/// The floor plan editor. Built for few steps: tools stay picked, a room is one drag outside the rooms (no tool
/// needed), a wall across a room two taps, a door one tap, a room's type one tap, its furniture one tap. Every change is saved at once and can be undone.
///
/// Positions come in plan centimeters; [cmPerPx] tells how many centimeters one pixel is at the current zoom, so touch
/// radii stay the same on screen.
@riverpod
class FloorplanEditorController extends _$FloorplanEditorController {
  static final _log = Logger('FloorplanEditorController');

  static const historyLimit = 50;

  // Touch radii in pixels.
  static const snapPx = 14.0;
  static const handlePx = 22.0;
  static const wallPx = 24.0;

  /// Junctions are grabbed only close to them; a bit further along, the wall itself is grabbed.
  static const nodePx = 12.0;

  /// Touch radius of a furniture handle from inside the piece.
  static const insideHandlePx = 10.0;

  /// How far the turn handle sits in front of a selected piece of furniture.
  static const turnPx = 30.0;

  _Drag? _drag;

  /// Room whose name is being typed; the typing counts as one step for undo.
  String? _renamingRoomId;

  @override
  FloorplanEditorState build() => FloorplanEditorState(layout: ref.read(homeLayoutServiceProvider).requireValue);

  HomeLayout get _layout => state.layout;

  void selectTool(EditorTool tool) {
    _renamingRoomId = null;
    state = state.copyWith(
      tool: tool,
      chain: const [],
      rectangle: null,
      openingDraft: null,
      guideX: null,
      guideY: null,
    );
  }

  /// Picks what the furniture tool puts down, and the furniture tool.
  void selectFurnitureKind(FurnitureKind kind) {
    selectTool(EditorTool.furniture);
    state = state.copyWith(furnitureKind: kind);
  }

  void togglePreview() => state = state.copyWith(preview: !state.preview);

  void select(EditorSelection? selection) {
    _renamingRoomId = null;
    state = state.copyWith(selection: selection);
  }

  void tap(PlanPoint point, {required double cmPerPx}) {
    final radius = handlePx * cmPerPx;
    // A tap on a handle of the selected piece keeps it selected.
    if (_furnitureHandleAt(point, cmPerPx) != null) return;
    switch (state.tool) {
      case EditorTool.select:
        select(_hit(point, radius));
      case EditorTool.room:
        select(_roomSelection(point));
      case EditorTool.wall:
        _chainTap(point, cmPerPx);
      case EditorTool.door:
        _openingTap(point, DoorType.door, cmPerPx);
      case EditorTool.window:
        _openingTap(point, DoorType.window, cmPerPx);
      case EditorTool.opening:
        _openingTap(point, DoorType.open, cmPerPx);
      case EditorTool.furniture:
        if (LayoutEditingUtil.furnitureAt(_layout, point) case final item?) {
          return select(EditorSelection.furniture(item.id));
        }
        if (LayoutEditingUtil.roomAt(_layout, point) == null) return;
        final id = LayoutGraphUtil.nextId('f', _layout.furniture.map((item) => item.id));
        final item = FurnishingUtil.keepInside(
          _layout,
          FurnishingUtil.place(_layout, state.furnitureKind, point, id: id),
        );
        _commit(_layout.copyWith(furniture: [..._layout.furniture, item]), select: EditorSelection.furniture(id));
    }
  }

  /// Puts a piece of [kind] dragged out of the palette where it was dropped, as it comes (not turned), against a
  /// wall only when dropped right at it. Outside the rooms nothing is placed.
  void dropFurniture(FurnitureKind kind, PlanPoint point, {required double cmPerPx}) {
    if (LayoutEditingUtil.roomAt(_layout, point) == null) return;
    selectFurnitureKind(kind);
    final id = LayoutGraphUtil.nextId('f', _layout.furniture.map((item) => item.id));
    final item = Furniture(
      id: id,
      kind: kind,
      position: PlanPoint(point.x.roundToDouble(), point.y.roundToDouble()),
      width: kind.width,
      depth: kind.depth,
    );
    final placed = FurnishingUtil.keepInside(_layout, FurnishingUtil.touchWall(_layout, item, reach: snapPx * cmPerPx));
    _commit(_layout.copyWith(furniture: [..._layout.furniture, placed]), select: EditorSelection.furniture(id));
  }

  /// Turns the piece of furniture under [point] by a quarter.
  void longPress(PlanPoint point, {required double cmPerPx}) {
    if (LayoutEditingUtil.furnitureAt(_layout, point) case final item?) {
      select(EditorSelection.furniture(item.id));
      rotateFurniture();
    }
  }

  /// Starts dragging whatever is under [point]. Returns `false` when there is nothing to drag, so the view pans.
  bool startDrag(PlanPoint point, {required double cmPerPx}) {
    _renamingRoomId = null;
    final radius = handlePx * cmPerPx;
    if (_furnitureHandleAt(point, cmPerPx) case (final item, final handle)) {
      _drag = _FurnitureHandleDrag(_layout, item.id, handle);
      return true;
    }
    switch (state.tool) {
      case EditorTool.room:
        _drag = _RectangleDrag(_snap(point, cmPerPx).point);
        return true;
      case EditorTool.door || EditorTool.window || EditorTool.opening:
        final wall = LayoutGraphUtil.wallAt(_layout, point, radius: wallPx * cmPerPx);
        if (wall == null) return false;
        _drag = _OpeningDraft(wall.id, point, snap: handlePx * cmPerPx);
        return true;
      case EditorTool.furniture:
        final item = LayoutEditingUtil.furnitureAt(_layout, point);
        if (item == null) return false;
        select(EditorSelection.furniture(item.id));
        _drag = _FurnitureDrag(_layout, item.id, point);
        return true;
      case EditorTool.wall:
        return false;
      case EditorTool.select:
        break;
    }
    if (state.selectedOpening case final opening?) {
      if (LayoutEditingUtil.openingAt(_layout, point, radius: radius)?.id == opening.id) {
        _drag = _OpeningDrag(_layout, opening.id);
        return true;
      }
    }
    if (LayoutGraphUtil.nodeAt(_layout, point, radius: nodePx * cmPerPx) case final node?) {
      _drag = _NodeDrag(_layout, node.id);
      return true;
    }
    if (LayoutEditingUtil.furnitureAt(_layout, point) case final item?) {
      select(EditorSelection.furniture(item.id));
      _drag = _FurnitureDrag(_layout, item.id, point);
      return true;
    }
    if (LayoutGraphUtil.wallAt(_layout, point, radius: radius) case final wall?) {
      select(EditorSelection.wall(wall.id));
      _drag = _WallDrag(_layout, wall.id, point);
      return true;
    }
    // Outside of all rooms, a drag draws a new room; inside one, a stroke splits it – no tool to pick first. Two
    // fingers move the view.
    final room = LayoutEditingUtil.roomAt(_layout, point);
    _drag = room == null ? _RectangleDrag(_snap(point, cmPerPx).point) : _SplitDrag(room.id, point);
    return true;
  }

  void updateDrag(PlanPoint point, {required double cmPerPx}) {
    switch (_drag) {
      case null:
        return;
      case final _RectangleDrag drag:
        final end = _snap(point, cmPerPx);
        state = state.copyWith(rectangle: [drag.start, end.point], guideX: end.guideX, guideY: end.guideY);
      case final _OpeningDraft drag:
        state = state.copyWith(openingDraft: [drag.start, point]);
      case final _SplitDrag drag:
        final outline = LayoutRoomsUtil.outlineOf(_layout, drag.roomId);
        final line = outline == null ? null : LayoutEditingUtil.splitLine(outline, drag.start, point);
        state = state.copyWith(splitDraft: line == null ? null : [line.$1, line.$2]);
      case final _NodeDrag drag:
        final snapped = LayoutEditingUtil.snap(drag.before, point, radius: snapPx * cmPerPx, except: {drag.nodeId});
        _change(drag, LayoutGraphUtil.moveNode(drag.before, drag.nodeId, snapped.point));
        state = state.copyWith(guideX: snapped.guideX, guideY: snapped.guideY);
      case final _WallDrag drag:
        final wall = drag.before.walls.firstWhere((wall) => wall.id == drag.wallId);
        final (a, _) = LayoutGraphUtil.endsOf(drag.before, wall);
        final snapped = LayoutEditingUtil.snap(
          drag.before,
          a + (point - drag.start),
          radius: snapPx * cmPerPx,
          except: {wall.from, wall.to},
        );
        _change(drag, LayoutGraphUtil.moveWall(drag.before, drag.wallId, snapped.point - a));
        state = state.copyWith(guideX: snapped.guideX, guideY: snapped.guideY);
      case final _OpeningDrag drag:
        final opening = drag.before.openings.firstWhere((opening) => opening.id == drag.openingId);
        final wall = drag.before.walls.firstWhere((wall) => wall.id == opening.wallId);
        final (a, b) = LayoutGraphUtil.endsOf(drag.before, wall);
        final length = a.distanceTo(b);
        final moved = LayoutGraphUtil.placedAt(drag.before, opening, point);
        final step = LayoutEditingUtil.openingStep;
        final offset = ((moved.offset / step).round() * step).clamp(moved.width / 2, length - moved.width / 2);
        _change(drag, _withOpening(drag.before, moved.copyWith(offset: offset.toDouble())));
      case final _FurnitureDrag drag:
        final item = drag.before.furniture.firstWhere((item) => item.id == drag.furnitureId);
        final delta = point - drag.start;
        final moved = item.copyWith(
          position: PlanPoint((item.position.x + delta.x).roundToDouble(), (item.position.y + delta.y).roundToDouble()),
        );
        // Free: the piece stays under the finger as it is turned, with a magnet only right at the walls.
        final touching = FurnishingUtil.touchWall(drag.before, moved, reach: snapPx * cmPerPx);
        final placed = FurnishingUtil.keepInside(drag.before, touching);
        _change(drag, _withFurniture(drag.before, placed));
      case final _FurnitureHandleDrag drag:
        final item = drag.before.furniture.firstWhere((item) => item.id == drag.furnitureId);
        final resized = FurnitureEditingUtil.resized(item, drag.handle, point);
        _change(drag, _withFurniture(drag.before, FurnishingUtil.keepInside(drag.before, resized)));
    }
  }

  void endDrag() {
    final drag = _drag;
    _drag = null;
    switch (drag) {
      case _RectangleDrag(:final start):
        final [from, to] = state.rectangle ?? [start, start];
        state = state.copyWith(rectangle: null, guideX: null, guideY: null);
        if ((to.x - from.x).abs() < LayoutEditingUtil.minRoomSide ||
            (to.y - from.y).abs() < LayoutEditingUtil.minRoomSide) {
          return;
        }
        final center = PlanPoint((from.x + to.x) / 2, (from.y + to.y) / 2);
        _commit(LayoutGraphUtil.addRectangle(_layout, from, to));
        select(_roomSelection(center));
      case _OpeningDraft(:final wallId, :final start, :final snap):
        final end = state.openingDraft?.last ?? start;
        state = state.copyWith(openingDraft: null);
        final wall = _layout.walls.where((wall) => wall.id == wallId).firstOrNull;
        if (wall == null) return;
        final type = _openingTypeOf(state.tool);
        final id = LayoutGraphUtil.nextId('${type.name}-', _layout.openings.map((opening) => opening.id));
        final dragged = LayoutEditingUtil.openingBetween(
          _layout,
          wall,
          id: id,
          type: type,
          from: start,
          to: end,
          snap: snap,
        );
        final opening = dragged.width >= LayoutEditingUtil.minOpening
            ? dragged
            : LayoutEditingUtil.openingOn(_layout, wall, id: id, type: type, center: start);
        _commit(_layout.copyWith(openings: [..._layout.openings, opening]), select: EditorSelection.opening(id));
      case _SplitDrag():
        final line = state.splitDraft;
        state = state.copyWith(splitDraft: null);
        if (line == null) return;
        final roomsBefore = {for (final room in _layout.rooms) room.id};
        _commit(LayoutGraphUtil.addWall(_layout, line.first, line.last));
        final created = _layout.rooms.where((room) => !roomsBefore.contains(room.id)).firstOrNull;
        if (created != null) select(EditorSelection.room(created.id));
      case final _EditDrag drag:
        state = state.copyWith(guideX: null, guideY: null);
        if (drag.moved) _save();
      case null:
        state = state.copyWith(guideX: null, guideY: null);
    }
  }

  /// Ends a drag that was interrupted, e.g. by a second finger: drafts are dropped, other changes kept.
  void cancelDrag() {
    if (_drag is _RectangleDrag || _drag is _OpeningDraft || _drag is _SplitDrag) {
      _drag = null;
      state = state.copyWith(rectangle: null, openingDraft: null, splitDraft: null, guideX: null, guideY: null);
      return;
    }
    endDrag();
  }

  /// Stops drawing walls.
  void finishChain() => state = state.copyWith(chain: const []);

  /// Takes back the last wall drawn, or the starting point when no wall is drawn yet.
  void removeLastChainPoint() {
    if (state.chain.length > 1) return undo();
    finishChain();
  }

  // Rooms

  /// Sets the selected room's type and names it after it.
  void setRoomType(RoomType type) {
    final room = state.selectedRoom;
    if (room == null) return;
    final name = LayoutEditingUtil.nameFor(_layout, type, exceptRoomId: room.id);
    _commit(_withRoom(room.copyWith(type: type, name: name)));
  }

  void renameRoom(String name) {
    final room = state.selectedRoom;
    if (room == null) return;
    final layout = _withRoom(room.copyWith(name: name));
    if (_renamingRoomId == room.id) {
      state = state.copyWith(layout: layout);
      _save();
    } else {
      _commit(layout);
      _renamingRoomId = room.id;
    }
  }

  /// Fills the selected room with the furniture its type usually has, replacing what is in it.
  void furnishRoom() {
    final room = state.selectedRoom;
    if (room != null) _commit(FurnishingUtil.furnish(_layout, room.id));
  }

  /// Furnishes every room that has no furniture yet.
  void furnishAll() => _commit(FurnishingUtil.furnishAll(_layout));

  void deleteRoom() {
    final room = state.selectedRoom;
    if (room != null) _commit(LayoutEditingUtil.deleteRoom(_layout, room.id), deselect: true);
  }

  // Walls

  void setWallThickness(double thickness) {
    final wall = state.selectedWall;
    if (wall == null || wall.thickness == thickness) return;
    _commit(
      _layout.copyWith(walls: [for (final w in _layout.walls) w.id == wall.id ? w.copyWith(thickness: thickness) : w]),
    );
  }

  /// Takes the selected wall away but keeps the rooms on either side apart, e.g. a storage nook open to the hall. Its
  /// doors and windows go with it; deleting the opening that is left puts the wall back.
  void removeWall() {
    final wall = state.selectedWall;
    if (wall == null) return;
    final (a, b) = LayoutGraphUtil.endsOf(_layout, wall);
    final length = a.distanceTo(b);
    final id = LayoutGraphUtil.nextId('open-', _layout.openings.map((opening) => opening.id));
    _commit(
      _layout.copyWith(
        openings: [
          for (final opening in _layout.openings)
            if (opening.wallId != wall.id) opening,
          LayoutOpening(id: id, wallId: wall.id, type: DoorType.open, offset: length / 2, width: length),
        ],
      ),
      select: EditorSelection.opening(id),
    );
  }

  /// Removes the selected wall; the room it divided is one again and stays selected, ready for its type.
  void deleteWall() {
    final wall = state.selectedWall;
    if (wall == null) return;
    final (a, b) = LayoutGraphUtil.endsOf(_layout, wall);
    _commit(LayoutGraphUtil.removeWall(_layout, wall.id), deselect: true);
    select(_roomSelection(PlanPoint((a.x + b.x) / 2, (a.y + b.y) / 2)));
  }

  // Openings

  void setOpeningType(DoorType type) {
    final opening = state.selectedOpening;
    if (opening == null || opening.type == type) return;
    _commit(_withOpening(_layout, opening.copyWith(type: type)));
  }

  /// Sets the selected opening's width around its middle; `null` opens the whole wall.
  void setOpeningWidth(double? width) {
    final opening = state.selectedOpening;
    final wall = _layout.walls.where((wall) => wall.id == opening?.wallId).firstOrNull;
    if (opening == null || wall == null) return;
    final (a, b) = LayoutGraphUtil.endsOf(_layout, wall);
    final length = a.distanceTo(b);
    final w = (width ?? length).clamp(0.0, length);
    final offset = width == null ? length / 2 : opening.offset.clamp(w / 2, length - w / 2);
    _commit(_withOpening(_layout, opening.copyWith(width: w, offset: offset)));
  }

  /// Turns the selected door to the next of its four ways to swing.
  void flipOpening() {
    final opening = state.selectedOpening;
    if (opening != null) _commit(_withOpening(_layout, opening.copyWith(swing: (opening.swing + 1) % 4)));
  }

  void deleteOpening() {
    final opening = state.selectedOpening;
    if (opening == null) return;
    _commit(
      _layout.copyWith(
        openings: [
          for (final other in _layout.openings)
            if (other.id != opening.id) other,
        ],
      ),
      deselect: true,
    );
  }

  // Furniture

  void rotateFurniture() {
    final item = state.selectedFurniture;
    if (item != null) _commitFurniture(item.copyWith(rotation: (item.rotation + 90) % 360));
  }

  /// Sets the selected piece's size; its back stays against its wall.
  void setFurnitureSize({double? width, double? depth}) {
    final item = state.selectedFurniture;
    if (item != null) _commitFurniture(FurnitureEditingUtil.withSize(item, width: width, depth: depth));
  }

  /// Puts a copy of the selected piece beside it and selects the copy, so a row of chairs is a few taps.
  void duplicateFurniture() {
    final item = state.selectedFurniture;
    if (item == null) return;
    final id = LayoutGraphUtil.nextId('f', _layout.furniture.map((item) => item.id));
    final copy = FurnishingUtil.keepInside(
      _layout,
      FurnishingUtil.snapToWall(_layout, FurnitureEditingUtil.copyBeside(item, id: id)),
    );
    _commit(_layout.copyWith(furniture: [..._layout.furniture, copy]), select: EditorSelection.furniture(id));
  }

  /// [item] changed, moved back into its room where it reaches into a wall.
  void _commitFurniture(Furniture item) => _commit(_withFurniture(_layout, FurnishingUtil.keepInside(_layout, item)));

  void deleteFurniture() {
    final item = state.selectedFurniture;
    if (item == null) return;
    _commit(
      _layout.copyWith(
        furniture: [
          for (final other in _layout.furniture)
            if (other.id != item.id) other,
        ],
      ),
      deselect: true,
    );
  }

  // History

  void undo() {
    if (state.past.isEmpty) return;
    _dropDrag();
    _renamingRoomId = null;
    final previous = state.past.last;
    state = state.copyWith(
      layout: previous,
      past: state.past.sublist(0, state.past.length - 1),
      future: [_layout, ...state.future],
      chain: state.chain.length > 1 ? state.chain.sublist(0, state.chain.length - 1) : const [],
      selection: _stillThere(state.selection, previous),
    );
    _save();
  }

  void redo() {
    if (state.future.isEmpty) return;
    _dropDrag();
    _renamingRoomId = null;
    final next = state.future.first;
    state = state.copyWith(
      layout: next,
      past: [...state.past, _layout],
      future: state.future.sublist(1),
      chain: const [],
      selection: _stillThere(state.selection, next),
    );
    _save();
  }

  /// The layout as JSON, e.g. to keep a copy.
  String exportJson() => ref.read(homeLayoutServiceProvider.notifier).encode(_layout);

  // Internals

  static DoorType _openingTypeOf(EditorTool tool) => switch (tool) {
    EditorTool.window => DoorType.window,
    EditorTool.opening => DoorType.open,
    _ => DoorType.door,
  };

  /// A drag still going on when the history moves would write over it; it ends without its changes.
  void _dropDrag() {
    _drag = null;
    state = state.copyWith(rectangle: null, openingDraft: null, splitDraft: null, guideX: null, guideY: null);
  }

  /// The selected piece of furniture and its handle under [point], when the tool shows handles.
  (Furniture, FurnitureHandle)? _furnitureHandleAt(PlanPoint point, double cmPerPx) {
    final item = state.selectedFurniture;
    if (item == null || (state.tool != EditorTool.select && state.tool != EditorTool.furniture)) return null;
    // On a small piece the handles' touch areas would cover all of it: inside the piece a handle has to be hit
    // nearly exactly, so a drag there moves the piece.
    final inside = PlanGeometryUtil.containsPoint(FurnishingUtil.cornersOf(item), point);
    final handle = FurnitureEditingUtil.handleAt(
      item,
      point,
      radius: (inside ? insideHandlePx : handlePx) * cmPerPx,
      turnReach: turnPx * cmPerPx,
    );
    return handle == null ? null : (item, handle);
  }

  SnapResult _snap(PlanPoint point, double cmPerPx) => LayoutEditingUtil.snap(_layout, point, radius: snapPx * cmPerPx);

  EditorSelection? _roomSelection(PlanPoint point) {
    final room = LayoutEditingUtil.roomAt(_layout, point);
    return room == null ? null : EditorSelection.room(room.id);
  }

  /// What a tap at [point] selects: an opening, a piece of furniture, a wall or a room – in that order.
  EditorSelection? _hit(PlanPoint point, double radius) {
    if (LayoutEditingUtil.openingAt(_layout, point, radius: radius) case final opening?) {
      return EditorSelection.opening(opening.id);
    }
    if (LayoutEditingUtil.furnitureAt(_layout, point) case final item?) return EditorSelection.furniture(item.id);
    if (LayoutGraphUtil.wallAt(_layout, point, radius: radius * 0.6) case final wall?) {
      return EditorSelection.wall(wall.id);
    }
    return _roomSelection(point);
  }

  void _chainTap(PlanPoint point, double cmPerPx) {
    final chain = state.chain;
    final snapped = LayoutEditingUtil.snap(_layout, point, radius: snapPx * cmPerPx, drawn: chain);
    if (chain.isEmpty) {
      state = state.copyWith(chain: [snapped.point]);
      return;
    }
    if (snapped.point.distanceTo(chain.last) < 1) return;
    final roomsBefore = {for (final room in _layout.rooms) room.id};
    _commit(LayoutGraphUtil.addWall(_layout, chain.last, snapped.point));
    // A wall that ends on the drawing finishes the line, e.g. a wall across a room or the last wall of a room.
    final ended = snapped.onDrawing || chain.contains(snapped.point);
    state = state.copyWith(chain: ended ? const [] : [...chain, snapped.point]);
    final created = _layout.rooms.where((room) => !roomsBefore.contains(room.id)).firstOrNull;
    if (created != null) select(EditorSelection.room(created.id));
  }

  void _openingTap(PlanPoint point, DoorType type, double cmPerPx) {
    if (LayoutEditingUtil.openingAt(_layout, point, radius: handlePx * cmPerPx) case final opening?) {
      if (opening.type == DoorType.door && type == DoorType.door && state.selectedOpening?.id == opening.id) {
        return flipOpening();
      }
      return select(EditorSelection.opening(opening.id));
    }
    final wall = LayoutGraphUtil.wallAt(_layout, point, radius: wallPx * cmPerPx);
    if (wall == null) return;
    final id = LayoutGraphUtil.nextId('${type.name}-', _layout.openings.map((opening) => opening.id));
    final opening = LayoutEditingUtil.openingOn(_layout, wall, id: id, type: type, center: point);
    _commit(_layout.copyWith(openings: [..._layout.openings, opening]), select: EditorSelection.opening(id));
  }

  /// A drag step: the layout before the drag becomes one undo step on the first change.
  void _change(_EditDrag drag, HomeLayout layout) {
    if (!drag.moved) {
      drag.moved = true;
      state = state.copyWith(past: _pastWith(drag.before), future: const []);
    }
    final outlines = drag.outlines ??= LayoutRoomsUtil.outlines(drag.before);
    state = state.copyWith(layout: LayoutRoomsUtil.normalize(layout, previousOutlines: outlines));
  }

  /// [layout] becomes the current one, its rooms matched to the areas they had; the one before is one undo step.
  /// The selection becomes [select], or is cleared with [deselect], or stays when it still exists.
  void _commit(HomeLayout layout, {EditorSelection? select, bool deselect = false}) {
    _renamingRoomId = null;
    final normalized = LayoutRoomsUtil.normalize(layout, previousOutlines: LayoutRoomsUtil.outlines(_layout));
    // Nothing changed: no undo step that would undo nothing.
    if (normalized == _layout) {
      state = state.copyWith(selection: deselect ? null : select ?? state.selection);
      return;
    }
    state = state.copyWith(
      layout: normalized,
      past: _pastWith(_layout),
      future: const [],
      selection: deselect ? null : select ?? _stillThere(state.selection, normalized),
    );
    _save();
  }

  static EditorSelection? _stillThere(EditorSelection? selection, HomeLayout layout) => switch (selection) {
    EditorRoomSelection(:final roomId) when layout.rooms.any((room) => room.id == roomId) => selection,
    EditorWallSelection(:final wallId) when layout.walls.any((wall) => wall.id == wallId) => selection,
    EditorOpeningSelection(:final openingId) when layout.openings.any((o) => o.id == openingId) => selection,
    EditorFurnitureSelection(:final furnitureId) when layout.furniture.any((f) => f.id == furnitureId) => selection,
    _ => null,
  };

  List<HomeLayout> _pastWith(HomeLayout layout) {
    final past = [...state.past, layout];
    return past.length > historyLimit ? past.sublist(past.length - historyLimit) : past;
  }

  void _save() {
    ref.read(homeLayoutServiceProvider.notifier).save(_layout).catchError((Object error, StackTrace stack) {
      _log.warning('Saving the floor plan failed', error, stack);
    });
  }

  HomeLayout _withRoom(LayoutRoom room) =>
      _layout.copyWith(rooms: [for (final r in _layout.rooms) r.id == room.id ? room : r]);

  static HomeLayout _withOpening(HomeLayout layout, LayoutOpening opening) =>
      layout.copyWith(openings: [for (final o in layout.openings) o.id == opening.id ? opening : o]);

  static HomeLayout _withFurniture(HomeLayout layout, Furniture item) =>
      layout.copyWith(furniture: [for (final f in layout.furniture) f.id == item.id ? item : f]);
}

sealed class _Drag {}

final class _RectangleDrag extends _Drag {
  _RectangleDrag(this.start);

  final PlanPoint start;
}

final class _SplitDrag extends _Drag {
  _SplitDrag(this.roomId, this.start);

  final String roomId;
  final PlanPoint start;
}

final class _OpeningDraft extends _Drag {
  _OpeningDraft(this.wallId, this.start, {required this.snap});

  final String wallId;
  final PlanPoint start;

  /// Ends of the opening this close to an end of the wall go all the way to it (cm).
  final double snap;
}

/// A drag that changes the layout.
sealed class _EditDrag extends _Drag {
  _EditDrag(this.before);

  /// The layout when the drag started.
  final HomeLayout before;

  /// Outlines of the rooms before the drag, so rooms keep their areas while walls move.
  Map<String, List<PlanPoint>>? outlines;

  /// Whether the drag changed the layout yet.
  var moved = false;
}

final class _NodeDrag extends _EditDrag {
  _NodeDrag(super.before, this.nodeId);

  final String nodeId;
}

final class _WallDrag extends _EditDrag {
  _WallDrag(super.before, this.wallId, this.start);

  final String wallId;
  final PlanPoint start;
}

final class _OpeningDrag extends _EditDrag {
  _OpeningDrag(super.before, this.openingId);

  final String openingId;
}

final class _FurnitureDrag extends _EditDrag {
  _FurnitureDrag(super.before, this.furnitureId, this.start);

  final String furnitureId;
  final PlanPoint start;
}

final class _FurnitureHandleDrag extends _EditDrag {
  _FurnitureHandleDrag(super.before, this.furnitureId, this.handle);

  final String furnitureId;
  final FurnitureHandle handle;
}
