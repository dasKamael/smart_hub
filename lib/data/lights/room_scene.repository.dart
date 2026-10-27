import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/data/database/app_database.dart';
import 'package:smart_hub/domain/lights/model/rgb_color.dart';
import 'package:smart_hub/domain/lights/model/room_scene.dart';

part 'room_scene.repository.g.dart';

class RoomSceneRepository {
  RoomSceneRepository({required this.database});

  final AppDatabase database;

  $RoomScenesTableTable get _table => database.roomScenesTable;

  /// The saved scenes per room id, in their order.
  Future<Map<String, List<RoomScene>>> loadAll() async {
    final query = database.select(_table)..orderBy([(t) => OrderingTerm(expression: t.position)]);
    final byRoom = <String, List<RoomScene>>{};
    for (final row in await query.get()) {
      byRoom.putIfAbsent(row.roomId, () => []).add(_toScene(row));
    }
    return byRoom;
  }

  /// Replaces the scenes of [roomId] with [scenes] in this order.
  Future<void> replaceRoom(String roomId, List<RoomScene> scenes) {
    return database.transaction(() async {
      await (database.delete(_table)..where((t) => t.roomId.equals(roomId))).go();
      await database.batch((batch) {
        batch.insertAll(_table, [
          for (final (position, scene) in scenes.indexed)
            RoomScenesTableCompanion.insert(
              id: scene.id,
              roomId: roomId,
              name: scene.name,
              position: position,
              brightnessPercent: scene.brightnessPercent,
              color: scene.color.argb,
              kelvin: scene.kelvin,
              lights: jsonEncode({
                for (final MapEntry(key: id, value: light) in scene.lights.entries)
                  id: {
                    'on': light.on,
                    'brightness': ?light.brightnessPercent,
                    'color': ?light.color?.argb,
                    'kelvin': ?light.kelvin,
                  },
              }),
            ),
        ]);
      });
    });
  }

  static RoomScene _toScene(RoomSceneRow row) {
    final lights = switch (jsonDecode(row.lights)) {
      final Map<String, Object?> map => map,
      _ => const <String, Object?>{},
    };
    return RoomScene(
      id: row.id,
      roomId: row.roomId,
      name: row.name,
      brightnessPercent: row.brightnessPercent,
      color: _color(row.color),
      kelvin: row.kelvin,
      lights: {
        for (final MapEntry(key: id, value: light) in lights.entries)
          if (light case final Map<String, Object?> light)
            id: SceneLight(
              on: light['on'] == true,
              brightnessPercent: (light['brightness'] as num?)?.toInt(),
              color: switch (light['color']) {
                final num argb => _color(argb.toInt()),
                _ => null,
              },
              kelvin: (light['kelvin'] as num?)?.toInt(),
            ),
      },
    );
  }

  static RgbColor _color(int argb) => RgbColor((argb >> 16) & 0xFF, (argb >> 8) & 0xFF, argb & 0xFF);
}

/// Providers
@Riverpod(keepAlive: true)
RoomSceneRepository roomSceneRepository(Ref ref) => RoomSceneRepository(database: ref.watch(appDatabaseProvider));
