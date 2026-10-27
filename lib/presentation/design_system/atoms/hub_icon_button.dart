import 'package:flutter/material.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_dimensions.dart';

/// Round icon button with the minimum touch target size.
class HubIconButton extends StatelessWidget {
  const HubIconButton({super.key, required this.glyph, required this.onPressed, required this.semanticLabel});

  final HubGlyph glyph;
  final VoidCallback onPressed;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: HubSizes.minTouchTarget,
          height: HubSizes.minTouchTarget,
          decoration: BoxDecoration(
            color: HubColorPalette.glassFill,
            shape: BoxShape.circle,
            border: Border.all(color: HubColorPalette.glassBorder, width: 0.5),
          ),
          alignment: Alignment.center,
          child: HubGlyphIcon(glyph, color: HubColorPalette.text2),
        ),
      ),
    );
  }
}
