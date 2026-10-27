import 'package:flutter/material.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_area_colors.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_dimensions.dart';

/// Full page card (`UI Library` → "PageCard · r26").
class PageCard extends StatelessWidget {
  const PageCard({super.key, required this.child, this.padding = const EdgeInsets.all(22), this.tint, this.background});

  final Widget child;
  final EdgeInsetsGeometry padding;

  /// The page's area color (`HubAreaColors`), fainter than on the widgets; changes blend over.
  final Color? tint;

  /// Painted on the card behind the content, e.g. the weather scene.
  final Widget? background;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeInOut,
      padding: background == null ? padding : EdgeInsets.zero,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            switch (tint) {
              final tint? => HubAreaColors.cardTop(tint, HubColorPalette.card, strength: 0.22),
              null => HubColorPalette.card,
            },
            HubColorPalette.card,
          ],
        ),
        borderRadius: BorderRadius.circular(HubRadius.pageCard),
        border: Border.all(color: HubColorPalette.cardBorder),
      ),
      child: switch (background) {
        final background? => Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(borderRadius: BorderRadius.circular(HubRadius.pageCard), child: background),
            Padding(padding: padding, child: child),
          ],
        ),
        null => child,
      },
    );
  }
}
