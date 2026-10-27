import 'package:flutter/material.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_motion.dart';

/// 48 px device icon; tapping it toggles the device (`UI Library` → "PowerToggle").
class PowerButton extends StatelessWidget {
  const PowerButton({
    super.key,
    required this.glyph,
    required this.background,
    required this.foreground,
    this.glowColor,
    this.onTap,
    this.semanticLabel,
  });

  final HubGlyph glyph;
  final Color background;
  final Color foreground;
  final Color? glowColor;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: onTap != null,
      label: semanticLabel,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: HubMotion.fadeDuration,
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: background,
            shape: BoxShape.circle,
            boxShadow: [if (glowColor case final glow?) BoxShadow(color: glow.withValues(alpha: 0.66), blurRadius: 16)],
          ),
          alignment: Alignment.center,
          child: HubGlyphIcon(
            glyph,
            color: foreground,
            size: Size(glyph.markerSize.width * 16 / 15, glyph.markerSize.height * 20 / 19),
          ),
        ),
      ),
    );
  }
}
