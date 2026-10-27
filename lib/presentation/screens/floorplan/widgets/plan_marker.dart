import 'package:flutter/widgets.dart';
import 'package:smart_hub/domain/music/model/playback.enum.dart';
import 'package:smart_hub/domain/plants/model/watering_state.enum.dart';
import 'package:smart_hub/presentation/design_system/atoms/device_marker.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/screens/floorplan/plan_device.dart';
import 'package:smart_hub/presentation/utils/extension/rgb_color.extension.dart';

/// Color a light shines in on the plan; lights without color information glow warm.
Color planLightColor(PlanLight device) => device.light.displayColor?.toColor() ?? HubColorPalette.lightWarm;

/// Marker for [device] in its current state (`README` → "Device markers").
class PlanMarker extends StatelessWidget {
  const PlanMarker({
    super.key,
    required this.device,
    this.highlight = MarkerHighlight.none,
    this.size = 44,
    this.showBadges = true,
  });

  final PlanDevice device;
  final MarkerHighlight highlight;
  final double size;

  /// `false` inside a collapsed group, where the count pill carries the state.
  final bool showBadges;

  @override
  Widget build(BuildContext context) {
    return switch (device) {
      final PlanLight light when light.light.isOn => DeviceMarker(
        glyph: HubGlyph.bulb,
        background: planLightColor(light),
        foreground: HubColorPalette.surface,
        glowColor: planLightColor(light),
        highlight: highlight,
        label: device.name,
        size: size,
      ),
      PlanLight() => DeviceMarker(
        glyph: HubGlyph.bulb,
        background: HubColorPalette.control,
        foreground: HubColorPalette.text2,
        ringColor: const Color(0x2EFFFFFF),
        ringWidth: 2,
        highlight: highlight,
        label: device.name,
        size: size,
      ),
      PlanSpeaker(:final speaker) => DeviceMarker(
        glyph: HubGlyph.speaker,
        background: HubColorPalette.elevated,
        foreground: speaker.playback == Playback.off ? const Color(0x80FFFFFF) : HubColorPalette.text,
        badge: showBadges && speaker.playback.isPlaying ? MarkerBadge.playing : MarkerBadge.none,
        highlight: highlight,
        label: device.name,
        size: size,
      ),
      PlanPlant(:final state) => DeviceMarker(
        glyph: HubGlyph.leaf,
        background: HubColorPalette.plantMarkerBg,
        foreground: HubColorPalette.success,
        ringColor: switch (state) {
          WateringState.overdue => HubColorPalette.danger,
          WateringState.dueToday => HubColorPalette.accent,
          WateringState.wateredToday || WateringState.upcoming => const Color(0x40FFFFFF),
        },
        ringWidth: state.isDue ? 3 : 2,
        haloColor: state == WateringState.overdue ? const Color(0x40FF453A) : null,
        badge: showBadges && state == WateringState.overdue ? MarkerBadge.alert : MarkerBadge.none,
        highlight: highlight,
        label: device.name,
        size: size,
      ),
    };
  }
}
