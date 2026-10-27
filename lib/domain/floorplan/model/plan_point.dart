import 'dart:math' as math;

/// A point on the floor plan in centimeters. Pixels only exist in the presentation layer.
final class PlanPoint {
  const PlanPoint(this.x, this.y);

  static const zero = PlanPoint(0, 0);

  final double x;
  final double y;

  PlanPoint operator +(PlanPoint other) => PlanPoint(x + other.x, y + other.y);

  PlanPoint operator -(PlanPoint other) => PlanPoint(x - other.x, y - other.y);

  double distanceTo(PlanPoint other) => math.sqrt(math.pow(x - other.x, 2) + math.pow(y - other.y, 2));

  @override
  bool operator ==(Object other) => other is PlanPoint && other.x == x && other.y == y;

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => 'PlanPoint($x, $y)';
}

/// Axis aligned rectangle on the plan in centimeters.
final class PlanRect {
  const PlanRect({required this.left, required this.top, required this.right, required this.bottom});

  final double left;
  final double top;
  final double right;
  final double bottom;

  double get width => right - left;

  double get height => bottom - top;

  @override
  bool operator ==(Object other) =>
      other is PlanRect && other.left == left && other.top == top && other.right == right && other.bottom == bottom;

  @override
  int get hashCode => Object.hash(left, top, right, bottom);

  @override
  String toString() => 'PlanRect($left, $top, $right, $bottom)';
}
