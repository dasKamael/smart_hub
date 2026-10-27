import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/weather/weather.service.dart';
import 'package:smart_hub/presentation/design_system/layouts/widget_tile.dart';
import 'package:smart_hub/presentation/screens/weather/widgets/weather_widget.dart';

import '../../../mocks/weather.mock.dart';
import '../../../utils/widget.test_util.dart';

void main() {
  group('WeatherWidget', () {
    late ProviderContainer container;

    Future<void> pumpWidget(WidgetTester tester, WidgetSize size, {FakeWeatherService? service}) async {
      container = createTestContainer(
        overrides: [
          weatherServiceProvider.overrideWith(() => service ?? FakeWeatherService(forecast: fixtureForecast())),
        ],
      );
      await loadWidgetTestApp(
        tester: tester,
        container: container,
        underTestWidget: Center(child: WeatherWidget(size: size)),
      );
    }

    testWidgets('Given a forecast, when showing it extra large, then now, the place, hours and five days show', (
      tester,
    ) async {
      await withClock(Clock.fixed(DateTime(2026, 10, 27, 10, 20)), () async {
        // When
        await pumpWidget(tester, WidgetSize.extraLarge);

        // Then
        expect(find.text('10°'), findsWidgets);
        expect(find.text('Mainz'), findsOneWidget);
        expect(find.text('Partly cloudy · Feels 8°'), findsOneWidget);
        expect(find.text('Now'), findsOneWidget);
        expect(find.text('Today'), findsOneWidget);
        expect(find.text('Wed'), findsOneWidget);
        expect(find.text('63%'), findsOneWidget);
      });
    });

    testWidgets('Given a forecast, when showing it small, then the condition and today\'s range show', (tester) async {
      // When
      await pumpWidget(tester, WidgetSize.small);

      // Then
      expect(find.text('Partly cloudy'), findsOneWidget);
      expect(find.text('15° / 7° · Rain 15%'), findsOneWidget);
    });

    testWidgets('Given the location is unknown, when showing the widget, then it asks for a place', (tester) async {
      // When
      await pumpWidget(tester, WidgetSize.large, service: FakeWeatherService());

      // Then
      expect(find.text('Where is the hub?'), findsOneWidget);
      expect(find.text('Choose a place'), findsOneWidget);
    });

    testWidgets('Given no connection, when showing the widget, then it says the weather is not available', (
      tester,
    ) async {
      // When
      await pumpWidget(tester, WidgetSize.medium, service: FakeWeatherService(error: Exception('offline')));

      // Then
      expect(find.text('Weather not available'), findsOneWidget);
      expect(find.text('Choose a place'), findsNothing);
      container.dispose(); // stops the retry timer of the failed load
    });
  });
}
