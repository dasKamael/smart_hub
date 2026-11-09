import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
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

  /// How much of a lamp's own color a lit surface takes on, whatever its color: walls glow in the lamp's color.
  static const _tint = 0.36;

  /// Distance at which a lamp has lost half its light, in cm.
  static const _falloff = 130.0;

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
      // Not smoothed: where a wall was removed two floors meet, and smoothed edges would leave a dark line between
      // them. Their other edges lie under the walls.
      canvas.drawPath(
        path,
        Paint()
          ..isAntiAlias = false
          ..color = _shade(HomeSceneColorPalette.of(floor.material), topLight),
      );
      canvas.save();
      canvas.clipPath(path, doAntiAlias: false);
      if (floor.material == SceneMaterial.floorWood) _paintPlanks(canvas, floor.outline);
      // Darker along the walls, as light does not reach into the corners; not where a wall was removed.
      canvas.drawPath(
        _wallEdges(floor),
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
              // A bright core right under the lamp, then a wide soft pool.
              colors: [
                Color.lerp(color, const Color(0xFFFFFFFF), 0.35)!.withValues(alpha: 0.32 * light.brightness),
                color.withValues(alpha: 0.15 * light.brightness),
                color.withValues(alpha: 0.05 * light.brightness),
                color.withValues(alpha: 0),
              ],
              stops: const [0, 0.14, 0.42, 1],
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

  /// The edges of [floor] that stand against a wall, on screen: one closed line when there are walls all around,
  /// else a line for each run of walls between removed ones (joined at corners, so the shade turns them cleanly).
  Path _wallEdges(SceneFloor floor) {
    final points = [for (final point in floor.outline) camera.projectPoint(point)];
    final count = points.length;
    if (floor.openEdges.isEmpty) return Path()..addPolygon(points, true);
    final path = Path();
    // Start right after a removed wall, so every run is drawn in one piece.
    final start = (floor.openEdges.first + 1) % count;
    var drawing = false;
    for (var k = 0; k < count; k++) {
      final i = (start + k) % count;
      if (floor.openEdges.contains(i)) {
        drawing = false;
        continue;
      }
      if (!drawing) path.moveTo(points[i].dx, points[i].dy);
      final next = points[(i + 1) % count];
      path.lineTo(next.dx, next.dy);
      drawing = true;
    }
    return path;
  }

  /// Joints of floorboards: along the boards every [_board] cm, across them staggered every [_boardLength] cm.
  void _paintPlanks(Canvas canvas, List<PlanPoint> outline) {
    final xs = outline.map((p) => p.x);
    final ys = outline.map((p) => p.y);
    final left = xs.reduce(math.min);
    final right = xs.reduce(math.max);
    final top = ys.reduce(math.min);
    final bottom = ys.reduce(math.max);
    final joint = Paint()
      ..color = HomeSceneColorPalette.floorJoint
      ..strokeWidth = 1 / camera.scale;
    canvas.save();
    canvas.transform(camera.planeAt(0));
    var row = 0;
    for (var y = (top / _board).floor() * _board; y < bottom; y += _board, row++) {
      canvas.drawLine(Offset(left, y), Offset(right, y), joint);
      final shift = (row % 3) * _boardLength / 3;
      for (var x = (left / _boardLength).floor() * _boardLength + shift; x < right; x += _boardLength) {
        canvas.drawLine(Offset(x, y), Offset(x, y + _board), joint);
      }
    }
    canvas.restore();
  }

  static const _board = 18.0;
  static const _boardLength = 120.0;

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
    // Junctions where a lowered outer wall ends: walls ending there show their end instead of a hole.
    final loweredNodes = {
      if (lowered > 0)
        for (final solid in scene.solids)
          if (_facesViewer(solid.outside)) ...solid.nodeEnds.values,
    };
    for (final solid in scene.solids) {
      // Only the outer walls facing the viewer come down; inner walls keep their height and show their end where
      // they meet a lowered wall.
      final isLowered = lowered > 0 && _facesViewer(solid.outside);
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
      // The slab lies under walls and floors: its top is never seen, but would cover door gaps from above.
      if (solid.material == SceneMaterial.slab) continue;
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
      _paintSide(canvas, face, points, lightRooms);
    }
    while (next < meshes.length) {
      _paintMesh(canvas, meshes[next++].$2, lightRooms);
    }
  }

  /// A side as triangles with a color at every corner: lamps light it along and up, low parts indoors get less light.
  /// Neighboring pieces share their edges' colors, so a wall reads as one surface, without seams.
  void _paintSide(Canvas canvas, _Face face, List<Offset> points, List<String?> lightRooms) {
    final (px, py, bottom) = face.corners[0];
    final (qx, qy, _) = face.corners[1];
    final top = face.corners[2].$3;
    final heights = [bottom, if (!face.isOutdoors && bottom < _shadeTop && top > _shadeTop) _shadeTop, top];
    final positions = <Offset>[];
    final colors = <Color>[];
    for (final z in heights) {
      final t = top - bottom <= 0 ? 0.0 : (z - bottom) / (top - bottom);
      positions
        ..add(Offset.lerp(points[0], points[3], t)!)
        ..add(Offset.lerp(points[1], points[2], t)!);
      colors
        ..add(_sideColor(face, px, py, z, lightRooms))
        ..add(_sideColor(face, qx, qy, z, lightRooms));
    }
    final indices = <int>[
      for (var row = 0; row < heights.length - 1; row++) ...[
        row * 2,
        row * 2 + 1,
        row * 2 + 3,
        row * 2,
        row * 2 + 3,
        row * 2 + 2,
      ],
    ];
    canvas.drawVertices(
      ui.Vertices(ui.VertexMode.triangles, positions, colors: colors, indices: indices),
      BlendMode.dst,
      Paint(),
    );
  }

  /// Height up to which walls and furniture indoors darken towards the floor, in cm.
  static const _shadeTop = 140.0;

  Color _sideColor(_Face face, double x, double y, double z, List<String?> lightRooms) {
    final color = _lit(face, x, y, z, lightRooms);
    if (face.isOutdoors) return color;
    final keep = 1 - HomeSceneColorPalette.floorShade * (1 - math.min(1.0, math.max(0.0, z) / _shadeTop));
    return Color.from(alpha: color.a, red: color.r * keep, green: color.g * keep, blue: color.b * keep);
  }

  /// A furniture model: its triangles facing the viewer, back to front, lit at every corner. What does not change from
  /// frame to frame is kept with the mesh (see [_MeshCache]): only projecting the corners happens every time.
  void _paintMesh(Canvas canvas, SceneMesh mesh, List<String?> lightRooms) {
    final cache = _meshCaches[mesh] ??= _MeshCache.of(mesh);
    final order = cache.orderFor(camera);
    if (order.isEmpty) return;
    final colors = cache.colorsFor(
      (_quantized(camera.yaw), lights),
      (t, corner) => _shadeAt(
        HomeSceneColorPalette.furniture(mesh.colors[t]),
        cache.normalOf(t),
        mesh.positions[corner * 3],
        mesh.positions[corner * 3 + 1],
        mesh.positions[corner * 3 + 2],
        _roomAt(mesh.item.position),
        lightRooms,
        outdoors: false,
        sky: HomeSceneColorPalette.furnitureSky,
      ),
    );
    final p = mesh.positions;
    final projected = Float32List(p.length ~/ 3 * 2);
    for (var v = 0; v < p.length ~/ 3; v++) {
      final at = camera.project(p[v * 3], p[v * 3 + 1], p[v * 3 + 2]);
      projected[v * 2] = at.dx;
      projected[v * 2 + 1] = at.dy;
    }
    final positions = Float32List(order.length * 6);
    final vertexColors = Int32List(order.length * 3);
    for (var i = 0; i < order.length; i++) {
      final t = order[i];
      for (var k = 0; k < 3; k++) {
        final v = mesh.triangles[t * 3 + k];
        positions[i * 6 + k * 2] = projected[v * 2];
        positions[i * 6 + k * 2 + 1] = projected[v * 2 + 1];
        vertexColors[i * 3 + k] = colors[t * 3 + k];
      }
    }
    canvas.drawVertices(
      ui.Vertices.raw(ui.VertexMode.triangles, positions, colors: vertexColors),
      BlendMode.dst,
      Paint(),
    );
  }

  static final _meshCaches = Expando<_MeshCache>();

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
    face.top && face.isWall ? HomeSceneColorPalette.wallTop : HomeSceneColorPalette.of(face.solid.material),
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
    double sky = 1,
  }) {
    final (nx, ny, nz) = normal;
    final skyLight = _skyLight(nx, ny, nz) * (outdoors ? 1 : HomeSceneColorPalette.indoors) * sky;
    var r = base.r * skyLight * HomeSceneColorPalette.moonlight.r;
    var g = base.g * skyLight * HomeSceneColorPalette.moonlight.g;
    var b = base.b * skyLight * HomeSceneColorPalette.moonlight.b;
    for (final (i, light) in lights.indexed) {
      if (light.brightness <= 0 || lightRooms[i] == null || lightRooms[i] != room) continue;
      final dx = light.position.x - x;
      final dy = light.position.y - y;
      final dz = lampHeight - z;
      final distance = math.sqrt(dx * dx + dy * dy + dz * dz);
      if (distance < 1) continue;
      // Light falls mostly on the walls; tops of furniture and floors get a share of it (floors have their pool).
      final facing = math.max(0.0, (dx * nx + dy * ny + dz * nz) / distance) * (1 - 0.55 * math.max(0.0, nz));
      final strength = light.brightness * 1.5 / (1 + math.pow(distance / _falloff, 2));
      final amount = strength * (0.35 + 0.65 * facing);
      r += (base.r * 1.1 + _tint) * light.r * amount;
      g += (base.g * 1.1 + _tint) * light.g * amount;
      b += (base.b * 1.1 + _tint) * light.b * amount;
    }
    return Color.from(alpha: base.a, red: _knee(r), green: _knee(g), blue: _knee(b));
  }

  /// Bright light rolls off softly instead of clipping to white.
  static double _knee(double value) {
    const start = 0.5;
    if (value <= start) return math.max(0, value);
    return start + (1 - start) * (1 - math.exp(-(value - start) / (1 - start)));
  }

  @override
  bool shouldRepaint(HomeScenePainter oldDelegate) =>
      oldDelegate.scene != scene ||
      oldDelegate.camera != camera ||
      !listEquals(oldDelegate.lights, lights) ||
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

/// Steps in which the camera's angles count for what is kept per mesh, in radians (about a degree).
double _quantized(double angle) => (angle / 0.02).roundToDouble();

/// What is kept for a furniture model between frames: the normal of every triangle; the triangles facing the viewer,
/// back to front, for the last camera angles; the color of every triangle corner for the last lamps.
final class _MeshCache {
  _MeshCache(this.mesh, this.normals);

  factory _MeshCache.of(SceneMesh mesh) {
    final p = mesh.positions;
    final count = mesh.triangles.length ~/ 3;
    final normals = Float32List(count * 3);
    for (var t = 0; t < count; t++) {
      final a = mesh.triangles[t * 3] * 3;
      final b = mesh.triangles[t * 3 + 1] * 3;
      final c = mesh.triangles[t * 3 + 2] * 3;
      final ux = p[b] - p[a];
      final uy = p[b + 1] - p[a + 1];
      final uz = p[b + 2] - p[a + 2];
      final vx = p[c] - p[a];
      final vy = p[c + 1] - p[a + 1];
      final vz = p[c + 2] - p[a + 2];
      final nx = uy * vz - uz * vy;
      final ny = uz * vx - ux * vz;
      final nz = ux * vy - uy * vx;
      final length = math.sqrt(nx * nx + ny * ny + nz * nz);
      if (length < 1e-6) continue;
      normals
        ..[t * 3] = nx / length
        ..[t * 3 + 1] = ny / length
        ..[t * 3 + 2] = nz / length;
    }
    return _MeshCache(mesh, normals);
  }

  final SceneMesh mesh;
  final Float32List normals;

  (double, double)? _orderKey;
  Int32List _order = Int32List(0);

  (double, List<SceneLight>)? _colorKey;
  Int32List _colors = Int32List(0);

  (double, double, double) normalOf(int t) => (normals[t * 3], normals[t * 3 + 1], normals[t * 3 + 2]);

  /// The triangles facing [camera], back to front.
  Int32List orderFor(SceneCamera camera) {
    final key = (_quantized(camera.yaw), _quantized(camera.pitch));
    if (key == _orderKey) return _order;
    final p = mesh.positions;
    final cosPitch = math.cos(camera.pitch);
    final sinPitch = math.sin(camera.pitch);
    final visible = <(double, int)>[];
    for (var t = 0; t < mesh.triangles.length ~/ 3; t++) {
      final (nx, ny, nz) = normalOf(t);
      if (nx == 0 && ny == 0 && nz == 0) continue;
      final (_, towards) = camera.turn(nx, ny);
      if (towards * cosPitch + nz * sinPitch <= 0) continue;
      final a = mesh.triangles[t * 3] * 3;
      final b = mesh.triangles[t * 3 + 1] * 3;
      final c = mesh.triangles[t * 3 + 2] * 3;
      visible.add((
        camera.depth(
          (p[a] + p[b] + p[c]) / 3,
          (p[a + 1] + p[b + 1] + p[c + 1]) / 3,
          (p[a + 2] + p[b + 2] + p[c + 2]) / 3,
        ),
        t,
      ));
    }
    visible.sort((x, y) => x.$1.compareTo(y.$1));
    _orderKey = key;
    return _order = Int32List.fromList([for (final (_, t) in visible) t]);
  }

  /// The color of every triangle corner (ARGB), from [shade] (triangle, vertex), kept until [key] changes.
  Int32List colorsFor((double, List<SceneLight>) key, Color Function(int t, int vertex) shade) {
    if (_colorKey case (final yaw, final lights) when yaw == key.$1 && listEquals(lights, key.$2)) return _colors;
    final colors = Int32List(mesh.triangles.length);
    for (var i = 0; i < mesh.triangles.length; i++) {
      colors[i] = shade(i ~/ 3, mesh.triangles[i]).toARGB32();
    }
    _colorKey = key;
    return _colors = colors;
  }
}
