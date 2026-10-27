import 'package:flutter/material.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_motion.dart';

enum MarkerBadge { none, alert, playing }

/// Interaction state of a marker (`README` → "Device markers", "Grouping", "Animation spec").
enum MarkerHighlight {
  none,

  /// White ring and the name pill below.
  selected,

  /// Picked up by the finger: white ring and a deep shadow.
  lifted,

  /// Where a dragged device would be grouped: blue double ring.
  dropTarget,

  /// Front marker of a collapsed group.
  stackFront,

  /// Marker behind the front one in a collapsed group.
  stackBehind,
}

/// Round device marker on the plan (`UI Library` → "Grundriss-Marker").
///
/// State is shown with rings, glow and small badges – never with text. [label] is only shown when [selected].
class DeviceMarker extends StatelessWidget {
  const DeviceMarker({
    super.key,
    required this.glyph,
    required this.background,
    required this.foreground,
    this.ringColor,
    this.ringWidth = 0,
    this.haloColor,
    this.glowColor,
    this.badge = MarkerBadge.none,
    this.highlight = MarkerHighlight.none,
    this.label,
    this.size = 44,
  });

  final HubGlyph glyph;
  final Color background;
  final Color foreground;
  final Color? ringColor;
  final double ringWidth;

  /// Soft outer ring, e.g. for overdue plants.
  final Color? haloColor;

  /// Light emitted by the device, e.g. a light that is on.
  final Color? glowColor;
  final MarkerBadge badge;
  final MarkerHighlight highlight;
  final String? label;
  final double size;

  @override
  Widget build(BuildContext context) {
    final scale = size / 44;
    return SizedBox.square(
      dimension: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: HubMotion.fadeDuration,
            curve: HubMotion.fade,
            width: size,
            height: size,
            decoration: BoxDecoration(color: background, shape: BoxShape.circle, boxShadow: _shadows()),
            alignment: Alignment.center,
            child: HubGlyphIcon(glyph, color: foreground, size: glyph.markerSize * scale),
          ),
          if (badge == MarkerBadge.alert)
            Positioned(
              top: -5 * scale,
              right: -5 * scale,
              child: _AlertBadge(size: 18 * scale),
            ),
          if (badge == MarkerBadge.playing)
            Positioned(
              bottom: -3 * scale,
              right: -3 * scale,
              child: _PlayingDot(size: 14 * scale),
            ),
          if (highlight == MarkerHighlight.selected)
            if (label case final name?)
              Positioned(
                top: size + 8,
                left: -80,
                right: -80,
                child: Center(child: _NamePill(label: name)),
              ),
        ],
      ),
    );
  }

  List<BoxShadow> _shadows() {
    return [
      if (glowColor case final glow?) BoxShadow(color: glow.withValues(alpha: 0.66), blurRadius: 16),
      if (haloColor case final halo?) BoxShadow(color: halo, spreadRadius: ringWidth + 7),
      ...switch (highlight) {
        MarkerHighlight.selected => const [
          BoxShadow(color: Color(0x80000000), blurRadius: 18, offset: Offset(0, 6)),
          BoxShadow(color: HubColorPalette.text, spreadRadius: 3),
        ],
        MarkerHighlight.lifted => const [
          BoxShadow(color: Color(0x8C000000), blurRadius: 30, offset: Offset(0, 14)),
          BoxShadow(color: HubColorPalette.text, spreadRadius: 3),
        ],
        MarkerHighlight.dropTarget => const [
          BoxShadow(color: Color(0x470A84FF), spreadRadius: 9),
          BoxShadow(color: HubColorPalette.accent, spreadRadius: 3),
        ],
        MarkerHighlight.stackFront => const [
          BoxShadow(color: Color(0x73000000), blurRadius: 10, offset: Offset(0, 4)),
          BoxShadow(color: HubColorPalette.surface, spreadRadius: 2),
        ],
        MarkerHighlight.stackBehind => const [BoxShadow(color: HubColorPalette.surface, spreadRadius: 2)],
        MarkerHighlight.none => [if (ringColor case final ring?) BoxShadow(color: ring, spreadRadius: ringWidth)],
      },
    ];
  }
}

class _AlertBadge extends StatelessWidget {
  const _AlertBadge({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: HubColorPalette.danger,
        shape: BoxShape.circle,
        border: Border.all(color: HubColorPalette.surface, width: 2),
      ),
      alignment: Alignment.center,
      child: Text(
        '!',
        style: TextStyle(fontSize: size * 0.6, fontWeight: FontWeight.w800, color: HubColorPalette.text, height: 1),
      ),
    );
  }
}

class _PlayingDot extends StatelessWidget {
  const _PlayingDot({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: HubColorPalette.success,
        shape: BoxShape.circle,
        border: Border.all(color: HubColorPalette.surface, width: 2),
      ),
    );
  }
}

class _NamePill extends StatelessWidget {
  const _NamePill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(color: const Color(0xCC000000), borderRadius: BorderRadius.circular(9)),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: HubColorPalette.text),
      ),
    );
  }
}
