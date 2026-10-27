import 'package:flutter/material.dart';
import 'package:smart_hub/domain/lights/model/light_scene.dart';
import 'package:smart_hub/presentation/design_system/atoms/vertical_slider.dart';
import 'package:smart_hub/presentation/design_system/layouts/page_card.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_dimensions.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_motion.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';
import 'package:smart_hub/presentation/screens/lights/light_room.dart';
import 'package:smart_hub/presentation/utils/extension/rgb_color.extension.dart';

/// Right card of the lights page: brightness and scenes of the selected room.
class RoomDetailCard extends StatelessWidget {
  const RoomDetailCard({
    super.key,
    required this.room,
    required this.enabled,
    required this.onBrightnessChanged,
    required this.onBrightnessEnd,
    required this.onScene,
  });

  final LightRoom room;
  final bool enabled;
  final ValueChanged<int> onBrightnessChanged;
  final ValueChanged<int> onBrightnessEnd;
  final ValueChanged<LightScene> onScene;

  @override
  Widget build(BuildContext context) {
    final active = room.activeScene;
    return PageCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: HubSpacing.s16,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(room.name, style: HubTextStyles.sectionTitle),
              Text(room.isOn ? 'On · ${room.brightnessPercent}% brightness' : 'Off', style: HubTextStyles.secondary),
            ],
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 18,
              children: [
                VerticalSlider(
                  value: room.brightnessPercent,
                  fillColor: room.color?.toColor() ?? HubColorPalette.lightWarm,
                  label: room.isOn ? '${room.brightnessPercent}%' : 'Off',
                  onChanged: enabled ? onBrightnessChanged : null,
                  onChangeEnd: onBrightnessEnd,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    spacing: 10,
                    children: [
                      Text('Scenes', style: HubTextStyles.secondary.copyWith(fontWeight: FontWeight.w600)),
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            // Buttons share the height, at most 64 px each, stacked from the top.
                            final count = LightScene.all.length;
                            final height = ((constraints.maxHeight - (count - 1) * 10) / count).clamp(0.0, 64.0);
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              spacing: 10,
                              children: [
                                for (final scene in LightScene.all)
                                  SizedBox(
                                    height: height,
                                    child: _SceneButton(
                                      scene: scene,
                                      active: scene == active,
                                      onTap: enabled ? () => onScene(scene) : null,
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SceneButton extends StatelessWidget {
  const _SceneButton({required this.scene, required this.active, this.onTap});

  final LightScene scene;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: active,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: HubMotion.fadeDuration,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: active ? HubColorPalette.accent : HubColorPalette.elevated,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            spacing: 12,
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(color: scene.color.toColor(), shape: BoxShape.circle),
              ),
              Text(
                scene.name,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: HubColorPalette.text),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
