import 'package:smart_hub/domain/dashboard/model/dashboard_widget_size.enum.dart';

/// What a dashboard widget shows, and the sizes it comes in.
enum DashboardWidgetKind {
  weather(DashboardWidgetSize.values),
  home([DashboardWidgetSize.medium]),
  plants(DashboardWidgetSize.values),
  lights(DashboardWidgetSize.values),
  music(DashboardWidgetSize.values),
  apps(DashboardWidgetSize.values, cardByDefault: false),
  focus(DashboardWidgetSize.values);

  const DashboardWidgetKind(this.sizes, {this.cardByDefault = true});

  final List<DashboardWidgetSize> sizes;

  /// Whether a new widget of this kind sits on a card; app icons stand on the dashboard itself.
  final bool cardByDefault;
}
