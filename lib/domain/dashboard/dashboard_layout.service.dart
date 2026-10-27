import 'package:clock/clock.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/data/dashboard/dashboard_layout.repository.dart';
import 'package:smart_hub/domain/dashboard/dashboard_layout.util.dart';
import 'package:smart_hub/domain/dashboard/model/dashboard_widget.dart';
import 'package:smart_hub/domain/dashboard/model/dashboard_widget_kind.enum.dart';
import 'package:smart_hub/domain/dashboard/model/dashboard_widget_size.enum.dart';

part 'dashboard_layout.service.g.dart';

/// The widgets on the dashboard in their order. Changes are only made when everything still fits on the page.
///
/// This service is the only writer: it loads the arrangement once and keeps it, so quick changes build on each
/// other instead of on what the database reports back later.
@Riverpod(keepAlive: true)
class DashboardLayoutService extends _$DashboardLayoutService {
  /// The arrangement before the dashboard was ever changed.
  static const defaultLayout = [
    DashboardWidget(id: 'weather-1', kind: DashboardWidgetKind.weather, size: DashboardWidgetSize.extraLarge),
    DashboardWidget(id: 'home-1', kind: DashboardWidgetKind.home, size: DashboardWidgetSize.medium),
    DashboardWidget(id: 'weather-2', kind: DashboardWidgetKind.weather, size: DashboardWidgetSize.medium),
  ];

  @override
  Future<List<DashboardWidget>> build() async {
    return await ref.watch(dashboardLayoutRepositoryProvider).load() ?? defaultLayout;
  }

  /// The sizes of [kind] that still fit on the page.
  List<DashboardWidgetSize> sizesThatFit(DashboardWidgetKind kind) {
    final widgets = state.value ?? const <DashboardWidget>[];
    return [
      for (final size in kind.sizes)
        if (DashboardLayoutUtil.fits([...widgets, DashboardWidget(id: '', kind: kind, size: size)])) size,
    ];
  }

  /// Adds a widget at the end; `false` when it does not fit.
  Future<bool> add(DashboardWidgetKind kind, DashboardWidgetSize size) {
    final id = '${kind.name}-${clock.now().microsecondsSinceEpoch}';
    return _saveIfFits([..._widgets, DashboardWidget(id: id, kind: kind, size: size)]);
  }

  Future<void> remove(String id) => _saveIfFits([..._widgets.where((widget) => widget.id != id)]);

  /// Changes the size of [id]; `false` when the page has no room for it.
  Future<bool> resize(String id, DashboardWidgetSize size) {
    return _saveIfFits([for (final widget in _widgets) widget.id == id ? widget.copyWith(size: size) : widget]);
  }

  /// Puts the widgets in the order of [ids]; unknown ids are ignored, missing widgets keep their place at the end.
  Future<bool> reorder(List<String> ids) {
    final byId = {for (final widget in _widgets) widget.id: widget};
    return _saveIfFits([
      for (final id in ids) ?byId[id],
      for (final widget in _widgets)
        if (!ids.contains(widget.id)) widget,
    ]);
  }

  List<DashboardWidget> get _widgets => state.value ?? defaultLayout;

  Future<bool> _saveIfFits(List<DashboardWidget> widgets) async {
    if (!DashboardLayoutUtil.fits(widgets)) return false;
    state = AsyncData(widgets);
    await ref.read(dashboardLayoutRepositoryProvider).save(widgets);
    return true;
  }
}
