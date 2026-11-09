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
    this.glyphColor,
    this.ringColor,
    this.alert = false,
  });

  static const size = 29.0;

  final HubGlyph glyph;
  final bool on;
  final String semanticLabel;
  final Color? glow;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  /// Overrides the glyph's color when off, e.g. green for a plant.
  final Color? glyphColor;

  /// A colored ring instead of the thin white one when off, e.g. a plant that needs water.
  final Color? ringColor;

  /// A red dot at the top right: something needs attention (an overdue plant).
  final bool alert;

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
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedContainer(
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
                        : (on ? const Color(0x00FFFFFF) : ringColor ?? HomeSceneColorPalette.markerOffBorder),
                    width: selected || ringColor != null ? 2 : 1.2,
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
                  color: on ? HomeSceneColorPalette.markerOnGlyph : glyphColor ?? HomeSceneColorPalette.markerOffGlyph,
                  size: Size(glyph.markerSize.width * 0.85, glyph.markerSize.height * 0.85),
                ),
              ),
              if (alert)
                Positioned(
                  top: (44 - size) / 2 - 3,
                  right: (44 - size) / 2 - 3,
                  child: Container(
                    width: 11,
                    height: 11,
                    decoration: BoxDecoration(
                      color: HomeSceneColorPalette.markerAlert,
                      shape: BoxShape.circle,
                      border: Border.all(color: HomeSceneColorPalette.background, width: 1.5),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
