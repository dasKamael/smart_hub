import 'package:clock/clock.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/data/dashboard/dashboard_layout.repository.dart';
import 'package:smart_hub/domain/dashboard/dashboard_layout.util.dart';
import 'package:smart_hub/domain/dashboard/model/dashboard_widget.dart';
import 'package:smart_hub/domain/dashboard/model/dashboard_widget_kind.enum.dart';
import 'package:smart_hub/domain/dashboard/model/dashboard_widget_size.enum.dart';

part 'dashboard_layout.service.g.dart';

/// The widgets on the dashboard and where they were put. Changes are only made when everything still fits on the
/// page; once changed, every widget keeps its cell.
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

  /// Adds a widget in the first free spot; `false` when it does not fit.
  Future<bool> add(DashboardWidgetKind kind, DashboardWidgetSize size) {
    final id = '${kind.name}-${clock.now().microsecondsSinceEpoch}';
    return _saveIfFits([..._widgets, DashboardWidget(id: id, kind: kind, size: size)]);
  }

  Future<void> remove(String id) => _saveIfFits([..._widgets.where((widget) => widget.id != id)]);

  /// Changes the size of [id], growing from its top left corner; `false` when another widget is in the way.
  Future<bool> resize(String id, DashboardWidgetSize size) async {
    final resized = [for (final widget in _widgets) widget.id == id ? widget.copyWith(size: size) : widget];
    if (!DashboardLayoutUtil.fitsInPlace(resized)) return false;
    return _saveIfFits(resized);
  }

  /// Sets what [id] shows (see `DashboardWidget.selection`, an empty list lets the widget choose) and whether it sits
  /// on a card.
  Future<void> edit(String id, {required List<String> selection, required bool card}) {
    return _saveIfFits([
      for (final widget in _widgets) widget.id == id ? widget.copyWith(selection: selection, card: card) : widget,
    ]);
  }

  /// Puts [id] at [cell] (see `DashboardLayoutUtil.move`); `false` when there is no room for that.
  Future<bool> move(String id, GridCell cell) async {
    final moved = DashboardLayoutUtil.move(_widgets, id, cell);
    if (moved == null) return false;
    return _saveIfFits(moved);
  }

  /// Where the widgets are now, each with its cell – so removing one leaves its gap instead of moving the others up.
  List<DashboardWidget> get _widgets => DashboardLayoutUtil.pinned(state.value ?? defaultLayout);

  Future<bool> _saveIfFits(List<DashboardWidget> changed) async {
    if (!DashboardLayoutUtil.fits(changed)) return false;
    final widgets = DashboardLayoutUtil.pinned(changed);
    state = AsyncData(widgets);
    await ref.read(dashboardLayoutRepositoryProvider).save(widgets);
    return true;
  }
}
