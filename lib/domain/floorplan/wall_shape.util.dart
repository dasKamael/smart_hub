import 'dart:math' as math;

import 'package:smart_hub/domain/floorplan/layout_graph.util.dart';
import 'package:smart_hub/domain/floorplan/layout_rooms.util.dart';
import 'package:smart_hub/domain/floorplan/model/home_layout.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/domain/floorplan/plan_geometry.util.dart';

/// The end of a wall's body at a junction: its corner on the right side, the junction itself, and its corner on the
/// left side (sides as seen walking the wall from its first junction to its second).
typedef WallEnd = (PlanPoint right, PlanPoint center, PlanPoint left);

/// The body of a wall as drawn: along its line from [from] to [to], [right] cm to one side and [left] cm to the other
/// ([across] points to the left). Outer walls grow outwards only, so their inner face lines up with the inner walls.
/// At junctions its ends are cut so that all walls meeting there join without gaps or overlaps ([start], [end]).
final class WallShape {
  const WallShape({
    required this.from,
    required this.to,
    required this.across,
    required this.left,
    required this.right,
    required this.outside,
    this.start,
    this.end,
    this.open = false,
  });

  /// The wall's line, junction to junction.
  final PlanPoint from;
  final PlanPoint to;

  /// Unit vector at right angles to the line, to its left.
  final PlanPoint across;
  final double left;
  final double right;

  /// The direction out of the apartment, for outer walls; `null` for inner walls.
  final PlanPoint? outside;

  /// The cut ends at junctions with other walls; `null` for an end that stands free.
  final WallEnd? start;
  final WallEnd? end;

  /// The wall is open along its whole length (see [LayoutGraphUtil.isOpen]): there is no wall to draw, only the line
  /// between two rooms.
  final bool open;

  /// Sides of a [section] that are its ends (by the index of their first corner).
  static const startSides = {4, 5};
  static const endSides = {1, 2};

  double get length => from.distanceTo(to);

  PlanPoint get direction => PlanPoint((to.x - from.x) / length, (to.y - from.y) / length);

  /// The point [along] cm from [from] on the line, moved [side] cm to the left.
  PlanPoint at(double along, double side) {
    final d = direction;
    return PlanPoint(from.x + d.x * along + across.x * side, from.y + d.y * along + across.y * side);
  }

  /// The outline of the part from [startAlong] to [endAlong] cm, with six corners: right side start and end, the
  /// middle of the end, left side end and start, the middle of the start. A full-width part reaching a cut end takes
  /// the cut; [right] and [left] narrow it (e.g. a pane of glass).
  List<PlanPoint> section(double startAlong, double endAlong, {double? right, double? left}) {
    final narrowed = right != null || left != null;
    final r = right ?? this.right;
    final l = left ?? this.left;
    WallEnd plain(double along) => (at(along, -r), at(along, (l - r) / 2), at(along, l));
    final (startRight, startCenter, startLeft) = switch (start) {
      final cut? when startAlong <= 0.01 && !narrowed => cut,
      _ => plain(startAlong),
    };
    final (endRight, endCenter, endLeft) = switch (end) {
      final cut? when endAlong >= length - 0.01 && !narrowed => cut,
      _ => plain(endAlong),
    };
    return [startRight, endRight, endCenter, endLeft, startLeft, startCenter];
  }

  /// The outline of the whole body.
  List<PlanPoint> get corners => section(0, length);
}

/// Shapes walls so that they meet cleanly, as a floor plan program does: outer walls thicken outwards, and at every
/// junction each wall's end is cut where its faces meet the faces of the walls next to it around the junction –
/// corners, T-junctions and crossings close without gaps, blocks or overlaps.
abstract final class WallShapeUtil {
  /// Cuts reaching farther from the junction than this many wall thicknesses (very sharp corners) are left square.
  static const _maxCut = 4.0;

  static Map<String, WallShape> shapesOf(HomeLayout layout) {
    final positions = {for (final node in layout.nodes) node.id: node.position};
    final rooms = LayoutRoomsUtil.areas(layout);
    final half = LayoutWall.innerThickness / 2;
    final walls = [
      for (final wall in layout.walls)
        if (positions[wall.from]!.distanceTo(positions[wall.to]!) >= 1) wall,
    ];

    // Across: how far each wall reaches to its left and right.
    final sides = <String, (double, double, PlanPoint?)>{};
    for (final wall in walls) {
      final a = positions[wall.from]!;
      final b = positions[wall.to]!;
      final outside = _outsideOf(a, b, wall.thickness, rooms);
      if (outside == null || wall.thickness <= LayoutWall.innerThickness) {
        sides[wall.id] = (wall.thickness / 2, wall.thickness / 2, outside);
      } else {
        final left = _leftOf(a, b);
        final outer = wall.thickness - half;
        sides[wall.id] = outside.x * left.x + outside.y * left.y > 0 ? (outer, half, outside) : (half, outer, outside);
      }
    }

    // One arm per wall end at a junction: which way the wall leaves it and how far it reaches to either side. Open
    // walls are not there to meet, so the walls next to them end square instead of being cut against nothing.
    final open = {
      for (final wall in walls)
        if (LayoutGraphUtil.isOpen(layout, wall)) wall.id,
    };
    final arms = <String, List<_Arm>>{};
    for (final wall in walls.where((wall) => !open.contains(wall.id))) {
      final a = positions[wall.from]!;
      final b = positions[wall.to]!;
      final length = a.distanceTo(b);
      final d = PlanPoint((b.x - a.x) / length, (b.y - a.y) / length);
      final (left, right, _) = sides[wall.id]!;
      // Turning to larger angles is the wall's right when it leaves its first junction, its left when it leaves
      // the second.
      arms.putIfAbsent(wall.from, () => []).add(_Arm(wall.id, true, d, plus: right, minus: left));
      arms.putIfAbsent(wall.to, () => []).add(_Arm(wall.id, false, PlanPoint(-d.x, -d.y), plus: left, minus: right));
    }

    final ends = <(String, bool), WallEnd>{};
    for (final MapEntry(key: node, value: around) in arms.entries) {
      if (around.length < 2) continue;
      final center = positions[node]!;
      around.sort((x, y) => x.angle.compareTo(y.angle));
      for (var i = 0; i < around.length; i++) {
        final arm = around[i];
        final next = around[(i + 1) % around.length];
        final previous = around[(i - 1 + around.length) % around.length];
        final plusCorner = _corner(center, arm, arm.plus, 1, next, next.minus, -1);
        final minusCorner = _corner(center, arm, arm.minus, -1, previous, previous.plus, 1);
        ends[(arm.wallId, arm.fromStart)] = arm.fromStart
            ? (plusCorner, center, minusCorner)
            : (minusCorner, center, plusCorner);
      }
    }

    return {
      for (final wall in walls)
        wall.id: WallShape(
          from: positions[wall.from]!,
          to: positions[wall.to]!,
          across: _leftOf(positions[wall.from]!, positions[wall.to]!),
          left: sides[wall.id]!.$1,
          right: sides[wall.id]!.$2,
          outside: sides[wall.id]!.$3,
          start: ends[(wall.id, true)],
          end: ends[(wall.id, false)],
          open: open.contains(wall.id),
        ),
    };
  }

  /// Where the face of [arm] on side [sign] (+1 towards larger angles, −1 the other), [extent] cm from its line, meets
  /// the face of [neighbor] turned towards it. Square across the wall when the two run straight on or meet far away.
  static PlanPoint _corner(
    PlanPoint center,
    _Arm arm,
    double extent,
    int sign,
    _Arm neighbor,
    double neighborExtent,
    int neighborSign,
  ) {
    final square = arm.side(center, extent * sign);
    final meet = _meet(square, arm.direction, neighbor.side(center, neighborExtent * neighborSign), neighbor.direction);
    if (meet == null) return square;
    if (meet.distanceTo(center) > _maxCut * 2 * math.max(extent, neighborExtent)) return square;
    return meet;
  }

  /// Unit vector to the left of the way from [a] to [b] (on screen, y pointing down).
  static PlanPoint _leftOf(PlanPoint a, PlanPoint b) {
    final length = a.distanceTo(b);
    if (length == 0) return const PlanPoint(0, -1);
    return PlanPoint((b.y - a.y) / length, -(b.x - a.x) / length);
  }

  /// Where the line through [p] along [u] meets the line through [q] along [v], or `null` when they (nearly) run
  /// parallel.
  static PlanPoint? _meet(PlanPoint p, PlanPoint u, PlanPoint q, PlanPoint v) {
    final denominator = u.x * v.y - u.y * v.x;
    if (denominator.abs() < 0.05) return null;
    final t = ((q.x - p.x) * v.y - (q.y - p.y) * v.x) / denominator;
    return PlanPoint(p.x + u.x * t, p.y + u.y * t);
  }

  /// The direction out of the apartment from the wall from [a] to [b], or `null` when there are rooms on both sides
  /// (or on none).
  static PlanPoint? _outsideOf(PlanPoint a, PlanPoint b, double thickness, List<List<PlanPoint>> rooms) {
    final length = a.distanceTo(b);
    if (length < 1) return null;
    final left = _leftOf(a, b);
    final middle = PlanPoint((a.x + b.x) / 2, (a.y + b.y) / 2);
    final reach = thickness / 2 + 15;
    bool inRoom(PlanPoint point) => rooms.any((outline) => PlanGeometryUtil.containsPoint(outline, point));
    final roomLeft = inRoom(PlanPoint(middle.x + left.x * reach, middle.y + left.y * reach));
    final roomRight = inRoom(PlanPoint(middle.x - left.x * reach, middle.y - left.y * reach));
    if (roomLeft == roomRight) return null;
    return roomLeft ? PlanPoint(-left.x, -left.y) : left;
  }
}

/// A wall leaving a junction in [direction]: [plus] cm to the side of larger angles, [minus] cm to the other.
class _Arm {
  _Arm(this.wallId, this.fromStart, this.direction, {required this.plus, required this.minus})
    : angle = math.atan2(direction.y, direction.x);

  final String wallId;

  /// Whether the junction is the wall's first one.
  final bool fromStart;
  final PlanPoint direction;
  final double plus;
  final double minus;
  final double angle;

  /// The point [offset] cm towards larger angles (negative: the other way) from [center], across the arm.
  PlanPoint side(PlanPoint center, double offset) =>
      PlanPoint(center.x - direction.y * offset, center.y + direction.x * offset);
}
