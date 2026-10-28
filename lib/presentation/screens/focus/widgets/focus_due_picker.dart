import 'package:flutter/material.dart';
import 'package:smart_hub/domain/focus/focus_due.util.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_motion.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';
import 'package:smart_hub/presentation/screens/focus/widgets/focus_day_label.dart';

/// A month to tap the day in. Days that have passed cannot be picked.
class FocusDuePicker extends StatefulWidget {
  const FocusDuePicker({super.key, required this.today, required this.value, required this.onChanged});

  final DateTime today;
  final DateTime? value;
  final ValueChanged<DateTime> onChanged;

  @override
  State<FocusDuePicker> createState() => _FocusDuePickerState();
}

class _FocusDuePickerState extends State<FocusDuePicker> {
  late DateTime _month = _firstOf(widget.value ?? widget.today);

  static DateTime _firstOf(DateTime day) => DateTime(day.year, day.month);

  void _shift(int months) => setState(() => _month = DateTime(_month.year, _month.month + months));

  @override
  Widget build(BuildContext context) {
    // A month grid starts on the Monday of the week the 1st falls in.
    final first = _month.subtract(Duration(days: _month.weekday - 1));
    final weeks = ((_month.weekday - 1 + DateTime(_month.year, _month.month + 1, 0).day) / 7).ceil();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            _Arrow(
              glyph: HubGlyph.back,
              label: 'Month before',
              onTap: _month.isAfter(_firstOf(widget.today)) ? () => _shift(-1) : null,
            ),
            Expanded(
              child: Text(
                focusMonthLabel(_month),
                textAlign: TextAlign.center,
                style: HubTextStyles.label.copyWith(fontSize: 15),
              ),
            ),
            _Arrow(glyph: HubGlyph.next, label: 'Month after', onTap: () => _shift(1)),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            for (final letter in focusWeekdayLabels)
              Expanded(
                child: Center(
                  child: Text(letter, style: HubTextStyles.micro.copyWith(color: HubColorPalette.text3)),
                ),
              ),
          ],
        ),
        for (var week = 0; week < weeks; week++)
          Row(
            children: [
              for (var weekday = 0; weekday < 7; weekday++)
                Expanded(child: _day(first.add(Duration(days: week * 7 + weekday)))),
            ],
          ),
      ],
    );
  }

  Widget _day(DateTime day) {
    if (day.month != _month.month) return const SizedBox(height: 38);
    final passed = FocusDueUtil.daysBetween(widget.today, day) < 0;
    return _Day(
      day: day,
      selected: widget.value != null && FocusDueUtil.daysBetween(widget.value!, day) == 0,
      isToday: FocusDueUtil.daysBetween(widget.today, day) == 0,
      onTap: passed ? null : () => widget.onChanged(day),
    );
  }
}

class _Arrow extends StatelessWidget {
  const _Arrow({required this.glyph, required this.label, required this.onTap});

  final HubGlyph glyph;
  final String label;

  /// `null` greys the arrow out, e.g. before this month.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: onTap != null,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: 38,
          height: 38,
          child: Center(
            child: HubGlyphIcon(
              glyph,
              color: onTap == null ? HubColorPalette.text3 : HubColorPalette.text2,
              size: const Size.square(14),
            ),
          ),
        ),
      ),
    );
  }
}

class _Day extends StatelessWidget {
  const _Day({required this.day, required this.selected, required this.isToday, required this.onTap});

  final DateTime day;
  final bool selected;
  final bool isToday;

  /// `null` for days that have passed.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: onTap != null,
      selected: selected,
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          height: 38,
          child: Center(
            child: AnimatedContainer(
              duration: HubMotion.fadeDuration,
              width: 34,
              height: 34,
              decoration: BoxDecoration(color: selected ? HubColorPalette.accent : null, shape: BoxShape.circle),
              alignment: Alignment.center,
              child: Text(
                '${day.day}',
                style: HubTextStyles.body
                    .copyWith(
                      fontSize: 15,
                      fontWeight: selected || isToday ? FontWeight.w700 : FontWeight.w400,
                      color: switch ((selected, isToday, onTap == null)) {
                        (true, _, _) => HubColorPalette.text,
                        (_, _, true) => HubColorPalette.text3,
                        (_, true, _) => HubColorPalette.accentText,
                        _ => HubColorPalette.text,
                      },
                    )
                    .tabular,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
