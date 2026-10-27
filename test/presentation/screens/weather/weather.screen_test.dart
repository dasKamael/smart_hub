import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/weather/weather.service.dart';
import 'package:smart_hub/presentation/screens/weather/weather.screen.dart';

import '../../../mocks/weather.mock.dart';
import '../../../utils/widget.test_util.dart';

void main() {
  group('WeatherScreen', () {
    testWidgets('Given a forecast, when opening the weather page, then outlook, details and ten days show', (
      tester,
    ) async {
      await withClock(Clock.fixed(DateTime(2026, 10, 27, 10, 20)), () async {
        // When
        await loadWidgetTestApp(
          tester: tester,
          container: createTestContainer(
            overrides: [weatherServiceProvider.overrideWith(() => FakeWeatherService(forecast: fixtureForecast()))],
          ),
          underTestWidget: const WeatherScreen(),
        );

        // Then
        expect(find.text('Updated 10:05'), findsOneWidget);
        expect(find.text('Next 10 days'), findsOneWidget);
        expect(find.text('Dry for the next 12 hours.'), findsOneWidget);
        expect(find.text('Humidity'), findsOneWidget);
        expect(find.text('70%'), findsOneWidget);
        expect(find.text('Sunset'), findsOneWidget);
        expect(find.text('16:46'), findsOneWidget);
        expect(find.textContaining('Open-Meteo'), findsOneWidget);
      });
    });
  });
}
