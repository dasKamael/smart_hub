import 'package:flutter/widgets.dart';
import 'package:smart_hub/domain/dashboard/model/dashboard_widget_kind.enum.dart';
import 'package:smart_hub/domain/dashboard/model/dashboard_widget_size.enum.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/layouts/widget_tile.dart';
import 'package:smart_hub/presentation/screens/dashboard/widgets/home_summary_widget.dart';
import 'package:smart_hub/presentation/screens/weather/widgets/weather_widget.dart';

/// Name, description, symbol and the widget itself for each kind of dashboard widget – what the gallery offers.
abstract final class DashboardCatalog {
  static String name(DashboardWidgetKind kind) => switch (kind) {
    DashboardWidgetKind.weather => 'Weather',
    DashboardWidgetKind.home => 'Home',
  };

  static String description(DashboardWidgetKind kind) => switch (kind) {
    DashboardWidgetKind.weather => 'Now, the next hours and days for where the hub is.',
    DashboardWidgetKind.home => 'Lights on, plants to water and what plays.',
  };

  static HubGlyph glyph(DashboardWidgetKind kind) => switch (kind) {
    DashboardWidgetKind.weather => HubGlyph.sun,
    DashboardWidgetKind.home => HubGlyph.pottedPlant,
  };

  static String sizeName(DashboardWidgetSize size) => switch (size) {
    DashboardWidgetSize.small => 'Small',
    DashboardWidgetSize.medium => 'Medium',
    DashboardWidgetSize.large => 'Large',
    DashboardWidgetSize.extraLarge => 'Extra large',
  };

  static WidgetSize tileSize(DashboardWidgetSize size) => WidgetSize.values.byName(size.name);

  static Widget build(DashboardWidgetKind kind, DashboardWidgetSize size) {
    return switch (kind) {
      DashboardWidgetKind.weather => WeatherWidget(size: tileSize(size)),
      DashboardWidgetKind.home => const HomeSummaryWidget(),
    };
  }
}
