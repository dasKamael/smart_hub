import 'package:flutter/material.dart';
import 'package:smart_hub/presentation/design_system/molecules/glass_tab_bar.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_dimensions.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';

/// Page frame of the hub: header (title · tab bar · trailing slot) above the page content.
class HubShell extends StatelessWidget {
  const HubShell({
    super.key,
    required this.title,
    required this.tabLabels,
    required this.selectedTab,
    required this.onTabSelected,
    required this.child,
    this.trailing,
  });

  final String title;
  final List<String> tabLabels;
  final int selectedTab;
  final ValueChanged<int> onTabSelected;
  final Widget? trailing;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HubColorPalette.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(HubSpacing.s24, HubSpacing.s20, HubSpacing.s24, HubSpacing.s24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: HubSpacing.s16,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(title, style: HubTextStyles.pageTitle, maxLines: 1, overflow: TextOverflow.ellipsis),
                  ),
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
    );
  }
}
