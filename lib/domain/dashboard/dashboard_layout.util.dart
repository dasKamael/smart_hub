import 'package:smart_hub/domain/dashboard/model/dashboard_widget.dart';
import 'package:smart_hub/domain/dashboard/model/dashboard_widget_size.enum.dart';

/// Where a widget sits: column and row of its top left corner.
typedef GridCell = ({int column, int row});

/// Places widgets on the one dashboard page like icons on an iPad: in their order, each in the first free spot from
/// the top left, so there are no gaps to manage and the others move up when one goes.
abstract final class DashboardLayoutUtil {
  static const columns = 6;
  static const rows = 3;

  /// The cell of each widget that fits, by id; widgets that do not fit any more are left out.
  static Map<String, GridCell> place(List<DashboardWidget> widgets) {
    final taken = List.generate(rows, (_) => List.filled(columns, false));
    final cells = <String, GridCell>{};
    for (final widget in widgets) {
      final cell = _firstFree(taken, widget.size);
      if (cell == null) continue;
      for (var row = cell.row; row < cell.row + widget.size.rows; row++) {
        for (var column = cell.column; column < cell.column + widget.size.columns; column++) {
          taken[row][column] = true;
        }
      }
      cells[widget.id] = cell;
    }
    return cells;
  }

  /// Whether all [widgets] fit on the page together.
  static bool fits(List<DashboardWidget> widgets) => place(widgets).length == widgets.length;

  static GridCell? _firstFree(List<List<bool>> taken, DashboardWidgetSize size) {
    for (var row = 0; row + size.rows <= rows; row++) {
      for (var column = 0; column + size.columns <= columns; column++) {
        if (_isFree(taken, column, row, size)) return (column: column, row: row);
      }
    }
    return null;
  }

  static bool _isFree(List<List<bool>> taken, int column, int row, DashboardWidgetSize size) {
    for (var r = row; r < row + size.rows; r++) {
      for (var c = column; c < column + size.columns; c++) {
        if (taken[r][c]) return false;
      }
    }
    return true;
  }
}
