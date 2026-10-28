import 'package:flutter/material.dart';
import 'package:smart_hub/presentation/design_system/layouts/hub_background.dart';
import 'package:smart_hub/presentation/design_system/molecules/glass_tab_bar.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_dimensions.dart';

/// Page frame of the hub: header (centered tab bar · trailing slot) above the page content.
class HubShell extends StatelessWidget {
  const HubShell({
    super.key,
    required this.tabLabels,
    required this.selectedTab,
    required this.onTabSelected,
    required this.child,
    this.trailing,
    this.tint,
  });

  final List<String> tabLabels;
  final int selectedTab;
  final ValueChanged<int> onTabSelected;
  final Widget? trailing;
  final Widget child;

  /// The shown page's area color; the whole sky behind it takes it on.
  final Color? tint;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HubColorPalette.bg,
      body: HubBackground(
        tint: tint,
        tintsSky: true,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(HubSpacing.s24, HubSpacing.s20, HubSpacing.s24, HubSpacing.s24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: HubSpacing.s16,
              children: [
                Row(
                  children: [
                    // Empty counterpart of the trailing slot keeps the tab bar centered.
                    const Spacer(),
                    GlassTabBar(labels: tabLabels, selectedIndex: selectedTab, onSelected: onTabSelected),
                    Expanded(
                      child: Align(alignment: Alignment.centerRight, child: trailing ?? const SizedBox.shrink()),
                    ),
                  ],
                ),
                Expanded(child: child),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
