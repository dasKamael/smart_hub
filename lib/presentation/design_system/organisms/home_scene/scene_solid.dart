import 'package:smart_hub/domain/floorplan/model/plan_point.dart';

/// What a surface of the 3D home is made of; the scene palette gives each its color.
enum SceneMaterial {
  wall,

  /// The slab under the outer walls.
  slab,
  glass,
  floorWood,
  floorTile,
  floorStone,
  wood,
  woodDark,
  woodLight,
  fabric,
  fabricLight,
  fabricDark,
  fabricRed,
  linen,
  pillow,
  white,
  steel,
  black,
  screen,
  counterTop,
  basinInner,
  leaf,
  pot,
  rug,
  lampShade,
}

/// An upright prism: [base] (a convex outline on the plan, cm) raised from [bottom] to [top] (cm above the floor).
final class SceneSolid {
  const SceneSolid({
    required this.base,
    required this.bottom,
    required this.top,
    required this.material,
    this.hiddenSides = const {},
  });

  final List<PlanPoint> base;
  final double bottom;
  final double top;
  final SceneMaterial material;

  /// Sides (by the index of their first corner in [base]) inside something else, e.g. where two pieces of a wall
  /// meet; they are never drawn.
  final Set<int> hiddenSides;
}
