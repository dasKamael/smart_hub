import 'package:flutter/material.dart';
import 'package:smart_hub/domain/lights/model/room_scene.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/atoms/vertical_slider.dart';
import 'package:smart_hub/presentation/design_system/layouts/page_card.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_dimensions.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_motion.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';
import 'package:smart_hub/presentation/screens/lights/light_room.dart';
import 'package:smart_hub/presentation/utils/extension/rgb_color.extension.dart';

/// A scene as the room shows it: the color it gives this room and whether the room shines like it now.
typedef SceneEntry = ({RoomScene scene, Color color, bool active});

/// What a long press on a scene offers.
final class SceneActions {
  const SceneActions({
    required this.onOptions,
    required this.onOverwrite,
    required this.onRename,
    required this.onDelete,
    required this.onAdd,
  });

  final ValueChanged<RoomScene> onOptions;
  final ValueChanged<RoomScene> onOverwrite;
  final ValueChanged<RoomScene> onRename;
  final ValueChanged<RoomScene> onDelete;

  /// `null` while the room has as many scenes as it can.
  final VoidCallback? onAdd;
}

/// Right card of the lights page: brightness and the scenes of the selected room. A long press on a scene shows its
/// options: save the current light into it, rename, delete.
class RoomDetailCard extends StatelessWidget {
  const RoomDetailCard({
    super.key,
    required this.room,
    required this.enabled,
    required this.onBrightnessChanged,
    required this.onBrightnessEnd,
    required this.scenes,
    required this.openSceneId,
    required this.onScene,
    required this.actions,
    this.onColor,
    this.tint,
  });

  final LightRoom room;
  final bool enabled;
  final ValueChanged<int> onBrightnessChanged;
  final ValueChanged<int> onBrightnessEnd;
  final List<SceneEntry> scenes;
  final String? openSceneId;
  final ValueChanged<RoomScene> onScene;
  final SceneActions actions;

  /// Opens the color wheel; `null` when the lights here have no colors or white tones.
  final VoidCallback? onColor;
  final Color? tint;

  @override
  Widget build(BuildContext context) {
    return PageCard(
      tint: tint,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: HubSpacing.s16,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(room.name, style: HubTextStyles.sectionTitle),
                    Text(
                      room.isOn ? 'On · ${room.brightnessPercent}% brightness' : 'Off',
                      style: HubTextStyles.secondary,
                    ),
                  ],
                ),
              ),
              if (onColor case final onColor?) _ColorButton(onTap: enabled ? onColor : null),
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
                  fillColors: [for (final color in room.colors) color.toColor()],
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
                            final count = scenes.length + (actions.onAdd == null ? 0 : 1);
                            final height = ((constraints.maxHeight - (count - 1) * 10) / count).clamp(0.0, 64.0);
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              spacing: 10,
                              children: [
                                for (final entry in scenes)
                                  SizedBox(
                                    height: height,
                                    child: _SceneButton(
                                      entry: entry,
                                      open: entry.scene.id == openSceneId,
                                      canDelete: scenes.length > 1,
                                      onTap: enabled ? () => onScene(entry.scene) : null,
                                      actions: actions,
                                    ),
                                  ),
                                if (actions.onAdd case final onAdd?)
                                  SizedBox(
                                    height: height,
                                    child: _AddSceneButton(onTap: onAdd),
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
  const _SceneButton({
    required this.entry,
    required this.open,
    required this.canDelete,
    required this.onTap,
    required this.actions,
  });

  final SceneEntry entry;
  final bool open;
  final bool canDelete;
  final VoidCallback? onTap;
  final SceneActions actions;

  @override
  Widget build(BuildContext context) {
    final scene = entry.scene;
    return Semantics(
      button: true,
      selected: entry.active,
      child: GestureDetector(
        onTap: open ? () => actions.onOptions(scene) : onTap,
        onLongPress: () => actions.onOptions(scene),
        child: AnimatedContainer(
          duration: HubMotion.fadeDuration,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: entry.active ? HubColorPalette.accent : HubColorPalette.elevated,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            spacing: 12,
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(color: entry.color, shape: BoxShape.circle),
              ),
              Expanded(
                child: Text(
                  scene.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: HubColorPalette.text),
                ),
              ),
              if (open) ...[
                _OptionIcon(glyph: HubGlyph.sync, label: 'Save current light', onTap: () => actions.onOverwrite(scene)),
                _OptionIcon(glyph: HubGlyph.pencil, label: 'Rename', onTap: () => actions.onRename(scene)),
                if (canDelete)
                  _OptionIcon(
                    glyph: HubGlyph.minus,
                    label: 'Delete',
                    onTap: () => actions.onDelete(scene),
                    danger: true,
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionIcon extends StatelessWidget {
  const _OptionIcon({required this.glyph, required this.label, required this.onTap, this.danger = false});

  final HubGlyph glyph;
  final String label;
  final VoidCallback onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      button: true,
      label: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          width: 36,
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: danger ? HubColorPalette.danger : HubColorPalette.control,
            shape: BoxShape.circle,
          ),
          child: HubGlyphIcon(glyph, color: HubColorPalette.text, size: const Size.square(15)),
        ),
      ),
    );
  }
}

/// "+ Scene": saves how the room shines now.
class _AddSceneButton extends StatelessWidget {
  const _AddSceneButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Add scene',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: HubColorPalette.controlStrong),
          ),
          child: const Row(
            spacing: 12,
            children: [
              HubGlyphIcon(HubGlyph.plus, color: HubColorPalette.text2, size: Size.square(14)),
              Expanded(
                child: Text(
                  'New scene',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 15, color: HubColorPalette.text2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A round button in all colors that opens the color wheel.
class _ColorButton extends StatelessWidget {
  const _ColorButton({required this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Colors',
      child: GestureDetector(
        onTap: onTap,
        child: Opacity(
          opacity: onTap == null ? 0.4 : 1,
          child: Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: SweepGradient(
                colors: [
                  Color(0xFFFF5F5F),
                  Color(0xFFFFC85F),
                  Color(0xFF8CF06E),
                  Color(0xFF5FD2FF),
                  Color(0xFF8C6EFF),
                  Color(0xFFFF6EC8),
                  Color(0xFFFF5F5F),
                ],
              ),
            ),
            padding: const EdgeInsets.all(4),
            child: Container(
              decoration: const BoxDecoration(color: HubColorPalette.surface, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(color: HubColorPalette.text, shape: BoxShape.circle),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
