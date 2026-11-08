import 'dart:math' as math;

import 'package:smart_hub/domain/floorplan/model/home_layout.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/domain/floorplan/plan_geometry.util.dart';

/// Changes to the walls of a [HomeLayout]. Walls form one connected drawing: a wall between two rooms exists once,
/// walls meet in shared junctions, and a wall that another one ends on is split there. Openings stay on their walls.
abstract final class LayoutGraphUtil {
  /// Two points closer than this are the same junction.
  static const tolerance = 1.0;

  /// Adds a wall from [a] to [b]. Ends on existing junctions or walls connect to them; crossed walls are split; parts
  /// that already exist are not added twice.
  static HomeLayout addWall(HomeLayout layout, PlanPoint a, PlanPoint b, {double? thickness}) {
    if (a.distanceTo(b) < tolerance) return layout;
    final graph = _Graph(layout);
    final start = graph.junctionAt(a);
    final end = graph.junctionAt(b);
    if (start == end) return layout;
    graph.connect(start, end, thickness ?? LayoutWall.innerThickness);
    return graph.build();
  }

  /// Adds the four walls of a rectangle between two opposite corners.
  static HomeLayout addRectangle(HomeLayout layout, PlanPoint from, PlanPoint to, {double? thickness}) {
    final corners = [from, PlanPoint(to.x, from.y), to, PlanPoint(from.x, to.y)];
    var result = layout;
    for (var i = 0; i < 4; i++) {
      result = addWall(result, corners[i], corners[(i + 1) % 4], thickness: thickness);
    }
    return result;
  }

  /// Adds walls along [points] one after another (a closed outline when the last point is the first one).
  static HomeLayout addChain(HomeLayout layout, List<PlanPoint> points, {double? thickness}) {
    var result = layout;
    for (var i = 0; i + 1 < points.length; i++) {
      result = addWall(result, points[i], points[i + 1], thickness: thickness);
    }
    return result;
  }

  /// Puts a junction on the wall at [point] (splitting it), e.g. to bend the wall there afterwards.
  static HomeLayout splitAt(HomeLayout layout, PlanPoint point) {
    final graph = _Graph(layout);
    final before = graph.nodes.length;
    graph.junctionAt(point);
    return graph.nodes.length == before ? layout : graph.build();
  }

  /// Removes wall [wallId] with its openings. Junctions left alone disappear, and two straight walls left meeting in
  /// a junction become one again.
  static HomeLayout removeWall(HomeLayout layout, String wallId) {
    final wall = layout.walls.where((wall) => wall.id == wallId).firstOrNull;
    if (wall == null) return layout;
    final graph = _Graph(layout)..removeWall(wallId);
    graph
      ..tidy(wall.from)
      ..tidy(wall.to);
    return graph.build();
  }

  /// Moves junction [nodeId] to [to]; its walls follow. Openings keep their relative place on those walls.
  static HomeLayout moveNode(HomeLayout layout, String nodeId, PlanPoint to) {
    final graph = _Graph(layout);
    if (!graph.nodes.containsKey(nodeId)) return layout;
    final relative = {
      for (final opening in graph.openings)
        if (graph.wall(opening.wallId) case final wall? when wall.from == nodeId || wall.to == nodeId)
          opening.id: opening.offset / math.max(graph.length(wall), tolerance),
    };
    graph.nodes[nodeId] = to;
    graph.openings = [
      for (final opening in graph.openings)
        switch (relative[opening.id]) {
          final t? => graph.fitted(opening.copyWith(offset: t * graph.length(graph.wall(opening.wallId)!))),
          null => opening,
        },
    ];
    return graph.build();
  }

  /// Moves wall [wallId] across itself by the part of [delta] perpendicular to it. Walls meeting its ends stretch;
  /// where a wall continues straight on beyond an end, the moved wall breaks away from it with a short jog (along a
  /// wall already there when there is one). Openings on other walls stay where they are.
  static HomeLayout moveWall(HomeLayout layout, String wallId, PlanPoint delta) {
    final graph = _Graph(layout);
    final wall = graph.wall(wallId);
    if (wall == null) return layout;
    final p = graph.nodes[wall.from]!;
    final q = graph.nodes[wall.to]!;
    final length = p.distanceTo(q);
    if (length < tolerance) return layout;
    final direction = PlanPoint((q.x - p.x) / length, (q.y - p.y) / length);
    final normal = PlanPoint(-direction.y, direction.x);
    final across = delta.x * normal.x + delta.y * normal.y;
    if (across.abs() < tolerance) return layout;
    final shift = PlanPoint(normal.x * across, normal.y * across);

    final absolute = graph.openingCenters();
    var moved = wall;
    for (final end in [wall.from, wall.to]) {
      final position = graph.nodes[end]!;
      final target = position + shift;
      final continues = graph.wallsAt(end).any((other) {
        if (other.id == wallId) return false;
        final away = graph.nodes[other.from == end ? other.to : other.from]! - position;
        final awayLength = math.sqrt(away.x * away.x + away.y * away.y);
        if (awayLength < tolerance) return false;
        final cross = (away.x * direction.y - away.y * direction.x) / awayLength;
        return cross.abs() < 0.02;
      });
      if (!continues) {
        graph.nodes[end] = target;
        continue;
      }
      // Break away from the straight continuation: onto a wall leading the same way, or with a new short wall.
      final junction = graph.junctionAt(target, except: {wallId});
      if (junction != end) {
        if (!graph.connected(end, junction)) graph.connect(end, junction, wall.thickness);
        moved = moved.from == end ? moved.copyWith(from: junction) : moved.copyWith(to: junction);
        graph.replaceWall(moved);
      }
    }
    graph.keepOpeningsAt(absolute, except: {wallId});
    return graph.build();
  }

  /// The junction closest to [point] within [radius].
  static LayoutNode? nodeAt(HomeLayout layout, PlanPoint point, {required double radius}) {
    LayoutNode? best;
    var bestDistance = radius;
    for (final node in layout.nodes) {
      final distance = node.position.distanceTo(point);
      if (distance < bestDistance) {
        bestDistance = distance;
        best = node;
      }
    }
    return best;
  }

  /// The wall closest to [point] within [radius].
  static LayoutWall? wallAt(HomeLayout layout, PlanPoint point, {required double radius}) {
    final positions = {for (final node in layout.nodes) node.id: node.position};
    LayoutWall? best;
    var bestDistance = radius;
    for (final wall in layout.walls) {
      final distance = PlanGeometryUtil.distanceToSegment(point, positions[wall.from]!, positions[wall.to]!);
      if (distance < bestDistance) {
        bestDistance = distance;
        best = wall;
      }
    }
    return best;
  }

  /// Both ends of [wall].
  static (PlanPoint, PlanPoint) endsOf(HomeLayout layout, LayoutWall wall) {
    PlanPoint at(String id) => layout.nodes.firstWhere((node) => node.id == id).position;
    return (at(wall.from), at(wall.to));
  }

  /// [opening] as a segment on its wall.
  static (PlanPoint, PlanPoint)? openingSegment(HomeLayout layout, LayoutOpening opening) {
    final wall = layout.walls.where((wall) => wall.id == opening.wallId).firstOrNull;
    if (wall == null) return null;
    final (a, b) = endsOf(layout, wall);
    final length = a.distanceTo(b);
    if (length < tolerance) return null;
    PlanPoint along(double distance) {
      final t = (distance / length).clamp(0.0, 1.0);
      return PlanPoint(a.x + (b.x - a.x) * t, a.y + (b.y - a.y) * t);
    }

    return (along(opening.offset - opening.width / 2), along(opening.offset + opening.width / 2));
  }

  /// [opening] on its wall, its middle moved to the point of the wall nearest to [to] and kept on the wall.
  static LayoutOpening placedAt(HomeLayout layout, LayoutOpening opening, PlanPoint to) {
    final wall = layout.walls.where((wall) => wall.id == opening.wallId).firstOrNull;
    if (wall == null) return opening;
    final (a, b) = endsOf(layout, wall);
    final length = a.distanceTo(b);
    final width = math.min(opening.width, length);
    final offset = (PlanGeometryUtil.segmentParameter(to, a, b) * length).clamp(width / 2, length - width / 2);
    return opening.copyWith(offset: offset, width: width);
  }

  /// The first `<prefix><n>` (n ≥ 1) not in [existing].
  static String nextId(String prefix, Iterable<String> existing) {
    final taken = existing.toSet();
    var n = 1;
    while (taken.contains('$prefix$n')) {
      n++;
    }
    return '$prefix$n';
  }
}

/// Mutable working copy of a layout's walls while one change is applied.
class _Graph {
  _Graph(this.layout)
    : nodes = {for (final node in layout.nodes) node.id: node.position},
      walls = [...layout.walls],
      openings = [...layout.openings],
      _nodeSeq = _highest(layout.nodes.map((node) => node.id), 'n'),
      _wallSeq = _highest(layout.walls.map((wall) => wall.id), 'w');

  final HomeLayout layout;
  final Map<String, PlanPoint> nodes;
  final List<LayoutWall> walls;
  List<LayoutOpening> openings;
  int _nodeSeq;
  int _wallSeq;

  static const _tolerance = LayoutGraphUtil.tolerance;

  static int _highest(Iterable<String> ids, String prefix) {
    var highest = 0;
    final pattern = RegExp('^$prefix(\\d+)\$');
    for (final id in ids) {
      final n = int.tryParse(pattern.firstMatch(id)?.group(1) ?? '');
      if (n != null && n > highest) highest = n;
    }
    return highest;
  }

  HomeLayout build() {
    final used = {
      for (final wall in walls) ...[wall.from, wall.to],
    };
    return layout.copyWith(
      nodes: [
        for (final MapEntry(key: id, value: position) in nodes.entries)
          if (used.contains(id)) LayoutNode(id: id, position: position),
      ],
      walls: List.unmodifiable(walls),
      openings: List.unmodifiable(openings),
    );
  }

  LayoutWall? wall(String id) => walls.where((wall) => wall.id == id).firstOrNull;

  double length(LayoutWall wall) => nodes[wall.from]!.distanceTo(nodes[wall.to]!);

  Iterable<LayoutWall> wallsAt(String node) => walls.where((wall) => wall.from == node || wall.to == node);

  bool connected(String a, String b) =>
      walls.any((wall) => (wall.from == a && wall.to == b) || (wall.from == b && wall.to == a));

  void replaceWall(LayoutWall replacement) {
    final index = walls.indexWhere((wall) => wall.id == replacement.id);
    if (index >= 0) walls[index] = replacement;
  }

  void removeWall(String id) {
    walls.removeWhere((wall) => wall.id == id);
    openings = [
      for (final opening in openings)
        if (opening.wallId != id) opening,
    ];
  }

  String newNode(PlanPoint position) {
    final id = 'n${++_nodeSeq}';
    nodes[id] = position;
    return id;
  }

  String newWallId() => 'w${++_wallSeq}';

  /// The junction at [point]: an existing one nearby, a new one splitting the wall [point] lies on, or a new one.
  String junctionAt(PlanPoint point, {Set<String> except = const {}}) {
    String? nearest;
    var nearestDistance = _tolerance;
    for (final MapEntry(key: id, value: position) in nodes.entries) {
      final distance = position.distanceTo(point);
      if (distance < nearestDistance && wallsAt(id).any((wall) => !except.contains(wall.id))) {
        nearestDistance = distance;
        nearest = id;
      }
    }
    if (nearest != null) return nearest;
    for (final wall in [...walls]) {
      if (except.contains(wall.id)) continue;
      final a = nodes[wall.from]!;
      final b = nodes[wall.to]!;
      if (PlanGeometryUtil.distanceToSegment(point, a, b) < _tolerance) {
        return split(wall, PlanGeometryUtil.closestOnSegment(point, a, b));
      }
    }
    return newNode(point);
  }

  /// Splits [wall] at [point] into two walls meeting in a new junction; openings go with the part they are on.
  String split(LayoutWall wall, PlanPoint point) {
    final a = nodes[wall.from]!;
    final firstLength = a.distanceTo(point);
    final node = newNode(point);
    final second = LayoutWall(id: newWallId(), from: node, to: wall.to, thickness: wall.thickness);
    replaceWall(wall.copyWith(to: node));
    walls.add(second);
    openings = [
      for (final opening in openings)
        if (opening.wallId != wall.id)
          opening
        else if (opening.offset <= firstLength)
          fitted(opening)
        else
          fitted(opening.copyWith(wallId: second.id, offset: opening.offset - firstLength)),
    ];
    return node;
  }

  /// Adds walls from [start] to [end], split at every junction on the way and at every wall crossed; parts that exist
  /// already are kept as they are.
  void connect(String start, String end, double thickness) {
    final a = nodes[start]!;
    final b = nodes[end]!;
    for (final wall in [...walls]) {
      if (wall.from == start || wall.to == start || wall.from == end || wall.to == end) continue;
      final crossing = PlanGeometryUtil.crossing(a, b, nodes[wall.from]!, nodes[wall.to]!);
      if (crossing != null) split(wall, crossing);
    }
    final stops = [
      for (final MapEntry(key: id, value: position) in nodes.entries)
        if (id != start &&
            id != end &&
            wallsAt(id).isNotEmpty &&
            PlanGeometryUtil.distanceToSegment(position, a, b) < _tolerance)
          (id, PlanGeometryUtil.segmentParameter(position, a, b)),
    ]..sort((x, y) => x.$2.compareTo(y.$2));
    final path = [start, for (final (id, _) in stops) id, end];
    for (var i = 0; i + 1 < path.length; i++) {
      if (!connected(path[i], path[i + 1])) {
        walls.add(LayoutWall(id: newWallId(), from: path[i], to: path[i + 1], thickness: thickness));
      }
    }
  }

  /// Removes [node] when no wall is left on it, or joins its two walls when they run straight through it.
  void tidy(String node) {
    final attached = wallsAt(node).toList();
    if (attached.length != 2) return;
    final [first, second] = attached;
    if (first.thickness != second.thickness) return;
    final firstFar = first.from == node ? first.to : first.from;
    final secondFar = second.from == node ? second.to : second.from;
    final position = nodes[node]!;
    if (PlanGeometryUtil.distanceToLine(position, nodes[firstFar]!, nodes[secondFar]!) >= _tolerance) return;
    if (PlanGeometryUtil.segmentParameter(position, nodes[firstFar]!, nodes[secondFar]!) <= 0) return;
    if (connected(firstFar, secondFar)) return;
    final centers = openingCenters();
    final joined = first.copyWith(from: firstFar, to: secondFar);
    walls.removeWhere((wall) => wall.id == second.id);
    replaceWall(joined);
    openings = [
      for (final opening in openings) opening.wallId == second.id ? opening.copyWith(wallId: joined.id) : opening,
    ];
    keepOpeningsAt(centers, only: {joined.id});
  }

  /// The middle of every opening on the plan as it is now.
  Map<String, PlanPoint> openingCenters() {
    final current = build();
    return {
      for (final opening in openings)
        if (LayoutGraphUtil.openingSegment(current, opening) case (final a, final b))
          opening.id: PlanPoint((a.x + b.x) / 2, (a.y + b.y) / 2),
    };
  }

  /// Puts openings back at the [centers] they had, on their (changed) walls.
  void keepOpeningsAt(Map<String, PlanPoint> centers, {Set<String> except = const {}, Set<String>? only}) {
    final current = build();
    openings = [
      for (final opening in openings)
        if (except.contains(opening.wallId) || (only != null && !only.contains(opening.wallId)))
          opening
        else if (centers[opening.id] case final center?)
          LayoutGraphUtil.placedAt(current, opening, center)
        else
          opening,
    ];
  }

  /// [opening] kept within its wall, narrowed when the wall got shorter than it.
  LayoutOpening fitted(LayoutOpening opening) {
    final wall = this.wall(opening.wallId);
    if (wall == null) return opening;
    final length = this.length(wall);
    final width = math.min(opening.width, length);
    return opening.copyWith(width: width, offset: opening.offset.clamp(width / 2, length - width / 2));
  }
}
