import 'package:flutter/material.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/atoms/power_button.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_dimensions.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_motion.dart';
import 'package:smart_hub/presentation/screens/lights/light_room.dart';
import 'package:smart_hub/presentation/utils/extension/rgb_color.extension.dart';

/// Room on the lights page: a tap anywhere on the tile switches the room and selects it, a long press only selects it.
class RoomTile extends StatelessWidget {
  const RoomTile({super.key, required this.room, required this.selected, required this.onSelect, this.onToggle});

  final LightRoom room;
  final bool selected;
  final VoidCallback onSelect;

  /// `null` while controls are disabled (offline).
  final VoidCallback? onToggle;

  @override
  Widget build(BuildContext context) {
    final color = room.color?.toColor() ?? HubColorPalette.lightWarm;
    final colors = [for (final color in room.colors) color.toColor()];
    final on = room.isOn;
    return Semantics(
      button: true,
      selected: selected,
      label: room.name,
      hint: on ? 'Turn room off' : 'Turn room on',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          onSelect();
          onToggle?.call();
        },
        onLongPress: onSelect,
        child: AnimatedContainer(
          duration: HubMotion.fadeDuration,
          curve: HubMotion.fade,
          padding: const EdgeInsets.all(HubSpacing.s16),
          decoration: BoxDecoration(
            color: on ? color.withValues(alpha: 0.18) : HubColorPalette.elevated,
            // A mixed room shows all its colors.
            gradient: on && colors.length > 1
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [for (final color in colors) color.withValues(alpha: 0.22)],
                  )
                : null,
            borderRadius: BorderRadius.circular(HubRadius.roomTile),
            // Outside stroke: a shadow would shine through the translucent tile color.
            border: Border.all(
              color: selected ? HubColorPalette.accent : Colors.transparent,
              width: 3,
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _RoomPowerButton(on: on, color: color, colors: colors),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    room.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                      color: HubColorPalette.text,
                    ),
                  ),
                  Text(
                    on ? '${room.lightsOn.length} of ${room.lights.length} on · ${room.brightnessPercent}%' : 'Off',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 15, color: on ? color : HubColorPalette.text2),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoomPowerButton extends StatelessWidget {
  const _RoomPowerButton({required this.on, required this.color, required this.colors});

  final bool on;
  final Color color;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 52 / 48,
      alignment: Alignment.topLeft,
      child: PowerButton(
        glyph: HubGlyph.bulb,
        background: on ? color : HubColorPalette.control,
        foreground: on ? HubColorPalette.surface : HubColorPalette.text2,
        glowColor: on ? color : null,
        colors: on ? colors : null,
      ),
    );
  }
}
