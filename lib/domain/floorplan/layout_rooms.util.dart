import 'dart:math' as math;

import 'package:smart_hub/domain/floorplan/layout_graph.util.dart';
import 'package:smart_hub/domain/floorplan/model/floor_plan.dart';
import 'package:smart_hub/domain/floorplan/model/home_layout.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/domain/floorplan/model/room_type.enum.dart';
import 'package:smart_hub/domain/floorplan/plan_geometry.util.dart';

/// The rooms of a [HomeLayout]: the closed areas its walls form, each named by the [LayoutRoom] whose anchor lies in
/// it. Also turns a layout into the [FloorPlan] the rest of the app shows.
abstract final class LayoutRoomsUtil {
  /// Outlines of all closed areas between walls, corners running clockwise on screen. Loose wall ends are ignored.
  static List<List<PlanPoint>> areas(HomeLayout layout) {
    final positions = {for (final node in layout.nodes) node.id: node.position};
    final neighbors = <String, Set<String>>{};
    for (final wall in layout.walls) {
      if (wall.from == wall.to) continue;
      neighbors.putIfAbsent(wall.from, () => {}).add(wall.to);
      neighbors.putIfAbsent(wall.to, () => {}).add(wall.from);
    }
    // Walls that end loose cannot enclose anything.
    var pruned = true;
    while (pruned) {
      pruned = false;
      for (final node in [...neighbors.keys]) {
        final around = neighbors[node]!;
        if (around.length > 1) continue;
        for (final other in around) {
          neighbors[other]?.remove(node);
        }
        neighbors.remove(node);
        pruned = true;
      }
    }
    final sorted = {
      for (final MapEntry(key: node, value: around) in neighbors.entries)
        node: around.toList()
          ..sort((a, b) => _angle(positions[node]!, positions[a]!).compareTo(_angle(positions[node]!, positions[b]!))),
    };

    final visited = <(String, String)>{};
    final result = <List<PlanPoint>>[];
    for (final MapEntry(key: start, value: around) in sorted.entries) {
      for (final next in around) {
        if (visited.contains((start, next))) continue;
        final cycle = <String>[];
        var (from, to) = (start, next);
        while (visited.add((from, to))) {
          cycle.add(from);
          final turn = sorted[to]!;
          final following = turn[(turn.indexOf(from) + 1) % turn.length];
          (from, to) = (to, following);
        }
        // Turning this way, enclosed areas come out counterclockwise; the outline around everything clockwise.
        final polygon = [for (final id in cycle.reversed) positions[id]!];
        if (PlanGeometryUtil.signedArea(polygon) > 1) result.add(polygon);
      }
    }
    return result;
  }

  static double _angle(PlanPoint from, PlanPoint to) => math.atan2(to.y - from.y, to.x - from.x);

  /// Gives every area exactly one room. An area belongs to the room whose outline before the change
  /// ([previousOutlines]) holds its middle – larger areas choose first, so a split room keeps its name on the larger
  /// part. Then rooms whose anchor lies in a free area take it, then rooms left take the nearest free area. Areas left
  /// get a new room. Anchors move to the middle of their area, so they stay inside while walls move.
  static HomeLayout normalize(HomeLayout layout, {Map<String, List<PlanPoint>> previousOutlines = const {}}) {
    final areas = LayoutRoomsUtil.areas(layout);
    final centers = [for (final area in areas) PlanGeometryUtil.interiorPoint(area)];
    final rooms = {for (final room in layout.rooms) room.id: room};
    final owner = <int, String>{};
    bool owns(String roomId) => owner.containsValue(roomId);

    final bySize = [for (var i = 0; i < areas.length; i++) i]
      ..sort((a, b) => PlanGeometryUtil.signedArea(areas[b]).compareTo(PlanGeometryUtil.signedArea(areas[a])));
    for (final index in bySize) {
      for (final MapEntry(key: roomId, value: outline) in previousOutlines.entries) {
        if (rooms.containsKey(roomId) && !owns(roomId) && PlanGeometryUtil.containsPoint(outline, centers[index])) {
          owner[index] = roomId;
          break;
        }
      }
    }
    for (final room in layout.rooms) {
      if (owns(room.id) || previousOutlines.containsKey(room.id)) continue;
      final index = areas.indexWhere((area) => PlanGeometryUtil.containsPoint(area, room.anchor));
      if (index >= 0 && !owner.containsKey(index)) owner[index] = room.id;
    }
    for (final room in layout.rooms) {
      if (owns(room.id)) continue;
      int? nearest;
      var nearestDistance = double.infinity;
      for (var i = 0; i < areas.length; i++) {
        if (owner.containsKey(i)) continue;
        final distance = centers[i].distanceTo(room.anchor);
        if (distance < nearestDistance) {
          nearestDistance = distance;
          nearest = i;
        }
      }
      if (nearest != null) owner[nearest] = room.id;
    }

    final added = <LayoutRoom>[];
    for (var i = 0; i < areas.length; i++) {
      if (owner.containsKey(i)) continue;
      final id = LayoutGraphUtil.nextId('room-', [...rooms.keys, ...added.map((room) => room.id)]);
      added.add(LayoutRoom(id: id, name: RoomType.other.label, anchor: centers[i]));
    }
    final anchors = {for (final MapEntry(key: index, value: roomId) in owner.entries) roomId: centers[index]};
    return layout.copyWith(
      rooms: [
        for (final room in layout.rooms)
          if (anchors[room.id] case final anchor?) room.copyWith(anchor: anchor),
        ...added,
      ],
    );
  }

  /// Outline of every room, by room id (rooms whose anchor lies in no area are left out).
  static Map<String, List<PlanPoint>> outlines(HomeLayout layout) {
    final areas = LayoutRoomsUtil.areas(layout);
    return {
      for (final room in layout.rooms)
        room.id: ?areas.where((area) => PlanGeometryUtil.containsPoint(area, room.anchor)).firstOrNull,
    };
  }

  /// The outline of room [roomId], or `null` when its anchor lies in no area.
  static List<PlanPoint>? outlineOf(HomeLayout layout, String roomId) {
    final room = layout.rooms.where((room) => room.id == roomId).firstOrNull;
    if (room == null) return null;
    return areas(layout).where((area) => PlanGeometryUtil.containsPoint(area, room.anchor)).firstOrNull;
  }

  /// The floor plan to show: every named room with its outline and every opening as a segment.
  static FloorPlan toFloorPlan(HomeLayout layout) {
    final areas = LayoutRoomsUtil.areas(layout);
    return FloorPlan(
      rooms: [
        for (final room in layout.rooms)
          if (areas.where((area) => PlanGeometryUtil.containsPoint(area, room.anchor)).firstOrNull case final outline?)
            Room(id: room.id, name: room.name, polygon: _withoutStraightCorners(outline)),
      ],
      doors: [
        for (final opening in layout.openings)
          if (LayoutGraphUtil.openingSegment(layout, opening) case (final a, final b))
            Door(id: opening.id, type: opening.type, a: a, b: b),
      ],
    );
  }

  /// Junctions where a wall merely passes another one's end are not corners of the room.
  static List<PlanPoint> _withoutStraightCorners(List<PlanPoint> outline) {
    if (outline.length <= 3) return outline;
    final result = <PlanPoint>[];
    for (var i = 0; i < outline.length; i++) {
      final previous = outline[(i - 1 + outline.length) % outline.length];
      final next = outline[(i + 1) % outline.length];
      if (PlanGeometryUtil.distanceToLine(outline[i], previous, next) >= 0.5) result.add(outline[i]);
    }
    return result.length >= 3 ? result : outline;
  }
}
