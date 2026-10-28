import 'package:flutter/material.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_button.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_dimensions.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';

/// A page with nothing on it says why: a symbol, what is the matter and what to do about it. For tiles and lists
/// inside a page the wordless `EmptyMark` is enough – a whole page needs the words.
class PageHint extends StatelessWidget {
  const PageHint({super.key, required this.glyph, required this.title, required this.text, this.action});

  final HubGlyph glyph;
  final String title;
  final String text;

  /// What to do about it; nothing where there is nothing to do but wait.
  final ({String label, VoidCallback onPressed})? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: HubSpacing.s12,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(color: HubColorPalette.elevated, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: HubGlyphIcon(glyph, color: HubColorPalette.text2, size: const Size.square(28)),
            ),
            Text(title, style: HubTextStyles.widgetTitle, textAlign: TextAlign.center),
            Text(text, style: HubTextStyles.secondary, textAlign: TextAlign.center),
            if (action case final action?) ...[
              const SizedBox(height: HubSpacing.s4),
              HubButton(label: action.label, variant: HubButtonVariant.secondary, onPressed: action.onPressed),
            ],
          ],
        ),
      ),
    );
  }
}
