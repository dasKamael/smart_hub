import 'package:flutter/material.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';

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
  });

  final WidgetSize size;
  final Widget child;
  final VoidCallback? onTap;
  final double padding;

  /// `false`: no card, the content stands on the dashboard (e.g. app icons).
  final bool card;

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: size.size,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: card ? HubColorPalette.card : null,
            borderRadius: BorderRadius.circular(24),
            border: card ? Border.all(color: HubColorPalette.cardBorder) : null,
          ),
          child: Padding(padding: EdgeInsets.all(padding), child: child),
        ),
      ),
    );
  }
}
