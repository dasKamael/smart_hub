import 'package:flutter/material.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';

/// An empty place: a faded symbol of what would be there, no words – the layout already says what is missing.
/// [label] is for screen readers only.
class EmptyMark extends StatelessWidget {
  const EmptyMark({super.key, required this.glyph, required this.label, this.size = 56});

  final HubGlyph glyph;
  final String label;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Semantics(
        container: true,
        label: label,
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: const BoxDecoration(color: HubColorPalette.elevated, shape: BoxShape.circle),
          child: HubGlyphIcon(glyph, color: HubColorPalette.text3, size: Size.square(size * 0.4)),
        ),
      ),
    );
  }
}
