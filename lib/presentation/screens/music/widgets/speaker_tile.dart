import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:smart_hub/domain/music/model/playback.enum.dart';
import 'package:smart_hub/domain/music/model/speaker_state.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/atoms/slider_bar.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_motion.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';
import 'package:smart_hub/presentation/screens/music/widgets/music_tile_decoration.dart';

/// Compact speaker tile. The active one (part of what "Now playing" shows) stands out; its options – volume and
/// joining / leaving the active group – show on the tile.
class SpeakerTile extends StatelessWidget {
  const SpeakerTile({
    super.key,
    required this.speaker,
    required this.active,
    required this.optionsShown,
    required this.enabled,
    required this.onTap,
    required this.onLongPress,
    required this.onVolumeChanged,
    required this.onVolumeEnd,
    required this.onToggleGroup,
    this.canJoin = true,
  });

  final SpeakerState speaker;

  /// Joining needs a speaker group to join; leaving is always possible.
  final bool canJoin;

  /// Part of the target shown in "Now playing".
  final bool active;
  final bool optionsShown;
  final bool enabled;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final ValueChanged<int> onVolumeChanged;
  final ValueChanged<int> onVolumeEnd;
  final VoidCallback onToggleGroup;

  @override
  Widget build(BuildContext context) {
    final playing = speaker.playback.isPlaying;
    return Semantics(
      button: true,
      selected: active,
      label: speaker.name,
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: AnimatedContainer(
          duration: HubMotion.fadeDuration,
          decoration: musicTileDecoration(active: active || optionsShown),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  spacing: 12,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(color: HubColorPalette.control, shape: BoxShape.circle),
                          alignment: Alignment.center,
                          child: HubGlyphIcon(
                            HubGlyph.speaker,
                            color: speaker.playback == Playback.off ? HubColorPalette.text3 : HubColorPalette.text,
                          ),
                        ),
                        if (playing)
                          Positioned(
                            right: -2,
                            bottom: -2,
                            child: Container(
                              width: 13,
                              height: 13,
                              decoration: BoxDecoration(
                                color: HubColorPalette.playing,
                                shape: BoxShape.circle,
                                border: Border.all(color: HubColorPalette.elevated, width: 2),
                              ),
                            ),
                          ),
                      ],
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            speaker.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: HubTextStyles.body.copyWith(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            '${speaker.volumePercent}%',
                            style: HubTextStyles.label.copyWith(color: HubColorPalette.text2).tabular,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned.fill(
                child: _Options(
                  shown: optionsShown,
                  speaker: speaker,
                  enabled: enabled,
                  onVolumeChanged: onVolumeChanged,
                  onVolumeEnd: onVolumeEnd,
                  onToggleGroup: onToggleGroup,
                  showGroupButton: speaker.isGrouped || canJoin,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Options extends StatelessWidget {
  const _Options({
    required this.shown,
    required this.speaker,
    required this.enabled,
    required this.onVolumeChanged,
    required this.onVolumeEnd,
    required this.onToggleGroup,
    required this.showGroupButton,
  });

  final bool showGroupButton;
  final bool shown;
  final SpeakerState speaker;
  final bool enabled;
  final ValueChanged<int> onVolumeChanged;
  final ValueChanged<int> onVolumeEnd;
  final VoidCallback onToggleGroup;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !shown,
      child: AnimatedOpacity(
        opacity: shown ? 1 : 0,
        duration: HubMotion.fadeDuration,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            enabled: shown,
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: ColoredBox(
              color: HubColorPalette.surface.withValues(alpha: 0.72),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  spacing: 8,
                  children: [
                    Expanded(
                      child: SliderBar(
                        value: speaker.volumePercent,
                        fillColor: HubColorPalette.text,
                        labelBuilder: (value) => '$value%',
                        onChanged: enabled ? onVolumeChanged : null,
                        onChangeEnd: onVolumeEnd,
                      ),
                    ),
                    if (showGroupButton)
                      Semantics(
                        // Own node, not merged into the tile.
                        container: true,
                        button: true,
                        label: speaker.isGrouped ? 'Leave group' : 'Join group',
                        excludeSemantics: true,
                        child: GestureDetector(
                          onTap: enabled ? onToggleGroup : null,
                          child: Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: speaker.isGrouped ? HubColorPalette.control : HubColorPalette.accent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: Text(speaker.isGrouped ? 'Leave' : 'Join', style: HubTextStyles.label),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
