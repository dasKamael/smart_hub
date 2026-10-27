import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/data/database/app_database.dart';
import 'package:smart_hub/data/floorplan/floorplan.repository.dart';
import 'package:smart_hub/domain/floorplan/model/door_type.enum.dart';
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
        'then the bundled apartment is parsed with 7 rooms and 7 doors', () async {
      // When
      final plan = await repository.load();

      // Then
      expect(plan.rooms.map((r) => r.name), ['Office', 'Storage', 'Storage 2', 'Hall', 'Kitchen', 'WC', 'Sleep']);
      expect(plan.doors, hasLength(7));
      expect(plan.doors.first.type, DoorType.door);
      expect(plan.doors.first.a, const PlanPoint(0, 160));
      expect(plan.rooms.first.polygon.first, PlanPoint.zero);
    });

    test('Given the plan was loaded once, '
        'when loading again after the bundled file changed, '
        'then the stored plan is used', () async {
      // Given
      await repository.load();
      assets.content = '{"unit": "cm", "rooms": []}';

      // When
      final plan = await repository.load();

      // Then
      expect(plan.rooms, hasLength(7));
      expect(assets.reads, 1);
    });

    test('Given a plan in meters, when parsing, then it is rejected', () {
      expect(() => FloorplanRepository.parse({'unit': 'm', 'rooms': <Object?>[]}), throwsFormatException);
    });
  });
}
