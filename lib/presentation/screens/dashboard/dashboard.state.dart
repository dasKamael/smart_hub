import 'dart:ui';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smart_hub/domain/dashboard/model/dashboard_widget.dart';
import 'package:smart_hub/domain/dashboard/model/dashboard_widget_size.enum.dart';

part 'dashboard.state.freezed.dart';

/// Editing the dashboard: whether the widgets jiggle, and what is being dragged or resized right now.
@freezed
abstract class DashboardPageState with _$DashboardPageState {
  const factory DashboardPageState({
    @Default(false) bool editing,

    /// The widget under the finger.
    String? draggedId,

    /// Where the dragged widget's top left was when the drag started, and how far it moved since.
    @Default(Offset.zero) Offset dragOrigin,
    @Default(Offset.zero) Offset dragOffset,

    /// Where the dragged widget would land, and the page as it would be then (others swapped or moved aside).
    GridCell? dropCell,
    List<DashboardWidget>? preview,

    /// The widget whose size is being dragged, how far its corner moved, and the size it would snap to.
    String? resizedId,
    @Default(Offset.zero) Offset resizeDelta,
    DashboardWidgetSize? resizeTo,
  }) = _DashboardPageState;
}
