import 'dart:io';

import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:smart_hub/common/config/perenual_config.dart';
import 'package:smart_hub/data/plants/perenual/perenual.repository.dart';

void main() {
  group('PerenualRepository', () {
    late List<Uri> requests;

    String fixture(String name) => File('test/fixtures/perenual/$name.json').readAsStringSync();

    PerenualRepository repository({Map<String, String> bodies = const {}}) {
      final client = MockClient((request) async {
        requests.add(request.url);
        final body = switch (request.url.path) {
          '/api/v2/species-list' => fixture('species_list'),
          '/api/v2/species/details/2193' => bodies['details'] ?? fixture('species_details'),
          '/api/species-care-guide-list' => bodies['guide'] ?? fixture('care_guide'),
          _ => null,
        };
        return body == null ? http.Response('', 404) : http.Response(body, 200);
      });
      return PerenualRepository(
        config: const PerenualConfig(apiKey: 'key-1'),
        client: client,
      );
    }

    setUp(() => requests = []);

    test('Given a search, when Perenual answers, then free species come first and premium ones are marked', () async {
      // When
      final matches = await repository().search('monstera');

      // Then
      expect(requests.single.queryParameters, {'key': 'key-1', 'q': 'monstera'});
      expect(matches.map((match) => '${match.id} ${match.available}'), ['2774 true', '2194 true', '5257 false']);
      expect(matches.first.commonName, 'pothos');
      expect(matches.first.scientificName, "Epipremnum aureum 'Neon'");
      expect(matches.first.thumbnailUrl, endsWith('thumbnail.jpg'));
      expect(matches[1].scientificName, isNull);
      expect(matches.last.thumbnailUrl, isNull, reason: 'the upgrade placeholder is no picture');
    });

    test('Given details and a care guide, when loading the profile, then the care data and guides are read', () async {
      // When
      final profile = await withClock(Clock.fixed(DateTime(2026, 10, 26)), () => repository().profile(2193));

      // Then
      expect(profile.commonName, 'Swiss cheese plant');
      expect(profile.watering, 'Average');
      expect((profile.wateringMinDays, profile.wateringMaxDays), (7, 10));
      expect(profile.sunlight, ['part shade', 'part sun/part shade']);
      expect(profile.pruningMonths, [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'December',
      ]);
      expect(profile.careLevel, 'Medium');
      expect(profile.indoor, isTrue);
      expect(profile.poisonousToPets, isTrue);
      expect(profile.imageUrl, endsWith('medium.jpg'));
      expect(profile.wateringGuide, 'Water when the top inch of soil is dry.');
      expect(profile.sunlightGuide, 'Bright, indirect light.');
      expect(profile.pruningGuide, 'Trim old leaves in spring.');
      expect(profile.fetchedAt, DateTime(2026, 10, 26));
    });

    test('Given a species beyond the free tier, when loading, then the placeholders count as unknown', () async {
      // Given
      const upgrade = 'Upgrade Plans To Premium/Supreme - https://perenual.com/subscription-api-pricing';
      final details =
          '{"id": 2193, "common_name": "Swiss cheese plant", "watering": "$upgrade", '
          '"watering_general_benchmark": {"value": "$upgrade", "unit": "days"}, "sunlight": ["$upgrade"], '
          '"care_level": "$upgrade"}';

      // When
      final profile = await repository(bodies: {'details': details, 'guide': '{"data": []}'}).profile(2193);

      // Then
      expect(profile.watering, isNull);
      expect(profile.wateringMinDays, isNull);
      expect(profile.sunlight, isEmpty);
      expect(profile.careLevel, isNull);
      expect(profile.wateringGuide, isNull);
    });

    test('Given the care guide fails, when loading the profile, then the care data still comes', () async {
      // When
      final profile = await repository(bodies: {'guide': 'not json'}).profile(2193);

      // Then
      expect(profile.watering, 'Average');
      expect(profile.wateringGuide, isNull);
    });
  });
}
