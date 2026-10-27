import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hub/domain/lights/light_bridge.service.dart';
import 'package:smart_hub/domain/connection/connection.service.dart';
import 'package:smart_hub/domain/floorplan/model/floor_plan.dart';
import 'package:smart_hub/presentation/design_system/layouts/page_card.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_dimensions.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_motion.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';
import 'package:smart_hub/presentation/screens/floorplan/floorplan.controller.dart';
import 'package:smart_hub/presentation/screens/floorplan/floorplan.state.dart';
import 'package:smart_hub/presentation/screens/floorplan/plan_device.dart';
import 'package:smart_hub/presentation/screens/floorplan/widgets/inspector/light_inspector.dart';
import 'package:smart_hub/presentation/screens/floorplan/widgets/inspector/plant_inspector.dart';
import 'package:smart_hub/presentation/screens/floorplan/widgets/inspector/room_inspector.dart';
import 'package:smart_hub/presentation/screens/floorplan/widgets/inspector/speaker_inspector.dart';

/// Bottom left card: details and controls for the selected room or device.
class InspectorCard extends ConsumerWidget {
  const InspectorCard({super.key, required this.plan});

  final FloorPlan plan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selection = ref.watch(floorplanControllerProvider.select((s) => s.selection));
    final devices = ref.watch(planDevicesProvider);
    // Controls are disabled while offline; the last known state stays visible.
    final enabled = ref.watch(connectionStatusServiceProvider).value?.isOnline ?? false;
    // Lights may come from a light bridge instead of Home Assistant.
    final lightsEnabled = ref.watch(lightsOnlineProvider);

    final content = switch (selection) {
      RoomSelection(:final roomId) => switch (plan.rooms.where((r) => r.id == roomId).firstOrNull) {
        final room? => RoomInspector(room: room, devices: devices, enabled: lightsEnabled),
        null => const _Hint(),
      },
      DeviceSelection(:final deviceId) => switch (devices.where((d) => d.id == deviceId).firstOrNull) {
        final PlanLight light => LightInspector(device: light, plan: plan, enabled: lightsEnabled),
        final PlanSpeaker speaker => SpeakerInspector(device: speaker, plan: plan, enabled: enabled),
        final PlanPlant plant => PlantInspector(device: plant, plan: plan),
        null => const _Hint(),
      },
      NoSelection() => const _Hint(),
    };

    return PageCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: AnimatedSwitcher(
        duration: HubMotion.fadeDuration,
        layoutBuilder: (current, previous) => Stack(alignment: Alignment.centerLeft, children: [...previous, ?current]),
        child: KeyedSubtree(key: ValueKey(selection), child: content),
      ),
    );
  }
}

class _Hint extends ConsumerWidget {
  const _Hint();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: HubSpacing.s4,
      children: [
        const Text('Tap a room or device', style: HubTextStyles.widgetTitle),
        Text(
          ref.watch(hasLightsProvider)
              ? "Drag anything on the plan to move it. Lights glow in the room they're in."
              : 'Drag anything on the plan to move it.',
          style: HubTextStyles.secondary,
        ),
      ],
    );
  }
}
