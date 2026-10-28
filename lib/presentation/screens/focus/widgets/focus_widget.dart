import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hub/domain/focus/focus.service.dart';
import 'package:smart_hub/domain/focus/model/focus_urgency.enum.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/layouts/widget_tile.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub.color_palette.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_area_colors.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_dimensions.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_motion.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_text_styles.dart';
import 'package:smart_hub/presentation/screens/focus/focus.controller.dart';
import 'package:smart_hub/presentation/screens/focus/widgets/focus_day_label.dart';
import 'package:smart_hub/presentation/screens/focus/widgets/focus_editor_dialog.dart';

/// The focus points as a dashboard widget in any [WidgetSize] (`Widget Kit` → Focus): at most three goals, each
/// one a name and the days left until its day. A tap lays "Done", "Edit" and "Drop" over the point – that is the
/// whole operation.
class FocusWidget extends ConsumerWidget {
  const FocusWidget({super.key, required this.size, this.card = true});

  final WidgetSize size;

  /// `false`: no card behind the widget (`DashboardWidget.card`).
  final bool card;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = ref.watch(focusPlanProvider);
    final controller = ref.read(focusControllerProvider.notifier);
    final openId = ref.watch(focusControllerProvider);

    Future<void> edit([FocusEntry? entry]) async {
      final edited = await showFocusEditor(context, point: entry?.point);
      if (edited != null) await controller.apply(entry?.point, edited);
    }

    final actions = (
      onTap: controller.toggleOptions,
      onAchieve: controller.achieve,
      onRemove: controller.remove,
      onEdit: (FocusEntry entry) => unawaited(edit(entry)),
      openId: openId,
    );
    void add() => unawaited(edit());

    return WidgetTile(
      card: card,
      tint: ref.watch(focusTintProvider),
      size: size,
      padding: size == WidgetSize.small ? 14 : 16,
      onTap: plan.isEmpty ? add : null,
      child: switch (size) {
        WidgetSize.small => _Small(plan, actions: actions),
        WidgetSize.medium => _Rows(plan, actions: actions, rows: 2, compact: true, onAdd: add),
        WidgetSize.large => _Rows(plan, actions: actions, rows: FocusService.maxActive, onAdd: add),
        WidgetSize.extraLarge => _Columns(plan, actions: actions, onAdd: add),
      },
    );
  }
}

/// What a point in the widget can trigger, plus the point whose options are open.
typedef FocusActions = ({
  void Function(String id) onTap,
  void Function(String id) onAchieve,
  void Function(String id) onRemove,
  void Function(FocusEntry entry) onEdit,
  String? openId,
});

/// How much time is left, as a color: ice while there is room, amber in the last days, terracotta once the day
/// has passed.
Color _colorOf(FocusUrgency urgency) => switch (urgency) {
  FocusUrgency.calm => HubColorPalette.lightCool,
  FocusUrgency.soon || FocusUrgency.today => HubAreaColors.focusSoon,
  FocusUrgency.overdue => HubAreaColors.focusOverdue,
  FocusUrgency.done => HubColorPalette.success,
};

/// The one point that is due first: big number, name, and how far its time has run.
class _Small extends StatelessWidget {
  const _Small(this.plan, {required this.actions});

  final List<FocusEntry> plan;
  final FocusActions actions;

  @override
  Widget build(BuildContext context) {
    final entry = plan.firstOrNull;
    if (entry == null) return const _Empty(compact: true);
    if (actions.openId == entry.point.id) return _Options(entry, actions: actions, stacked: true);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => actions.onTap(entry.point.id),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const HubGlyphIcon(HubGlyph.target, color: HubColorPalette.text2, size: Size.square(16)),
              const Spacer(),
              if (plan.length > 1)
                Text('+${plan.length - 1}', style: HubTextStyles.micro.copyWith(color: HubColorPalette.text3).tabular),
            ],
          ),
          const Spacer(),
          _Countdown(entry, size: 46),
          const SizedBox(height: 8),
          Text(
            entry.point.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: HubTextStyles.body.copyWith(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          _Bar(entry),
        ],
      ),
    );
  }
}

/// "Focus" and the points under each other, the one due first on top.
class _Rows extends StatelessWidget {
  const _Rows(this.plan, {required this.actions, required this.rows, required this.onAdd, this.compact = false});

  final List<FocusEntry> plan;
  final FocusActions actions;
  final int rows;
  final VoidCallback onAdd;

  /// Name and countdown on one line; there is no room for more.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final shown = plan.take(rows).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Head(canAdd: plan.length < FocusService.maxActive, onAdd: onAdd, more: plan.length - shown.length),
        if (shown.isEmpty)
          const Expanded(child: _Empty())
        else
          Expanded(
            child: Column(
              children: [
                for (final entry in shown)
                  Expanded(
                    child: _PointRow(entry, actions: actions, compact: compact),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

/// All three points next to each other, with room for the day they are due and a free place to take one on.
class _Columns extends StatelessWidget {
  const _Columns(this.plan, {required this.actions, required this.onAdd});

  final List<FocusEntry> plan;
  final FocusActions actions;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final canAdd = plan.length < FocusService.maxActive;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Head(canAdd: false, onAdd: onAdd, more: 0),
        Expanded(
          child: Row(
            spacing: HubSpacing.s12,
            children: [
              for (final entry in plan) Expanded(child: _PointCard(entry, actions: actions)),
              if (canAdd) Expanded(child: _AddCard(onTap: onAdd)),
            ],
          ),
        ),
      ],
    );
  }
}

/// The glyph and the plus, which is there only while fewer than three points are active. No title – the points
/// are what the widget is about, and they say it themselves.
class _Head extends StatelessWidget {
  const _Head({required this.canAdd, required this.onAdd, required this.more});

  final bool canAdd;
  final VoidCallback onAdd;

  /// Points that did not fit in this size.
  final int more;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: HubSpacing.s8),
      child: Row(
        spacing: HubSpacing.s8,
        children: [
          const HubGlyphIcon(HubGlyph.target, color: HubColorPalette.text3, size: Size.square(15)),
          const Spacer(),
          if (more > 0) Text('+$more', style: HubTextStyles.label.copyWith(color: HubColorPalette.text2).tabular),
          if (canAdd)
            Semantics(
              button: true,
              label: 'New focus',
              child: GestureDetector(
                onTap: onAdd,
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: const BoxDecoration(color: HubColorPalette.elevated, shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: const HubGlyphIcon(HubGlyph.plus, color: HubColorPalette.text, size: Size.square(13)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// One point as a row: what it is, how many days are left, and how far its time has run.
class _PointRow extends StatelessWidget {
  const _PointRow(this.entry, {required this.actions, required this.compact});

  final FocusEntry entry;
  final FocusActions actions;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final open = actions.openId == entry.point.id;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => actions.onTap(entry.point.id),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: compact ? 8 : 12),
          decoration: BoxDecoration(
            color: HubAreaColors.veil(HubAreaColors.focus),
            borderRadius: BorderRadius.circular(HubRadius.row),
          ),
          child: open
              ? _Options(entry, actions: actions)
              : compact
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      spacing: HubSpacing.s8,
                      children: [
                        Expanded(child: _Title(entry, fontSize: 15)),
                        Text(
                          entry.countdown,
                          style: HubTextStyles.micro.copyWith(color: _colorOf(entry.urgency)).tabular,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    _Bar(entry, height: 5),
                  ],
                )
              : Row(
                  spacing: HubSpacing.s16,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _Title(entry, fontSize: 16),
                          const SizedBox(height: 4),
                          Text(
                            focusDayLabel(entry.point.dueDate),
                            maxLines: 1,
                            style: HubTextStyles.micro
                                .copyWith(fontWeight: FontWeight.w500, color: HubColorPalette.text3)
                                .tabular,
                          ),
                          const SizedBox(height: 8),
                          _Bar(entry),
                        ],
                      ),
                    ),
                    _Countdown(entry, size: 30),
                  ],
                ),
        ),
      ),
    );
  }
}

/// One point as a column (extra large): the countdown is the biggest thing on the card.
class _PointCard extends StatelessWidget {
  const _PointCard(this.entry, {required this.actions});

  final FocusEntry entry;
  final FocusActions actions;

  @override
  Widget build(BuildContext context) {
    final open = actions.openId == entry.point.id;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => actions.onTap(entry.point.id),
      child: Container(
        padding: const EdgeInsets.all(HubSpacing.s16),
        decoration: BoxDecoration(
          color: HubAreaColors.veil(HubAreaColors.focus),
          borderRadius: BorderRadius.circular(HubRadius.roomTile),
        ),
        child: open
            ? Center(child: _Options(entry, actions: actions, stacked: true))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Title(entry, fontSize: 18, maxLines: 2),
                  const SizedBox(height: 6),
                  Text(
                    focusDayLabel(entry.point.dueDate),
                    style: HubTextStyles.secondary.copyWith(fontSize: 13, color: HubColorPalette.text3).tabular,
                  ),
                  const Spacer(),
                  _Countdown(entry, size: 52),
                  const SizedBox(height: 12),
                  _Bar(entry, height: 7),
                ],
              ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title(this.entry, {required this.fontSize, this.maxLines = 1});

  final FocusEntry entry;
  final double fontSize;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      entry.point.title,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: HubTextStyles.body.copyWith(fontSize: fontSize, fontWeight: FontWeight.w700, height: 1.2),
    );
  }
}

/// The days left, big, with what they are in words under them.
class _Countdown extends StatelessWidget {
  const _Countdown(this.entry, {required this.size});

  final FocusEntry entry;
  final double size;

  @override
  Widget build(BuildContext context) {
    final color = _colorOf(entry.urgency);
    final days = entry.daysLeft.abs();
    final number = TextStyle(
      color: color,
      fontSize: size,
      fontWeight: FontWeight.w700,
      letterSpacing: -1.5,
      height: 1,
    ).tabular;
    if (entry.daysLeft == 0) {
      return Text('Today', style: number.copyWith(fontSize: size * 0.62, letterSpacing: -0.5));
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('$days', style: number),
        Text(switch ((entry.daysLeft > 0, days)) {
          (true, 1) => 'day left',
          (true, _) => 'days left',
          (false, 1) => 'day over',
          (false, _) => 'days over',
        }, style: HubTextStyles.micro.copyWith(color: HubColorPalette.text2)),
      ],
    );
  }
}

/// How much of the time from taking it on to its day has run.
class _Bar extends StatelessWidget {
  const _Bar(this.entry, {this.height = 6});

  final FocusEntry entry;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: Stack(
        children: [
          Container(height: height, color: HubColorPalette.elevated),
          FractionallySizedBox(
            widthFactor: entry.progress,
            child: AnimatedContainer(duration: HubMotion.fadeDuration, height: height, color: _colorOf(entry.urgency)),
          ),
        ],
      ),
    );
  }
}

/// The free place next to the points: a frame with a plus.
class _AddCard extends StatelessWidget {
  const _AddCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'New focus',
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(HubRadius.roomTile),
            border: Border.all(color: HubColorPalette.cardBorder),
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: HubSpacing.s8,
            children: [
              const HubGlyphIcon(HubGlyph.plus, color: HubColorPalette.text3, size: Size.square(18)),
              Text('New focus', style: HubTextStyles.label.copyWith(color: HubColorPalette.text3)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Done, edit and drop, laid over the point after a tap – tapping it again puts them away.
class _Options extends StatelessWidget {
  const _Options(this.entry, {required this.actions, this.stacked = false});

  final FocusEntry entry;
  final FocusActions actions;

  /// Under each other instead of next to each other, where a row would be too narrow.
  final bool stacked;

  @override
  Widget build(BuildContext context) {
    final chips = [
      _Chip(label: 'Done', glyph: HubGlyph.check, primary: true, onTap: () => actions.onAchieve(entry.point.id)),
      _Chip(label: 'Edit', glyph: HubGlyph.pencil, onTap: () => actions.onEdit(entry)),
      _Chip(label: 'Drop', glyph: HubGlyph.trash, onTap: () => actions.onRemove(entry.point.id)),
    ];
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => actions.onTap(entry.point.id),
      child: stacked
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: HubSpacing.s8,
              children: chips,
            )
          // Each one as wide as the next, so three of them always fit the row they lie over.
          : Row(spacing: 6, children: [for (final chip in chips) Expanded(child: chip)]),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.glyph, required this.onTap, this.primary = false});

  final String label;
  final HubGlyph glyph;
  final VoidCallback onTap;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: primary ? HubColorPalette.controlStrong : HubColorPalette.control,
            borderRadius: BorderRadius.circular(HubRadius.pill),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 6,
            children: [
              HubGlyphIcon(glyph, color: HubColorPalette.text, size: const Size.square(13)),
              Text(label, style: HubTextStyles.label.copyWith(fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Nothing taken on yet.
class _Empty extends StatelessWidget {
  const _Empty({this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (compact) ...[
          const HubGlyphIcon(HubGlyph.target, color: HubColorPalette.text2, size: Size.square(16)),
          const Spacer(),
        ],
        Text(
          'What are you on?',
          maxLines: 2,
          style: HubTextStyles.body.copyWith(fontWeight: FontWeight.w700, height: 1.2),
        ),
        const SizedBox(height: 4),
        Text(
          'A name and a day. Up to three.',
          maxLines: 2,
          style: HubTextStyles.label.copyWith(fontWeight: FontWeight.w400, color: HubColorPalette.text2),
        ),
      ],
    );
  }
}
