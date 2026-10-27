import 'package:flutter/material.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_motion.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';

/// Icon, number and a short label – a glanceable key figure like in a weather widget.
class StatChip extends StatelessWidget {
  const StatChip({super.key, required this.glyph, required this.color, required this.value, required this.label});

  final HubGlyph glyph;
  final Color color;
  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final active = value > 0;
    return AnimatedContainer(
      duration: HubMotion.fadeDuration,
      padding: const EdgeInsets.fromLTRB(10, 8, 16, 8),
      decoration: BoxDecoration(
        color: active ? color.withValues(alpha: 0.14) : HubColorPalette.elevated,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: active ? color : HubColorPalette.control, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: HubGlyphIcon(glyph, color: active ? HubColorPalette.surface : HubColorPalette.text2),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$value', style: HubTextStyles.widgetTitle.copyWith(fontSize: 22, height: 1.1).tabular),
              Text(label, style: HubTextStyles.label.copyWith(color: HubColorPalette.text2)),
            ],
          ),
        ],
      ),
    );
  }
}
