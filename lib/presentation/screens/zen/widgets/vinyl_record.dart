import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/shared_widgets/artwork.dart';

/// The cover as the label of a record that turns while the music plays.
///
/// Like a real turntable it needs a moment to come up to speed and runs out slowly when the music stops, and the
/// sheen stays where it is while the record turns under it.
///
/// Turns 20 times a second instead of every frame and repaints instead of rebuilding – like the drifting background
/// it is ambience on a screen that is on all day, not an animation.
class VinylRecord extends StatefulWidget {
  const VinylRecord({super.key, required this.seed, required this.size, this.url, this.playing = false});

  /// Part of the diameter the cover in the middle takes; the preloaded cover is decoded for that size.
  static const labelFraction = 0.42;

  /// One turn at full speed.
  static const turn = Duration(seconds: 12);

  /// Time from standing still to full speed and back.
  static const runUp = Duration(milliseconds: 1800);

  /// How far the record is up to speed after [elapsed], 0 … 1.
  static double throttleAfter(double throttle, Duration elapsed, {required bool playing}) {
    final step = elapsed.inMicroseconds / runUp.inMicroseconds;
    return (playing ? throttle + step : throttle - step).clamp(0.0, 1.0);
  }

  /// How far the record has turned after [elapsed] at [throttle], in turns.
  static double turnsAfter(double turns, double throttle, Duration elapsed) {
    final speed = Curves.easeInOut.transform(throttle);
    return (turns + elapsed.inMicroseconds / turn.inMicroseconds * speed) % 1;
  }

  final String seed;
  final String? url;
  final double size;
  final bool playing;

  @override
  State<VinylRecord> createState() => _VinylRecordState();
}

class _VinylRecordState extends State<VinylRecord> {
  static const _tick = Duration(milliseconds: 50);

  /// How far the record is turned, in turns; only the fraction is kept, so it never grows out of precision.
  final _turns = ValueNotifier(0.0);

  /// How far the record is up to speed, 0 … 1.
  var _throttle = 0.0;
  Timer? _timer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _timer?.cancel();
    _timer = TickerMode.valuesOf(context).enabled ? Timer.periodic(_tick, (_) => _turnOn()) : null;
  }

  void _turnOn() {
    _throttle = VinylRecord.throttleAfter(_throttle, _tick, playing: widget.playing);
    // Standing still costs nothing.
    if (_throttle == 0) return;
    _turns.value = VinylRecord.turnsAfter(_turns.value, _throttle, _tick);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _turns.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final side = widget.size;
    return SizedBox(
      width: side,
      height: side,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Color(0x99000000), blurRadius: 60, offset: Offset(0, 24))],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _Turning(
              turns: _turns,
              child: CustomPaint(
                painter: const _DiscPainter(),
                child: Center(
                  child: Artwork(
                    seed: widget.seed,
                    url: widget.url,
                    size: side * VinylRecord.labelFraction,
                    radius: side,
                    showNote: false,
                  ),
                ),
              ),
            ),
            // The hole in the middle: it is the one thing that does not move with the record.
            Center(
              child: Container(
                width: side * 0.03,
                height: side * 0.03,
                decoration: const BoxDecoration(color: HubColorPalette.bg, shape: BoxShape.circle),
              ),
            ),
            const IgnorePointer(child: CustomPaint(painter: _SheenPainter())),
          ],
        ),
      ),
    );
  }
}

/// Turns its child around its middle on a new angle – by repainting, not by rebuilding.
class _Turning extends SingleChildRenderObjectWidget {
  const _Turning({required this.turns, super.child});

  final ValueListenable<double> turns;

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderTurning(turns);

  @override
  void updateRenderObject(BuildContext context, _RenderTurning renderObject) => renderObject.turns = turns;
}

class _RenderTurning extends RenderProxyBox {
  _RenderTurning(this._turns) {
    _turns.addListener(markNeedsPaint);
  }

  ValueListenable<double> _turns;

  set turns(ValueListenable<double> value) {
    if (value == _turns) return;
    _turns.removeListener(markNeedsPaint);
    _turns = value..addListener(markNeedsPaint);
    markNeedsPaint();
  }

  @override
  void dispose() {
    _turns.removeListener(markNeedsPaint);
    super.dispose();
  }

  @override
  bool get alwaysNeedsCompositing => child != null;

  @override
  void paint(PaintingContext context, Offset offset) {
    final center = size.center(Offset.zero);
    final transform = Matrix4.identity()
      ..translateByDouble(center.dx, center.dy, 0, 1)
      ..rotateZ(_turns.value * 2 * math.pi)
      ..translateByDouble(-center.dx, -center.dy, 0, 1);
    layer = context.pushTransform(
      needsCompositing,
      offset,
      transform,
      super.paint,
      oldLayer: layer is TransformLayer ? layer! as TransformLayer : null,
    );
  }
}

/// The black disc with its grooves.
class _DiscPainter extends CustomPainter {
  const _DiscPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2;
    final disc = Rect.fromCircle(center: center, radius: radius);

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = const RadialGradient(
          colors: [Color(0xFF14161B), Color(0xFF0A0C10), Color(0xFF020305)],
          stops: [0.0, 0.55, 1.0],
        ).createShader(disc),
    );

    // Grooves: fine rings over the playing area, a wider gap where one side ends.
    final groove = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (var r = radius * 0.99; r > radius * VinylRecord.labelFraction + 2; r -= radius * 0.012) {
      final shade = ((r / radius) * 7).floor().isEven ? 0x0AFFFFFF : 0x03FFFFFF;
      canvas.drawCircle(center, r, groove..color = Color(shade));
    }
    // Lead-out: the smooth band around the label.
    canvas.drawCircle(
      center,
      radius * (VinylRecord.labelFraction + 0.035),
      groove
        ..color = const Color(0x0FFFFFFF)
        ..strokeWidth = radius * 0.012,
    );
  }

  @override
  bool shouldRepaint(_DiscPainter oldDelegate) => false;
}

/// A light that lies on the record instead of turning with it.
class _SheenPainter extends CustomPainter {
  const _SheenPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2;
    canvas.clipPath(Path()..addOval(Rect.fromCircle(center: center, radius: radius)));
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = const SweepGradient(
          startAngle: 0,
          endAngle: math.pi * 2,
          colors: [
            Color(0x00FFFFFF),
            Color(0x12FFFFFF),
            Color(0x00FFFFFF),
            Color(0x00FFFFFF),
            Color(0x0AFFFFFF),
            Color(0x00FFFFFF),
          ],
          stops: [0.0, 0.12, 0.26, 0.5, 0.62, 0.76],
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );
  }

  @override
  bool shouldRepaint(_SheenPainter oldDelegate) => false;
}
