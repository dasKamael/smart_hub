import 'dart:math' as math;

import 'package:smart_hub/domain/floorplan/model/door_type.enum.dart';
import 'package:smart_hub/domain/floorplan/model/floor_plan.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';

/// A wall near a point: the edge from corner [index] to the next corner of the room [roomId], and [point], the
/// closest point on it.
final class WallHit {
  const WallHit({required this.roomId, required this.index, required this.a, required this.b, required this.point});

  final String roomId;
  final int index;
  final PlanPoint a;
  final PlanPoint b;
  final PlanPoint point;

  double get length => a.distanceTo(b);
}

/// A snapped point. [guideX] / [guideY] are set when the point was aligned with a corner on that axis.
final class SnapResult {
  const SnapResult(this.point, {this.guideX, this.guideY});

  final PlanPoint point;
  final double? guideX;
  final double? guideY;
}

/// Editing the floor plan: snapping, hit tests and changes to rooms and wall openings. Pure functions, all values
/// in centimeters; search radii are passed in, so they can follow the zoom level.
abstract final class PlanEditingUtil {
  static const grid = 10.0;

  /// Openings are placed along their wall in these steps.
  static const openingStep = 5.0;

  static const minRectangleSide = 50.0;

  /// Two points closer than this count as the same, e.g. an opening on a wall.
  static const _tolerance = 1.0;

  static const doorWidths = <double>[70, 80, 90, 100, 180];
  static const windowWidths = <double>[60, 80, 100, 120, 160];

  static List<double> widthsFor(DoorType type) => type == DoorType.window ? windowWidths : doorWidths;

  static double defaultWidth(DoorType type) => type == DoorType.window ? 100 : 80;

  /// Corners of all rooms, optionally without corner [exceptIndex] of room [exceptRoomId] (the one being dragged).
  static List<PlanPoint> cornersOf(FloorPlan plan, {String? exceptRoomId, int? exceptIndex}) => [
    for (final room in plan.rooms)
      for (final (i, corner) in room.polygon.indexed)
        if (room.id != exceptRoomId || i != exceptIndex) corner,
  ];

  /// Snaps onto a corner closer than [radius]; otherwise onto the grid, aligned with corners on either axis.
  static SnapResult snap(PlanPoint point, Iterable<PlanPoint> corners, {required double radius}) {
    PlanPoint? nearest;
    var nearestDistance = radius;
    for (final corner in corners) {
      final distance = corner.distanceTo(point);
      if (distance < nearestDistance) {
        nearestDistance = distance;
        nearest = corner;
      }
    }
    if (nearest != null) return SnapResult(nearest);

    var x = _round(point.x, grid);
    var y = _round(point.y, grid);
    double? guideX;
    double? guideY;
    var bestX = radius;
    var bestY = radius;
    for (final corner in corners) {
      final dx = (corner.x - point.x).abs();
      final dy = (corner.y - point.y).abs();
      if (dx < bestX) {
        bestX = dx;
        x = guideX = corner.x;
      }
      if (dy < bestY) {
        bestY = dy;
        y = guideY = corner.y;
      }
    }
    return SnapResult(PlanPoint(x, y), guideX: guideX, guideY: guideY);
  }

  /// The wall closer than [radius] to [point], the closest one first.
  static WallHit? wallAt(FloorPlan plan, PlanPoint point, {required double radius}) {
    WallHit? best;
    var bestDistance = radius;
    for (final room in plan.rooms) {
      for (var i = 0; i < room.polygon.length; i++) {
        final a = room.polygon[i];
        final b = room.polygon[(i + 1) % room.polygon.length];
        if (a.distanceTo(b) == 0) continue;
        final closest = _closestOnSegment(point, a, b);
        final distance = point.distanceTo(closest);
        if (distance < bestDistance) {
          bestDistance = distance;
          best = WallHit(roomId: room.id, index: i, a: a, b: b, point: closest);
        }
      }
    }
    return best;
  }

  /// The wall [opening] lies on, with its middle as [WallHit.point], or `null` when it lies on none.
  static WallHit? wallOf(FloorPlan plan, Door opening, {String? roomId}) {
    for (final room in plan.rooms) {
      if (roomId != null && room.id != roomId) continue;
      for (var i = 0; i < room.polygon.length; i++) {
        final a = room.polygon[i];
        final b = room.polygon[(i + 1) % room.polygon.length];
        if (_onSegment(opening.a, a, b) && _onSegment(opening.b, a, b)) {
          return WallHit(roomId: room.id, index: i, a: a, b: b, point: _middle(opening.a, opening.b));
        }
      }
    }
    return null;
  }

  /// An opening of [width] centered on [wall]'s point (rounded to [openingStep]), kept on the wall.
  static Door placeOpening(WallHit wall, {required String id, required DoorType type, required double width}) {
    final length = wall.length;
    final w = math.min(width, length);
    final center = _round(wall.a.distanceTo(wall.point), openingStep).clamp(w / 2, length - w / 2);
    return Door(
      id: id,
      type: type,
      a: _along(wall.a, wall.b, center - w / 2),
      b: _along(wall.a, wall.b, center + w / 2),
    );
  }

  /// [opening] with a new [width] around the same middle; it stays on its wall.
  static Door resizeOpening(FloorPlan plan, Door opening, double width) {
    final wall = wallOf(plan, opening);
    if (wall == null) {
      final middle = _middle(opening.a, opening.b);
      final half = width / 2 / math.max(opening.a.distanceTo(opening.b), _tolerance);
      return opening.copyWith(
        a: PlanPoint(middle.x + (opening.a.x - middle.x) * 2 * half, middle.y + (opening.a.y - middle.y) * 2 * half),
        b: PlanPoint(middle.x + (opening.b.x - middle.x) * 2 * half, middle.y + (opening.b.y - middle.y) * 2 * half),
      );
    }
    return placeOpening(wall, id: opening.id, type: opening.type, width: width);
  }

  /// [opening] moved along its wall towards [to]; it keeps its width and stops at the corners.
  static Door slideOpening(FloorPlan plan, Door opening, PlanPoint to) {
    final wall = wallOf(plan, opening);
    if (wall == null) return opening;
    final hit = WallHit(
      roomId: wall.roomId,
      index: wall.index,
      a: wall.a,
      b: wall.b,
      point: _closestOnSegment(to, wall.a, wall.b),
    );
    return placeOpening(hit, id: opening.id, type: opening.type, width: opening.a.distanceTo(opening.b));
  }

  static List<PlanPoint> moveCorner(List<PlanPoint> polygon, int index, PlanPoint to) => [
    for (final (i, corner) in polygon.indexed) i == index ? to : corner,
  ];

  /// [polygon] with [point] between corner [afterIndex] and the next one.
  static List<PlanPoint> insertCorner(List<PlanPoint> polygon, int afterIndex, PlanPoint point) =>
      [...polygon]..insert(afterIndex + 1, point);

  /// [polygon] without corner [index], or `null` when only a triangle is left.
  static List<PlanPoint>? removeCorner(List<PlanPoint> polygon, int index) {
    if (polygon.length <= 3) return null;
    return [...polygon]..removeAt(index);
  }

  /// Index of the corner closer than [radius] to [point], the closest one first.
  static int? cornerAt(List<PlanPoint> polygon, PlanPoint point, {required double radius}) =>
      _nearestIndex([for (final corner in polygon) corner.distanceTo(point)], radius);

  /// Index of the edge whose middle is closer than [radius] to [point].
  static int? edgeMiddleAt(List<PlanPoint> polygon, PlanPoint point, {required double radius}) =>
      _nearestIndex([for (var i = 0; i < polygon.length; i++) edgeMiddle(polygon, i).distanceTo(point)], radius);

  static PlanPoint edgeMiddle(List<PlanPoint> polygon, int index) =>
      _middle(polygon[index], polygon[(index + 1) % polygon.length]);

  /// The opening closer than [radius] to [point].
  static Door? openingAt(List<Door> openings, PlanPoint point, {required double radius}) {
    final index = _nearestIndex([
      for (final opening in openings) point.distanceTo(_closestOnSegment(point, opening.a, opening.b)),
    ], radius);
    return index == null ? null : openings[index];
  }

  /// A rectangle between two opposite corners, or `null` when a side is shorter than [minRectangleSide].
  static List<PlanPoint>? rectangle(PlanPoint from, PlanPoint to) {
    final left = math.min(from.x, to.x);
    final top = math.min(from.y, to.y);
    final right = math.max(from.x, to.x);
    final bottom = math.max(from.y, to.y);
    if (right - left < minRectangleSide || bottom - top < minRectangleSide) return null;
    return [PlanPoint(left, top), PlanPoint(right, top), PlanPoint(right, bottom), PlanPoint(left, bottom)];
  }

  /// The way from [from] to [to] in whole grid steps.
  static PlanPoint gridDelta(PlanPoint from, PlanPoint to) =>
      PlanPoint(_round(to.x - from.x, grid), _round(to.y - from.y, grid));

  /// Moves room [roomId] by [delta]; openings on its walls move along.
  static FloorPlan moveRoom(FloorPlan plan, String roomId, PlanPoint delta) {
    final onRoom = {
      for (final opening in plan.doors)
        if (wallOf(plan, opening, roomId: roomId) != null) opening.id,
    };
    return plan.copyWith(
      rooms: [
        for (final room in plan.rooms)
          room.id == roomId ? room.copyWith(polygon: [for (final p in room.polygon) p + delta]) : room,
      ],
      doors: [
        for (final opening in plan.doors)
          onRoom.contains(opening.id) ? opening.copyWith(a: opening.a + delta, b: opening.b + delta) : opening,
      ],
    );
  }

  /// Removes room [roomId] and its openings that no longer lie on any wall (a door to a neighbor stays).
  static FloorPlan deleteRoom(FloorPlan plan, String roomId) {
    final onRoom = {
      for (final opening in plan.doors)
        if (wallOf(plan, opening, roomId: roomId) != null) opening.id,
    };
    final rest = plan.copyWith(
      rooms: [
        for (final room in plan.rooms)
          if (room.id != roomId) room,
      ],
    );
    return rest.copyWith(
      doors: [
        for (final opening in rest.doors)
          if (!onRoom.contains(opening.id) || wallOf(rest, opening) != null) opening,
      ],
    );
  }

  /// Gives room [roomId] a new [polygon]. Its openings that fell off their wall are put back onto the nearest wall of
  /// the room, with their width.
  static FloorPlan withRoomPolygon(FloorPlan plan, String roomId, List<PlanPoint> polygon) {
    final changed = plan.copyWith(
      rooms: [for (final room in plan.rooms) room.id == roomId ? room.copyWith(polygon: polygon) : room],
    );
    final room = FloorPlan(
      rooms: [
        for (final room in changed.rooms)
          if (room.id == roomId) room,
      ],
    );
    return changed.copyWith(
      doors: [
        for (final opening in plan.doors)
          if (wallOf(plan, opening, roomId: roomId) == null || wallOf(changed, opening) != null)
            opening
          else
            _reattach(room, opening),
      ],
    );
  }

  static Door _reattach(FloorPlan room, Door opening) {
    final wall = wallAt(room, _middle(opening.a, opening.b), radius: double.infinity);
    if (wall == null) return opening;
    return placeOpening(wall, id: opening.id, type: opening.type, width: opening.a.distanceTo(opening.b));
  }

  /// Whether a tap at [point] closes [draft]: it has at least three corners and the tap is on the first one.
  static bool closesDraft(List<PlanPoint> draft, PlanPoint point, {required double radius}) =>
      draft.length >= 3 && draft.first.distanceTo(point) < radius;

  /// The first `<prefix><n>` (n ≥ 1) not in [existing].
  static String nextId(String prefix, Iterable<String> existing) {
    final taken = existing.toSet();
    var n = 1;
    while (taken.contains('$prefix$n')) {
      n++;
    }
    return '$prefix$n';
  }

  /// Center of the area of [polygon]; its first corner when it has no area.
  static PlanPoint centroid(List<PlanPoint> polygon) {
    var twiceArea = 0.0;
    var x = 0.0;
    var y = 0.0;
    for (var i = 0; i < polygon.length; i++) {
      final p = polygon[i];
      final q = polygon[(i + 1) % polygon.length];
      final cross = p.x * q.y - q.x * p.y;
      twiceArea += cross;
      x += (p.x + q.x) * cross;
      y += (p.y + q.y) * cross;
    }
    if (twiceArea.abs() < _tolerance) return polygon.first;
    return PlanPoint(x / (3 * twiceArea), y / (3 * twiceArea));
  }

  static double _round(double value, double step) => (value / step).round() * step;

  static PlanPoint _middle(PlanPoint a, PlanPoint b) => PlanPoint((a.x + b.x) / 2, (a.y + b.y) / 2);

  /// The point [distance] from [a] towards [b], to the millimeter.
  static PlanPoint _along(PlanPoint a, PlanPoint b, double distance) {
    final t = distance / a.distanceTo(b);
    return PlanPoint(_toMillimeter(a.x + (b.x - a.x) * t), _toMillimeter(a.y + (b.y - a.y) * t));
  }

  static double _toMillimeter(double cm) => (cm * 10).round() / 10;

  static PlanPoint _closestOnSegment(PlanPoint point, PlanPoint a, PlanPoint b) {
    final dx = b.x - a.x;
    final dy = b.y - a.y;
    final lengthSquared = dx * dx + dy * dy;
    if (lengthSquared == 0) return a;
    final t = (((point.x - a.x) * dx + (point.y - a.y) * dy) / lengthSquared).clamp(0.0, 1.0);
    return PlanPoint(a.x + dx * t, a.y + dy * t);
  }

  static bool _onSegment(PlanPoint point, PlanPoint a, PlanPoint b) =>
      point.distanceTo(_closestOnSegment(point, a, b)) < _tolerance;

  static int? _nearestIndex(List<double> distances, double radius) {
    int? nearest;
    var nearestDistance = radius;
    for (final (i, distance) in distances.indexed) {
      if (distance < nearestDistance) {
        nearestDistance = distance;
        nearest = i;
      }
    }
    return nearest;
  }
}
