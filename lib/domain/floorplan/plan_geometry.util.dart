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

  /// The point of the segment from [a] to [b] closest to [point].
  static PlanPoint closestOnSegment(PlanPoint point, PlanPoint a, PlanPoint b) {
    final t = segmentParameter(point, a, b).clamp(0.0, 1.0);
    return PlanPoint(a.x + (b.x - a.x) * t, a.y + (b.y - a.y) * t);
  }

  /// Where [point] projects onto the line through [a] and [b]: 0 at [a], 1 at [b].
  static double segmentParameter(PlanPoint point, PlanPoint a, PlanPoint b) {
    final dx = b.x - a.x;
    final dy = b.y - a.y;
    final lengthSquared = dx * dx + dy * dy;
    if (lengthSquared == 0) return 0;
    return ((point.x - a.x) * dx + (point.y - a.y) * dy) / lengthSquared;
  }

  static double distanceToSegment(PlanPoint point, PlanPoint a, PlanPoint b) =>
      point.distanceTo(closestOnSegment(point, a, b));

  /// Distance of [point] to the nearest edge of [polygon].
  static double distanceToOutline(PlanPoint point, List<PlanPoint> polygon) {
    var best = double.infinity;
    for (var i = 0; i < polygon.length; i++) {
      best = math.min(best, distanceToSegment(point, polygon[i], polygon[(i + 1) % polygon.length]));
    }
    return best;
  }

  /// Distance of [point] to the infinite line through [a] and [b].
  static double distanceToLine(PlanPoint point, PlanPoint a, PlanPoint b) {
    final length = a.distanceTo(b);
    if (length == 0) return point.distanceTo(a);
    return ((b.x - a.x) * (a.y - point.y) - (a.x - point.x) * (b.y - a.y)).abs() / length;
  }

  /// Where the segments [a]–[b] and [c]–[d] cross, not counting their ends (within [margin]) and parallel segments.
  static PlanPoint? crossing(PlanPoint a, PlanPoint b, PlanPoint c, PlanPoint d, {double margin = 1}) {
    final r = b - a;
    final s = d - c;
    final denominator = r.x * s.y - r.y * s.x;
    if (denominator.abs() < 1e-9) return null;
    final qp = c - a;
    final t = (qp.x * s.y - qp.y * s.x) / denominator;
    final u = (qp.x * r.y - qp.y * r.x) / denominator;
    final rLength = a.distanceTo(b);
    final sLength = c.distanceTo(d);
    if (t * rLength < margin || (1 - t) * rLength < margin) return null;
    if (u * sLength < margin || (1 - u) * sLength < margin) return null;
    return PlanPoint(a.x + r.x * t, a.y + r.y * t);
  }

  /// Twice the signed area: positive when the corners run clockwise on screen (y pointing down).
  static double signedArea(List<PlanPoint> polygon) {
    var sum = 0.0;
    for (var i = 0; i < polygon.length; i++) {
      final p = polygon[i];
      final q = polygon[(i + 1) % polygon.length];
      sum += p.x * q.y - q.x * p.y;
    }
    return sum;
  }

  /// A point well inside [polygon]: its centroid when that lies inside, otherwise the middle of the widest inside
  /// stretch of a horizontal line through it.
  static PlanPoint interiorPoint(List<PlanPoint> polygon) {
    final twiceArea = signedArea(polygon);
    var x = 0.0;
    var y = 0.0;
    for (var i = 0; i < polygon.length; i++) {
      final p = polygon[i];
      final q = polygon[(i + 1) % polygon.length];
      final cross = p.x * q.y - q.x * p.y;
      x += (p.x + q.x) * cross;
      y += (p.y + q.y) * cross;
    }
    if (twiceArea.abs() < 1e-9) return polygon.first;
    final centroid = PlanPoint(x / (3 * twiceArea), y / (3 * twiceArea));
    if (containsPoint(polygon, centroid)) return centroid;
    // Scan a few lines across the polygon and take the widest inside stretch.
    final ys = polygon.map((p) => p.y);
    final top = ys.reduce(math.min);
    final bottom = ys.reduce(math.max);
    PlanPoint? best;
    var bestWidth = 0.0;
    for (var step = 1; step < 8; step++) {
      final scanY = top + (bottom - top) * step / 8;
      final xs = <double>[];
      for (var i = 0; i < polygon.length; i++) {
        final p = polygon[i];
        final q = polygon[(i + 1) % polygon.length];
        if ((p.y > scanY) != (q.y > scanY)) xs.add(p.x + (scanY - p.y) / (q.y - p.y) * (q.x - p.x));
      }
      xs.sort();
      for (var i = 0; i + 1 < xs.length; i += 2) {
        if (xs[i + 1] - xs[i] > bestWidth) {
          bestWidth = xs[i + 1] - xs[i];
          best = PlanPoint((xs[i] + xs[i + 1]) / 2, scanY);
        }
      }
    }
    return best ?? centroid;
  }
}
