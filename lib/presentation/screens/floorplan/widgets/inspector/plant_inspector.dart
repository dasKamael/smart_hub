import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hub/domain/floorplan/model/floor_plan.dart';
import 'package:smart_hub/domain/plants/model/watering_state.enum.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_button.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';
import 'package:smart_hub/presentation/screens/floorplan/floorplan.controller.dart';
import 'package:smart_hub/presentation/screens/floorplan/plan_device.dart';
import 'package:smart_hub/presentation/screens/floorplan/widgets/inspector/inspector_header.dart';
import 'package:smart_hub/presentation/shared_widgets/plant_photo.dart';

/// Photo, schedule and watering of one plant. Plants are local, so they work offline too.
class PlantInspector extends ConsumerWidget {
  const PlantInspector({super.key, required this.device, required this.plan});

  final PlanPlant device;
  final FloorPlan plan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(floorplanControllerProvider.notifier);
    final plant = device.plant;
    final watered = device.state == WateringState.wateredToday;

    return Row(
      spacing: 16,
      children: [
        PlantPhoto(plant: plant, size: 100),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 3,
            children: [
              InspectorTitle(
                title: plant.name,
                subtitle: '${roomNameOf(device, plan)} · Every ${plant.everyDays} ${_days(plant.everyDays)}',
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  wateringStatusText(device),
                  style: HubTextStyles.secondary.copyWith(
                    fontWeight: FontWeight.w600,
                    color: wateringStatusColor(device.state),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Both buttons as wide as the wider one.
        IntrinsicWidth(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 8,
            children: [
              HubButton(
                label: watered ? 'Undo' : 'Water now',
                variant: watered ? HubButtonVariant.secondary : HubButtonVariant.primary,
                height: 40,
                onPressed: () => watered ? controller.undoWatering(plant.id) : controller.waterPlants([plant.id]),
              ),
              HubButton(
                label: 'Remove',
                variant: HubButtonVariant.destructive,
                height: 36,
                onPressed: () => controller.removeDevice(plant.id),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

String _days(int count) => count == 1 ? 'day' : 'days';

/// Status line of a plant (`Widget Kit` → plant inspector).
String wateringStatusText(PlanPlant device) {
  final due = device.dueInDays;
  return switch (device.state) {
    WateringState.wateredToday => 'Watered today · next in ${device.plant.everyDays} ${_days(device.plant.everyDays)}',
    WateringState.overdue => '${-due} ${_days(-due)} overdue',
    WateringState.dueToday => 'Due today',
    WateringState.upcoming => 'Next watering in $due ${_days(due)}',
  };
}

Color wateringStatusColor(WateringState state) {
  return switch (state) {
    WateringState.wateredToday => HubColorPalette.success,
    WateringState.overdue => HubColorPalette.dangerText,
    WateringState.dueToday => HubColorPalette.accentText,
    WateringState.upcoming => HubColorPalette.text2,
  };
}
