import 'dart:math' as math;

import 'package:smart_hub/domain/floorplan/model/home_layout.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';

/// Handles on a selected piece of furniture: [width] on its right side, [depth] on its front, [turn] further out in
/// front of it.
enum FurnitureHandle { turn, width, depth }

/// Turning, resizing and copying a piece of furniture in the editor. A piece's own frame has x across it and y from
/// its back to its front; its back is what stands against a wall, so resizing keeps the back where it is.
abstract final class FurnitureEditingUtil {
  static const minSide = 20.0;
  static const maxSide = 600.0;

  /// Sizes change in steps of this many cm, turns in steps of [turnStep] degrees.
  static const sizeStep = 5.0;
  static const turnStep = 15.0;

  /// Room left between a piece and its copy.
  static const copyGap = 10.0;

  static Map<FurnitureHandle, PlanPoint> handlesOf(Furniture item, {required double turnReach}) => {
    FurnitureHandle.width: _toPlan(item, item.width / 2, 0),
    FurnitureHandle.depth: _toPlan(item, 0, item.depth / 2),
    FurnitureHandle.turn: _toPlan(item, 0, item.depth / 2 + turnReach),
  };

  /// The handle within [radius] of [point], the nearest when several are.
  static FurnitureHandle? handleAt(
    Furniture item,
    PlanPoint point, {
    required double radius,
    required double turnReach,
  }) {
    FurnitureHandle? nearest;
    var nearestDistance = radius;
    for (final MapEntry(key: handle, value: at) in handlesOf(item, turnReach: turnReach).entries) {
      final distance = at.distanceTo(point);
      if (distance <= nearestDistance) {
        nearestDistance = distance;
        nearest = handle;
      }
    }
    return nearest;
  }

  /// [item] turned so that its front faces [point], in steps of [turnStep] degrees.
  static Furniture turnedTowards(Furniture item, PlanPoint point) {
    final dx = point.x - item.position.x;
    final dy = point.y - item.position.y;
    if (dx == 0 && dy == 0) return item;
    final degrees = math.atan2(-dx, dy) * 180 / math.pi;
    final snapped = (degrees / turnStep).round() * turnStep;
    return item.copyWith(rotation: snapped % 360);
  }

  /// [item] with [handle] dragged to [point]: the width handle moves the right side (the left one stays), the depth
  /// handle the front (the back stays). The turn handle turns it.
  static Furniture resized(Furniture item, FurnitureHandle handle, PlanPoint point) {
    final (x, y) = _toLocal(item, point);
    return switch (handle) {
      FurnitureHandle.turn => turnedTowards(item, point),
      FurnitureHandle.width => _sized(item, _side(x + item.width / 2), item.depth, keepLeft: true),
      FurnitureHandle.depth => _sized(item, item.width, _side(y + item.depth / 2)),
    };
  }

  /// [item] at a new size, wider on both sides and deeper to the front.
  static Furniture withSize(Furniture item, {double? width, double? depth}) =>
      _sized(item, _side(width ?? item.width), _side(depth ?? item.depth));

  /// A copy of [item] standing to its right, turned the same way.
  static Furniture copyBeside(Furniture item, {required String id}) =>
      item.copyWith(id: id, position: _toPlan(item, item.width + copyGap, 0));

  static Furniture _sized(Furniture item, double width, double depth, {bool keepLeft = false}) {
    final shiftX = keepLeft ? (width - item.width) / 2 : 0.0;
    final shiftY = (depth - item.depth) / 2;
    final center = _toPlan(item, shiftX, shiftY);
    return item.copyWith(width: width, depth: depth, position: PlanPoint(_round(center.x), _round(center.y)));
  }

  static double _side(double value) => ((value / sizeStep).round() * sizeStep).clamp(minSide, maxSide);

  static double _round(double value) => (value * 10).round() / 10;

  static PlanPoint _toPlan(Furniture item, double x, double y) {
    final angle = item.rotation * math.pi / 180;
    final cos = math.cos(angle);
    final sin = math.sin(angle);
    return PlanPoint(item.position.x + x * cos - y * sin, item.position.y + x * sin + y * cos);
  }

  static (double, double) _toLocal(Furniture item, PlanPoint point) {
    final angle = item.rotation * math.pi / 180;
    final cos = math.cos(angle);
    final sin = math.sin(angle);
    final dx = point.x - item.position.x;
    final dy = point.y - item.position.y;
    return (dx * cos + dy * sin, -dx * sin + dy * cos);
  }
}
