import 'dart:math' as math;

import 'package:smart_hub/domain/floorplan/model/floor_plan.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';

/// Geometry on the floor plan. Pure functions, all values in centimeters.
abstract final class PlanGeometryUtil {
  /// Minimum distance of a device to the plan border.
  static const borderMargin = 20.0;

  /// Even-odd rule. Points exactly on an edge count as inside for the left/top edges and outside for the
  /// right/bottom edges, so a point on a shared wall belongs to exactly one of two adjacent rooms.
  static bool containsPoint(List<PlanPoint> polygon, PlanPoint point) {
    var inside = false;
    for (var i = 0, j = polygon.length - 1; i < polygon.length; j = i++) {
      final a = polygon[i];
      final b = polygon[j];
      final crossesRow = (a.y > point.y) != (b.y > point.y);
      if (crossesRow && point.x < (b.x - a.x) * (point.y - a.y) / (b.y - a.y) + a.x) inside = !inside;
    }
    return inside;
  }

  /// Bounding box of all rooms and walls.
  static PlanRect bounds(FloorPlan plan) {
    final points = [for (final room in plan.rooms) ...room.polygon, for (final wall in plan.walls) ...wall.polygon];
    if (points.isEmpty) return const PlanRect(left: 0, top: 0, right: 0, bottom: 0);
    return PlanRect(
      left: points.map((p) => p.x).reduce(math.min),
      top: points.map((p) => p.y).reduce(math.min),
      right: points.map((p) => p.x).reduce(math.max),
      bottom: points.map((p) => p.y).reduce(math.max),
    );
  }

  /// Keeps [point] at least [margin] inside [bounds].
  static PlanPoint clampInside(PlanPoint point, PlanRect bounds, {double margin = borderMargin}) {
    return PlanPoint(
      point.x.clamp(bounds.left + margin, math.max(bounds.left + margin, bounds.right - margin)),
      point.y.clamp(bounds.top + margin, math.max(bounds.top + margin, bounds.bottom - margin)),
    );
  }

  /// Area of [polygon] in square meters (shoelace formula).
  static double areaInSquareMeters(List<PlanPoint> polygon) {
    var twiceArea = 0.0;
    for (var i = 0, j = polygon.length - 1; i < polygon.length; j = i++) {
      twiceArea += (polygon[j].x + polygon[i].x) * (polygon[j].y - polygon[i].y);
    }
    return twiceArea.abs() / 2 / 10000;
  }
}
