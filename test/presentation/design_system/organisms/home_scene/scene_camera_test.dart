import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/presentation/design_system/organisms/home_scene/scene_camera.dart';

void main() {
  group('SceneCamera', () {
    const corners = [(0.0, 0.0, 0.0), (400.0, 0.0, 0.0), (400.0, 300.0, 250.0), (0.0, 300.0, 250.0)];

    test('Given the view from above, when projecting, then the plan is only scaled and moved', () {
      // When
      final camera = SceneCamera.fit(corners, const Size(800, 600), yaw: 0, pitch: math.pi / 2, padding: 0);

      // Then
      expect(camera.scale, 2);
      expect(camera.project(0, 0, 0), const Offset(0, 0));
      expect(camera.project(400, 300, 250), const Offset(800, 600));
    });

    test('Given a tilted camera, when fitting, then every corner lies within the view', () {
      // When
      final camera = SceneCamera.fit(
        corners,
        const Size(800, 600),
        yaw: SceneCamera.tiltedYaw,
        pitch: SceneCamera.tiltedPitch,
        padding: 10,
      );

      // Then
      for (final (x, y, z) in corners) {
        final point = camera.project(x, y, z);
        expect(point.dx, inInclusiveRange(9.99, 790.01));
        expect(point.dy, inInclusiveRange(9.99, 590.01));
      }
    });

    test('Given a tilted camera, when unprojecting a projected floor point, then the plan point comes back', () {
      // Given
      final camera = SceneCamera.fit(corners, const Size(800, 600), yaw: -0.5, pitch: 1.0);

      // When
      final back = camera.unproject(camera.projectPoint(const PlanPoint(120, 80)));

      // Then
      expect(back.x, closeTo(120, 1e-6));
      expect(back.y, closeTo(80, 1e-6));
    });

    test('Given a tilted camera, when ordering for drawing, then what stands nearer the viewer comes later', () {
      // Given
      final camera = SceneCamera.fit(corners, const Size(800, 600), yaw: 0, pitch: SceneCamera.tiltedPitch);

      // Then
      expect(camera.drawOrder(100, 250, 0), greaterThan(camera.drawOrder(100, 50, 200)));
    });
  });
}
