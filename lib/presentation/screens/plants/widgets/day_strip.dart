import 'package:flutter/material.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_motion.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';
import 'package:smart_hub/presentation/screens/plants/plants.controller.dart';
import 'package:smart_hub/presentation/shared_widgets/plant_photo.dart';

/// The coming 7 days with the plants due on each, plus "All". Tap a day to show its plants.
class DayStrip extends StatelessWidget {
  const DayStrip({
    super.key,
    required this.today,
    required this.week,
    required this.allCount,
    required this.selectedDay,
    required this.onSelect,
  });

  final DateTime today;
  final List<List<ScheduledPlant>> week;
  final int allCount;
  final int selectedDay;
  final ValueChanged<int> onSelect;

  static const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        for (final (day, plants) in week.indexed)
          Expanded(
            child: _DayChip(
              label: day == 0 ? 'Today' : _weekdays[DateTime(today.year, today.month, today.day + day).weekday - 1],
              date: DateTime(today.year, today.month, today.day + day).day,
              isToday: day == 0,
              selected: selectedDay == day,
              plants: plants,
              onTap: () => onSelect(day),
            ),
          ),
        Expanded(
          child: _AllChip(count: allCount, selected: selectedDay == allPlantsDay, onTap: () => onSelect(allPlantsDay)),
        ),
      ],
    );
  }
}

class _ChipFrame extends StatelessWidget {
  const _ChipFrame({required this.selected, required this.onTap, required this.semanticLabel, required this.child});

  final bool selected;
  final VoidCallback onTap;
  final String semanticLabel;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: semanticLabel,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: HubMotion.fadeDuration,
          height: 96,
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          decoration: BoxDecoration(
            color: selected ? HubColorPalette.accentTint : HubColorPalette.elevated,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: selected ? HubColorPalette.accent : Colors.transparent, width: 2),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({
    required this.label,
    required this.date,
    required this.isToday,
    required this.selected,
    required this.plants,
    required this.onTap,
  });

  final String label;
  final int date;
  final bool isToday;
  final bool selected;
  final List<ScheduledPlant> plants;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _ChipFrame(
      selected: selected,
      onTap: onTap,
      semanticLabel: '$label $date',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            spacing: 6,
            children: [
              Text(
                label.toUpperCase(),
                style: HubTextStyles.micro.copyWith(
                  color: isToday ? HubColorPalette.accentText : HubColorPalette.text2,
                ),
              ),
              const Spacer(),
              Text('$date', style: HubTextStyles.body.copyWith(fontWeight: FontWeight.w700).tabular),
            ],
          ),
          const Spacer(),
          if (plants.isEmpty)
            Text('—', style: HubTextStyles.secondary.copyWith(color: HubColorPalette.text3))
          else
            _AvatarStack(plants: plants),
        ],
      ),
    );
  }
}

/// Up to three overlapping plant avatars and "+N" for the rest.
class _AvatarStack extends StatelessWidget {
  const _AvatarStack({required this.plants});

  static const _size = 30.0;
  static const _overlap = 18.0;

  final List<ScheduledPlant> plants;

  @override
  Widget build(BuildContext context) {
    final shown = plants.take(3).toList();
    final rest = plants.length - shown.length;
    return SizedBox(
      height: _size,
      child: Row(
        children: [
          SizedBox(
            width: _size + (shown.length - 1) * _overlap,
            child: Stack(
              children: [
                for (final (index, entry) in shown.indexed)
                  Positioned(
                    left: index * _overlap,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: HubColorPalette.elevated, width: 2),
                      ),
                      child: PlantPhoto(plant: entry.plant, size: _size - 4, radius: _size),
                    ),
                  ),
              ],
            ),
          ),
          if (rest > 0)
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Text('+$rest', style: HubTextStyles.label.copyWith(color: HubColorPalette.text2)),
            ),
        ],
      ),
    );
  }
}

class _AllChip extends StatelessWidget {
  const _AllChip({required this.count, required this.selected, required this.onTap});

  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _ChipFrame(
      selected: selected,
      onTap: onTap,
      semanticLabel: 'All plants',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('ALL', style: HubTextStyles.micro.copyWith(color: HubColorPalette.text2)),
          const Spacer(),
          Row(
            spacing: 8,
            children: [
              const HubGlyphIcon(HubGlyph.pottedPlant, color: HubColorPalette.success, size: Size(24, 24)),
              Text('$count', style: HubTextStyles.widgetTitle.tabular),
            ],
          ),
        ],
      ),
    );
  }
}
