import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:smart_hub/domain/plants/model/plant.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';

/// Photo of a plant; without a photo an illustrated potted plant on a soft gradient stands in. The gradient varies
/// per plant, so a list of plants without photos does not look uniform.
class PlantPhoto extends StatelessWidget {
  const PlantPhoto({super.key, required this.plant, required this.size, this.radius = 18, this.ringColor});

  /// Deep greens and teals that sit well on the dark surfaces.
  static const _palettes = [
    (Color(0xFF2E7D5B), Color(0xFF173F2E)),
    (Color(0xFF2F7F86), Color(0xFF173E42)),
    (Color(0xFF5E8F3A), Color(0xFF2C461B)),
    (Color(0xFF3A8F6B), Color(0xFF1B4635)),
    (Color(0xFF4F7F9A), Color(0xFF233B49)),
  ];

  final Plant plant;
  final double size;
  final double radius;

  /// E.g. red for overdue plants.
  final Color? ringColor;

  @override
  Widget build(BuildContext context) {
    final (light, dark) = _palettes[plant.id.codeUnits.fold(0, (a, b) => a + b) % _palettes.length];
    final illustration = DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [light, dark]),
      ),
      child: Center(
        child: HubGlyphIcon(
          HubGlyph.pottedPlant,
          color: const Color(0xE6FFFFFF),
          size: Size.square(math.max(14, size * 0.52)),
        ),
      ),
    );
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [if (ringColor case final ring?) BoxShadow(color: ring, spreadRadius: 3)],
      ),
      clipBehavior: Clip.antiAlias,
      child: switch (plant.photoPath) {
        final path? => Image.file(
          File(path),
          fit: BoxFit.cover,
          cacheWidth: (size * 3).round(),
          errorBuilder: (_, _, _) => illustration,
        ),
        null => illustration,
      },
    );
  }
}
