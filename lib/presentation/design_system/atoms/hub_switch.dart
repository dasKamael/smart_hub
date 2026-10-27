import 'package:flutter/material.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_motion.dart';

/// On/off switch in the hub style.
class HubSwitch extends StatelessWidget {
  const HubSwitch({super.key, required this.value, this.onChanged, this.semanticLabel});

  final bool value;

  /// `null` disables the switch.
  final ValueChanged<bool>? onChanged;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      toggled: value,
      enabled: onChanged != null,
      label: semanticLabel,
      child: GestureDetector(
        onTap: switch (onChanged) {
          final onChanged? => () => onChanged(!value),
          null => null,
        },
        child: AnimatedOpacity(
          opacity: onChanged == null ? 0.4 : 1,
          duration: HubMotion.fadeDuration,
          child: AnimatedContainer(
            duration: HubMotion.fadeDuration,
            curve: HubMotion.fade,
            width: 51,
            height: 31,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: value ? HubColorPalette.success : HubColorPalette.control,
              borderRadius: BorderRadius.circular(16),
            ),
            child: AnimatedAlign(
              duration: HubMotion.popDuration,
              curve: HubMotion.pop,
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 27,
                height: 27,
                decoration: const BoxDecoration(
                  color: HubColorPalette.text,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Color(0x40000000), blurRadius: 4, offset: Offset(0, 2))],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
