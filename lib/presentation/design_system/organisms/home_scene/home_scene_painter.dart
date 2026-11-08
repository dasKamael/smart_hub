import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/domain/floorplan/plan_geometry.util.dart';
import 'package:smart_hub/presentation/design_system/organisms/home_scene/furniture_meshes.dart';
import 'package:smart_hub/presentation/design_system/organisms/home_scene/home_scene.dart';
import 'package:smart_hub/presentation/design_system/organisms/home_scene/scene_camera.dart';
import 'package:smart_hub/presentation/design_system/organisms/home_scene/scene_solid.dart';
import 'package:smart_hub/presentation/design_system/tokens/home_scene.color_palette.dart';

/// Draws a [HomeScene] at night: floors with the light pools of lamps that are on, then every visible face of the
/// walls and furniture from back to front, lit by the night sky and by the lamps of their own room.
class HomeScenePainter extends CustomPainter {
  HomeScenePainter({
    required this.scene,
    required this.camera,
    this.lights = const [],
    this.selectedRoomId,
    this.selectionColor,
    this.lowered = 0,
  });

  /// Height of the lamps in cm.
  static const lampHeight = 200.0;

  /// Inner wall pieces shorter than this come down with a lowered corner they end at, in cm.
  static const _stub = 30.0;

  /// Distance at which a lamp has lost half its light, in cm.
  static const _falloff = 190.0;

  final HomeScene scene;
  final SceneCamera camera;
  final List<SceneLight> lights;
  final String? selectedRoomId;
  final Color? selectionColor;

  /// How far outer walls facing the viewer are lowered, from 0 (full height) to 1 (down to a low wall).
  final double lowered;

  @override
  void paint(Canvas canvas, Size size) {
    final lightRooms = [for (final light in lights) _roomAt(light.position)];
    _paintFloors(canvas, lightRooms);
    _paintContactShadows(canvas);
    _paintFaces(canvas, lightRooms);
  }

  String? _roomAt(PlanPoint point) {
    for (final floor in scene.floors) {
      if (PlanGeometryUtil.containsPoint(floor.outline, point)) return floor.roomId;
    }
    return null;
  }

  Path _floorPath(List<PlanPoint> outline) =>
      Path()..addPolygon([for (final point in outline) camera.projectPoint(point)], true);

  void _paintFloors(Canvas canvas, List<String?> lightRooms) {
    final topLight = _skyLight(0, 0, 1) * HomeSceneColorPalette.indoors * 0.7;
    for (final floor in scene.floors) {
      final path = _floorPath(floor.outline);
      canvas.drawPath(path, Paint()..color = _shade(HomeSceneColorPalette.of(floor.material), topLight));
      canvas.save();
      canvas.clipPath(path);
      // Darker along the walls, as light does not reach into the corners.
      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 40 * camera.scale
          ..color = const Color(0x66000000)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 14 * camera.scale),
      );
      for (final (i, light) in lights.indexed) {
        if (lightRooms[i] != floor.roomId || light.brightness <= 0) continue;
        canvas.save();
        canvas.transform(camera.planeAt(0));
        final radius = 260 + 220 * light.brightness;
        final color = Color.from(alpha: 1, red: light.r, green: light.g, blue: light.b);
        canvas.drawCircle(
          Offset(light.position.x, light.position.y),
          radius,
          Paint()
            ..blendMode = BlendMode.plus
            ..shader = RadialGradient(
              colors: [
                color.withValues(alpha: 0.5 * light.brightness),
                color.withValues(alpha: 0.2 * light.brightness),
                color.withValues(alpha: 0),
              ],
              stops: const [0, 0.38, 1],
            ).createShader(Rect.fromCircle(center: Offset(light.position.x, light.position.y), radius: radius)),
        );
        canvas.restore();
      }
      if (floor.roomId == selectedRoomId && selectionColor != null) {
        canvas.drawPath(path, Paint()..color = selectionColor!.withValues(alpha: 0.18));
      }
      canvas.restore();
    }
  }

  void _paintContactShadows(Canvas canvas) {
    final shadow = Paint()
      ..color = const Color(0x73000000)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, math.max(1, 5 * camera.scale));
    for (final footprint in scene.footprints) {
      canvas.drawPath(_floorPath(footprint), shadow);
    }
  }

  /// Whether a wall whose outer side points to [outside] faces the viewer.
  bool _facesViewer(PlanPoint? outside) => outside != null && camera.turn(outside.x, outside.y).$2 > 0.05;

  void _paintFaces(Canvas canvas, List<String?> lightRooms) {
    final faces = <_Face>[];
    final tilted = camera.pitch < math.pi / 2 - 0.001;
    // Corner blocks come down with the walls when every outer wall meeting there faces the viewer.
    final loweredNodes = {
      if (lowered > 0)
        for (final solid in scene.solids)
          if (solid.node case final node?
              when solid.joins.any(_facesViewer) && solid.joins.every((join) => join == null || _facesViewer(join)))
            node,
    };
    for (final solid in scene.solids) {
      final isLowered = switch (solid) {
        SceneSolid(:final node?) => loweredNodes.contains(node),
        SceneSolid(:final outside?) => lowered > 0 && _facesViewer(outside),
        // A short stub of an inner wall at a lowered corner would stand up as a thin post.
        _ => solid.nodeEnds.values.any(loweredNodes.contains) && solid.base[0].distanceTo(solid.base[1]) < _stub,
      };
      final top = isLowered
          ? ui.lerpDouble(solid.top, math.min(solid.top, HomeScene.loweredHeight), lowered)!
          : solid.top;
      if (top - solid.bottom < 0.5) continue;
      final base = solid.base;
      final cx = base.fold(0.0, (sum, p) => sum + p.x) / base.length;
      final cy = base.fold(0.0, (sum, p) => sum + p.y) / base.length;
      final isWall = scene.walls.contains(solid);
      if (tilted) {
        for (var i = 0; i < base.length; i++) {
          // A hidden end shows when the corner block it ends at is lowered and the piece itself is not.
          final opened = !isLowered && loweredNodes.contains(solid.nodeEnds[i]);
          if (solid.hiddenSides.contains(i) && !opened) continue;
          final p = base[i];
          final q = base[(i + 1) % base.length];
          final length = p.distanceTo(q);
          if (length < 0.01) continue;
          var nx = -(q.y - p.y) / length;
          var ny = (q.x - p.x) / length;
          final mx = (p.x + q.x) / 2;
          final my = (p.y + q.y) / 2;
          if ((mx + nx - cx) * (mx + nx - cx) + (my + ny - cy) * (my + ny - cy) <
              (mx - cx) * (mx - cx) + (my - cy) * (my - cy)) {
            nx = -nx;
            ny = -ny;
          }
          final (_, towards) = camera.turn(nx, ny);
          if (towards <= 0.001) continue;
          faces.add(
            _Face(
              solid: solid,
              corners: [(p.x, p.y, solid.bottom), (q.x, q.y, solid.bottom), (q.x, q.y, top), (p.x, p.y, top)],
              normal: (nx, ny, 0),
              isWall: isWall,
              room: isWall ? _roomAt(PlanPoint(mx + nx * 20, my + ny * 20)) : _roomAt(PlanPoint(cx, cy)),
              camera: camera,
            ),
          );
        }
      }
      faces.add(
        _Face(
          solid: solid,
          corners: [for (final p in base) (p.x, p.y, top)],
          normal: (0, 0, 1),
          isWall: isWall,
          room: isWall ? null : _roomAt(PlanPoint(cx, cy)),
          camera: camera,
          top: true,
        ),
      );
    }
    faces.sort((a, b) {
      final byDepth = a.depth.compareTo(b.depth);
      if (byDepth != 0) return byDepth;
      return a.top == b.top ? 0 : (a.top ? 1 : -1);
    });
    // Furniture models go in between, each as one piece, by where they stand.
    final meshes = [
      for (final mesh in scene.meshes)
        (camera.drawOrder(mesh.item.position.x, mesh.item.position.y, mesh.item.kind.height / 2), mesh),
    ]..sort((a, b) => a.$1.compareTo(b.$1));
    var next = 0;

    for (final face in faces) {
      while (next < meshes.length && meshes[next].$1 < face.depth) {
        _paintMesh(canvas, meshes[next++].$2, lightRooms);
      }
      final points = [for (final (x, y, z) in face.corners) camera.project(x, y, z)];
      final path = Path()..addPolygon(_grown(points), true);
      final paint = Paint()..isAntiAlias = true;
      if (face.top) {
        final (x, y, z) = face.corners.fold((0.0, 0.0, 0.0), (sum, c) => (sum.$1 + c.$1, sum.$2 + c.$2, c.$3));
        paint.color = _lit(face, x / face.corners.length, y / face.corners.length, z, lightRooms);
        canvas.drawPath(path, paint);
        continue;
      }
      // A side: light changes along it (lamps), blended from one upright edge to the other at mid height, so the
      // pieces of a long wall meet in the same color.
      final (px, py, bottom) = face.corners[0];
      final (qx, qy, _) = face.corners[1];
      final top = face.corners[2].$3;
      final middle = (bottom + top) / 2;
      final left = _lit(face, px, py, middle, lightRooms);
      final right = _lit(face, qx, qy, middle, lightRooms);
      if (left == right) {
        paint.color = left;
      } else {
        paint.shader = ui.Gradient.linear((points[0] + points[3]) / 2, (points[1] + points[2]) / 2, [left, right]);
      }
      canvas.drawPath(path, paint);
      if (!face.isOutdoors) {
        // Indoors, low parts get less light. Not enlarged: overlapping, the darkening would add up at the seams.
        canvas.drawPath(
          Path()..addPolygon(points, true),
          Paint()
            ..isAntiAlias = false
            ..shader = ui.Gradient.linear(
              (points[2] + points[3]) / 2,
              (points[0] + points[1]) / 2,
              [_darkening(top), _darkening(math.max(bottom, math.min(top, 140))), _darkening(bottom)],
              [
                0,
                top - bottom <= 0 ? 0 : ((top - math.min(top, math.max(bottom, 140))) / (top - bottom)).clamp(0, 1),
                1,
              ],
            ),
        );
      }
    }
    while (next < meshes.length) {
      _paintMesh(canvas, meshes[next++].$2, lightRooms);
    }
  }

  /// A furniture model: its triangles facing the viewer, back to front, each lit on its own.
  void _paintMesh(Canvas canvas, SceneMesh mesh, List<String?> lightRooms) {
    final room = _roomAt(mesh.item.position);
    final p = mesh.positions;
    final cosPitch = math.cos(camera.pitch);
    final sinPitch = math.sin(camera.pitch);
    final visible = <(double, int)>[];
    final normals = <int, (double, double, double)>{};
    for (var t = 0; t < mesh.triangles.length; t += 3) {
      final a = mesh.triangles[t] * 3;
      final b = mesh.triangles[t + 1] * 3;
      final c = mesh.triangles[t + 2] * 3;
      final ux = p[b] - p[a];
      final uy = p[b + 1] - p[a + 1];
      final uz = p[b + 2] - p[a + 2];
      final vx = p[c] - p[a];
      final vy = p[c + 1] - p[a + 1];
      final vz = p[c + 2] - p[a + 2];
      var nx = uy * vz - uz * vy;
      var ny = uz * vx - ux * vz;
      var nz = ux * vy - uy * vx;
      final length = math.sqrt(nx * nx + ny * ny + nz * nz);
      if (length < 1e-6) continue;
      nx /= length;
      ny /= length;
      nz /= length;
      final (_, towards) = camera.turn(nx, ny);
      if (towards * cosPitch + nz * sinPitch <= 0) continue;
      normals[t] = (nx, ny, nz);
      final depth = camera.depth(
        (p[a] + p[b] + p[c]) / 3,
        (p[a + 1] + p[b + 1] + p[c + 1]) / 3,
        (p[a + 2] + p[b + 2] + p[c + 2]) / 3,
      );
      visible.add((depth, t));
    }
    if (visible.isEmpty) return;
    visible.sort((x, y) => x.$1.compareTo(y.$1));
    final positions = <Offset>[];
    final colors = <Color>[];
    for (final (_, t) in visible) {
      final corners = [mesh.triangles[t] * 3, mesh.triangles[t + 1] * 3, mesh.triangles[t + 2] * 3];
      final cx = (p[corners[0]] + p[corners[1]] + p[corners[2]]) / 3;
      final cy = (p[corners[0] + 1] + p[corners[1] + 1] + p[corners[2] + 1]) / 3;
      final cz = (p[corners[0] + 2] + p[corners[1] + 2] + p[corners[2] + 2]) / 3;
      final color = _shadeAt(
        HomeSceneColorPalette.furniture(mesh.colors[t ~/ 3]),
        normals[t]!,
        cx,
        cy,
        cz,
        room,
        lightRooms,
        outdoors: false,
      );
      for (final corner in corners) {
        positions.add(camera.project(p[corner], p[corner + 1], p[corner + 2]));
        colors.add(color);
      }
    }
    canvas.drawVertices(ui.Vertices(ui.VertexMode.triangles, positions, colors: colors), BlendMode.dst, Paint());
  }

  static Color _darkening(double z) =>
      Color.from(alpha: 0.28 * (1 - math.min(1.0, math.max(0.0, z) / 140)), red: 0, green: 0, blue: 0);

  /// [points] pushed out by half a pixel, so neighboring faces meet without a hairline gap.
  static List<Offset> _grown(List<Offset> points) {
    final center = points.fold(Offset.zero, (sum, p) => sum + p) / points.length.toDouble();
    return [
      for (final point in points)
        if ((point - center).distance case final d when d > 0) center + (point - center) * ((d + 0.9) / d) else point,
    ];
  }

  /// How much the night sky lights a surface facing (nx, ny, nz) in the plan.
  double _skyLight(double nx, double ny, double nz) {
    final (rx, ry) = camera.turn(nx, ny);
    // From the left of the screen and from above: faces turned left are lit, faces turned right a little darker.
    const lx = -0.6;
    const ly = 0.25;
    const lz = 0.76;
    final diffuse = math.max(0.0, rx * lx + ry * ly + nz * lz);
    return HomeSceneColorPalette.ambient + (1 - HomeSceneColorPalette.ambient) * diffuse * 0.85;
  }

  Color _shade(Color base, double factor) {
    final sky = HomeSceneColorPalette.moonlight;
    return Color.from(
      alpha: base.a,
      red: (base.r * factor * sky.r).clamp(0, 1),
      green: (base.g * factor * sky.g).clamp(0, 1),
      blue: (base.b * factor * sky.b).clamp(0, 1),
    );
  }

  Color _lit(_Face face, double x, double y, double z, List<String?> lightRooms) => _shadeAt(
    HomeSceneColorPalette.of(face.solid.material),
    face.normal,
    x,
    y,
    z,
    face.room,
    lightRooms,
    outdoors: face.isOutdoors,
  );

  /// [base] lit at (x, y, z) on a surface facing [normal]: by the night sky, and by the lamps of [room].
  Color _shadeAt(
    Color base,
    (double, double, double) normal,
    double x,
    double y,
    double z,
    String? room,
    List<String?> lightRooms, {
    required bool outdoors,
  }) {
    final (nx, ny, nz) = normal;
    final sky = _skyLight(nx, ny, nz) * (outdoors ? 1 : HomeSceneColorPalette.indoors);
    var r = base.r * sky * HomeSceneColorPalette.moonlight.r;
    var g = base.g * sky * HomeSceneColorPalette.moonlight.g;
    var b = base.b * sky * HomeSceneColorPalette.moonlight.b;
    for (final (i, light) in lights.indexed) {
      if (light.brightness <= 0 || lightRooms[i] == null || lightRooms[i] != room) continue;
      final dx = light.position.x - x;
      final dy = light.position.y - y;
      final dz = lampHeight - z;
      final distance = math.sqrt(dx * dx + dy * dy + dz * dz);
      if (distance < 1) continue;
      final facing = math.max(0.0, (dx * nx + dy * ny + dz * nz) / distance);
      final strength = light.brightness * 1.1 / (1 + math.pow(distance / _falloff, 2));
      final amount = strength * (0.35 + 0.65 * facing);
      r += (base.r * 1.1 + 0.25) * light.r * amount;
      g += (base.g * 1.1 + 0.25) * light.g * amount;
      b += (base.b * 1.1 + 0.25) * light.b * amount;
    }
    return Color.from(alpha: base.a, red: _knee(r), green: _knee(g), blue: _knee(b));
  }

  /// Bright light rolls off softly instead of clipping to white.
  static double _knee(double value) {
    const start = 0.55;
    if (value <= start) return math.max(0, value);
    return start + (1 - start) * (1 - math.exp(-(value - start) / (1 - start)));
  }

  @override
  bool shouldRepaint(HomeScenePainter oldDelegate) =>
      oldDelegate.scene != scene ||
      oldDelegate.camera != camera ||
      oldDelegate.lights != lights ||
      oldDelegate.lowered != lowered ||
      oldDelegate.selectedRoomId != selectedRoomId;
}

class _Face {
  _Face({
    required this.solid,
    required this.corners,
    required this.normal,
    required this.isWall,
    required this.room,
    required SceneCamera camera,
    this.top = false,
  }) : depth = corners.fold(0.0, (sum, c) => sum + camera.drawOrder(c.$1, c.$2, c.$3)) / corners.length;

  final SceneSolid solid;
  final List<(double, double, double)> corners;
  final (double, double, double) normal;
  final bool isWall;
  final String? room;
  final bool top;
  final double depth;

  /// The outer side or top of an outer wall: in the night sky's light, not in a room.
  bool get isOutdoors => isWall && room == null;
}
