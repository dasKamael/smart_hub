import 'package:flutter/material.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';

/// Small pill with icon and label, e.g. the "Offline" indicator in the header.
class StatusPill extends StatelessWidget {
  const StatusPill({super.key, required this.glyph, required this.label, this.color = HubColorPalette.text});

  final HubGlyph glyph;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(color: HubColorPalette.elevated, borderRadius: BorderRadius.circular(18)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 6,
        children: [
          HubGlyphIcon(glyph, color: color, size: const Size(15, 15)),
          Text(label, style: HubTextStyles.label.copyWith(color: color)),
        ],
      ),
    );
  }
}
