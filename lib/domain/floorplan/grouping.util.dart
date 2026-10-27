import 'package:smart_hub/domain/floorplan/model/plan_point.dart';

/// Grouping of devices that are placed close together (`README` → "Grouping").
abstract final class GroupingUtil {
  /// Devices closer than this form a group (single linkage).
  static const groupDistance = 34.0;

  /// While dragging, the nearest other device within this distance is the drop target.
  static const dropTargetDistance = 40.0;

  /// Offset from the drop target where a dropped device lands.
  static const dropOffset = PlanPoint(7, 5);

  /// Groups of at least two devices. Each group's ids are sorted; groups are sorted by their first id.
  ///
  /// Single linkage: a device joins a group when it is closer than [distance] to any member.
  static List<List<String>> groups(Map<String, PlanPoint> positions, {double distance = groupDistance}) {
    final ids = positions.keys.toList()..sort();
    final parent = {for (final id in ids) id: id};

    String root(String id) {
      var current = id;
      while (parent[current] != current) {
        current = parent[current]!;
      }
      return current;
    }

    for (var i = 0; i < ids.length; i++) {
      for (var j = i + 1; j < ids.length; j++) {
        if (positions[ids[i]]!.distanceTo(positions[ids[j]]!) < distance) {
          parent[root(ids[j])] = root(ids[i]);
        }
      }
    }

    final clusters = <String, List<String>>{};
    for (final id in ids) {
      clusters.putIfAbsent(root(id), () => []).add(id);
    }
    return clusters.values.where((members) => members.length > 1).toList()..sort((a, b) => a.first.compareTo(b.first));
  }

  /// Stable key of a group: sorted member ids joined by `|`.
  static String groupKey(Iterable<String> memberIds) => ([...memberIds]..sort()).join('|');

  /// The device nearest to [position] within [dropTargetDistance], ignoring [draggedId]. `null` if none.
  static String? dropTarget(String draggedId, PlanPoint position, Map<String, PlanPoint> others) {
    String? nearest;
    var nearestDistance = dropTargetDistance;
    for (final MapEntry(key: id, value: other) in others.entries) {
      if (id == draggedId) continue;
      final distance = other.distanceTo(position);
      if (distance <= nearestDistance) {
        nearest = id;
        nearestDistance = distance;
      }
    }
    return nearest;
  }

  /// Where a device dropped on [target] lands.
  static PlanPoint dropPosition(PlanPoint target) => target + dropOffset;
}
