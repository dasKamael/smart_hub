import 'dart:math' as math;
import 'dart:ui';

import 'package:smart_hub/domain/floorplan/model/plan_point.dart';

/// Which part of the plan the editor shows: [scale] pixels per centimeter, the plan origin at [offset].
final class EditorViewport {
  const EditorViewport({required this.scale, required this.offset});

  /// Shows all [points] centered in [size] with [padding] centimeters around them.
  factory EditorViewport.fit(List<PlanPoint> points, Size size, {double padding = 80}) {
    final xs = points.isEmpty ? const [0.0, 1000.0] : points.map((p) => p.x);
    final ys = points.isEmpty ? const [0.0, 500.0] : points.map((p) => p.y);
    final left = xs.reduce(math.min) - padding;
    final top = ys.reduce(math.min) - padding;
    final width = xs.reduce(math.max) + padding - left;
    final height = ys.reduce(math.max) + padding - top;
    final scale = math.min(size.width / width, size.height / height).clamp(minScale, maxScale);
    return EditorViewport(
      scale: scale,
      offset: Offset((size.width - width * scale) / 2 - left * scale, (size.height - height * scale) / 2 - top * scale),
    );
  }

  static const minScale = 0.1;
  static const maxScale = 4.0;

  final double scale;
  final Offset offset;

  double get cmPerPx => 1 / scale;

  Offset toPx(PlanPoint point) => offset + Offset(point.x * scale, point.y * scale);

  PlanPoint toPlan(Offset px) => PlanPoint((px.dx - offset.dx) / scale, (px.dy - offset.dy) / scale);

  EditorViewport panned(Offset delta) => EditorViewport(scale: scale, offset: offset + delta);

  /// Zoomed to [newScale] with [anchor] (plan) staying under [focal] (pixels).
  EditorViewport zoomed(double newScale, {required PlanPoint anchor, required Offset focal}) {
    final clamped = newScale.clamp(minScale, maxScale);
    return EditorViewport(scale: clamped, offset: focal - Offset(anchor.x * clamped, anchor.y * clamped));
  }

  @override
  bool operator ==(Object other) => other is EditorViewport && other.scale == scale && other.offset == offset;

  @override
  int get hashCode => Object.hash(scale, offset);
}
