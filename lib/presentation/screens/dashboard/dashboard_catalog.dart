import 'package:flutter/widgets.dart';
import 'package:smart_hub/domain/dashboard/model/dashboard_widget_kind.enum.dart';
import 'package:smart_hub/domain/dashboard/model/dashboard_widget_size.enum.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/layouts/widget_tile.dart';
import 'package:smart_hub/presentation/screens/dashboard/widgets/home_summary_widget.dart';
import 'package:smart_hub/presentation/screens/lights/widgets/lights_widget.dart';
import 'package:smart_hub/presentation/screens/music/widgets/music_widget.dart';
import 'package:smart_hub/presentation/screens/plants/widgets/plants_widget.dart';
import 'package:smart_hub/presentation/screens/weather/widgets/weather_widget.dart';

/// Name, description, symbol and the widget itself for each kind of dashboard widget – what the gallery offers.
abstract final class DashboardCatalog {
  static String name(DashboardWidgetKind kind) => switch (kind) {
    DashboardWidgetKind.weather => 'Weather',
    DashboardWidgetKind.home => 'Home',
    DashboardWidgetKind.plants => 'Plants',
    DashboardWidgetKind.lights => 'Lights',
    DashboardWidgetKind.music => 'Music',
  };

  static String description(DashboardWidgetKind kind) => switch (kind) {
    DashboardWidgetKind.weather => 'Now, the next hours and days for where the hub is.',
    DashboardWidgetKind.home => 'Lights on, plants to water and what plays.',
    DashboardWidgetKind.plants => 'Which plants need water – tap one to water it.',
    DashboardWidgetKind.lights => 'Switch rooms, dim them and pick a scene.',
    DashboardWidgetKind.music => 'What plays, with play, skip and your playlists.',
  };

  static HubGlyph glyph(DashboardWidgetKind kind) => switch (kind) {
    DashboardWidgetKind.weather => HubGlyph.sun,
    DashboardWidgetKind.home => HubGlyph.pottedPlant,
    DashboardWidgetKind.plants => HubGlyph.drop,
    DashboardWidgetKind.lights => HubGlyph.bulb,
    DashboardWidgetKind.music => HubGlyph.note,
  };

  static String sizeName(DashboardWidgetSize size) => switch (size) {
    DashboardWidgetSize.small => 'Small',
    DashboardWidgetSize.medium => 'Medium',
    DashboardWidgetSize.large => 'Large',
    DashboardWidgetSize.extraLarge => 'Extra large',
  };

  /// What a widget of [kind] lets you choose in "Edit widget" (see `DashboardWidget.selection`); `null` when there
  /// is nothing to edit.
  static String? selectionName(DashboardWidgetKind kind) => switch (kind) {
    DashboardWidgetKind.lights => 'Rooms',
    _ => null,
  };

  static WidgetSize tileSize(DashboardWidgetSize size) => WidgetSize.values.byName(size.name);

  static Widget build(DashboardWidgetKind kind, DashboardWidgetSize size, {List<String> selection = const []}) {
    return switch (kind) {
      DashboardWidgetKind.weather => WeatherWidget(size: tileSize(size)),
      DashboardWidgetKind.home => const HomeSummaryWidget(),
      DashboardWidgetKind.plants => PlantsWidget(size: tileSize(size)),
      DashboardWidgetKind.lights => LightsWidget(size: tileSize(size), roomIds: selection),
      DashboardWidgetKind.music => MusicWidget(size: tileSize(size)),
    };
  }
}
