import 'package:smart_hub/domain/dashboard/model/dashboard_widget_size.enum.dart';

/// What a dashboard widget shows, and the sizes it comes in.
enum DashboardWidgetKind {
  weather(DashboardWidgetSize.values),
  home([DashboardWidgetSize.medium]),
  plants(DashboardWidgetSize.values);

  const DashboardWidgetKind(this.sizes);

  final List<DashboardWidgetSize> sizes;
}
