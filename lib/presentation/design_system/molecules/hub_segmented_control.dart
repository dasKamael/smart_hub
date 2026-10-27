import 'package:flutter/material.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_motion.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';

/// A row of equal choices in a pill, the selected one lifted (as the system's segmented control).
class HubSegmentedControl<T> extends StatelessWidget {
  const HubSegmentedControl({
    super.key,
    required this.values,
    required this.selected,
    required this.labelOf,
    required this.onChanged,
    this.height = 40,
  });

  final List<T> values;
  final T selected;
  final String Function(T value) labelOf;
  final ValueChanged<T> onChanged;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(color: HubColorPalette.control, borderRadius: BorderRadius.circular(height / 2)),
      child: Row(
        children: [
          for (final value in values)
            Expanded(
              child: Semantics(
                button: true,
                selected: value == selected,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onChanged(value),
                  child: AnimatedContainer(
                    duration: HubMotion.fadeDuration,
                    curve: HubMotion.fade,
                    decoration: BoxDecoration(
                      color: value == selected ? const Color(0x38FFFFFF) : const Color(0x00FFFFFF),
                      borderRadius: BorderRadius.circular(height / 2),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      labelOf(value),
                      style: HubTextStyles.label.copyWith(
                        fontSize: 14,
                        color: value == selected ? HubColorPalette.text : HubColorPalette.text2,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
