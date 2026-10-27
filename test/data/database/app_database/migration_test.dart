// dart format width=80
// ignore_for_file: unused_local_variable, unused_import
import 'package:drift/drift.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:smart_hub/data/database/app_database.dart';
import 'package:flutter_test/flutter_test.dart';

import 'generated/schema.dart';

import 'generated/schema_v1.dart' as v1;
import 'generated/schema_v2.dart' as v2;

void main() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  late SchemaVerifier verifier;

  setUpAll(() {
    verifier = SchemaVerifier(GeneratedHelper());
  });

  group('simple database migrations', () {
    // These simple tests verify all possible schema updates with a simple (no
    // data) migration. This is a quick way to ensure that written database
    // migrations properly alter the schema.
    const versions = GeneratedHelper.versions;
    for (final (i, fromVersion) in versions.indexed) {
      group('from $fromVersion', () {
        for (final toVersion in versions.skip(i + 1)) {
          test('to $toVersion', () async {
            final schema = await verifier.schemaAt(fromVersion);
            final db = AppDatabase(schema.newConnection());
            await verifier.migrateAndValidate(db, toVersion);
            await db.close();
          });
        }
      });
    }
  });

  test('migration from v1 to v2 does not corrupt data', () async {
    // Floor plan and placements must survive adding the plants table.
    final oldFloorPlansData = [
      const v1.FloorPlansData(id: 1, json: '{"unit": "cm", "rooms": []}'),
    ];
    final expectedNewFloorPlansData = [
      const v2.FloorPlansData(id: 1, json: '{"unit": "cm", "rooms": []}'),
    ];

    final oldPlacementsData = [
      const v1.PlacementsData(
        deviceId: 'light.desk',
        kind: 'light',
        x: 100,
        y: 50,
      ),
    ];
    final expectedNewPlacementsData = [
      const v2.PlacementsData(
        deviceId: 'light.desk',
        kind: 'light',
        x: 100,
        y: 50,
      ),
    ];

    await verifier.testWithDataIntegrity(
      oldVersion: 1,
      newVersion: 2,
      createOld: v1.DatabaseAtV1.new,
      createNew: v2.DatabaseAtV2.new,
      openTestedDatabase: AppDatabase.new,
      createItems: (batch, oldDb) {
        batch.insertAll(oldDb.floorPlans, oldFloorPlansData);
        batch.insertAll(oldDb.placements, oldPlacementsData);
      },
      validateItems: (newDb) async {
        expect(
          expectedNewFloorPlansData,
          await newDb.select(newDb.floorPlans).get(),
        );
        expect(
          expectedNewPlacementsData,
          await newDb.select(newDb.placements).get(),
        );
      },
    );
  });
}
