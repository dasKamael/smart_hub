import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';
import 'package:smart_hub/presentation/screens/focus/focus.controller.dart';

/// One focus point under the clock in the zen mode: what it is and how long is left. Which one changes with [now]:
/// it rides on the minute the zen mode already counts, instead of keeping a timer of its own. Only to read – the
/// zen mode is where the goal finds you, not where you work on it. Shows nothing while no focus point is active.
class FocusWhisper extends ConsumerWidget {
  const FocusWhisper({super.key, required this.now});

  final DateTime now;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = ref.watch(focusPlanProvider);
    if (plan.isEmpty) return const SizedBox.shrink();
    final entry = plan[now.minute % plan.length];
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 1200),
      child: Row(
        key: ValueKey(entry.point.id),
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          const HubGlyphIcon(HubGlyph.target, color: HubColorPalette.text3, size: Size.square(16)),
          Flexible(
            child: Text(
              entry.point.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: HubTextStyles.secondary.copyWith(fontSize: 20, color: HubColorPalette.text2),
            ),
          ),
          Text(
            entry.countdown,
            style: HubTextStyles.secondary.copyWith(fontSize: 18, color: HubColorPalette.text3).tabular,
          ),
        ],
      ),
    );
  }
}
