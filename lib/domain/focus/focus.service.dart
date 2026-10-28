import 'package:clock/clock.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/data/focus/focus.repository.dart';
import 'package:smart_hub/domain/focus/focus_due.util.dart';
import 'package:smart_hub/domain/focus/model/focus_point.dart';

part 'focus.service.g.dart';

/// The focus points and what you can do with them: take one on, say it is done, change it, drop it. At most
/// [maxActive] are active at a time – a fourth one only goes in once another is done or dropped.
@Riverpod(keepAlive: true)
class FocusService extends _$FocusService {
  static const maxActive = 3;

  @override
  Stream<List<FocusPoint>> build() => ref.watch(focusRepositoryProvider).watchAll();

  /// Takes on a point, due on [dueDate]. Returns `null` when [maxActive] are already active.
  Future<FocusPoint?> add({required String title, required DateTime dueDate}) async {
    final repository = ref.read(focusRepositoryProvider);
    final points = await repository.all();
    final active = points.where((point) => point.isActive).toList();
    if (active.length >= maxActive) return null;
    final now = clock.now();
    final point = FocusPoint(
      id: _freeId(now, points.map((point) => point.id).toSet()),
      title: title.trim(),
      dueDate: FocusDueUtil.dayOf(dueDate),
      createdAt: now,
      position: active.isEmpty ? 0 : active.map((point) => point.position).reduce(_max) + 1,
    );
    await repository.save(point);
    return point;
  }

  /// Saves a new name or day for [id].
  Future<void> edit(String id, {required String title, required DateTime dueDate}) async {
    final point = await _byId(id);
    if (point == null) return;
    await ref
        .read(focusRepositoryProvider)
        .save(point.copyWith(title: title.trim(), dueDate: FocusDueUtil.dayOf(dueDate)));
  }

  /// Done. The point keeps its day, so the archive shows whether it was in time.
  Future<void> achieve(String id) async {
    final point = await _byId(id);
    if (point == null) return;
    await ref.read(focusRepositoryProvider).save(point.copyWith(achievedAt: clock.now()));
  }

  /// Takes a point back up after it was marked done.
  Future<void> undoAchieve(String id) async {
    final point = await _byId(id);
    if (point == null) return;
    await ref.read(focusRepositoryProvider).save(point.copyWith(achievedAt: null));
  }

  Future<void> remove(String id) => ref.read(focusRepositoryProvider).delete(id);

  /// Orders the points as [ids] lists them.
  Future<void> reorder(List<String> ids) async {
    final repository = ref.read(focusRepositoryProvider);
    final points = await repository.all();
    await repository.saveAll([
      for (final point in points)
        if (ids.contains(point.id)) point.copyWith(position: ids.indexOf(point.id)),
    ]);
  }

  Future<FocusPoint?> _byId(String id) async {
    return (await ref.read(focusRepositoryProvider).all()).where((point) => point.id == id).firstOrNull;
  }

  /// An id from the moment it was taken on, counted up while it is taken – two points added in the same
  /// microsecond (which happens with a fixed clock in tests) must not share one.
  static String _freeId(DateTime now, Set<String> taken) {
    final base = 'focus-${now.microsecondsSinceEpoch.toRadixString(36)}';
    var id = base;
    for (var suffix = 1; taken.contains(id); suffix++) {
      id = '$base-$suffix';
    }
    return id;
  }

  static int _max(int a, int b) => a > b ? a : b;
}

/// The focus points still to do, in their order, at most [FocusService.maxActive].
@riverpod
List<FocusPoint> activeFocusPoints(Ref ref) {
  final points = ref.watch(focusServiceProvider).value ?? const <FocusPoint>[];
  return [
    for (final point in points)
      if (point.isActive) point,
  ];
}

/// What is done, newest first.
@riverpod
List<FocusPoint> achievedFocusPoints(Ref ref) {
  final points = ref.watch(focusServiceProvider).value ?? const <FocusPoint>[];
  final achieved = [
    for (final point in points)
      if (!point.isActive) point,
  ];
  return achieved..sort((a, b) => b.achievedAt!.compareTo(a.achievedAt!));
}
