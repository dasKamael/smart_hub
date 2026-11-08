import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/floorplan/model/home_layout.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/presentation/design_system/organisms/home_scene/home_scene.dart';
import 'package:smart_hub/presentation/design_system/organisms/home_scene/home_scene_painter.dart';
import 'package:smart_hub/presentation/design_system/organisms/home_scene/scene_camera.dart';

void main() {
  group('HomeScenePainter.shouldRepaint', () {
    final scene = HomeScene.of(const HomeLayout());
    final camera = SceneCamera.fit(const [(0, 0, 0), (100, 100, 0)], const Size(400, 300), yaw: 0, pitch: math.pi / 2);
    SceneLight lamp({double brightness = 1}) =>
        SceneLight(position: const PlanPoint(50, 50), r: 1, g: 0.7, b: 0.4, brightness: brightness);

    test('Given the same lamps in a new list, when asked to repaint, then it does not', () {
      // Given
      final before = HomeScenePainter(scene: scene, camera: camera, lights: [lamp()]);

      // When
      final repaint = HomeScenePainter(scene: scene, camera: camera, lights: [lamp()]).shouldRepaint(before);

      // Then
      expect(repaint, isFalse);
    });

    test('Given a lamp that was dimmed, when asked to repaint, then it does', () {
      // Given
      final before = HomeScenePainter(scene: scene, camera: camera, lights: [lamp()]);

      // When
      final repaint = HomeScenePainter(
        scene: scene,
        camera: camera,
        lights: [lamp(brightness: 0.5)],
      ).shouldRepaint(before);

      // Then
      expect(repaint, isTrue);
    });
  });
}
