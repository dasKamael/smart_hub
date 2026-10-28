import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smart_hub/domain/dashboard/model/dashboard_widget_kind.enum.dart';
import 'package:smart_hub/domain/dashboard/model/dashboard_widget_size.enum.dart';

part 'dashboard_widget.freezed.dart';

/// Where a widget sits: column and row of its top left corner.
typedef GridCell = ({int column, int row});

/// One widget on the dashboard, where it was put (see `DashboardLayoutUtil`).
@freezed
abstract class DashboardWidget with _$DashboardWidget {
  const factory DashboardWidget({
    required String id,
    required DashboardWidgetKind kind,
    required DashboardWidgetSize size,

    /// What the widget shows, in this order – e.g. room ids for the lights widget. Empty: chosen automatically.
    @Default(<String>[]) List<String> selection,

    /// Whether the widget sits on a card; `null`: as its kind does by default.
    bool? card,

    /// Where it was put; `null` (e.g. arranged before widgets kept their place): the first free spot.
    GridCell? cell,
  }) = _DashboardWidget;

  const DashboardWidget._();

  bool get showsCard => card ?? kind.cardByDefault;
}
