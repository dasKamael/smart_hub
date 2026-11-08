import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui';

import 'package:smart_hub/domain/floorplan/model/plan_point.dart';

/// Looks at the home from far away (no perspective): turned by [yaw] around the vertical axis and tilted by [pitch]
/// (π/2 looks straight down, smaller values look from the front). [scale] is pixels per cm; the plan point [center]
/// lands at [origin] on screen.
final class SceneCamera {
  const SceneCamera({
    required this.yaw,
    required this.pitch,
    required this.scale,
    required this.origin,
    required this.center,
  });

  /// Fits [corners] (cm) into [size] with [padding] pixels around.
  factory SceneCamera.fit(
    Iterable<(double, double, double)> corners,
    Size size, {
    required double yaw,
    required double pitch,
    double padding = 16,
  }) {
    final list = corners.toList();
    if (list.isEmpty) return SceneCamera(yaw: yaw, pitch: pitch, scale: 1, origin: Offset.zero, center: PlanPoint.zero);
    var minX = double.infinity;
    var maxX = -double.infinity;
    var minY = double.infinity;
    var maxY = -double.infinity;
    for (final (x, y, _) in list) {
      minX = math.min(minX, x);
      maxX = math.max(maxX, x);
      minY = math.min(minY, y);
      maxY = math.max(maxY, y);
    }
    final center = PlanPoint((minX + maxX) / 2, (minY + maxY) / 2);
    final unit = SceneCamera(yaw: yaw, pitch: pitch, scale: 1, origin: Offset.zero, center: center);
    var left = double.infinity;
    var right = -double.infinity;
    var top = double.infinity;
    var bottom = -double.infinity;
    for (final (x, y, z) in list) {
      final p = unit.project(x, y, z);
      left = math.min(left, p.dx);
      right = math.max(right, p.dx);
      top = math.min(top, p.dy);
      bottom = math.max(bottom, p.dy);
    }
    final width = math.max(right - left, 1.0);
    final height = math.max(bottom - top, 1.0);
    final scale = math.max(0.01, math.min((size.width - 2 * padding) / width, (size.height - 2 * padding) / height));
    final origin = Offset(size.width / 2 - (left + right) / 2 * scale, size.height / 2 - (top + bottom) / 2 * scale);
    return SceneCamera(yaw: yaw, pitch: pitch, scale: scale, origin: origin, center: center);
  }

  final double yaw;
  final double pitch;
  final double scale;
  final Offset origin;
  final PlanPoint center;

  /// A plan direction turned into the camera's frame: x to the right, y towards the viewer.
  (double, double) turn(double dx, double dy) {
    final c = math.cos(yaw);
    final s = math.sin(yaw);
    return (dx * c - dy * s, dx * s + dy * c);
  }

  Offset project(double x, double y, double z) {
    final (rx, ry) = turn(x - center.x, y - center.y);
    return origin + Offset(rx * scale, (ry * math.sin(pitch) - z * math.cos(pitch)) * scale);
  }

  Offset projectPoint(PlanPoint point, [double z = 0]) => project(point.x, point.y, z);

  /// How close to the viewer a point is; larger is nearer.
  double depth(double x, double y, double z) {
    final (_, ry) = turn(x - center.x, y - center.y);
    return ry * math.cos(pitch) + z * math.sin(pitch);
  }

  /// The order to draw in, back to front: by the position on the floor towards the viewer, so that things standing
  /// on the floor hide what is behind them whatever their height; height only counts when looking from (nearly)
  /// straight above.
  double drawOrder(double x, double y, double z) {
    final (_, ry) = turn(x - center.x, y - center.y);
    return ry * math.cos(pitch) + z * math.pow(math.sin(pitch), 30);
  }

  /// The plan point at height [z] seen at [screen].
  PlanPoint unproject(Offset screen, [double z = 0]) {
    final rx = (screen.dx - origin.dx) / scale;
    final ry = ((screen.dy - origin.dy) / scale + z * math.cos(pitch)) / math.sin(pitch);
    final c = math.cos(-yaw);
    final s = math.sin(-yaw);
    return PlanPoint(rx * c - ry * s + center.x, rx * s + ry * c + center.y);
  }

  /// The transform that draws plan coordinates (cm) lying flat at height [z], for `Canvas.transform`.
  Float64List planeAt(double z) {
    final c = math.cos(yaw);
    final s = math.sin(yaw);
    final sp = math.sin(pitch);
    final cp = math.cos(pitch);
    final a = scale * c;
    final b = scale * sp * s;
    final cc = -scale * s;
    final d = scale * sp * c;
    final tx = origin.dx - scale * (c * center.x - s * center.y);
    final ty = origin.dy - scale * sp * (s * center.x + c * center.y) - scale * cp * z;
    return Float64List.fromList([a, b, 0, 0, cc, d, 0, 0, 0, 0, 1, 0, tx, ty, 0, 1]);
  }

  /// Looking straight down, north up – the plan as on paper.
  static const topYaw = 0.0;
  static const topPitch = math.pi / 2;

  /// The angle of `appartment.mp4`: turned a little to the left, looking down from the front.
  static const tiltedYaw = -28 * math.pi / 180;
  static const tiltedPitch = 61 * math.pi / 180;

  @override
  bool operator ==(Object other) =>
      other is SceneCamera &&
      other.yaw == yaw &&
      other.pitch == pitch &&
      other.scale == scale &&
      other.origin == origin &&
      other.center == center;

  @override
  int get hashCode => Object.hash(yaw, pitch, scale, origin, center);
}
