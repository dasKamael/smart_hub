import 'package:smart_hub/domain/dashboard/model/dashboard_widget.dart';
import 'package:smart_hub/domain/dashboard/model/dashboard_widget_size.enum.dart';

/// Places widgets on the one dashboard page. Each stays where it was put, gaps included; a widget without a place yet
/// (new, or arranged before widgets kept their place) takes the first free spot from the top left.
abstract final class DashboardLayoutUtil {
  static const columns = 6;
  static const rows = 3;

  /// The cell of each widget that fits, by id and in the order of [widgets]: its own cell while that is free, else
  /// the first free spot. Widgets that do not fit any more are left out.
  static Map<String, GridCell> place(List<DashboardWidget> widgets) {
    final taken = _empty();
    final cells = <String, GridCell>{};
    for (final widget in widgets) {
      final cell = widget.cell;
      if (cell != null && _isFree(taken, cell, widget.size)) cells[widget.id] = _take(taken, cell, widget.size);
    }
    for (final widget in widgets) {
      if (cells.containsKey(widget.id)) continue;
      if (_firstFree(taken, widget.size) case final cell?) cells[widget.id] = _take(taken, cell, widget.size);
    }
    return {for (final widget in widgets) widget.id: ?cells[widget.id]};
  }

  /// Whether all [widgets] fit on the page together.
  static bool fits(List<DashboardWidget> widgets) => place(widgets).length == widgets.length;

  /// Whether every widget fits in the cell it was put in, e.g. after one grew: nothing else has to move for it.
  static bool fitsInPlace(List<DashboardWidget> widgets) {
    final cells = place(widgets);
    return widgets.every((widget) => widget.cell != null && cells[widget.id] == widget.cell);
  }

  /// [widgets] with the cells they are shown in, so each keeps its place from now on; those that do not fit are left
  /// out.
  static List<DashboardWidget> pinned(List<DashboardWidget> widgets) {
    final cells = place(widgets);
    return [
      for (final widget in widgets)
        if (cells[widget.id] case final cell?) widget.copyWith(cell: cell),
    ];
  }

  /// [widgets] with [id] put at [target]. One widget in the way swaps places with it if it fits there; otherwise the
  /// widgets in the way take the free spots nearest to where they were. `null` when there is no room for that.
  static List<DashboardWidget>? move(List<DashboardWidget> widgets, String id, GridCell target) {
    final all = pinned(widgets);
    final moved = all.where((widget) => widget.id == id).firstOrNull;
    if (moved == null || !_inBounds(target, moved.size)) return null;
    final from = moved.cell!;
    final put = moved.copyWith(cell: target);
    final others = all.where((widget) => widget.id != id);
    final inTheWay = [
      for (final other in others)
        if (_overlaps(other.cell!, other.size, target, moved.size)) other,
    ];
    final staying = [
      for (final other in others)
        if (!inTheWay.contains(other)) other,
    ];

    if (inTheWay case [final single]) {
      final swapped = [...staying, put, single.copyWith(cell: from)];
      if (fitsInPlace(swapped)) return _inOrderOf(widgets, swapped);
    }

    final taken = _empty();
    for (final widget in [...staying, put]) {
      _take(taken, widget.cell!, widget.size);
    }
    final result = [...staying, put];
    for (final other in inTheWay) {
      final cell = _nearestFree(taken, other.size, other.cell!);
      if (cell == null) return null;
      result.add(other.copyWith(cell: _take(taken, cell, other.size)));
    }
    return _inOrderOf(widgets, result);
  }

  static List<List<bool>> _empty() => List.generate(rows, (_) => List.filled(columns, false));

  static GridCell _take(List<List<bool>> taken, GridCell cell, DashboardWidgetSize size) {
    for (var row = cell.row; row < cell.row + size.rows; row++) {
      for (var column = cell.column; column < cell.column + size.columns; column++) {
        taken[row][column] = true;
      }
    }
    return cell;
  }

  static bool _inBounds(GridCell cell, DashboardWidgetSize size) =>
      cell.column >= 0 && cell.row >= 0 && cell.column + size.columns <= columns && cell.row + size.rows <= rows;

  static bool _overlaps(GridCell a, DashboardWidgetSize aSize, GridCell b, DashboardWidgetSize bSize) =>
      a.column < b.column + bSize.columns &&
      b.column < a.column + aSize.columns &&
      a.row < b.row + bSize.rows &&
      b.row < a.row + aSize.rows;

  static GridCell? _firstFree(List<List<bool>> taken, DashboardWidgetSize size) {
    for (var row = 0; row + size.rows <= rows; row++) {
      for (var column = 0; column + size.columns <= columns; column++) {
        final cell = (column: column, row: row);
        if (_isFree(taken, cell, size)) return cell;
      }
    }
    return null;
  }

  /// The free spot closest to [near]; the one further up and left when two are as close.
  static GridCell? _nearestFree(List<List<bool>> taken, DashboardWidgetSize size, GridCell near) {
    GridCell? best;
    var bestDistance = 1 << 30;
    for (var row = 0; row + size.rows <= rows; row++) {
      for (var column = 0; column + size.columns <= columns; column++) {
        final cell = (column: column, row: row);
        if (!_isFree(taken, cell, size)) continue;
        final distance = (column - near.column) * (column - near.column) + (row - near.row) * (row - near.row);
        if (distance < bestDistance) {
          bestDistance = distance;
          best = cell;
        }
      }
    }
    return best;
  }

  static bool _isFree(List<List<bool>> taken, GridCell cell, DashboardWidgetSize size) {
    if (!_inBounds(cell, size)) return false;
    for (var row = cell.row; row < cell.row + size.rows; row++) {
      for (var column = cell.column; column < cell.column + size.columns; column++) {
        if (taken[row][column]) return false;
      }
    }
    return true;
  }

  /// [changed] in the order of [widgets].
  static List<DashboardWidget> _inOrderOf(List<DashboardWidget> widgets, List<DashboardWidget> changed) {
    final byId = {for (final widget in changed) widget.id: widget};
    return [for (final widget in widgets) ?byId[widget.id]];
  }
}
