import 'dart:math' as math;
import 'dart:ui';

import 'package:smart_hub/domain/floorplan/model/plan_point.dart';

/// Maps plan centimeters to logical pixels and back. The plan is scaled uniformly to fit the available size.
final class PlanTransform {
  const PlanTransform({required this.scale, required this.origin, required this.bounds});

  /// Fits [bounds] into [size], centered, with [inset] pixels kept free on every side.
  factory PlanTransform.fit(PlanRect bounds, Size size, {double inset = 0}) {
    final available = Size(math.max(0, size.width - 2 * inset), math.max(0, size.height - 2 * inset));
    final scale = bounds.width == 0 || bounds.height == 0
        ? 1.0
        : math.min(available.width / bounds.width, available.height / bounds.height);
    final planSize = Size(bounds.width * scale, bounds.height * scale);
    final origin = Offset((size.width - planSize.width) / 2, (size.height - planSize.height) / 2);
    return PlanTransform(scale: scale, origin: origin, bounds: bounds);
  }

  /// Pixels per centimeter.
  final double scale;

  /// Pixel position of the top left corner of [bounds].
  final Offset origin;
  final PlanRect bounds;

  Offset toPx(PlanPoint point) => origin + Offset((point.x - bounds.left) * scale, (point.y - bounds.top) * scale);

  PlanPoint toPlan(Offset px) {
    return PlanPoint((px.dx - origin.dx) / scale + bounds.left, (px.dy - origin.dy) / scale + bounds.top);
  }

  Path pathOf(List<PlanPoint> polygon) => Path()..addPolygon([for (final p in polygon) toPx(p)], true);

  /// Plan width in pixels.
  double get width => bounds.width * scale;

  @override
  bool operator ==(Object other) =>
      other is PlanTransform && other.scale == scale && other.origin == origin && other.bounds == bounds;

  @override
  int get hashCode => Object.hash(scale, origin, bounds);
}
