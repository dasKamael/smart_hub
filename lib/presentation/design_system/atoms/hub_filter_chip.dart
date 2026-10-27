import 'package:flutter/material.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_motion.dart';

/// On/off chip for layers and filters (`UI Library` → "FilterChip").
class HubFilterChip extends StatelessWidget {
  const HubFilterChip({super.key, required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      toggled: selected,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: HubMotion.fadeDuration,
          curve: HubMotion.fade,
          height: 34,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: selected ? HubColorPalette.accentTint : HubColorPalette.elevated,
            borderRadius: BorderRadius.circular(17),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: selected ? HubColorPalette.accentText : HubColorPalette.text2,
            ),
          ),
        ),
      ),
    );
  }
}
