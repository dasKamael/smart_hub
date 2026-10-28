import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/painting.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/common/utils/current_day.provider.dart';
import 'package:smart_hub/domain/focus/focus.service.dart';
import 'package:smart_hub/domain/focus/focus_due.util.dart';
import 'package:smart_hub/domain/focus/model/focus_point.dart';
import 'package:smart_hub/domain/focus/model/focus_urgency.enum.dart';
import 'package:smart_hub/presentation/design_system/tokens/hub_area_colors.dart';

part 'focus.controller.g.dart';

/// What the focus editor returns.
sealed class FocusEdit {
  const FocusEdit();
}

final class SaveFocus extends FocusEdit {
  const SaveFocus({required this.title, required this.dueDate});

  final String title;
  final DateTime dueDate;
}

final class RemoveFocus extends FocusEdit {
  const RemoveFocus();
}

/// A focus point with its countdown today: days left, how much of its time has passed, how pressing it is and the
/// countdown in words.
typedef FocusEntry = ({FocusPoint point, int daysLeft, double progress, FocusUrgency urgency, String countdown});

/// The focus widget: saying a point is done, dropping it and saving the editor.
@riverpod
class FocusController extends _$FocusController {
  static final _log = Logger('FocusController');

  /// The point whose options are laid over it; `null` while none are shown.
  @override
  String? build() => null;

  /// Shows the options of a point, or hides them when they are already shown.
  void toggleOptions(String id) => state = state == id ? null : id;

  void closeOptions() => state = null;

  void achieve(String id) {
    closeOptions();
    _run('mark the focus point as done', _service.achieve(id));
  }

  void remove(String id) {
    closeOptions();
    _run('drop the focus point', _service.remove(id));
  }

  /// Saves what the editor returned for [point] (`null` takes on a new one). `false` when it could not be saved –
  /// because three are already active, or because the save failed.
  Future<bool> apply(FocusPoint? point, FocusEdit edit) async {
    closeOptions();
    try {
      switch (edit) {
        case RemoveFocus():
          if (point != null) await _service.remove(point.id);
          return true;
        case SaveFocus(:final title, :final dueDate):
          if (point == null) return await _service.add(title: title, dueDate: dueDate) != null;
          await _service.edit(point.id, title: title, dueDate: dueDate);
          return true;
      }
    } on Object catch (e) {
      _log.warning('Could not save the focus point: $e');
      return false;
    }
  }

  FocusService get _service => ref.read(focusServiceProvider.notifier);

  void _run(String action, Future<void> command) {
    unawaited(command.catchError((Object e) => _log.warning('Could not $action: $e')));
  }
}

/// The focus points still to do with their countdown, the most pressing one first.
@riverpod
List<FocusEntry> focusPlan(Ref ref) {
  final today = ref.watch(currentDayProvider).value ?? clock.now();
  final entries = [
    for (final point in ref.watch(activeFocusPointsProvider))
      (
        point: point,
        daysLeft: FocusDueUtil.daysLeft(point, today),
        progress: FocusDueUtil.progress(point, today),
        urgency: FocusDueUtil.urgencyOf(point, today),
        countdown: FocusDueUtil.countdown(point, today),
      ),
  ];
  // What is due first stands first – that is the whole order a focus list needs.
  return entries..sort((a, b) => a.daysLeft.compareTo(b.daysLeft));
}

/// The color of the focus area: it warms as the days run out.
@riverpod
Color focusTint(Ref ref) {
  final plan = ref.watch(focusPlanProvider);
  return HubAreaColors.focusFor(
    soon: plan.where((entry) => entry.urgency == FocusUrgency.soon || entry.urgency == FocusUrgency.today).length,
    overdue: plan.where((entry) => entry.urgency == FocusUrgency.overdue).length,
  );
}
