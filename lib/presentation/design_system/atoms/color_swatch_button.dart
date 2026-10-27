import 'package:flutter/material.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_motion.dart';

/// Round color choice; the selected one gets a double ring (`UI Library` → "ColorSwatch").
class ColorSwatchButton extends StatelessWidget {
  const ColorSwatchButton({super.key, required this.color, required this.selected, this.onTap, this.size = 30});

  final Color color;
  final bool selected;
  final VoidCallback? onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: HubMotion.fadeDuration,
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: selected
                ? const [
                    BoxShadow(color: HubColorPalette.text, spreadRadius: 4),
                    BoxShadow(color: HubColorPalette.surface, spreadRadius: 2),
                  ]
                : null,
          ),
        ),
      ),
    );
  }
}
