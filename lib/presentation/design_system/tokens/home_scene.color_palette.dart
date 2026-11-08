import 'package:flutter/painting.dart';
import 'package:smart_hub/presentation/design_system/organisms/home_scene/scene_solid.dart';

/// Colors of the 3D home at night: lavender walls, dark floors, furniture in muted tones (`appartment.mp4`).
abstract final class HomeSceneColorPalette {
  /// Behind the model.
  static const background = Color(0xFF1B1918);

  /// Light of the night sky falling on the model, and the share of it everywhere (no shadows).
  static const moonlight = Color(0xFFFFFFFF);
  static const ambient = 0.78;

  /// Inside the rooms it is darker than on the outer walls.
  static const indoors = 0.52;

  /// Furniture gets only this share of the sky's light, so that a lamp's room stands out from the dark ones.
  static const furnitureSky = 0.5;

  /// Joints between floorboards.
  static const floorJoint = Color(0x24000000);

  /// Darkening of walls and furniture right above the floor, fading out by 1.4 m.
  static const floorShade = 0.42;

  /// The cut tops of the walls: lighter than their sides, a crisp edge.
  static const wallTop = Color(0xFF6A7699);

  /// How much of their own color furniture models keep; the rest turns grey, for the muted look at night.
  static const furnitureSaturation = 0.72;

  /// [color] of a furniture model, muted.
  static Color furniture(Color color) {
    final grey = 0.3 * color.r + 0.59 * color.g + 0.11 * color.b;
    double mix(double channel) => (grey + (channel - grey) * furnitureSaturation) * 0.92;
    return Color.from(alpha: color.a, red: mix(color.r), green: mix(color.g), blue: mix(color.b));
  }

  /// Light marker, off and on (`appartment.mp4`).
  static const markerOff = Color(0x8C26282E);
  static const markerOffBorder = Color(0x66FFFFFF);
  static const markerOffGlyph = Color(0xFFE9E9EE);
  static const markerOn = Color(0xFFF7E1C0);
  static const markerOnGlyph = Color(0xFFE49D54);
  static const markerGlow = Color(0x99F2B36B);

  static const _materials = {
    SceneMaterial.wall: Color(0xFF56617D),
    SceneMaterial.slab: Color(0xFF2E3648),
    SceneMaterial.glass: Color(0x5598B4D4),
    SceneMaterial.floorWood: Color(0xFF4A3628),
    SceneMaterial.floorTile: Color(0xFF4A5060),
    SceneMaterial.floorStone: Color(0xFF4E5868),
    SceneMaterial.wood: Color(0xFF7A5A40),
    SceneMaterial.woodDark: Color(0xFF4A3426),
    SceneMaterial.woodLight: Color(0xFFA27E5C),
    SceneMaterial.fabric: Color(0xFF4F5A70),
    SceneMaterial.fabricLight: Color(0xFF66728A),
    SceneMaterial.fabricDark: Color(0xFF34384A),
    SceneMaterial.fabricRed: Color(0xFF9C2A2A),
    SceneMaterial.linen: Color(0xFFC8C8CE),
    SceneMaterial.pillow: Color(0xFFDCDCE0),
    SceneMaterial.white: Color(0xFFD2D4DA),
    SceneMaterial.steel: Color(0xFF8A9098),
    SceneMaterial.black: Color(0xFF26272B),
    SceneMaterial.screen: Color(0xFF15161A),
    SceneMaterial.counterTop: Color(0xFF6A6460),
    SceneMaterial.basinInner: Color(0xFF9AA6B8),
    SceneMaterial.leaf: Color(0xFF2E5A36),
    SceneMaterial.pot: Color(0xFF8A6A52),
    SceneMaterial.rug: Color(0xFF3C4250),
    SceneMaterial.lampShade: Color(0xFFE8DCC8),
  };

  static Color of(SceneMaterial material) => _materials[material]!;
}
