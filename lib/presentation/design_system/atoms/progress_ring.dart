import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_motion.dart';

/// Circular progress around [child], starting at 12 o'clock (e.g. how thirsty a plant is).
class ProgressRing extends StatelessWidget {
  const ProgressRing({
    super.key,
    required this.progress,
    required this.color,
    required this.child,
    this.strokeWidth = 4,
    this.gap = 4,
    this.trackColor = const Color(0x1FFFFFFF),
  });

  /// 0–1.
  final double progress;
  final Color color;
  final Color trackColor;
  final double strokeWidth;

  /// Space between ring and child.
  final double gap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(end: progress.clamp(0, 1)),
      duration: HubMotion.moveDuration,
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => CustomPaint(
        foregroundPainter: _RingPainter(
          progress: value,
          color: color,
          trackColor: trackColor,
          strokeWidth: strokeWidth,
        ),
        child: Padding(padding: EdgeInsets.all(strokeWidth + gap), child: child),
      ),
      child: child,
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({required this.progress, required this.color, required this.trackColor, required this.strokeWidth});

  final double progress;
  final Color color;
  final Color trackColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = (Offset.zero & size).deflate(strokeWidth / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, 0, 2 * math.pi, false, paint..color = trackColor);
    if (progress > 0) canvas.drawArc(rect, -math.pi / 2, 2 * math.pi * progress, false, paint..color = color);
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color || oldDelegate.trackColor != trackColor;
  }
}
