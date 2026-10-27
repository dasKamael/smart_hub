import 'package:flutter/widgets.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';

/// The hub's logo: a floor plan with a glowing light and a plant (master: `branding/logo.svg`). With [background]
/// it is drawn as the app icon on its dark tile.
class HubLogo extends StatelessWidget {
  const HubLogo({super.key, this.size = 64, this.background = true});

  final double size;
  final bool background;

  @override
  Widget build(BuildContext context) {
    final logo = CustomPaint(
      size: Size.square(size),
      painter: _LogoPainter(background: background),
    );
    if (!background) return logo;
    return ClipRRect(borderRadius: BorderRadius.circular(size * 0.22), child: logo);
  }
}

class _LogoPainter extends CustomPainter {
  _LogoPainter({required this.background});

  static const _light = Color(0xFFFFB340);
  static const _wall = Color(0xFFD6D6DC);

  final bool background;

  @override
  void paint(Canvas canvas, Size size) {
    // The icon's 108 unit canvas; without background only the drawing (22–86) is shown.
    final (origin, extent) = background ? (0.0, 108.0) : (22.0, 64.0);
    canvas
      ..scale(size.width / extent)
      ..translate(-origin, -origin);
    if (background) {
      canvas.drawRect(
        const Rect.fromLTWH(0, 0, 108, 108),
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [HubColorPalette.surface, Color(0xFF0A0A0B)],
          ).createShader(const Rect.fromLTWH(0, 0, 108, 108)),
      );
    }
    canvas
      ..drawCircle(
        const Offset(44, 44),
        20,
        Paint()
          ..shader = RadialGradient(
            colors: [_light.withValues(alpha: 0.85), _light.withValues(alpha: 0.25), _light.withValues(alpha: 0)],
            stops: const [0, 0.45, 1],
          ).createShader(Rect.fromCircle(center: const Offset(44, 44), radius: 20)),
      )
      ..drawPath(
        Path()
          ..addRect(const Rect.fromLTRB(30, 30, 78, 78))
          ..moveTo(58, 30)
          ..lineTo(58, 50)
          ..moveTo(58, 60)
          ..lineTo(58, 78)
          ..moveTo(30, 56)
          ..lineTo(48, 56),
        Paint()
          ..color = _wall
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.2
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      )
      ..drawCircle(const Offset(44, 44), 4.2, Paint()..color = HubColorPalette.lightSoft)
      ..drawCircle(const Offset(68, 68), 3.6, Paint()..color = HubColorPalette.success);
  }

  @override
  bool shouldRepaint(_LogoPainter oldDelegate) => oldDelegate.background != background;
}
