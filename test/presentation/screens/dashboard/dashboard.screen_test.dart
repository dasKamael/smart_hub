import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/data/dashboard/dashboard_layout.repository.dart';
import 'package:smart_hub/data/database/app_database.dart';
import 'package:smart_hub/domain/dashboard/dashboard_layout.service.dart';
import 'package:smart_hub/domain/dashboard/model/dashboard_widget.dart';
import 'package:smart_hub/domain/lights/light.service.dart';
import 'package:smart_hub/domain/lights/model/light_state.dart';
import 'package:smart_hub/domain/music/model/playback.enum.dart';
import 'package:smart_hub/domain/music/model/speaker_state.dart';
import 'package:smart_hub/domain/music/speaker.service.dart';
import 'package:smart_hub/domain/music/speaker_settings.service.dart';
import 'package:smart_hub/domain/plants/model/plant.dart';
import 'package:smart_hub/domain/weather/weather.service.dart';
import 'package:smart_hub/presentation/screens/dashboard/dashboard.screen.dart';
import 'package:smart_hub/presentation/screens/weather/widgets/weather_widget.dart';

import '../../../mocks/devices.mock.dart';
import '../../../mocks/floorplan.mock.dart';
import '../../../mocks/weather.mock.dart';
import '../../../utils/widget.test_util.dart';

void main() {
  group('DashboardScreen', () {
    late ProviderContainer container;

    Future<void> pumpScreen(WidgetTester tester) async {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      container = createTestContainer(
        overrides: [
          ...floorplanWidgetTestOverrides(
            FakePlacementService(),
            plants: FakePlantsService([
              Plant(id: 'p.fern', name: 'Fern', everyDays: 2, lastWatered: DateTime(2026, 10, 20)),
            ]),
          ),
          lightsServiceProvider.overrideWith(
            () => FakeLightsService(const [
              LightState(id: 'light.desk', name: 'Desk', isOn: true),
              LightState(id: 'light.hall', name: 'Hall', isOn: true),
              LightState(id: 'light.wc', name: 'WC', isOn: false),
            ]),
          ),
          speakersServiceProvider.overrideWith(
            () => FakeSpeakersService(const [
              SpeakerState(
                id: 'media_player.office',
                name: 'Office',
                playback: Playback.playing,
                groupMembers: ['media_player.office'],
              ),
            ]),
          ),
          speakerSettingsServiceProvider.overrideWith(FakeSpeakerSettingsService.new),
          weatherServiceProvider.overrideWith(() => FakeWeatherService(forecast: fixtureForecast())),
          dashboardLayoutRepositoryProvider.overrideWithValue(DashboardLayoutRepository(database: database)),
        ],
      );
      await loadWidgetTestApp(tester: tester, container: container, underTestWidget: const DashboardScreen());
    }

    List<String> layout() => [
      for (final widget in container.read(dashboardLayoutServiceProvider).value ?? const <DashboardWidget>[])
        '${widget.id} ${widget.size.name}',
    ];

    Future<void> startEditing(WidgetTester tester) async {
      await tester.longPress(find.text('Home').first);
      await tester.pump(const Duration(milliseconds: 500));
    }

    /// Ends editing, so the jiggle stops and the test can settle.
    Future<void> stopEditing(WidgetTester tester) async {
      await tester.tap(find.text('Done'));
      await tester.pumpAndSettle();
    }

    testWidgets('Given lights on, an overdue plant and a playing group, '
        'when opening the dashboard, '
        'then the Home widget sums them up next to the weather', (tester) async {
      // When
      await pumpScreen(tester);

      // Then
      expect(find.text('2 on'), findsOneWidget);
      expect(find.text('1 overdue'), findsOneWidget);
      expect(find.text('Office'), findsOneWidget);
      expect(find.text('Mainz'), findsOneWidget);
    });

    testWidgets('Given the dashboard, when long pressing and removing the home widget, then it is gone', (
      tester,
    ) async {
      // Given
      await pumpScreen(tester);

      // When
      await startEditing(tester);
      final editing = find.text('Done').evaluate().length;
      await tester.tap(find.bySemanticsLabel('Remove Home'));
      await tester.pump(const Duration(milliseconds: 500));
      await stopEditing(tester);

      // Then
      expect(editing, 1);
      expect(layout(), ['weather-1 extraLarge', 'weather-2 medium']);
    });

    testWidgets('Given editing, when dragging the small weather to the top left, then the others make room', (
      tester,
    ) async {
      // Given
      await pumpScreen(tester);
      await startEditing(tester);
      const step = DashboardScreen.step;

      // When: from the middle of weather-2 (column 4, row 1) to the top left corner.
      final gesture = await tester.startGesture(tester.getCenter(find.byType(WeatherWidget).last));
      for (var i = 0; i < 20; i++) {
        await gesture.moveBy(const Offset(-4 * step / 20, -step / 20));
        await tester.pump(const Duration(milliseconds: 16));
      }
      await gesture.up();
      await tester.pump(const Duration(milliseconds: 500));
      await stopEditing(tester);

      // Then
      expect(layout(), ['weather-2 medium', 'weather-1 extraLarge', 'home-1 medium']);
    });

    testWidgets('Given editing, when dragging the corner of the big weather to half its width, then it is large', (
      tester,
    ) async {
      // Given
      await pumpScreen(tester);
      await startEditing(tester);

      // When
      final grip = find.bySemanticsLabel('Resize').first;
      await tester.drag(grip, const Offset(-2 * DashboardScreen.step, 0));
      await tester.pump(const Duration(milliseconds: 500));
      await stopEditing(tester);

      // Then
      expect(layout().first, 'weather-1 large');
    });

    testWidgets('Given room in the last row, when adding a small weather from the gallery, then it is added', (
      tester,
    ) async {
      // Given
      await pumpScreen(tester);
      await startEditing(tester);

      // When
      await tester.tap(find.text('Add widget'));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.tap(find.text('Add Widget'));
      await tester.pump(const Duration(milliseconds: 500));
      await stopEditing(tester);

      // Then
      expect(layout().last, endsWith('small'));
      expect(layout(), hasLength(4));
    });
  });
}
