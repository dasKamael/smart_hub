import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_hub/common/go_router/hub_route.enum.dart';
import 'package:smart_hub/common/utils/current_day.provider.dart';
import 'package:smart_hub/domain/plants/model/watering_state.enum.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/layouts/widget_tile.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';
import 'package:smart_hub/presentation/screens/plants/plants.controller.dart';
import 'package:smart_hub/presentation/shared_widgets/plant_photo.dart';

/// The watering plan as a dashboard widget in any [WidgetSize] (`Widget Kit` → Plants). Tapping a plant waters it
/// (or undoes today's watering), tapping elsewhere opens the plants page.
class PlantsWidget extends ConsumerWidget {
  const PlantsWidget({super.key, required this.size, this.card = true});

  final WidgetSize size;

  /// `false`: no card behind the widget (`DashboardWidget.card`).
  final bool card;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = ref.watch(wateringPlanProvider);
    final due = [...plan.all.where((entry) => entry.state.isDue)]..sort((a, b) => a.dueInDays.compareTo(b.dueInDays));
    void water(ScheduledPlant entry) => ref.read(plantsControllerProvider.notifier).toggleWatered(entry);

    return WidgetTile(
      card: card,
      tint: ref.watch(plantsTintProvider),
      size: size,
      padding: switch (size) {
        WidgetSize.small => 14,
        WidgetSize.extraLarge => 12,
        _ => 16,
      },
      onTap: () => context.go(HubRoute.plants.path),
      child: switch (size) {
        WidgetSize.small => _Small(due),
        WidgetSize.medium => _Medium(due, onWater: water),
        WidgetSize.large => _Large(
          due,
          upcoming: [...plan.all.where((entry) => entry.state == WateringState.upcoming)]
            ..sort((a, b) => a.dueInDays.compareTo(b.dueInDays)),
          onWater: water,
        ),
        WidgetSize.extraLarge => _Week(
          plan.week,
          today: ref.watch(currentDayProvider).value ?? clock.now(),
          onWater: water,
        ),
      },
    );
  }
}

int _overdue(List<ScheduledPlant> due) => due.where((entry) => entry.state == WateringState.overdue).length;

/// Drop, how many plants need water and how many of them are overdue.
class _Small extends StatelessWidget {
  const _Small(this.due);

  final List<ScheduledPlant> due;

  @override
  Widget build(BuildContext context) {
    final overdue = _overdue(due);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const HubGlyphIcon(HubGlyph.drop, color: HubColorPalette.accent, size: Size(16, 20)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${due.length}', style: HubTextStyles.display.copyWith(height: 1.05, letterSpacing: -1.5).tabular),
            Text(
              due.length == 1 ? 'plant to water' : 'plants to water',
              style: HubTextStyles.secondary.copyWith(fontSize: 14),
            ),
            if (overdue > 0)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text('$overdue overdue', style: HubTextStyles.label.copyWith(color: HubColorPalette.dangerText)),
              )
            else if (due.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text('All watered', style: HubTextStyles.label.copyWith(color: HubColorPalette.success)),
              ),
          ],
        ),
      ],
    );
  }
}

/// "Water today": the first three due plants as round photos.
class _Medium extends StatelessWidget {
  const _Medium(this.due, {required this.onWater});

  static const _shown = 3;

  final List<ScheduledPlant> due;
  final ValueChanged<ScheduledPlant> onWater;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 10,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Expanded(
              child: Text('Water today', style: HubTextStyles.body.copyWith(fontWeight: FontWeight.w700)),
            ),
            if (due.length > _shown)
              Text('+${due.length - _shown} more', style: HubTextStyles.label.copyWith(color: HubColorPalette.text2)),
          ],
        ),
        Expanded(
          child: due.isEmpty
              ? const _AllWatered()
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < _shown; i++)
                      Expanded(
                        child: i < due.length ? _PlantBubble(due[i], size: 58, onTap: onWater) : const SizedBox(),
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}

/// "Plants": overdue and today's plants as rows; rows left over show the plants that come next.
class _Large extends StatelessWidget {
  const _Large(this.due, {required this.upcoming, required this.onWater});

  static const _rows = 5;

  final List<ScheduledPlant> due;
  final List<ScheduledPlant> upcoming;
  final ValueChanged<ScheduledPlant> onWater;

  @override
  Widget build(BuildContext context) {
    final shown = due.take(due.length > _rows ? _rows - 1 : _rows).toList();
    final overdue = [
      for (final entry in shown)
        if (entry.state == WateringState.overdue) entry,
    ];
    final today = [
      for (final entry in shown)
        if (entry.state != WateringState.overdue) entry,
    ];
    // Due plants come first; a "+N more" line means there is no room left.
    final next = due.length > shown.length ? const <ScheduledPlant>[] : upcoming.take(_rows - shown.length).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 4),
          child: Text('Plants', style: HubTextStyles.widgetTitle),
        ),
        if (due.isEmpty && upcoming.isEmpty) const Expanded(child: _AllWatered()),
        if (overdue.isNotEmpty) ...[
          _GroupLabel('Overdue', color: HubColorPalette.dangerText),
          for (final entry in overdue) _PlantRow(entry, onTap: onWater),
        ],
        if (today.isNotEmpty) ...[
          _GroupLabel('Today', color: HubColorPalette.text2, top: overdue.isEmpty ? 0 : 6),
          for (final entry in today) _PlantRow(entry, onTap: onWater),
        ],
        if (due.length > shown.length)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              '+${due.length - shown.length} more',
              style: HubTextStyles.label.copyWith(color: HubColorPalette.text2),
            ),
          ),
        if (next.isNotEmpty) ...[
          _GroupLabel('Next', color: HubColorPalette.text2, top: shown.isEmpty ? 0 : 6),
          for (final entry in next) _UpcomingRow(entry),
        ],
      ],
    );
  }
}

/// A plant due in the coming days (large size): faded, with the days left instead of the drop.
class _UpcomingRow extends StatelessWidget {
  const _UpcomingRow(this.entry);

  final ScheduledPlant entry;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: Row(
        spacing: 12,
        children: [
          Opacity(opacity: 0.6, child: PlantPhoto(plant: entry.plant, size: 32, radius: 16)),
          Expanded(
            child: Text(
              entry.plant.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: HubTextStyles.secondary.copyWith(fontSize: 16),
            ),
          ),
          Text(
            entry.dueInDays == 1 ? 'Tomorrow' : 'In ${entry.dueInDays} d',
            style: HubTextStyles.label.copyWith(color: HubColorPalette.text3).tabular,
          ),
        ],
      ),
    );
  }
}

/// The coming week: today wide with photos, the six following days narrow with small avatars.
class _Week extends StatelessWidget {
  const _Week(this.week, {required this.today, required this.onWater});

  final List<List<ScheduledPlant>> week;
  final DateTime today;
  final ValueChanged<ScheduledPlant> onWater;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var day = 0; day < week.length; day++)
          Expanded(
            flex: day == 0 ? 26 : 10,
            child: _DayColumn(
              day: day,
              date: today.add(Duration(days: day)),
              plants: week[day],
              onWater: onWater,
            ),
          ),
      ],
    );
  }
}

class _DayColumn extends StatelessWidget {
  const _DayColumn({required this.day, required this.date, required this.plants, required this.onWater});

  static const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  final int day;
  final DateTime date;
  final List<ScheduledPlant> plants;
  final ValueChanged<ScheduledPlant> onWater;

  bool get _isToday => day == 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: _isToday ? 12 : 6),
      decoration: BoxDecoration(
        color: _isToday ? HubColorPalette.elevated : null,
        borderRadius: _isToday ? BorderRadius.circular(16) : null,
        // 1 px: thinner lines vanish on some columns after rounding.
        border: day > 1 ? Border(left: BorderSide(color: HubColorPalette.separator.withValues(alpha: 0.35))) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 10,
        children: [
          Wrap(
            alignment: _isToday ? WrapAlignment.start : WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 6,
            runSpacing: 2,
            children: [
              Text(
                _isToday ? 'TODAY' : _weekdays[date.weekday - 1].toUpperCase(),
                style: HubTextStyles.micro.copyWith(
                  letterSpacing: 0.5,
                  color: _isToday ? HubColorPalette.accentText : HubColorPalette.text3,
                ),
              ),
              Container(
                constraints: const BoxConstraints(minWidth: 28),
                height: 28,
                padding: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  color: _isToday ? HubColorPalette.accent : null,
                  borderRadius: BorderRadius.circular(14),
                ),
                // widthFactor 1: only as wide as the number, not the whole column.
                child: Center(
                  widthFactor: 1,
                  child: Text(
                    '${date.day}',
                    style: HubTextStyles.secondary
                        .copyWith(fontWeight: FontWeight.w600, color: _isToday ? HubColorPalette.text : null)
                        .tabular,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: _isToday
                ? plants.isEmpty
                      ? const _AllWatered()
                      : GridView.count(
                          crossAxisCount: 3,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 8,
                          childAspectRatio: 0.72,
                          padding: EdgeInsets.zero,
                          children: [for (final entry in plants) _PlantTile(entry, onTap: onWater)],
                        )
                : ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      for (final entry in plants)
                        Padding(padding: const EdgeInsets.only(bottom: 8), child: _UpcomingPlant(entry)),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

/// A plant of today in the week view: square photo and name; faded once watered.
class _PlantTile extends StatelessWidget {
  const _PlantTile(this.entry, {required this.onTap});

  final ScheduledPlant entry;
  final ValueChanged<ScheduledPlant> onTap;

  @override
  Widget build(BuildContext context) {
    final overdue = entry.state == WateringState.overdue;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(entry),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 250),
        opacity: entry.state == WateringState.wateredToday ? 0.35 : 1,
        child: Column(
          spacing: 4,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: LayoutBuilder(
                builder: (context, constraints) => PlantPhoto(
                  plant: entry.plant,
                  size: constraints.maxWidth,
                  radius: 14,
                  ringColor: overdue ? HubColorPalette.danger : null,
                ),
              ),
            ),
            _Name(entry, fontSize: 11, color: overdue ? HubColorPalette.dangerText : HubColorPalette.text),
          ],
        ),
      ),
    );
  }
}

/// A plant due later in the week: small avatar and name, faded.
class _UpcomingPlant extends StatelessWidget {
  const _UpcomingPlant(this.entry);

  final ScheduledPlant entry;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.55,
      child: Column(
        spacing: 3,
        children: [
          PlantPhoto(plant: entry.plant, size: 30, radius: 15),
          _Name(entry, fontSize: 11, color: HubColorPalette.text, weight: FontWeight.w400),
        ],
      ),
    );
  }
}

/// A due plant as a round photo with its name below (medium size).
class _PlantBubble extends StatelessWidget {
  const _PlantBubble(this.entry, {required this.size, required this.onTap});

  final ScheduledPlant entry;
  final double size;
  final ValueChanged<ScheduledPlant> onTap;

  @override
  Widget build(BuildContext context) {
    final overdue = entry.state == WateringState.overdue;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(entry),
      child: Column(
        spacing: 5,
        children: [
          PlantPhoto(
            plant: entry.plant,
            size: size,
            radius: size / 2,
            ringColor: overdue ? HubColorPalette.danger : null,
          ),
          _Name(entry, fontSize: 12, color: overdue ? HubColorPalette.dangerText : HubColorPalette.text),
        ],
      ),
    );
  }
}

/// A due plant as a row (large size).
class _PlantRow extends StatelessWidget {
  const _PlantRow(this.entry, {required this.onTap});

  final ScheduledPlant entry;
  final ValueChanged<ScheduledPlant> onTap;

  @override
  Widget build(BuildContext context) {
    final overdue = entry.state == WateringState.overdue;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(entry),
      child: SizedBox(
        height: 42,
        child: Row(
          spacing: 12,
          children: [
            PlantPhoto(plant: entry.plant, size: 32, radius: 16),
            Expanded(
              child: Text(
                entry.plant.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: HubTextStyles.body.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: overdue ? HubColorPalette.dangerText : HubColorPalette.text,
                ),
              ),
            ),
            const HubGlyphIcon(HubGlyph.drop, color: HubColorPalette.accent, size: Size(13, 16)),
          ],
        ),
      ),
    );
  }
}

class _GroupLabel extends StatelessWidget {
  const _GroupLabel(this.text, {required this.color, this.top = 0});

  final String text;
  final Color color;
  final double top;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: top),
      child: Text(text, style: HubTextStyles.label.copyWith(color: color)),
    );
  }
}

class _Name extends StatelessWidget {
  const _Name(this.entry, {required this.fontSize, required this.color, this.weight = FontWeight.w600});

  final ScheduledPlant entry;
  final double fontSize;
  final Color color;
  final FontWeight weight;

  @override
  Widget build(BuildContext context) {
    return Text(
      entry.plant.name,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: fontSize, fontWeight: weight, color: color, height: 1.2),
    );
  }
}

/// Shown when nothing needs water: a green check, no words needed.
class _AllWatered extends StatelessWidget {
  const _AllWatered();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Semantics(
        container: true,
        label: 'All watered',
        child: Container(
          width: 44,
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: HubColorPalette.success.withValues(alpha: 0.16), shape: BoxShape.circle),
          child: const HubGlyphIcon(HubGlyph.check, color: HubColorPalette.success, size: Size(20, 20)),
        ),
      ),
    );
  }
}
