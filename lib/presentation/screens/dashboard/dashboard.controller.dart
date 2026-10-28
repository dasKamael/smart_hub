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

/// Editing the dashboard like the iPad home screen: long press to jiggle, drag a widget to any free cell (one in the
/// way swaps with it or moves aside), drag the corner to resize, remove and add.
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

  void edit(String id, {required List<String> selection, required bool card}) {
    _run('edit a widget', ref.read(dashboardLayoutServiceProvider.notifier).edit(id, selection: selection, card: card));
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
      dropCell: cell,
      preview: null,
    );
  }

  /// Moves the dragged widget by [delta]; the page previews it in the cell under it, with the others swapped or moved
  /// aside. A cell without room for that keeps the last preview.
  void dragBy(Offset delta) {
    final id = state.draggedId;
    if (id == null) return;
    final offset = state.dragOffset + delta;
    final dragged = _saved.where((widget) => widget.id == id).firstOrNull;
    if (dragged == null) return;
    final corner = state.dragOrigin + offset;
    final cell = (
      column: (corner.dx / step).round().clamp(0, DashboardLayoutUtil.columns - dragged.size.columns),
      row: (corner.dy / step).round().clamp(0, DashboardLayoutUtil.rows - dragged.size.rows),
    );
    if (cell == state.dropCell) {
      state = state.copyWith(dragOffset: offset);
      return;
    }
    final preview = DashboardLayoutUtil.move(_saved, id, cell);
    state = preview == null
        ? state.copyWith(dragOffset: offset)
        : state.copyWith(dragOffset: offset, dropCell: cell, preview: preview);
  }

  void endDrag() {
    final (id, cell, preview) = (state.draggedId, state.dropCell, state.preview);
    state = state.copyWith(draggedId: null, dragOffset: Offset.zero, dropCell: null, preview: null);
    if (id != null && cell != null && preview != null) {
      _run('move a widget', ref.read(dashboardLayoutServiceProvider.notifier).move(id, cell));
    }
  }

  /// Resizes [id] by dragging its corner [delta] pixels; the closest size of its kind that fits is previewed.
  void resizeBy(String id, Offset delta) {
    final widget = _saved.where((widget) => widget.id == id).firstOrNull;
    if (widget == null) return;
    final columns = (widget.size.columns + delta.dx / step).clamp(1, DashboardLayoutUtil.columns).toDouble();
    final rows = (widget.size.rows + delta.dy / step).clamp(1, DashboardLayoutUtil.rows).toDouble();
    // It grows from its top left corner, as far as the others leave room.
    final fitting = [
      for (final size in widget.kind.sizes)
        if (DashboardLayoutUtil.fitsInPlace([
          for (final other in DashboardLayoutUtil.pinned(_saved)) other.id == id ? other.copyWith(size: size) : other,
        ]))
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
  if (page.preview case final preview?) widgets = preview;
  return (widgets: widgets, cells: DashboardLayoutUtil.place(widgets));
}
