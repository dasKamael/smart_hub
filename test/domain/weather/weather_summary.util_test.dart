import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/weather/model/forecast.dart';
import 'package:smart_hub/domain/weather/model/weather_condition.enum.dart';
import 'package:smart_hub/domain/weather/weather_summary.util.dart';

void main() {
  group('WeatherSummaryUtil', () {
    List<WeatherHour> hours({
      Map<int, WeatherCondition> conditions = const {},
      Map<int, int> chances = const {},
      Map<int, double> gusts = const {},
    }) => [
      for (var i = 0; i < 12; i++)
        WeatherHour(
          time: DateTime(2026, 10, 27, 10 + i),
          temperature: 12,
          condition: conditions[i] ?? WeatherCondition.cloudy,
          isDay: true,
          precipitationProbability: chances[i] ?? 0,
          precipitation: 0,
          windGusts: gusts[i] ?? 20,
        ),
    ];

    test('Given no rain and calm wind, when summing up, then it stays dry', () {
      expect(WeatherSummaryUtil.headline(hours()), 'Dry for the next 12 hours.');
    });

    test('Given a likely shower at 17:00 and evening gusts, when summing up, then both are named', () {
      expect(
        WeatherSummaryUtil.headline(hours(chances: {7: 70}, gusts: {9: 46.4})),
        'Rain expected around 17:00. Gusts up to 46 km/h in the evening.',
      );
    });

    test('Given it snows now until 13:00, when summing up, then it says until when', () {
      expect(
        WeatherSummaryUtil.headline(
          hours(conditions: {0: WeatherCondition.snow, 1: WeatherCondition.snow, 2: WeatherCondition.snow}),
        ),
        'Snow until around 13:00.',
      );
    });

    test('Given a wind direction in degrees, when naming it, then it is the compass direction it comes from', () {
      expect([0, 44, 90, 168, 270, 350].map(WeatherSummaryUtil.windFrom), [
        'North',
        'Northeast',
        'East',
        'South',
        'West',
        'North',
      ]);
    });
  });
}
