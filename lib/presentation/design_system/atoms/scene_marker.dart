import 'package:flutter/widgets.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/tokens/home_scene.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_motion.dart';

/// A device in the 3D home (`appartment.mp4`): a dark glass circle with a white glyph, or – when [on] – a lit cream
/// circle with an orange glyph and a glow in [glow].
class SceneMarker extends StatelessWidget {
  const SceneMarker({
    super.key,
    required this.glyph,
    required this.on,
    required this.semanticLabel,
    this.glow,
    this.selected = false,
    this.onTap,
    this.onLongPress,
  });

  static const size = 32.0;

  final HubGlyph glyph;
  final bool on;
  final String semanticLabel;
  final Color? glow;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final glowColor = glow ?? HomeSceneColorPalette.markerGlow;
    return Semantics(
      button: true,
      toggled: on,
      label: semanticLabel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        onLongPress: onLongPress,
        // Larger than the circle, so it is easy to hit.
        child: SizedBox.square(
          dimension: 44,
          child: Center(
            child: AnimatedContainer(
              duration: HubMotion.fadeDuration,
              curve: HubMotion.fade,
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: on ? HomeSceneColorPalette.markerOn : HomeSceneColorPalette.markerOff,
                border: Border.all(
                  color: selected
                      ? HomeSceneColorPalette.markerOn
                      : (on ? const Color(0x00FFFFFF) : HomeSceneColorPalette.markerOffBorder),
                  width: selected ? 2 : 1.2,
                ),
                boxShadow: on
                    ? [
                        BoxShadow(color: glowColor.withValues(alpha: 0.75), blurRadius: 18, spreadRadius: 2),
                        BoxShadow(color: glowColor.withValues(alpha: 0.35), blurRadius: 34, spreadRadius: 6),
                      ]
                    : null,
              ),
              alignment: Alignment.center,
              child: HubGlyphIcon(
                glyph,
                color: on ? HomeSceneColorPalette.markerOnGlyph : HomeSceneColorPalette.markerOffGlyph,
                size: Size(glyph.markerSize.width * 0.85, glyph.markerSize.height * 0.85),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
