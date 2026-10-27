import 'package:flutter/material.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_area_colors.dart';

/// Dashboard widget sizes on the 170 px grid with 16 px gaps (`README` → "Widget grid").
enum WidgetSize {
  small(1, 1),
  medium(2, 1),
  large(2, 2),
  extraLarge(4, 2);

  const WidgetSize(this.columns, this.rows);

  static const unit = 170.0;
  static const gap = 16.0;

  final int columns;
  final int rows;

  Size get size => Size(columns * unit + (columns - 1) * gap, rows * unit + (rows - 1) * gap);
}

/// A dashboard widget: fixed size, radius 24, surface color; tappable when [onTap] is set.
class WidgetTile extends StatelessWidget {
  const WidgetTile({
    super.key,
    required this.size,
    required this.child,
    this.onTap,
    this.padding = 18,
    this.card = true,
    this.tint,
    this.background,
  });

  final WidgetSize size;
  final Widget child;
  final VoidCallback? onTap;
  final double padding;

  /// `false`: no card, the content stands on the dashboard (e.g. app icons).
  final bool card;

  /// The area's color (`HubAreaColors`), fading over the card from the top left; changes blend over.
  final Color? tint;

  /// Painted on the card behind the content, e.g. the weather scene.
  final Widget? background;

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: size.size,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeInOut,
          decoration: card
              ? BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      switch (tint) {
                        final tint? => HubAreaColors.cardTop(tint, HubColorPalette.card),
                        null => HubColorPalette.card,
                      },
                      HubColorPalette.card,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                )
              : const BoxDecoration(),
          // In front: a border in the decoration would take its width from the content.
          foregroundDecoration: card
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: switch (tint) {
                      final tint? => HubAreaColors.cardTop(tint, HubColorPalette.cardBorder, strength: 0.22),
                      null => HubColorPalette.cardBorder,
                    },
                  ),
                )
              : null,
          child: switch (background) {
            final background? => Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(borderRadius: BorderRadius.circular(24), child: background),
                Padding(padding: EdgeInsets.all(padding), child: child),
              ],
            ),
            null => Padding(padding: EdgeInsets.all(padding), child: child),
          },
        ),
      ),
    );
  }
}
