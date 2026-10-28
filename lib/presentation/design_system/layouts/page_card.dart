import 'package:flutter/material.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_area_colors.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_dimensions.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_motion.dart';

/// Full page card (`UI Library` → "PageCard · r26").
class PageCard extends StatelessWidget {
  const PageCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(22),
    this.tint,
    this.color,
    this.background,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  /// The page's area color (`HubAreaColors`), fainter than on the widgets; changes blend over.
  final Color? tint;

  /// A plain fill instead of the [tint]ed gradient.
  final Color? color;

  /// Painted on the card behind the content, e.g. the weather scene.
  final Widget? background;

  /// The tint of the card around [context], e.g. for a hint of it in the tiles on the card.
  static Color? tintOf(BuildContext context) => context.dependOnInheritedWidgetOfExactType<_CardTint>()?.tint;

  /// The card's solid look, also for controls that stand on the page beside cards.
  static BoxDecoration decoration({Color? tint, Color? color, double radius = HubRadius.pageCard}) {
    return BoxDecoration(
      color: color,
      gradient: color != null
          ? null
          : LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                switch (tint) {
                  final tint? => HubAreaColors.cardTop(tint, HubColorPalette.card, strength: 0.3),
                  null => HubColorPalette.card,
                },
                HubColorPalette.card,
              ],
            ),
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: HubColorPalette.cardBorder),
    );
  }

  @override
  Widget build(BuildContext context) {
    final child = _CardTint(tint: tint, child: this.child);
    return AnimatedContainer(
      duration: HubMotion.tintDuration,
      curve: HubMotion.tint,
      padding: background == null ? padding : EdgeInsets.zero,
      decoration: decoration(tint: tint, color: color),
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

class _CardTint extends InheritedWidget {
  const _CardTint({required this.tint, required super.child});

  final Color? tint;

  @override
  bool updateShouldNotify(_CardTint oldWidget) => tint != oldWidget.tint;
}
