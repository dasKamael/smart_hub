import 'package:flutter/widgets.dart';
import 'package:smart_hub/domain/dashboard/model/dashboard_widget_kind.enum.dart';
import 'package:smart_hub/domain/dashboard/model/dashboard_widget_size.enum.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';
import 'package:smart_hub/presentation/design_system/layouts/widget_tile.dart';
import 'package:smart_hub/presentation/screens/apps/widgets/apps_widget.dart';
import 'package:smart_hub/presentation/screens/dashboard/widgets/home_summary_widget.dart';
import 'package:smart_hub/presentation/screens/focus/widgets/focus_widget.dart';
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
    DashboardWidgetKind.apps => 'Apps',
    DashboardWidgetKind.focus => 'Focus',
  };

  static String description(DashboardWidgetKind kind) => switch (kind) {
    DashboardWidgetKind.weather => 'Now, the next hours and days for where the hub is.',
    DashboardWidgetKind.home => 'Lights on, plants to water and what plays.',
    DashboardWidgetKind.plants => 'Which plants need water – tap one to water it.',
    DashboardWidgetKind.lights => 'Switch rooms, dim them and pick a scene.',
    DashboardWidgetKind.music => 'What plays, with play, skip and your playlists.',
    DashboardWidgetKind.apps => 'Open the apps on the tablet with one tap.',
    DashboardWidgetKind.focus => 'Up to three goals and the days left until each is due.',
  };

  static HubGlyph glyph(DashboardWidgetKind kind) => switch (kind) {
    DashboardWidgetKind.weather => HubGlyph.sun,
    DashboardWidgetKind.home => HubGlyph.pottedPlant,
    DashboardWidgetKind.plants => HubGlyph.drop,
    DashboardWidgetKind.lights => HubGlyph.bulb,
    DashboardWidgetKind.music => HubGlyph.note,
    DashboardWidgetKind.apps => HubGlyph.tablet,
    DashboardWidgetKind.focus => HubGlyph.target,
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
    DashboardWidgetKind.apps => 'Apps',
    _ => null,
  };

  /// What "Automatic" shows in "Edit widget".
  static String automaticDetail(DashboardWidgetKind kind) => switch (kind) {
    DashboardWidgetKind.apps => 'Streaming and video apps',
    _ => 'All ${selectionName(kind)?.toLowerCase()}, as on the plan',
  };

  static WidgetSize tileSize(DashboardWidgetSize size) => WidgetSize.values.byName(size.name);

  static Widget build(
    DashboardWidgetKind kind,
    DashboardWidgetSize size, {
    List<String> selection = const [],
    bool? card,
  }) {
    final onCard = card ?? kind.cardByDefault;
    return switch (kind) {
      DashboardWidgetKind.weather => WeatherWidget(size: tileSize(size), card: onCard),
      DashboardWidgetKind.home => HomeSummaryWidget(card: onCard),
      DashboardWidgetKind.plants => PlantsWidget(size: tileSize(size), card: onCard),
      DashboardWidgetKind.lights => LightsWidget(size: tileSize(size), roomIds: selection, card: onCard),
      DashboardWidgetKind.music => MusicWidget(size: tileSize(size), card: onCard),
      DashboardWidgetKind.apps => AppsWidget(size: tileSize(size), packageNames: selection, card: onCard),
      DashboardWidgetKind.focus => FocusWidget(size: tileSize(size), card: onCard),
    };
  }
}
