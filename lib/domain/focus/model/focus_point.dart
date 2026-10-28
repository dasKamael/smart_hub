import 'package:freezed_annotation/freezed_annotation.dart';

part 'focus_point.freezed.dart';

/// A goal that is currently yours: a name and the day it has to be done. At most three are active at a time –
/// the limit is the point of the whole thing. Focus points live only in the app.
@freezed
abstract class FocusPoint with _$FocusPoint {
  const factory FocusPoint({
    required String id,
    required String title,

    /// The day it has to be done.
    required DateTime dueDate,
    required DateTime createdAt,

    /// Order in the widget, smallest first.
    @Default(0) int position,
    DateTime? achievedAt,
  }) = _FocusPoint;

  const FocusPoint._();

  /// Still to do.
  bool get isActive => achievedAt == null;
}
