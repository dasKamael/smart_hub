import 'dart:async';
import 'dart:ui';

import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/domain/dashboard/dashboard_layout.service.dart';
import 'package:smart_hub/domain/dashboard/dashboard_layout.util.dart';
import 'package:smart_hub/domain/dashboard/model/dashboard_widget.dart';
import 'package:smart_hub/domain/dashboard/model/dashboard_widget_kind.enum.dart';
import 'package:smart_hub/domain/dashboard/model/dashboard_widget_size.enum.dart';
import 'package:smart_hub/presentation/design_system/layouts/widget_tile.dart';
import 'package:smart_hub/presentation/screens/dashboard/dashboard.state.dart';

part 'dashboard.controller.g.dart';

/// The widgets as shown, with their cells: the saved arrangement, or the preview while dragging or resizing.
typedef DashboardLayout = ({List<DashboardWidget> widgets, Map<String, GridCell> cells});

/// Editing the dashboard like the iPad home screen: long press to jiggle, drag to move (the others make room),
/// drag the corner to resize, remove and add.
@riverpod
class DashboardController extends _$DashboardController {
  static final _log = Logger('DashboardController');

  /// Pixels per grid unit, gap included.
  static const step = WidgetSize.unit + WidgetSize.gap;

  @override
  DashboardPageState build() => const DashboardPageState();

  void startEditing() => state = state.copyWith(editing: true);

  void stopEditing() => state = const DashboardPageState();

  void remove(String id) => _run('remove a widget', ref.read(dashboardLayoutServiceProvider.notifier).remove(id));

  void select(String id, List<String> selection) {
    _run('choose what a widget shows', ref.read(dashboardLayoutServiceProvider.notifier).select(id, selection));
  }

  Future<bool> add(DashboardWidgetKind kind, DashboardWidgetSize size) {
    return ref.read(dashboardLayoutServiceProvider.notifier).add(kind, size);
  }

  void startDrag(String id) {
    // From the saved arrangement: [dashboardLayout] depends on this controller and must not be read here.
    final cell = DashboardLayoutUtil.place(_saved)[id];
    if (cell == null) return;
    state = state.copyWith(
      draggedId: id,
      dragOrigin: Offset(cell.column * step, cell.row * step),
      dragOffset: Offset.zero,
      order: [for (final widget in _saved) widget.id],
    );
  }

  /// Moves the dragged widget by [delta]; the order changes to where it would land closest to the finger.
  void dragBy(Offset delta) {
    final id = state.draggedId;
    final order = state.order;
    if (id == null || order == null) return;
    final offset = state.dragOffset + delta;
    final widgets = _saved;
    final dragged = widgets.where((widget) => widget.id == id).firstOrNull;
    if (dragged == null) return;
    final size = Offset(dragged.size.columns * step, dragged.size.rows * step);
    final center = state.dragOrigin + offset + size / 2;

    final others = [
      for (final other in order)
        if (other != id) other,
    ];
    List<String>? best;
    var bestDistance = double.infinity;
    for (var index = 0; index <= others.length; index++) {
      final candidate = [...others]..insert(index, id);
      final cells = DashboardLayoutUtil.place(_inOrder(widgets, candidate));
      final cell = cells[id];
      if (cells.length != widgets.length || cell == null) continue;
      final distance = (Offset(cell.column * step, cell.row * step) + size / 2 - center).distance;
      if (distance < bestDistance) {
        bestDistance = distance;
        best = candidate;
      }
    }
    state = state.copyWith(dragOffset: offset, order: best ?? order);
  }

  void endDrag() {
    final order = state.order;
    state = state.copyWith(draggedId: null, dragOffset: Offset.zero, order: null);
    if (order != null) _run('move a widget', ref.read(dashboardLayoutServiceProvider.notifier).reorder(order));
  }

  /// Resizes [id] by dragging its corner [delta] pixels; the closest size of its kind that fits is previewed.
  void resizeBy(String id, Offset delta) {
    final widget = _saved.where((widget) => widget.id == id).firstOrNull;
    if (widget == null) return;
    final columns = (widget.size.columns + delta.dx / step).clamp(1, DashboardLayoutUtil.columns).toDouble();
    final rows = (widget.size.rows + delta.dy / step).clamp(1, DashboardLayoutUtil.rows).toDouble();
    final fitting = [
      for (final size in widget.kind.sizes)
        if (DashboardLayoutUtil.fits([for (final other in _saved) other.id == id ? other.copyWith(size: size) : other]))
          size,
    ];
    if (fitting.isEmpty) return;
    double distance(DashboardWidgetSize size) =>
        (size.columns - columns) * (size.columns - columns) + (size.rows - rows) * (size.rows - rows);
    final closest = fitting.reduce((a, b) => distance(b) < distance(a) ? b : a);
    state = state.copyWith(resizedId: id, resizeDelta: delta, resizeTo: closest);
  }

  void endResize() {
    final (id, size) = (state.resizedId, state.resizeTo);
    state = state.copyWith(resizedId: null, resizeDelta: Offset.zero, resizeTo: null);
    if (id != null && size != null) {
      _run('resize a widget', ref.read(dashboardLayoutServiceProvider.notifier).resize(id, size));
    }
  }

  List<DashboardWidget> get _saved => ref.read(dashboardLayoutServiceProvider).value ?? const [];

  static List<DashboardWidget> _inOrder(List<DashboardWidget> widgets, List<String> order) {
    final byId = {for (final widget in widgets) widget.id: widget};
    return [for (final id in order) ?byId[id]];
  }

  void _run(String action, Future<Object?> command) {
    unawaited(
      command.catchError((Object e) {
        _log.warning('Could not $action: $e');
        return null;
      }),
    );
  }
}

@riverpod
DashboardLayout dashboardLayout(Ref ref) {
  final saved = ref.watch(dashboardLayoutServiceProvider).value ?? const <DashboardWidget>[];
  final page = ref.watch(dashboardControllerProvider);
  var widgets = [
    for (final widget in saved)
      widget.id == page.resizedId && page.resizeTo != null ? widget.copyWith(size: page.resizeTo!) : widget,
  ];
  if (page.order case final order?) {
    final byId = {for (final widget in widgets) widget.id: widget};
    widgets = [for (final id in order) ?byId[id]];
  }
  return (widgets: widgets, cells: DashboardLayoutUtil.place(widgets));
}
