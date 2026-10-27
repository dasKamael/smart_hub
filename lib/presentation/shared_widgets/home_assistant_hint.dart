import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_hub/common/go_router/hub_page.enum.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_button.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_dimensions.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';

/// Shown where a part needs Home Assistant while the hub runs without it; leads to the setup.
class HomeAssistantHint extends StatelessWidget {
  const HomeAssistantHint({
    super.key,
    required this.glyph,
    required this.title,
    required this.text,
    this.showConnect = true,
  });

  final HubGlyph glyph;
  final String title;
  final String text;

  /// Off where a connect button is already close by.
  final bool showConnect;

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
            if (showConnect) ...[
              const SizedBox(height: HubSpacing.s4),
              HubButton(label: 'Connect Home Assistant', onPressed: () => context.push(HubPage.setup.path)),
            ],
          ],
        ),
      ),
    );
  }
}
