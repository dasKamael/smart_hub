import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_hub/common/go_router/hub_page.enum.dart';
import 'package:smart_hub/common/utils/current_day.provider.dart';
import 'package:smart_hub/domain/plants/model/plant.dart';
import 'package:smart_hub/domain/plants/model/watering_state.enum.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_button.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_icon_button.dart';
import 'package:smart_hub/presentation/design_system/layouts/page_card.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_dimensions.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_motion.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';
import 'package:smart_hub/presentation/screens/plants/plants.controller.dart';
import 'package:smart_hub/presentation/screens/plants/widgets/day_strip.dart';
import 'package:smart_hub/presentation/screens/plants/widgets/plant_card.dart';
import 'package:smart_hub/presentation/screens/plants/widgets/plant_editor_dialog.dart';
import 'package:smart_hub/presentation/screens/plants/widgets/plant_import_dialog.dart';

/// Watering plan: key figures, the coming week and the plants of the selected day as cards.
class PlantsScreen extends ConsumerWidget {
  const PlantsScreen({super.key});

  static const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  static const _weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = ref.watch(wateringPlanProvider);
    final page = ref.watch(plantsControllerProvider);
    final selectedDay = page.selectedDay;
    final controller = ref.read(plantsControllerProvider.notifier);
    final now = ref.watch(currentDayProvider).value ?? clock.now();
    final today = DateTime(now.year, now.month, now.day);

    final due = [
      for (final entry in plan.all)
        if (entry.state.isDue) entry,
    ];

    final shown = switch (selectedDay) {
      allPlantsDay => [...plan.all]..sort((a, b) => _order(a).compareTo(_order(b))),
      final day => plan.week[day],
    };
    final day = DateTime(today.year, today.month, today.day + selectedDay.clamp(0, 6));
    final title = switch (selectedDay) {
      allPlantsDay => 'All plants',
      0 => 'Today',
      1 => 'Tomorrow',
      _ => '${_weekdays[day.weekday - 1]}, ${day.day} ${_months[day.month - 1]}',
    };

    Future<void> edit(Plant? plant) async {
      final result = await showPlantEditor(context, plant: plant);
      if (result != null) await controller.applyEdit(plant, result);
    }

    return PageCard(
      tint: ref.watch(plantsTintProvider),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: HubSpacing.s20,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            spacing: HubSpacing.s12,
            children: [
              if (due.isNotEmpty)
                HubButton(label: 'Water all', glyph: HubGlyph.drop, onPressed: () => controller.waterAll(due)),
              HubIconButton(
                glyph: HubGlyph.import,
                semanticLabel: 'Import care data',
                onPressed: () => unawaited(showPlantImport(context)),
              ),
              HubButton(
                label: 'Plant',
                glyph: HubGlyph.plus,
                variant: HubButtonVariant.secondary,
                onPressed: () => edit(null),
              ),
            ],
          ),
          DayStrip(
            today: today,
            week: plan.week,
            allCount: plan.all.length,
            selectedDay: selectedDay,
            onSelect: controller.selectDay,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            spacing: HubSpacing.s8,
            children: [
              Text(title, style: HubTextStyles.sectionTitle),
              Text('${shown.length}', style: HubTextStyles.sectionTitle.copyWith(color: HubColorPalette.text3)),
            ],
          ),
          Expanded(
            // A tap next to the tiles hides the shown options.
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: controller.closeOptions,
              child: AnimatedSwitcher(
                duration: HubMotion.fadeDuration,
                child: KeyedSubtree(
                  key: ValueKey(selectedDay),
                  child: shown.isEmpty
                      ? _EmptyDay(isToday: selectedDay == 0, hasPlants: plan.all.isNotEmpty)
                      : GridView.builder(
                          padding: const EdgeInsets.only(bottom: HubSpacing.s8),
                          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 240,
                            mainAxisExtent: 140,
                            crossAxisSpacing: HubSpacing.s16,
                            mainAxisSpacing: HubSpacing.s16,
                          ),
                          itemCount: shown.length,
                          itemBuilder: (context, index) {
                            final entry = shown[index];
                            return PlantCard(
                              key: ValueKey(entry.plant.id),
                              entry: entry,
                              optionsShown: page.openPlantId == entry.plant.id,
                              onTap: () => controller.toggleOptions(entry.plant.id),
                              onWater: () => controller.toggleWatered(entry),
                              onFeed: () => controller.fertilize(entry),
                              onProfile: () {
                                controller.closeOptions();
                                unawaited(context.push(HubPage.plantProfile.path.replaceFirst(':id', entry.plant.id)));
                              },
                              onEdit: () {
                                controller.closeOptions();
                                edit(entry.plant);
                              },
                            );
                          },
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Most urgent first, watered plants last.
  static int _order(ScheduledPlant entry) => entry.state == WateringState.wateredToday ? 1 << 20 : entry.dueInDays;
}

class _EmptyDay extends StatelessWidget {
  const _EmptyDay({required this.isToday, required this.hasPlants});

  final bool isToday;
  final bool hasPlants;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: HubSpacing.s12,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(color: HubColorPalette.success.withValues(alpha: 0.14), shape: BoxShape.circle),
            alignment: Alignment.center,
            child: HubGlyphIcon(
              hasPlants ? HubGlyph.check : HubGlyph.pottedPlant,
              color: HubColorPalette.success,
              size: const Size(32, 32),
            ),
          ),
          Text(
            !hasPlants
                ? 'Add your first plant'
                : isToday
                ? 'All plants are happy'
                : 'Nothing to water',
            style: HubTextStyles.secondary,
          ),
        ],
      ),
    );
  }
}
