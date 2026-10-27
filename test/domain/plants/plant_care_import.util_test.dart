import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/plants/model/plant_profile_source.enum.dart';
import 'package:smart_hub/domain/plants/plant_care_import.util.dart';

void main() {
  group('PlantCareImportUtil', () {
    final now = DateTime(2026, 10, 26);

    test('Given plant names, when building the prompt, then it names the format and every plant', () {
      // When
      final prompt = PlantCareImportUtil.prompt(['Basil', 'Monstera']);

      // Then
      expect(prompt, contains('"format": "smart-hub-plant-care"'));
      expect(prompt, contains('- Basil\n- Monstera'));
    });

    test('Given an answer in a Markdown code block, when parsing, then every field is read', () {
      // Given
      const answer = '''
Here is your data:
```json
{
  "format": "smart-hub-plant-care",
  "version": 1,
  "plants": [
    {
      "name": "Basil",
      "commonName": "Sweet basil",
      "scientificName": "Ocimum basilicum",
      "wateringSummerDays": [2, 3],
      "wateringWinterDays": [4, 6],
      "wateringGuide": "Keep the soil slightly moist.",
      "fertilizeEveryWeeks": 2,
      "light": ["full sun"],
      "lightGuide": "A sunny windowsill.",
      "careLevel": "Medium",
      "indoor": true,
      "toxicToPets": false,
      "pruningMonths": ["May", "June"],
      "pruningGuide": null
    }
  ]
}
```
''';

      // When
      final result = PlantCareImportUtil.parse(answer, now: now);

      // Then
      expect(result.problems, isEmpty);
      final (:name, :profile) = result.plants.single;
      expect(name, 'Basil');
      expect(profile.source, PlantProfileSource.imported);
      expect(profile.speciesId, isNull);
      expect(profile.commonName, 'Sweet basil');
      expect(profile.scientificName, 'Ocimum basilicum');
      expect((profile.wateringMinDays, profile.wateringMaxDays), (2, 3));
      expect((profile.wateringWinterMinDays, profile.wateringWinterMaxDays), (4, 6));
      expect(profile.fertilizeEveryWeeks, 2);
      expect(profile.sunlight, ['full sun']);
      expect(profile.poisonousToPets, isFalse);
      expect(profile.pruningMonths, ['May', 'June']);
      expect(profile.pruningGuide, isNull);
      expect(profile.fetchedAt, now);
    });

    test('Given odd values, when parsing, then days are sorted and clamped, a single number is a range', () {
      // When
      final result = PlantCareImportUtil.parse(
        '{"plants": [{"name": "Cactus", "wateringSummerDays": [200, 14], "wateringWinterDays": 30, '
        '"fertilizeEveryWeeks": 0}]}',
        now: now,
      );

      // Then
      final profile = result.plants.single.profile;
      expect((profile.wateringMinDays, profile.wateringMaxDays), (14, 90));
      expect((profile.wateringWinterMinDays, profile.wateringWinterMaxDays), (30, 30));
      expect(profile.fertilizeEveryWeeks, isNull);
      expect(profile.commonName, 'Cactus');
    });

    test('Given entries without name or watering, when parsing, then they are skipped and named', () {
      // When
      final result = PlantCareImportUtil.parse(
        '{"plants": [{"name": "Fern", "wateringSummerDays": [3, 4]}, {"name": "Palm"}, {"wateringSummerDays": [5]}, 7]}',
        now: now,
      );

      // Then
      expect(result.plants.map((entry) => entry.name), ['Fern']);
      expect(result.problems, [
        'Palm: needs a name and watering days',
        'Entry 3: needs a name and watering days',
        'Entry 4 is not an object',
      ]);
    });

    test('Given no or broken JSON, when parsing, then it says so', () {
      expect(PlantCareImportUtil.parse('Sorry, I cannot help.', now: now).problems, ['No JSON found']);
      expect(PlantCareImportUtil.parse('{"plants": [}', now: now).problems.single, startsWith('The JSON is not valid'));
      expect(PlantCareImportUtil.parse('{"items": []}', now: now).problems, ['No "plants" list found']);
    });

    test('Given an answer with typographic quotes, as some apps paste it, when parsing, then it is read anyway', () {
      // Given
      const answer = '''
{
“format”: “smart-hub-plant-care”,
“version”: 1,
“plants”: [
{
“name”: “Calathea”,
“commonName”: “Prayer plant (Calathea)”,
“wateringSummerDays”: [5, 7],
“wateringWinterDays”: [8, 12],
“wateringGuide”: “Water when the top 2 cm of soil feel dry; cut the leaf’s brown tips.”,
“fertilizeEveryWeeks”: 4,
“light”: [“medium to bright indirect light”, “no direct sun”]
}
]
}''';

      // When
      final result = PlantCareImportUtil.parse(answer, now: now);

      // Then
      expect(result.problems, isEmpty);
      final profile = result.plants.single.profile;
      expect(result.plants.single.name, 'Calathea');
      expect((profile.wateringWinterMinDays, profile.wateringWinterMaxDays), (8, 12));
      expect(profile.wateringGuide, contains('leaf’s'));
      expect(profile.sunlight, ['medium to bright indirect light', 'no direct sun']);
    });
  });
}
