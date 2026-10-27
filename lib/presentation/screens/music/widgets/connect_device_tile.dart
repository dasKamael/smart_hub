import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:smart_hub/domain/music/model/connect_device.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/atoms/slider_bar.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_motion.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';
import 'package:smart_hub/presentation/screens/music/widgets/music_tile_decoration.dart';

/// A device with Spotify open. The active one stands out; its options show the volume (if the device allows it).
class ConnectDeviceTile extends StatelessWidget {
  const ConnectDeviceTile({
    super.key,
    required this.device,
    required this.playing,
    required this.active,
    required this.optionsShown,
    required this.onTap,
    required this.onLongPress,
    required this.onVolumeChanged,
    required this.onVolumeEnd,
  });

  final ConnectDevice device;

  /// Spotify plays on this device right now.
  final bool playing;

  /// Shown in "Now playing".
  final bool active;
  final bool optionsShown;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final ValueChanged<int> onVolumeChanged;
  final ValueChanged<int> onVolumeEnd;

  static HubGlyph glyphOf(ConnectDeviceType type) {
    return switch (type) {
      ConnectDeviceType.smartphone => HubGlyph.phone,
      ConnectDeviceType.tablet => HubGlyph.tablet,
      ConnectDeviceType.computer => HubGlyph.computer,
      ConnectDeviceType.tv => HubGlyph.tv,
      ConnectDeviceType.speaker => HubGlyph.speaker,
      ConnectDeviceType.other => HubGlyph.note,
    };
  }

  @override
  Widget build(BuildContext context) {
    final volume = device.volumePercent;
    return Semantics(
      button: true,
      selected: active,
      label: device.name,
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
                          child: HubGlyphIcon(glyphOf(device.type), color: HubColorPalette.text),
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
                            device.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: HubTextStyles.body.copyWith(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            device.isRestricted
                                ? 'Spotify · no remote control'
                                : volume == null
                                ? 'Spotify'
                                : 'Spotify · $volume%',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: HubTextStyles.label.copyWith(color: HubColorPalette.text2).tabular,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned.fill(
                child: IgnorePointer(
                  ignoring: !optionsShown,
                  child: AnimatedOpacity(
                    opacity: optionsShown ? 1 : 0,
                    duration: HubMotion.fadeDuration,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        enabled: optionsShown,
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: ColoredBox(
                          color: HubColorPalette.surface.withValues(alpha: 0.72),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              spacing: 8,
                              children: [
                                if (device.supportsVolume && !device.isRestricted)
                                  Expanded(
                                    child: SliderBar(
                                      value: volume ?? 0,
                                      fillColor: HubColorPalette.text,
                                      labelBuilder: (value) => '$value%',
                                      onChanged: onVolumeChanged,
                                      onChangeEnd: onVolumeEnd,
                                    ),
                                  )
                                else
                                  Expanded(
                                    child: Text(
                                      'Spotify does not allow changing the volume here',
                                      textAlign: TextAlign.center,
                                      style: HubTextStyles.label.copyWith(color: HubColorPalette.text2),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
