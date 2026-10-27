import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hub/domain/floorplan/model/floor_plan.dart';
import 'package:smart_hub/domain/floorplan/plan_geometry.util.dart';
import 'package:smart_hub/domain/floorplan/room_lookup.util.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_button.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_dimensions.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';
import 'package:smart_hub/presentation/screens/floorplan/floorplan.controller.dart';
import 'package:smart_hub/presentation/screens/floorplan/plan_device.dart';
import 'package:smart_hub/presentation/screens/floorplan/widgets/inspector/inspector_header.dart';

class RoomInspector extends ConsumerWidget {
  const RoomInspector({super.key, required this.room, required this.devices, required this.enabled});

  final Room room;
  final List<PlanDevice> devices;
  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ids = RoomLookupUtil.devicesIn(room, {for (final device in devices) device.id: ?device.position});
    final inRoom = devices.where((d) => ids.contains(d.id)).toList();
    final lights = inRoom.whereType<PlanLight>().toList();
    final speakers = inRoom.whereType<PlanSpeaker>().toList();
    final plants = inRoom.whereType<PlanPlant>().toList();
    final duePlants = plants.where((plant) => plant.state.isDue).toList();
    final lightsOn = lights.where((l) => l.light.isOn).length;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: HubSpacing.s12,
      children: [
        Row(
          spacing: HubSpacing.s12,
          children: [
            Expanded(
              child: InspectorTitle(
                title: room.name,
                subtitle: '${PlanGeometryUtil.areaInSquareMeters(room.polygon).toStringAsFixed(1)} m²',
              ),
            ),
            if (lights.isNotEmpty)
              HubButton(
                label: lightsOn > 0 ? 'Lights off' : 'Lights on',
                variant: HubButtonVariant.secondary,
                height: 38,
                onPressed: enabled
                    ? () => ref.read(floorplanControllerProvider.notifier).setLightsOn([
                        for (final light in lights) light.id,
                      ], on: lightsOn == 0)
                    : null,
              ),
            // Plants are local and can be watered offline.
            if (duePlants.isNotEmpty)
              HubButton(
                label: 'Water ${duePlants.length}',
                height: 38,
                onPressed: () => ref.read(floorplanControllerProvider.notifier).waterPlants([
                  for (final plant in duePlants) plant.id,
                ]),
              ),
          ],
        ),
        Row(
          spacing: 10,
          children: [
            _StatTile(label: 'Lights', value: lights.isEmpty ? 'None' : '$lightsOn of ${lights.length} on'),
            _StatTile(
              label: 'Plants',
              value: plants.isEmpty
                  ? 'None'
                  : duePlants.isEmpty
                  ? '${plants.length}'
                  : '${plants.length} · ${duePlants.length} to water',
            ),
            _StatTile(
              label: 'Speakers',
              value: speakers.isEmpty
                  ? 'None'
                  : speakers.any((s) => s.speaker.playback.isPlaying)
                  ? 'Playing'
                  : 'Idle',
            ),
          ],
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(color: HubColorPalette.elevated, borderRadius: BorderRadius.circular(HubRadius.tile)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: HubTextStyles.label.copyWith(color: HubColorPalette.text2)),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: HubTextStyles.body.copyWith(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
