import 'package:flutter/material.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_dimensions.dart';

/// Full page card (`UI Library` → "PageCard · r26").
class PageCard extends StatelessWidget {
  const PageCard({super.key, required this.child, this.padding = const EdgeInsets.all(22)});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: HubColorPalette.card,
        borderRadius: BorderRadius.circular(HubRadius.pageCard),
        border: Border.all(color: HubColorPalette.cardBorder),
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
