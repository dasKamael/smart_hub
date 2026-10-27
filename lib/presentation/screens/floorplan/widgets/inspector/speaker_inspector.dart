import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hub/domain/floorplan/model/floor_plan.dart';
import 'package:smart_hub/domain/music/model/playback.enum.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_button.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/atoms/power_button.dart';
import 'package:smart_hub/presentation/design_system/atoms/slider_bar.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';
import 'package:smart_hub/presentation/screens/floorplan/floorplan.controller.dart';
import 'package:smart_hub/presentation/screens/floorplan/plan_device.dart';
import 'package:smart_hub/presentation/screens/floorplan/widgets/inspector/inspector_header.dart';

/// Playback, volume and group of one speaker.
class SpeakerInspector extends ConsumerWidget {
  const SpeakerInspector({super.key, required this.device, required this.plan, required this.enabled});

  final PlanSpeaker device;
  final FloorPlan plan;
  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(floorplanControllerProvider.notifier);
    final speaker = device.speaker;
    final status = switch (speaker.playback) {
      Playback.playing => 'Playing',
      Playback.paused => 'Paused',
      Playback.idle => 'Idle',
      Playback.off => 'Off',
    };

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 14,
      children: [
        Row(
          spacing: 14,
          children: [
            PowerButton(
              glyph: HubGlyph.speaker,
              background: HubColorPalette.elevated,
              foreground: speaker.playback == Playback.off ? HubColorPalette.text3 : HubColorPalette.text,
            ),
            Expanded(
              child: InspectorTitle(
                title: speaker.name,
                subtitle: '${roomNameOf(device, plan)} · ${speaker.isGrouped ? status : '$status · Not in group'}',
              ),
            ),
            HubButton(
              label: speaker.isGrouped ? 'Leave group' : 'Join group',
              variant: HubButtonVariant.secondary,
              height: 36,
              onPressed: enabled ? () => controller.toggleGroup(speaker) : null,
            ),
            HubButton(
              label: 'Remove',
              variant: HubButtonVariant.destructive,
              height: 36,
              onPressed: () => controller.removeDevice(speaker.id),
            ),
          ],
        ),
        Row(
          spacing: 12,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: HubColorPalette.elevated, borderRadius: BorderRadius.circular(8)),
              alignment: Alignment.center,
              child: const HubGlyphIcon(HubGlyph.speaker, color: HubColorPalette.text3, size: Size(11, 14)),
            ),
            SizedBox(
              width: 150,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    speaker.title ?? 'Nothing playing',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: HubTextStyles.body.copyWith(fontSize: 15),
                  ),
                  Text(
                    speaker.artist ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: HubTextStyles.label.copyWith(fontWeight: FontWeight.w400, color: HubColorPalette.text2),
                  ),
                ],
              ),
            ),
            _PlayPauseButton(
              playing: speaker.playback.isPlaying,
              onTap: enabled ? () => controller.playPause(speaker.id) : null,
            ),
            Expanded(
              child: SliderBar(
                value: speaker.volumePercent,
                fillColor: HubColorPalette.text,
                labelBuilder: (value) => 'Volume $value%',
                onChanged: enabled ? (value) => controller.changeVolume(speaker.id, value) : null,
                onChangeEnd: (value) => controller.endVolume(speaker.id, value),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PlayPauseButton extends StatelessWidget {
  const _PlayPauseButton({required this.playing, this.onTap});

  final bool playing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: playing ? 'Pause' : 'Play',
      child: GestureDetector(
        onTap: onTap,
        child: Opacity(
          opacity: onTap == null ? 0.4 : 1,
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(color: HubColorPalette.text, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: HubGlyphIcon(playing ? HubGlyph.pause : HubGlyph.play, color: HubColorPalette.surface),
          ),
        ),
      ),
    );
  }
}
