import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/presentation/design_system/organisms/home_scene/home_scene.dart';
import 'package:smart_hub/presentation/design_system/organisms/home_scene/home_scene_painter.dart';
import 'package:smart_hub/presentation/design_system/organisms/home_scene/scene_camera.dart';

typedef SceneOverlayBuilder = Widget Function(BuildContext context, SceneCamera camera);

/// The 3D home, looked at from straight above or – with [tilted] – from the front at an angle; switching between the
/// two turns and tilts the model smoothly. [overlayBuilder] adds widgets placed with the current camera, e.g. lamps.
class HomeSceneView extends StatefulWidget {
  const HomeSceneView({
    super.key,
    required this.scene,
    this.lights = const [],
    this.tilted = false,
    this.tiltIn = false,
    this.topCamera,
    this.onSettled,
    this.overlayBuilder,
    this.padding = 16,
    this.selectedRoomId,
    this.selectionColor,
  });

  static const tiltDuration = Duration(milliseconds: 900);

  final HomeScene scene;
  final List<SceneLight> lights;
  final bool tilted;

  /// Starts looking from above and tilts on its own when it first shows [tilted].
  final bool tiltIn;

  /// The camera looking from above, e.g. the one of a flat plan this view takes over from; by default the model is
  /// fitted into the view.
  final SceneCamera Function(Size size)? topCamera;

  /// Called when a turn has come to rest, with whether the view is tilted now.
  final ValueChanged<bool>? onSettled;
  final SceneOverlayBuilder? overlayBuilder;
  final double padding;
  final String? selectedRoomId;
  final Color? selectionColor;

  @override
  State<HomeSceneView> createState() => _HomeSceneViewState();
}

class _HomeSceneViewState extends State<HomeSceneView> with SingleTickerProviderStateMixin {
  late final _tilt = AnimationController(
    vsync: this,
    duration: HomeSceneView.tiltDuration,
    value: widget.tilted && !widget.tiltIn ? 1 : 0,
  )..addStatusListener(_settled);
  late var _corners = widget.scene.corners.toList();

  @override
  void initState() {
    super.initState();
    if (widget.tilted && widget.tiltIn) _tilt.forward();
  }

  void _settled(AnimationStatus status) {
    if (status == AnimationStatus.completed) widget.onSettled?.call(true);
    if (status == AnimationStatus.dismissed) widget.onSettled?.call(false);
  }

  @override
  void didUpdateWidget(HomeSceneView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scene != widget.scene) _corners = widget.scene.corners.toList();
    if (oldWidget.tilted != widget.tilted) widget.tilted ? _tilt.forward() : _tilt.reverse();
  }

  @override
  void dispose() {
    _tilt.dispose();
    super.dispose();
  }

  SceneCamera _fit(Size size, double yaw, double pitch) =>
      SceneCamera.fit(_corners, size, yaw: yaw, pitch: pitch, padding: widget.padding);

  SceneCamera _camera(Size size, double t) {
    final tilted = _fit(size, SceneCamera.tiltedYaw, SceneCamera.tiltedPitch);
    if (t >= 1) return tilted;
    final top = widget.topCamera?.call(size) ?? _fit(size, SceneCamera.topYaw, SceneCamera.topPitch);
    if (t <= 0) return top;
    return SceneCamera(
      yaw: ui.lerpDouble(top.yaw, tilted.yaw, t)!,
      pitch: ui.lerpDouble(top.pitch, tilted.pitch, t)!,
      scale: ui.lerpDouble(top.scale, tilted.scale, t)!,
      origin: Offset.lerp(top.origin, tilted.origin, t)!,
      center: PlanPoint(
        ui.lerpDouble(top.center.x, tilted.center.x, t)!,
        ui.lerpDouble(top.center.y, tilted.center.y, t)!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => AnimatedBuilder(
        animation: _tilt,
        builder: (context, _) {
          final camera = _camera(constraints.biggest, Curves.easeInOutCubic.transform(_tilt.value));
          return Stack(
            children: [
              Positioned.fill(
                child: RepaintBoundary(
                  child: CustomPaint(
                    painter: HomeScenePainter(
                      scene: widget.scene,
                      camera: camera,
                      lights: widget.lights,
                      selectedRoomId: widget.selectedRoomId,
                      selectionColor: widget.selectionColor,
                    ),
                  ),
                ),
              ),
              if (widget.overlayBuilder case final builder?) Positioned.fill(child: builder(context, camera)),
            ],
          );
        },
      ),
    );
  }
}
