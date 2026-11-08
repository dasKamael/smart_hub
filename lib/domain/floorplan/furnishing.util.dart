import 'dart:math' as math;

import 'package:smart_hub/domain/floorplan/layout_graph.util.dart';
import 'package:smart_hub/domain/floorplan/layout_rooms.util.dart';
import 'package:smart_hub/domain/floorplan/model/door_type.enum.dart';
import 'package:smart_hub/domain/floorplan/model/furniture_kind.enum.dart';
import 'package:smart_hub/domain/floorplan/model/home_layout.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/domain/floorplan/model/room_type.enum.dart';
import 'package:smart_hub/domain/floorplan/plan_geometry.util.dart';
import 'package:smart_hub/domain/floorplan/wall_shape.util.dart';

/// Placing furniture: a piece put down near a wall turns its back to it, and "furnish" fills a room with the
/// furniture its type usually has – against the walls, clear of doors, nothing tall in front of windows.
abstract final class FurnishingUtil {
  /// A piece put down closer than this to a wall stands against it.
  static const wallSnap = 60.0;

  /// Kept free in front of and behind every door, so it can open.
  static const doorClearance = 90.0;

  /// The four corners of [item] on the plan.
  static List<PlanPoint> cornersOf(Furniture item) {
    final angle = item.rotation * math.pi / 180;
    final cos = math.cos(angle);
    final sin = math.sin(angle);
    PlanPoint corner(double x, double y) =>
        PlanPoint(item.position.x + x * cos - y * sin, item.position.y + x * sin + y * cos);
    final w = item.width / 2;
    final d = item.depth / 2;
    return [corner(-w, -d), corner(w, -d), corner(w, d), corner(-w, d)];
  }

  /// A new piece of [kind] at [point]: against the nearest wall of its room when that is closer than [wallSnap].
  static Furniture place(HomeLayout layout, FurnitureKind kind, PlanPoint point, {required String id}) {
    final item = Furniture(id: id, kind: kind, position: point, width: kind.width, depth: kind.depth);
    return snapToWall(layout, item);
  }

  /// [item] moved against the nearest wall of its room (back to the wall) when it is close enough, else as it is.
  static Furniture snapToWall(HomeLayout layout, Furniture item) {
    final room = _roomEdgesAt(layout, item.position);
    if (room == null || item.kind.isFlat) return item;
    _Edge? nearest;
    var nearestDistance = wallSnap + item.depth / 2;
    for (final edge in room) {
      final distance = PlanGeometryUtil.distanceToSegment(item.position, edge.a, edge.b) - edge.face;
      if (distance < nearestDistance) {
        nearestDistance = distance;
        nearest = edge;
      }
    }
    if (nearest == null) return item;
    final along = PlanGeometryUtil.segmentParameter(item.position, nearest.a, nearest.b) * nearest.length;
    return _against(
      item,
      nearest,
      along.clamp(item.width / 2, math.max(item.width / 2, nearest.length - item.width / 2)),
    );
  }

  /// [item] moved the least needed so that no corner reaches into a wall of its room. Its turn and size stay.
  static Furniture keepInside(HomeLayout layout, Furniture item) {
    final room = _roomEdgesAt(layout, item.position);
    if (room == null) return item;
    var position = item.position;
    // A few rounds, as pushing out of one wall can push into the one around a corner.
    for (var round = 0; round < 4; round++) {
      var pushed = false;
      for (final edge in room) {
        final along = PlanPoint((edge.b.x - edge.a.x) / edge.length, (edge.b.y - edge.a.y) / edge.length);
        var deepest = 0.0;
        for (final corner in cornersOf(item.copyWith(position: position))) {
          final t = (corner.x - edge.a.x) * along.x + (corner.y - edge.a.y) * along.y;
          // Only corners alongside this wall; past its ends another wall is in charge.
          if (t < -edge.face || t > edge.length + edge.face) continue;
          final into = edge.face - ((corner.x - edge.a.x) * edge.inward.x + (corner.y - edge.a.y) * edge.inward.y);
          deepest = math.max(deepest, into);
        }
        if (deepest > 0.05) {
          position = PlanPoint(position.x + edge.inward.x * deepest, position.y + edge.inward.y * deepest);
          pushed = true;
        }
      }
      if (!pushed) break;
    }
    if (position == item.position) return item;
    return item.copyWith(position: PlanPoint(_round(position.x), _round(position.y)));
  }

  /// [layout] with the usual furniture for every room that has none yet.
  static HomeLayout furnishAll(HomeLayout layout) {
    var result = layout;
    for (final room in layout.rooms) {
      final outline = LayoutRoomsUtil.outlineOf(result, room.id);
      if (outline == null) continue;
      final hasFurniture = result.furniture.any((item) => PlanGeometryUtil.containsPoint(outline, item.position));
      if (!hasFurniture) result = furnish(result, room.id);
    }
    return result;
  }

  /// [layout] with the furniture of room [roomId] replaced by what its type usually has.
  static HomeLayout furnish(HomeLayout layout, String roomId) {
    final room = layout.rooms.where((room) => room.id == roomId).firstOrNull;
    final outline = LayoutRoomsUtil.outlineOf(layout, roomId);
    if (room == null || outline == null) return layout;
    final kept = [
      for (final item in layout.furniture)
        if (!PlanGeometryUtil.containsPoint(outline, item.position)) item,
    ];
    final planner = _Planner(layout.copyWith(furniture: kept), outline);
    planner.furnish(room.type);
    return layout.copyWith(furniture: [...kept, ...planner.placed]);
  }

  static List<_Edge>? _roomEdgesAt(HomeLayout layout, PlanPoint point) {
    final outline = LayoutRoomsUtil.areas(layout)
        .where((area) => PlanGeometryUtil.containsPoint(area, point))
        .firstOrNull;
    return outline == null ? null : _edgesOf(layout, outline);
  }

  /// The walls around [outline] (corners clockwise on screen) with the direction into the room.
  static List<_Edge> _edgesOf(HomeLayout layout, List<PlanPoint> raw) {
    // Junctions where another wall merely ends do not break a wall into pieces.
    final outline = [
      for (var i = 0; i < raw.length; i++)
        if (PlanGeometryUtil.distanceToLine(
              raw[i],
              raw[(i - 1 + raw.length) % raw.length],
              raw[(i + 1) % raw.length],
            ) >=
            0.5)
          raw[i],
    ];
    final shapes = WallShapeUtil.shapesOf(layout);
    final edges = <_Edge>[];
    for (var i = 0; i < outline.length; i++) {
      final a = outline[i];
      final b = outline[(i + 1) % outline.length];
      final length = a.distanceTo(b);
      if (length < 1) continue;
      final middle = PlanPoint((a.x + b.x) / 2, (a.y + b.y) / 2);
      final wall = LayoutGraphUtil.wallAt(layout, middle, radius: 2);
      // Clockwise on screen, the room lies to the right of the walking direction.
      final inward = PlanPoint(-(b.y - a.y) / length, (b.x - a.x) / length);
      edges.add(_Edge(a, b, inward, _faceOf(shapes[wall?.id], inward, wall), wall?.id));
    }
    return edges;
  }

  /// [item] with its back against [edge], its middle [along] the wall from [_Edge.a].
  static Furniture _against(Furniture item, _Edge edge, double along) {
    final t = along / edge.length;
    final onWall = PlanPoint(edge.a.x + (edge.b.x - edge.a.x) * t, edge.a.y + (edge.b.y - edge.a.y) * t);
    final away = edge.face + item.depth / 2 + 1;
    final rotation = math.atan2(-edge.inward.x, edge.inward.y) * 180 / math.pi;
    return item.copyWith(
      position: PlanPoint(_round(onWall.x + edge.inward.x * away), _round(onWall.y + edge.inward.y * away)),
      rotation: (rotation.round() % 360).toDouble(),
    );
  }

  /// The distance of the room-side face of [wall] from its line, from its [shape] when it has one.
  static double _faceOf(WallShape? shape, PlanPoint inward, LayoutWall? wall) {
    if (shape == null) return (wall?.thickness ?? LayoutWall.innerThickness) / 2;
    return inward.x * shape.across.x + inward.y * shape.across.y > 0 ? shape.left : shape.right;
  }

  static double _round(double value) => (value * 10).round() / 10;
}

class _Edge {
  _Edge(this.a, this.b, this.inward, this.face, this.wallId);

  final PlanPoint a;
  final PlanPoint b;
  final PlanPoint inward;

  /// How far the wall's face on the room's side is from its line.
  final double face;
  final String? wallId;

  double get length => a.distanceTo(b);
}

/// Places the furniture of one room, one piece after another, each where it fits.
class _Planner {
  _Planner(this.layout, this.outline) : edges = FurnishingUtil._edgesOf(layout, outline) {
    for (final opening in layout.openings) {
      final segment = LayoutGraphUtil.openingSegment(layout, opening);
      if (segment == null) continue;
      final (a, b) = segment;
      if (opening.type == DoorType.window) {
        windows.add((a, b));
      } else {
        doors.add((a, b));
      }
    }
  }

  final HomeLayout layout;
  final List<PlanPoint> outline;
  final List<_Edge> edges;
  final doors = <(PlanPoint, PlanPoint)>[];
  final windows = <(PlanPoint, PlanPoint)>[];
  final placed = <Furniture>[];

  double get area => PlanGeometryUtil.areaInSquareMeters(outline);

  String _id() =>
      LayoutGraphUtil.nextId('f', [...layout.furniture.map((item) => item.id), ...placed.map((item) => item.id)]);

  Furniture _new(FurnitureKind kind, {double? width}) =>
      Furniture(id: _id(), kind: kind, position: PlanPoint.zero, width: width ?? kind.width, depth: kind.depth);

  void furnish(RoomType type) {
    switch (type) {
      case RoomType.bedroom:
        final double = area >= 7;
        final bedItem = _new(double ? FurnitureKind.bed : FurnitureKind.singleBed);
        final bed =
            againstWall(
              bedItem,
              preferNoDoor: true,
              accept: (bed) =>
                  _fitsBeside(bed, FurnitureKind.nightstand, left: true) &&
                  (!double || _fitsBeside(bed, FurnitureKind.nightstand, left: false)),
            ) ??
            againstWall(bedItem, preferNoDoor: true);
        if (bed != null) {
          beside(bed, FurnitureKind.nightstand, left: true);
          if (double) beside(bed, FurnitureKind.nightstand, left: false);
        }
        againstWall(_new(FurnitureKind.wardrobe)) ?? againstWall(_new(FurnitureKind.dresser));
        againstWall(_new(FurnitureKind.plant));
      case RoomType.kids:
        final bed = againstWall(_new(FurnitureKind.singleBed), preferNoDoor: true);
        if (bed != null) beside(bed, FurnitureKind.nightstand, left: true);
        final desk = againstWall(_new(FurnitureKind.desk), preferWindow: true);
        if (desk != null) inFront(desk, FurnitureKind.officeChair, gap: -15);
        againstWall(_new(FurnitureKind.shelf));
      case RoomType.living:
        final sofa = againstWall(_new(FurnitureKind.sofa), preferNoDoor: true);
        if (sofa != null) {
          final table = inFront(sofa, FurnitureKind.coffeeTable, gap: 40);
          if (table != null) under(table, FurnitureKind.rug);
          opposite(sofa, FurnitureKind.tvUnit);
        }
        againstWall(_new(FurnitureKind.armchair));
        againstWall(_new(FurnitureKind.plant));
        againstWall(_new(FurnitureKind.floorLamp));
      case RoomType.kitchen:
        final counters = counterRun();
        if (counters != null) besideRun(counters, FurnitureKind.fridge);
        if (area >= 8) diningSet(chairs: area >= 11 ? 4 : 2);
        againstWall(_new(FurnitureKind.plant));
      case RoomType.dining:
        diningSet(chairs: 4);
        againstWall(_new(FurnitureKind.shelf));
        againstWall(_new(FurnitureKind.plant));
      case RoomType.office:
        final desk = againstWall(_new(FurnitureKind.desk), preferWindow: true);
        if (desk != null) inFront(desk, FurnitureKind.officeChair, gap: -15);
        againstWall(_new(FurnitureKind.shelf));
        againstWall(_new(FurnitureKind.armchair));
        againstWall(_new(FurnitureKind.plant));
      case RoomType.bathroom:
        againstWall(_new(FurnitureKind.bathtub), preferNoDoor: true) ??
            againstWall(_new(FurnitureKind.shower), preferNoDoor: true);
        againstWall(_new(FurnitureKind.toilet));
        againstWall(_new(FurnitureKind.washbasin));
        againstWall(_new(FurnitureKind.washingMachine));
      case RoomType.wc:
        againstWall(_new(FurnitureKind.toilet), preferNoDoor: true);
        againstWall(_new(FurnitureKind.washbasin));
        if (area >= 3.5) againstWall(_new(FurnitureKind.shower));
      case RoomType.hall:
        againstWall(_new(FurnitureKind.coatRack));
        againstWall(_new(FurnitureKind.plant));
      case RoomType.storage:
        againstWall(_new(FurnitureKind.shelf));
        againstWall(_new(FurnitureKind.shelf));
      case RoomType.balcony:
        final table = againstWall(_new(FurnitureKind.coffeeTable, width: 60));
        if (table != null) beside(table, FurnitureKind.chair, left: true);
        if (table != null) beside(table, FurnitureKind.chair, left: false);
        againstWall(_new(FurnitureKind.plant));
        againstWall(_new(FurnitureKind.plant));
      case RoomType.other:
        break;
    }
  }

  /// Walls longest first; [preferNoDoor] puts walls without a door first, [preferWindow] walls with a window.
  List<_Edge> _wallOrder({bool preferNoDoor = false, bool preferWindow = false}) {
    double score(_Edge edge) {
      var score = edge.length;
      if (preferNoDoor && doors.any((door) => _onEdge(door, edge))) score -= 10000;
      if (preferWindow && windows.any((window) => _onEdge(window, edge))) score += 10000;
      return score;
    }

    return [...edges]..sort((a, b) => score(b).compareTo(score(a)));
  }

  static bool _onEdge((PlanPoint, PlanPoint) segment, _Edge edge) {
    final (a, b) = segment;
    final middle = PlanPoint((a.x + b.x) / 2, (a.y + b.y) / 2);
    return PlanGeometryUtil.distanceToSegment(middle, edge.a, edge.b) < 2;
  }

  /// [item] against the first wall where it fits and [accept] agrees, as close to the wall's middle as possible.
  Furniture? againstWall(
    Furniture item, {
    bool preferNoDoor = false,
    bool preferWindow = false,
    bool Function(Furniture candidate)? accept,
  }) {
    for (final edge in _wallOrder(preferNoDoor: preferNoDoor, preferWindow: preferWindow)) {
      if (edge.length < item.width) continue;
      final middle = edge.length / 2;
      for (var step = 0; step * 10 <= edge.length / 2; step++) {
        for (final along in {middle - step * 10, middle + step * 10}) {
          if (along < item.width / 2 || along > edge.length - item.width / 2) continue;
          final candidate = FurnishingUtil._against(item, edge, along);
          if (fits(candidate) && (accept?.call(candidate) ?? true)) return _keep(candidate);
        }
      }
    }
    return null;
  }

  /// Whether a piece of [kind] would fit next to [anchor] on the given side.
  bool _fitsBeside(Furniture anchor, FurnitureKind kind, {required bool left}) =>
      fits(_besideOf(anchor, kind, left: left), ignore: {anchor.id});

  /// A piece of [kind] next to [anchor] along the same wall, on its left or right.
  Furniture? beside(Furniture anchor, FurnitureKind kind, {required bool left}) {
    final candidate = _besideOf(anchor, kind, left: left);
    return fits(candidate) ? _keep(candidate) : null;
  }

  Furniture _besideOf(Furniture anchor, FurnitureKind kind, {required bool left}) {
    final angle = anchor.rotation * math.pi / 180;
    final side = PlanPoint(math.cos(angle), math.sin(angle));
    final distance = (anchor.width + kind.width) / 2 + 2;
    final sign = left ? -1 : 1;
    final backShift = (anchor.depth - kind.depth) / 2;
    final back = PlanPoint(math.sin(angle), -math.cos(angle));
    return _new(kind).copyWith(
      rotation: anchor.rotation,
      position: PlanPoint(
        anchor.position.x + side.x * distance * sign + back.x * backShift,
        anchor.position.y + side.y * distance * sign + back.y * backShift,
      ),
    );
  }

  /// A piece of [kind] in front of [anchor], [gap] centimeters away, facing it.
  Furniture? inFront(Furniture anchor, FurnitureKind kind, {required double gap}) {
    final angle = anchor.rotation * math.pi / 180;
    final front = PlanPoint(-math.sin(angle), math.cos(angle));
    final distance = anchor.depth / 2 + gap + kind.depth / 2;
    final candidate = _new(kind).copyWith(
      rotation: (anchor.rotation + 180) % 360,
      position: PlanPoint(anchor.position.x + front.x * distance, anchor.position.y + front.y * distance),
    );
    return fits(candidate, ignore: gap < 0 ? {anchor.id} : const {}) ? _keep(candidate) : null;
  }

  /// A flat piece of [kind] centered under [anchor].
  Furniture? under(Furniture anchor, FurnitureKind kind) {
    final candidate = _new(kind).copyWith(rotation: anchor.rotation, position: anchor.position);
    return _inside(candidate) ? _keep(candidate) : null;
  }

  /// A piece of [kind] against the wall facing [anchor], in line with it.
  Furniture? opposite(Furniture anchor, FurnitureKind kind) {
    final angle = anchor.rotation * math.pi / 180;
    final front = PlanPoint(-math.sin(angle), math.cos(angle));
    for (final edge in edges) {
      if (edge.inward.x * front.x + edge.inward.y * front.y > -0.9) continue;
      final along = PlanGeometryUtil.segmentParameter(anchor.position, edge.a, edge.b) * edge.length;
      if (along < kind.width / 2 || along > edge.length - kind.width / 2) continue;
      final candidate = FurnishingUtil._against(_new(kind), edge, along);
      if (fits(candidate)) return _keep(candidate);
    }
    return null;
  }

  /// Kitchen counters along the longest wall that has room for at least two, as one piece.
  Furniture? counterRun() {
    for (final edge in _wallOrder(preferNoDoor: true)) {
      for (var width = (edge.length / 60).floor() * 60.0; width >= 120; width -= 60) {
        final item = _new(FurnitureKind.counter, width: width - 60);
        for (final along in [width / 2 - 30, edge.length - width / 2 + 30]) {
          if (along < item.width / 2 || along > edge.length - item.width / 2) continue;
          final candidate = FurnishingUtil._against(item, edge, along);
          if (fits(candidate)) return _keep(candidate);
        }
      }
    }
    return null;
  }

  /// A piece of [kind] at one end of [run], else anywhere against a wall.
  Furniture? besideRun(Furniture run, FurnitureKind kind) =>
      beside(run, kind, left: false) ?? beside(run, kind, left: true) ?? againstWall(_new(kind));

  /// A table with chairs in the free middle of the room.
  void diningSet({required int chairs}) {
    final center = PlanGeometryUtil.interiorPoint(outline);
    final widths = chairs > 2 ? [FurnitureKind.diningTable.width, 120.0] : [90.0];
    for (final width in widths) {
      final table = _new(FurnitureKind.diningTable, width: width).copyWith(position: center);
      if (!fits(table, margin: 50)) continue;
      _keep(table);
      final seats = chairs > 2 ? [-width / 4, width / 4] : [0.0];
      for (final x in seats) {
        for (final side in [-1, 1]) {
          final chair = _new(FurnitureKind.chair).copyWith(
            rotation: side < 0 ? 0 : 180,
            position: PlanPoint(center.x + x, center.y + side * (table.depth / 2 + 15)),
          );
          if (fits(chair, ignore: {table.id})) _keep(chair);
        }
      }
      return;
    }
  }

  Furniture _keep(Furniture item) {
    placed.add(item);
    return item;
  }

  /// Inside the room, clear of other furniture, of the space doors need, and – when tall – of windows.
  bool fits(Furniture item, {double margin = 0, Set<String> ignore = const {}}) {
    if (!_inside(item)) return false;
    final corners = FurnishingUtil.cornersOf(item);
    for (final other in [...layout.furniture, ...placed]) {
      if (other.kind.isFlat || item.kind.isFlat || ignore.contains(other.id)) continue;
      if (_overlap(corners, FurnishingUtil.cornersOf(other), margin: margin)) return false;
    }
    for (final (a, b) in doors) {
      if (_nearSegment(corners, a, b, FurnishingUtil.doorClearance)) return false;
    }
    if (item.kind.height > 100) {
      for (final (a, b) in windows) {
        if (_nearSegment(corners, a, b, 30)) return false;
      }
    }
    return true;
  }

  bool _inside(Furniture item) =>
      FurnishingUtil.cornersOf(item).every((corner) => PlanGeometryUtil.containsPoint(outline, corner));

  /// Whether the box of [corners] comes closer than [distance] to the opening from [a] to [b].
  static bool _nearSegment(List<PlanPoint> corners, PlanPoint a, PlanPoint b, double distance) {
    final length = a.distanceTo(b);
    if (length == 0) return false;
    final normal = PlanPoint(-(b.y - a.y) / length * distance, (b.x - a.x) / length * distance);
    final zone = [a + normal, b + normal, b - normal, a - normal];
    return _overlap(corners, zone);
  }

  /// Separating axis test for two convex quadrilaterals, grown by [margin].
  static bool _overlap(List<PlanPoint> first, List<PlanPoint> second, {double margin = 0}) {
    for (final shape in [first, second]) {
      for (var i = 0; i < shape.length; i++) {
        final a = shape[i];
        final b = shape[(i + 1) % shape.length];
        final axis = PlanPoint(-(b.y - a.y), b.x - a.x);
        final length = math.sqrt(axis.x * axis.x + axis.y * axis.y);
        if (length == 0) continue;
        double project(PlanPoint p) => (p.x * axis.x + p.y * axis.y) / length;
        final firstValues = first.map(project);
        final secondValues = second.map(project);
        if (firstValues.reduce(math.max) + margin <= secondValues.reduce(math.min) ||
            secondValues.reduce(math.max) + margin <= firstValues.reduce(math.min)) {
          return false;
        }
      }
    }
    return true;
  }
}
