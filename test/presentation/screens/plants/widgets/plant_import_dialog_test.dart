import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/plants/model/plant.dart';
import 'package:smart_hub/domain/plants/model/plant_profile.dart';
import 'package:smart_hub/domain/plants/plant_care_import.util.dart';
import 'package:smart_hub/domain/plants/plant_profile.service.dart';
import 'package:smart_hub/presentation/screens/plants/plants.screen.dart';

import '../../../../mocks/floorplan.mock.dart';
import '../../../../utils/widget.test_util.dart';

void main() {
  group('PlantImportDialog', () {
    late _FakeProfiles profiles;
    String? clipboard;

    Future<void> openDialog(WidgetTester tester) async {
      profiles = _FakeProfiles();
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
        if (call.method == 'Clipboard.setData') {
          clipboard = (call.arguments as Map<Object?, Object?>)['text'] as String?;
        }
        return null;
      });
      await loadWidgetTestApp(
        tester: tester,
        container: createTestContainer(
          overrides: [
            ...floorplanWidgetTestOverrides(
              FakePlacementService(),
              plants: FakePlantsService([
                Plant(id: 'p.basil', name: 'Basil', everyDays: 7, lastWatered: DateTime(2026, 10, 24)),
              ]),
            ),
            plantProfileServiceProvider.overrideWith(() => profiles),
          ],
        ),
        underTestWidget: const PlantsScreen(),
      );
      await tester.tap(find.bySemanticsLabel('Import care data'));
      await tester.pumpAndSettle();
    }

    testWidgets('Given the hub has plants, when adding a name and copying the prompt, then it lists all of them', (
      tester,
    ) async {
      // Given
      await openDialog(tester);

      // When
      await tester.enterText(find.byType(TextFormField).first, 'Basil\nMint\n');
      await tester.tap(find.text('Copy prompt'));
      await tester.pumpAndSettle();

      // Then
      expect(clipboard, contains('- Basil\n- Mint\n'));
      expect(find.text('Copied'), findsOneWidget);
    });

    testWidgets('Given an answer for Basil and Mint, '
        'when pasting and importing, '
        'then the preview marks Mint as new and both are imported', (tester) async {
      // Given
      await openDialog(tester);

      // When
      await tester.enterText(
        find.byType(TextFormField).last,
        '```json\n{"plants": [{"name": "Basil", "wateringSummerDays": [2, 3]}, '
        '{"name": "Mint", "wateringSummerDays": [3, 4]}, {"name": "Broken"}]}\n```',
      );
      await tester.pump();
      final preview = (
        find.text('Basil · 2–3 d').evaluate().length,
        find.text('Mint · 3–4 d · new').evaluate().length,
        find.text('Broken: needs a name and watering days').evaluate().length,
      );
      await tester.tap(find.text('Import'));
      await tester.pumpAndSettle();

      // Then
      expect(preview, (1, 1, 1));
      expect(profiles.imported, ['Basil', 'Mint']);
      expect(find.textContaining('1 plant updated, 1 added'), findsOneWidget);
    });
  });
}

class _FakeProfiles extends PlantProfileService {
  final imported = <String>[];

  @override
  Future<({int updated, int added})> importCare(List<PlantCareEntry> entries) async {
    imported.addAll([for (final entry in entries) entry.name]);
    return (updated: 1, added: 1);
  }

  @override
  Future<PlantProfile> link(String plantId, int speciesId) => throw UnimplementedError();
}
