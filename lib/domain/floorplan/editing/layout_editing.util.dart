import 'dart:math' as math;

import 'package:smart_hub/domain/floorplan/furnishing.util.dart';
import 'package:smart_hub/domain/floorplan/layout_graph.util.dart';
import 'package:smart_hub/domain/floorplan/layout_rooms.util.dart';
import 'package:smart_hub/domain/floorplan/model/door_type.enum.dart';
import 'package:smart_hub/domain/floorplan/model/home_layout.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/domain/floorplan/model/room_type.enum.dart';
import 'package:smart_hub/domain/floorplan/plan_geometry.util.dart';

/// A snapped point. [onDrawing] is set when it landed on an existing junction or wall; [guideX] / [guideY] when it
/// was aligned with a junction on that axis.
final class SnapResult {
  const SnapResult(this.point, {this.onDrawing = false, this.guideX, this.guideY});

  final PlanPoint point;
  final bool onDrawing;
  final double? guideX;
  final double? guideY;
}

/// Editing helpers of the floor plan editor: snapping, what is under a finger, and edits made of several steps.
/// Pure functions; search radii are passed in, so they follow the zoom level.
abstract final class LayoutEditingUtil {
  static const grid = 5.0;

  /// Openings move along their wall in these steps.
  static const openingStep = 5.0;

  /// Openings dragged out narrower than this get their usual width instead.
  static const minOpening = 30.0;

  static const minRoomSide = 50.0;

  static const doorWidths = <double>[70, 80, 90, 100];
  static const windowWidths = <double>[60, 80, 100, 120, 160];
  static const openingWidths = <double>[80, 100, 150, 200];

  static List<double> widthsFor(DoorType type) => switch (type) {
    DoorType.door => doorWidths,
    DoorType.window => windowWidths,
    DoorType.open => openingWidths,
  };

  static double defaultWidth(DoorType type) => switch (type) {
    DoorType.door => 80,
    DoorType.window => 100,
    DoorType.open => 100,
  };

  /// Snaps onto a junction, else onto a wall, else onto the grid aligned with junctions on either axis. [drawn] are
  /// points placed but not part of the layout yet (the walls being drawn); they count like junctions.
  static SnapResult snap(
    HomeLayout layout,
    PlanPoint point, {
    required double radius,
    Set<String> except = const {},
    List<PlanPoint> drawn = const [],
  }) {
    final close = drawn.where((p) => p.distanceTo(point) < radius).toList()
      ..sort((a, b) => a.distanceTo(point).compareTo(b.distanceTo(point)));
    if (close.isNotEmpty) return SnapResult(close.first);
    final node = layout.nodes
        .where((node) => !except.contains(node.id) && node.position.distanceTo(point) < radius)
        .fold<LayoutNode?>(
          null,
          (best, node) =>
              best == null || node.position.distanceTo(point) < best.position.distanceTo(point) ? node : best,
        );
    if (node != null) return SnapResult(node.position, onDrawing: true);

    final walls = [
      for (final wall in layout.walls)
        if (!except.contains(wall.from) && !except.contains(wall.to)) wall,
    ];
    final wall = LayoutGraphUtil.wallAt(layout.copyWith(walls: walls), point, radius: radius);
    if (wall != null) {
      final (a, b) = LayoutGraphUtil.endsOf(layout, wall);
      final length = a.distanceTo(b);
      final along = (PlanGeometryUtil.segmentParameter(point, a, b) * length / openingStep).round() * openingStep;
      final t = (along / length).clamp(0.0, 1.0);
      return SnapResult(PlanPoint(_mm(a.x + (b.x - a.x) * t), _mm(a.y + (b.y - a.y) * t)), onDrawing: true);
    }

    var x = (point.x / grid).round() * grid;
    var y = (point.y / grid).round() * grid;
    double? guideX;
    double? guideY;
    var bestX = radius;
    var bestY = radius;
    final aligned = [
      for (final node in layout.nodes)
        if (!except.contains(node.id)) node.position,
      ...drawn,
    ];
    for (final position in aligned) {
      final dx = (position.x - point.x).abs();
      final dy = (position.y - point.y).abs();
      if (dx < bestX) {
        bestX = dx;
        x = guideX = position.x;
      }
      if (dy < bestY) {
        bestY = dy;
        y = guideY = position.y;
      }
    }
    return SnapResult(PlanPoint(x, y), guideX: guideX, guideY: guideY);
  }

  /// The opening closer than [radius] to [point].
  static LayoutOpening? openingAt(HomeLayout layout, PlanPoint point, {required double radius}) {
    LayoutOpening? best;
    var bestDistance = radius;
    for (final opening in layout.openings) {
      final segment = LayoutGraphUtil.openingSegment(layout, opening);
      if (segment == null) continue;
      final distance = PlanGeometryUtil.distanceToSegment(point, segment.$1, segment.$2);
      if (distance < bestDistance) {
        bestDistance = distance;
        best = opening;
      }
    }
    return best;
  }

  /// The piece of furniture under [point] (the smallest one when they overlap, flat ones last).
  static Furniture? furnitureAt(HomeLayout layout, PlanPoint point) {
    final hits =
        [
          for (final item in layout.furniture)
            if (PlanGeometryUtil.containsPoint(FurnishingUtil.cornersOf(item), point)) item,
        ]..sort((a, b) {
          if (a.kind.isFlat != b.kind.isFlat) return a.kind.isFlat ? 1 : -1;
          return (a.width * a.depth).compareTo(b.width * b.depth);
        });
    return hits.firstOrNull;
  }

  /// The room whose area holds [point].
  static LayoutRoom? roomAt(HomeLayout layout, PlanPoint point) {
    final outlines = LayoutRoomsUtil.outlines(layout);
    for (final room in layout.rooms) {
      final outline = outlines[room.id];
      if (outline != null && PlanGeometryUtil.containsPoint(outline, point)) return room;
    }
    return null;
  }

  /// A new opening of [type] on [wall] around [center], [width] wide (kept on the wall).
  static LayoutOpening openingOn(
    HomeLayout layout,
    LayoutWall wall, {
    required String id,
    required DoorType type,
    required PlanPoint center,
    double? width,
  }) {
    final (a, b) = LayoutGraphUtil.endsOf(layout, wall);
    final length = a.distanceTo(b);
    final w = math.min(width ?? defaultWidth(type), length);
    final along = (PlanGeometryUtil.segmentParameter(center, a, b) * length / openingStep).round() * openingStep;
    return LayoutOpening(id: id, wallId: wall.id, type: type, offset: along.clamp(w / 2, length - w / 2), width: w);
  }

  /// An opening on [wall] spanning from [from] to [to] (both projected onto the wall). Ends closer than [snap] to
  /// an end of the wall go all the way to it.
  static LayoutOpening openingBetween(
    HomeLayout layout,
    LayoutWall wall, {
    required String id,
    required DoorType type,
    required PlanPoint from,
    required PlanPoint to,
    double snap = 0,
  }) {
    final (a, b) = LayoutGraphUtil.endsOf(layout, wall);
    final length = a.distanceTo(b);
    double along(PlanPoint point) {
      final exact = PlanGeometryUtil.segmentParameter(point, a, b) * length;
      if (exact < snap) return 0;
      if (exact > length - snap) return length;
      return ((exact / openingStep).round() * openingStep).clamp(0, length).toDouble();
    }

    final start = math.min(along(from), along(to));
    final end = math.max(along(from), along(to));
    return LayoutOpening(id: id, wallId: wall.id, type: type, offset: (start + end) / 2, width: end - start);
  }

  /// Turns within this many degrees of a straight or right angle are taken as one.
  static const straightAngle = 8.0;

  /// The wall that splits the room with [outline] along a stroke from [from] to [to]: the stroke made straight when
  /// nearly so, then lengthened both ways to the room's walls. `null` when it does not cross the room.
  static (PlanPoint, PlanPoint)? splitLine(List<PlanPoint> outline, PlanPoint from, PlanPoint to) {
    final length = from.distanceTo(to);
    if (length < minOpening) return null;
    var angle = math.atan2(to.y - from.y, to.x - from.x);
    final quarter = math.pi / 2;
    final nearest = (angle / quarter).round() * quarter;
    if ((angle - nearest).abs() < straightAngle * math.pi / 180) angle = nearest;
    final dx = math.cos(angle);
    final dy = math.sin(angle);
    double? back;
    double? ahead;
    for (var i = 0; i < outline.length; i++) {
      final a = outline[i];
      final b = outline[(i + 1) % outline.length];
      final ex = b.x - a.x;
      final ey = b.y - a.y;
      final denominator = dx * ey - dy * ex;
      if (denominator.abs() < 1e-9) continue;
      final t = ((a.x - from.x) * ey - (a.y - from.y) * ex) / denominator;
      final u = ((a.x - from.x) * dy - (a.y - from.y) * dx) / denominator;
      if (u < -1e-6 || u > 1 + 1e-6) continue;
      if (t > 0 && (ahead == null || t < ahead)) ahead = t;
      if (t < 0 && (back == null || t > back)) back = t;
    }
    if (back == null || ahead == null) return null;
    PlanPoint at(double t) => PlanPoint(_mm(from.x + dx * t), _mm(from.y + dy * t));
    return (at(back), at(ahead));
  }

  /// The name for a room of [type]: its type's name, numbered when another room has it already.
  static String nameFor(HomeLayout layout, RoomType type, {String? exceptRoomId}) {
    final taken = {
      for (final room in layout.rooms)
        if (room.id != exceptRoomId) room.name,
    };
    if (!taken.contains(type.label)) return type.label;
    var n = 2;
    while (taken.contains('${type.label} $n')) {
      n++;
    }
    return '${type.label} $n';
  }

  /// Removes room [roomId]: its walls that border no other room, and the furniture in it.
  static HomeLayout deleteRoom(HomeLayout layout, String roomId) {
    final outline = LayoutRoomsUtil.outlineOf(layout, roomId);
    if (outline == null) return layout;
    final others = [
      for (final MapEntry(key: id, value: area) in LayoutRoomsUtil.outlines(layout).entries)
        if (id != roomId) area,
    ];
    var result = layout.copyWith(
      furniture: [
        for (final item in layout.furniture)
          if (!PlanGeometryUtil.containsPoint(outline, item.position)) item,
      ],
      rooms: [
        for (final room in layout.rooms)
          if (room.id != roomId) room,
      ],
    );
    for (final wall in layout.walls) {
      final (a, b) = LayoutGraphUtil.endsOf(layout, wall);
      final middle = PlanPoint((a.x + b.x) / 2, (a.y + b.y) / 2);
      if (PlanGeometryUtil.distanceToOutline(middle, outline) > 1) continue;
      final length = a.distanceTo(b);
      final normal = PlanPoint(-(b.y - a.y) / length * 15, (b.x - a.x) / length * 15);
      final bordersOther = [
        middle + normal,
        middle - normal,
      ].any((side) => others.any((area) => PlanGeometryUtil.containsPoint(area, side)));
      if (!bordersOther) result = LayoutGraphUtil.removeWall(result, wall.id);
    }
    return result;
  }

  static double _mm(double cm) => (cm * 10).round() / 10;
}
