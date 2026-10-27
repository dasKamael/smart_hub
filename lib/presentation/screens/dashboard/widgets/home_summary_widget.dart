import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_area_colors.dart';
import 'package:smart_hub/common/go_router/hub_route.enum.dart';
import 'package:smart_hub/domain/connection/connection.service.dart';
import 'package:smart_hub/domain/lights/light.service.dart';
import 'package:smart_hub/domain/lights/model/light_state.dart';
import 'package:smart_hub/domain/plants/model/watering_state.enum.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/layouts/widget_tile.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';
import 'package:smart_hub/presentation/screens/music/music.controller.dart';
import 'package:smart_hub/presentation/screens/plants/plants.controller.dart';

/// "Home" (M): lights on, plants to water and what plays, one row each; a row opens its page
/// (`README` → "Floor plan – widgets").
class HomeSummaryWidget extends ConsumerWidget {
  const HomeSummaryWidget({super.key, this.card = true});

  /// `false`: no card behind the widget (`DashboardWidget.card`).
  final bool card;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasHomeAssistant = ref.watch(hasHomeAssistantProvider);
    final lightsOn = (ref.watch(lightsServiceProvider).value ?? const <LightState>[]).where((light) => light.isOn);
    final plants = ref.watch(wateringPlanProvider).all;
    final overdue = plants.where((entry) => entry.state == WateringState.overdue).length;
    final dueToday = plants.where((entry) => entry.state == WateringState.dueToday).length;
    final playing = [
      for (final group in ref.watch(speakerGroupsProvider))
        if (group.leader.playback.isPlaying) group.name,
    ];

    return WidgetTile(
      card: card,
      tint: HubAreaColors.home,
      size: WidgetSize.medium,
      padding: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Home', style: HubTextStyles.widgetTitle),
          _Row(
            glyph: HubGlyph.bulb,
            color: HubColorPalette.lightWarm,
            label: 'Lights',
            value: hasHomeAssistant ? (lightsOn.isEmpty ? 'All off' : '${lightsOn.length} on') : 'Not connected',
            onTap: () => context.go(HubRoute.lights.path),
          ),
          _Row(
            glyph: HubGlyph.leaf,
            color: HubColorPalette.success,
            label: 'Plants',
            value: switch ((overdue, dueToday)) {
              (> 0, _) => '$overdue overdue',
              (_, > 0) => '$dueToday due today',
              _ => 'All watered',
            },
            valueColor: switch ((overdue, dueToday)) {
              (> 0, _) => HubColorPalette.dangerText,
              (_, > 0) => HubColorPalette.accentText,
              _ => HubColorPalette.success,
            },
            onTap: () => context.go(HubRoute.plants.path),
          ),
          _Row(
            glyph: HubGlyph.speaker,
            color: HubColorPalette.playing,
            label: 'Music',
            value: playing.isEmpty ? 'Paused' : playing.join(', '),
            onTap: () => context.go(HubRoute.music.path),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.glyph,
    required this.color,
    required this.label,
    required this.value,
    required this.onTap,
    this.valueColor = HubColorPalette.text2,
  });

  final HubGlyph glyph;
  final Color color;
  final String label;
  final String value;
  final Color valueColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        spacing: 10,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.18), shape: BoxShape.circle),
            alignment: Alignment.center,
            child: HubGlyphIcon(glyph, color: color, size: const Size(13, 13)),
          ),
          Text(label, style: HubTextStyles.body.copyWith(fontSize: 15)),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: HubTextStyles.secondary.copyWith(color: valueColor, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
