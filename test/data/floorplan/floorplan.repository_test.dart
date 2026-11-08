import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/data/database/app_database.dart';
import 'package:smart_hub/data/floorplan/floorplan.repository.dart';
import 'package:smart_hub/domain/floorplan/model/door_type.enum.dart';
import 'package:smart_hub/domain/floorplan/model/furniture_kind.enum.dart';
import 'package:smart_hub/domain/floorplan/model/home_layout.dart';
import 'package:smart_hub/domain/floorplan/model/room_type.enum.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';

/// Serves [content] for every key and counts the reads.
class _FakeAssetBundle extends CachingAssetBundle {
  _FakeAssetBundle(this.content);

  String content;
  var reads = 0;

  @override
  Future<ByteData> load(String key) async {
    reads++;
    return ByteData.sublistView(Uint8List.fromList(content.codeUnits));
  }

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    reads++;
    return content;
  }
}

const _layout = HomeLayout(
  nodes: [
    LayoutNode(id: 'n1', position: PlanPoint.zero),
    LayoutNode(id: 'n2', position: PlanPoint(400, 0)),
    LayoutNode(id: 'n3', position: PlanPoint(400, 300.5)),
  ],
  walls: [
    LayoutWall(id: 'w1', from: 'n1', to: 'n2', thickness: 24),
    LayoutWall(id: 'w2', from: 'n2', to: 'n3'),
    LayoutWall(id: 'w3', from: 'n3', to: 'n1'),
  ],
  openings: [LayoutOpening(id: 'd', wallId: 'w1', type: DoorType.window, offset: 120.5, width: 100, swing: 2)],
  rooms: [LayoutRoom(id: 'r', name: 'Bedroom', type: RoomType.bedroom, anchor: PlanPoint(260, 100))],
  furniture: [
    Furniture(id: 'f1', kind: FurnitureKind.bed, position: PlanPoint(200, 110), rotation: 90, width: 160, depth: 205),
  ],
);

void main() {
  group('FloorplanRepository', () {
    late AppDatabase database;
    late _FakeAssetBundle assets;
    late FloorplanRepository repository;

    setUp(() {
      database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      assets = _FakeAssetBundle(File('assets/floorplan/floorplan.json').readAsStringSync());
      repository = FloorplanRepository(database: database, assets: assets);
    });

    test('Given a fresh database, '
        'when loading, '
        'then the bundled apartment comes as room outlines with 7 rooms and 7 doors', () async {
      // When
      final stored = await repository.load();

      // Then
      final plan = (stored as StoredOutlines).plan;
      expect(plan.rooms.map((r) => r.name), ['Office', 'Storage', 'Storage 2', 'Hall', 'Kitchen', 'WC', 'Sleep']);
      expect(plan.doors, hasLength(7));
      expect(plan.doors.first.type, DoorType.door);
      expect(plan.doors.first.a, const PlanPoint(0, 160));
    });

    test('Given a saved layout, when loading again, then that layout comes back instead of the bundled plan', () async {
      // Given
      await repository.save(_layout);

      // When
      final stored = await repository.load();

      // Then
      expect((stored as StoredLayout).layout, _layout);
    });

    test('Given a plan of room outlines in the database, when saving the converted layout and keeping the previous '
        'plan, then the old plan is kept as a backup', () async {
      // Given
      final outlines = File('assets/floorplan/floorplan.json').readAsStringSync();
      await database.into(database.floorPlansTable).insert(FloorPlanRow(id: 1, json: outlines));

      // When
      await repository.save(_layout, keepPrevious: true);

      // Then
      expect(await repository.loadBackup(), outlines);
      expect((await repository.load() as StoredLayout).layout, _layout);
    });

    test('Given a fresh database, when saving without keeping the previous plan, then there is no backup', () async {
      // When
      await repository.save(_layout);

      // Then
      expect(await repository.loadBackup(), isNull);
    });

    test('Given a layout with everything in it, when encoding and parsing it, then nothing is lost', () {
      // When
      final json = FloorplanRepository.encode(_layout);

      // Then
      expect(FloorplanRepository.parseLayout(jsonDecode(json) as Map<String, Object?>), _layout);
      expect(json, contains('"format": "smart-hub-home"'));
    });

    test('Given a plan in meters, when parsing, then it is rejected', () {
      expect(() => FloorplanRepository.parse({'unit': 'm', 'rooms': <Object?>[]}), throwsFormatException);
    });
  });
}
