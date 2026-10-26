import 'package:flutter/material.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_motion.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';

/// Segmented tab bar with a sliding glass indicator (`UI Library` → "GlassTabBar").
class GlassTabBar extends StatelessWidget {
  const GlassTabBar({super.key, required this.labels, required this.selectedIndex, required this.onSelected});

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const tabWidth = 74.0;
  static const tabHeight = 44.0;
  static const _padding = 4.0;
  static const _gap = 2.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(_padding),
      decoration: BoxDecoration(
        color: HubColorPalette.glassFill,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: HubColorPalette.glassBorder, width: 0.5),
        boxShadow: const [BoxShadow(color: Color(0x59000000), blurRadius: 24, offset: Offset(0, 8))],
      ),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: HubMotion.tabDuration,
            curve: HubMotion.tab,
            left: selectedIndex * (tabWidth + _gap),
            top: 0,
            width: tabWidth,
            height: tabHeight,
            child: const DecoratedBox(
              decoration: BoxDecoration(
                color: HubColorPalette.glassIndicator,
                borderRadius: BorderRadius.all(Radius.circular(22)),
                border: Border(top: BorderSide(color: HubColorPalette.glassIndicatorHighlight, width: 1)),
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: _gap,
            children: [
              for (final (index, label) in labels.indexed)
                _Tab(label: label, selected: index == selectedIndex, onTap: () => onSelected(index)),
            ],
          ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          width: GlassTabBar.tabWidth,
          height: GlassTabBar.tabHeight,
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: HubMotion.fadeDuration,
              curve: HubMotion.fade,
              style: HubTextStyles.label.copyWith(color: selected ? HubColorPalette.text : HubColorPalette.text2),
              child: Text(label, maxLines: 1),
            ),
          ),
        ),
      ),
    );
  }
}
