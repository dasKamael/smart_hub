import 'package:flutter/widgets.dart';
import 'package:smart_hub/domain/floorplan/model/floor_plan.dart';
import 'package:smart_hub/domain/floorplan/room_lookup.util.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_motion.dart';
import 'package:smart_hub/presentation/screens/floorplan/plan_device.dart';
import 'package:smart_hub/presentation/screens/floorplan/widgets/plan_marker.dart';
import 'package:smart_hub/presentation/screens/floorplan/widgets/plan_transform.dart';

/// Light glow on the plan: a radial gradient per light that is on, clipped to the light's room
/// (`README` → "Light glow").
class GlowLayer extends StatelessWidget {
  const GlowLayer({
    super.key,
    required this.plan,
    required this.transform,
    required this.lights,
    required this.visible,
  });

  final FloorPlan plan;
  final PlanTransform transform;
  final List<PlanLight> lights;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          for (final light in lights)
            if (light.position case final position?)
              if (RoomLookupUtil.roomAt(plan, position) case final room?)
                Positioned.fill(
                  key: ValueKey(light.id),
                  child: _GlowSpot(
                    center: transform.toPx(position),
                    diameter: (16 + _brightness(light) * 0.26) / 100 * transform.width,
                    color: planLightColor(light),
                    opacity: visible && light.light.isOn ? 0.45 + _brightness(light) / 180 : 0,
                    clip: transform.pathOf(room.polygon),
                  ),
                ),
        ],
      ),
    );
  }

  static int _brightness(PlanLight light) => light.light.brightnessPercent ?? (light.light.isOn ? 100 : 0);
}

class _GlowSpot extends StatelessWidget {
  const _GlowSpot({
    required this.center,
    required this.diameter,
    required this.color,
    required this.opacity,
    required this.clip,
  });

  final Offset center;
  final double diameter;
  final Color color;
  final double opacity;
  final Path clip;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(end: opacity.clamp(0, 1)),
      duration: HubMotion.glowDuration,
      curve: HubMotion.glow,
      builder: (context, animatedOpacity, _) => CustomPaint(
        painter: _GlowPainter(center: center, diameter: diameter, color: color, opacity: animatedOpacity, clip: clip),
      ),
    );
  }
}

class _GlowPainter extends CustomPainter {
  _GlowPainter({
    required this.center,
    required this.diameter,
    required this.color,
    required this.opacity,
    required this.clip,
  });

  final Offset center;
  final double diameter;
  final Color color;
  final double opacity;
  final Path clip;

  @override
  void paint(Canvas canvas, Size size) {
    if (opacity <= 0 || diameter <= 0) return;
    final radius = diameter / 2;
    final paint = Paint()
      ..blendMode = BlendMode.screen
      ..shader = RadialGradient(
        colors: [
          color.withValues(alpha: 0.7 * opacity),
          color.withValues(alpha: 0.3 * opacity),
          color.withValues(alpha: 0),
        ],
        stops: const [0, 0.35, 0.7],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas
      ..save()
      ..clipPath(clip)
      ..drawCircle(center, radius, paint)
      ..restore();
  }

  @override
  bool shouldRepaint(_GlowPainter oldDelegate) {
    return oldDelegate.center != center ||
        oldDelegate.diameter != diameter ||
        oldDelegate.color != color ||
        oldDelegate.opacity != opacity ||
        oldDelegate.clip != clip;
  }
}
