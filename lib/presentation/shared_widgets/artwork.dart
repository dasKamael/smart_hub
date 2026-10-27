import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';

/// Cover art. Without an image a warm gradient picked from [seed] (e.g. the title) and a note stand in, so
/// different tracks and playlists still look different.
class Artwork extends StatelessWidget {
  const Artwork({super.key, required this.seed, this.url, this.size, this.radius = 14, this.showNote = true});

  /// Colors of the prototype's covers.
  static const palette = [
    Color(0xFFC76B4A),
    Color(0xFF4A6FC7),
    Color(0xFF5C9A6A),
    Color(0xFF8A5CC7),
    Color(0xFFB8894A),
    Color(0xFF4A8FA8),
  ];

  final String seed;
  final String? url;

  /// `null` fills the parent.
  final double? size;
  final double radius;
  final bool showNote;

  /// The image of cover [url] decoded for [side] logical pixels. Covers come as 640 px squares; decoding them at the
  /// shown size keeps scrolling and loading smooth. Preloading with the same arguments hits the same cache entry.
  static ImageProvider imageOf(String url, {required double side, required double devicePixelRatio}) {
    final pixels = side.isFinite ? (side * devicePixelRatio).round() : null;
    return ResizeImage.resizeIfNeeded(pixels, null, NetworkImage(url));
  }

  /// The color an image-less cover of [seed] gets, e.g. to tint a card behind it.
  static Color colorOf(String seed) => palette[seed.codeUnits.fold(0, (a, b) => a + b) % palette.length];

  @override
  Widget build(BuildContext context) {
    final color = colorOf(seed);
    final generated = DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color, Color.lerp(color, Colors.black, 0.45) ?? color],
        ),
      ),
      child: showNote
          ? LayoutBuilder(
              builder: (context, constraints) => Center(
                child: HubGlyphIcon(
                  HubGlyph.note,
                  color: const Color(0x8CFFFFFF),
                  size: Size.square(constraints.biggest.shortestSide * 0.36),
                ),
              ),
            )
          : null,
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: size,
        height: size,
        child: switch (url) {
          final url? => LayoutBuilder(
            builder: (context, constraints) {
              final side = size ?? math.max(constraints.maxWidth, constraints.maxHeight);
              return Image(
                image: imageOf(url, side: side, devicePixelRatio: MediaQuery.devicePixelRatioOf(context)),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                // The old cover stays until the next one is decoded, so no placeholder shows in between.
                gaplessPlayback: true,
                frameBuilder: (context, image, frame, synchronous) =>
                    Stack(fit: StackFit.expand, children: [generated, image]),
                errorBuilder: (_, _, _) => generated,
              );
            },
          ),
          null => generated,
        },
      ),
    );
  }
}
