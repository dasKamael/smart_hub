import 'package:flutter/widgets.dart';
import 'package:smart_hub/domain/music/model/playback.enum.dart';
import 'package:smart_hub/domain/plants/model/watering_state.enum.dart';
import 'package:smart_hub/presentation/design_system/atoms/device_marker.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/atoms/scene_marker.dart';
import 'package:smart_hub/presentation/design_system/tokens/home_scene.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/screens/floorplan/plan_device.dart';
import 'package:smart_hub/presentation/utils/extension/rgb_color.extension.dart';

/// Color a light shines in on the plan; lights without color information glow warm.
Color planLightColor(PlanLight device) => device.light.displayColor?.toColor() ?? HubColorPalette.lightWarm;

/// Marker for [device] in its current state, in the look of the 3D home (`appartment.mp4`): a small dark glass
/// circle with a white glyph, a lit cream one with an orange glyph and a glow for a light that is on. Plants show how
/// urgent watering is with their ring (`README` → "Device markers"). [size] is the touch area; the circle is smaller.
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

  static const _ring = 1.2;

  @override
  Widget build(BuildContext context) {
    final circle = size * SceneMarker.size / 44;
    final marker = switch (device) {
      final PlanLight light when light.light.isOn => DeviceMarker(
        glyph: HubGlyph.bulb,
        background: HomeSceneColorPalette.markerOn,
        foreground: HomeSceneColorPalette.markerOnGlyph,
        glowColor: planLightColor(light),
        highlight: highlight,
        label: device.name,
        size: circle,
      ),
      PlanLight() => _glass(HubGlyph.bulb, HomeSceneColorPalette.markerOffGlyph, circle),
      PlanSpeaker(:final speaker) => _glass(
        HubGlyph.speaker,
        speaker.playback == Playback.off ? const Color(0x80FFFFFF) : HomeSceneColorPalette.markerOffGlyph,
        circle,
        badge: showBadges && speaker.playback.isPlaying ? MarkerBadge.playing : MarkerBadge.none,
      ),
      PlanPlant(:final state) => _glass(
        HubGlyph.leaf,
        HubColorPalette.success,
        circle,
        ring: switch (state) {
          WateringState.overdue => HubColorPalette.danger,
          WateringState.dueToday => HubColorPalette.accent,
          WateringState.wateredToday || WateringState.upcoming => HomeSceneColorPalette.markerOffBorder,
        },
        ringWidth: state.isDue ? 2 : _ring,
        badge: showBadges && state == WateringState.overdue ? MarkerBadge.alert : MarkerBadge.none,
      ),
    };
    return SizedBox.square(
      dimension: size,
      child: Center(child: marker),
    );
  }

  DeviceMarker _glass(
    HubGlyph glyph,
    Color foreground,
    double size, {
    Color ring = HomeSceneColorPalette.markerOffBorder,
    double ringWidth = _ring,
    MarkerBadge badge = MarkerBadge.none,
  }) => DeviceMarker(
    glyph: glyph,
    // Opaque: the ring is drawn behind the circle and must not show through the glass.
    background: Color.alphaBlend(HomeSceneColorPalette.markerOff, HomeSceneColorPalette.background),
    foreground: foreground,
    ringColor: ring,
    ringWidth: ringWidth,
    badge: badge,
    highlight: highlight,
    label: device.name,
    size: size,
  );
}
