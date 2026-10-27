import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smart_hub/domain/dashboard/model/dashboard_widget_kind.enum.dart';
import 'package:smart_hub/domain/dashboard/model/dashboard_widget_size.enum.dart';

part 'dashboard_widget.freezed.dart';

/// One widget on the dashboard. Its place follows from the order of all widgets (see `DashboardLayoutUtil`).
@freezed
abstract class DashboardWidget with _$DashboardWidget {
  const factory DashboardWidget({
    required String id,
    required DashboardWidgetKind kind,
    required DashboardWidgetSize size,
  }) = _DashboardWidget;
}
