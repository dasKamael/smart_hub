import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/connection/connection.service.dart';
import 'package:smart_hub/domain/connection/model/connection_config.dart';
import 'package:smart_hub/domain/connection/model/connection_status.enum.dart';
import 'package:smart_hub/domain/lights/light.service.dart';
import 'package:smart_hub/domain/music/speaker.service.dart';
import 'package:smart_hub/domain/weather/model/forecast.dart';
import 'package:smart_hub/domain/weather/weather.service.dart';
import 'package:smart_hub/domain/zen/zen.service.dart';
import 'package:smart_hub/presentation/hub_app.dart';
import 'package:smart_hub/presentation/screens/dashboard/dashboard.screen.dart';
import 'package:smart_hub/presentation/screens/music/music.screen.dart';
import 'package:smart_hub/presentation/screens/settings/settings.screen.dart';
import 'package:smart_hub/presentation/screens/setup/setup.screen.dart';

import '../mocks/connection.mock.dart';
import '../mocks/devices.mock.dart';
import '../mocks/floorplan.mock.dart';
import '../utils/widget.test_util.dart';

void main() {
  group('Hub router', () {
    late FakeConnectionConfigService service;

    Future<void> pumpApp(WidgetTester tester) async {
      useTabletSurface(tester);
      final container = createTestContainer(
        overrides: [
          connectionConfigServiceProvider.overrideWith(() => service),
          connectionStatusServiceProvider.overrideWith((ref) => Stream.value(ConnectionStatus.online)),
          hubEntitiesServiceProvider.overrideWith((ref) => Stream.value(const [])),
          lightsServiceProvider.overrideWith(FakeLightsService.new),
          speakersServiceProvider.overrideWith(FakeSpeakersService.new),
          // No idle timer: these tests are about navigation.
          zenIdleServiceProvider.overrideWith(_ZenOff.new),
          // No network or location in tests.
          weatherServiceProvider.overrideWith(_NoWeather.new),
          ...floorplanTestOverrides(),
        ],
      );
      await container.read(connectionConfigServiceProvider.future);
      await tester.pumpWidget(UncontrolledProviderScope(container: container, child: const HubApp()));
      await tester.pumpAndSettle();
    }

    testWidgets('Given no connection is configured, '
        'when the app starts, '
        'then the setup screen is shown', (tester) async {
      // Given
      service = FakeConnectionConfigService();

      // When
      await pumpApp(tester);

      // Then
      expect(find.byType(SetupScreen), findsOneWidget);
    });

    testWidgets('Given the setup screen, '
        'when the demo connects, '
        'then the dashboard is shown', (tester) async {
      // Given
      service = FakeConnectionConfigService();
      await pumpApp(tester);

      // When
      await tester.tap(find.text('Try demo'));
      await tester.pumpAndSettle();

      // Then
      expect(find.byType(DashboardScreen), findsOneWidget);
    });

    group('with a configured connection', () {
      setUp(() => service = FakeConnectionConfigService(initial: const ConnectionConfig.demo()));

      testWidgets('Given the app starts, '
          'when no location is given, '
          'then the dashboard is shown with its page title', (tester) async {
        // When
        await pumpApp(tester);

        // Then
        expect(find.byType(DashboardScreen), findsOneWidget);
        expect(find.text('Home'), findsWidgets);
      });

      testWidgets('Given the dashboard is shown, '
          'when tapping the Music tab, '
          'then the music page is shown', (tester) async {
        // Given
        await pumpApp(tester);

        // When
        await tester.tap(find.text('Music').first);
        await tester.pumpAndSettle();

        // Then
        expect(find.byType(MusicScreen), findsOneWidget);
      });

      testWidgets('Given the dashboard is shown, '
          'when opening the settings and disconnecting, '
          'then the setup screen is shown', (tester) async {
        // Given
        await pumpApp(tester);

        // When
        await tester.tap(find.bySemanticsLabel('Settings'));
        await tester.pumpAndSettle();
        expect(find.byType(SettingsScreen), findsOneWidget);
        await tester.tap(find.text('Disconnect'));
        await tester.pumpAndSettle();

        // Then
        expect(find.byType(SetupScreen), findsOneWidget);
      });
    });

    group('without Home Assistant', () {
      setUp(() => service = FakeConnectionConfigService());

      testWidgets('Given the setup screen, '
          'when starting without Home Assistant, '
          'then the dashboard is shown and lights explain what they need', (tester) async {
        // Given
        await pumpApp(tester);

        // When
        await tester.tap(find.textContaining('No Home Assistant?'));
        await tester.pumpAndSettle();
        final plan = find.byType(DashboardScreen).evaluate().length;
        await tester.tap(find.text('Lights').first);
        await tester.pumpAndSettle();

        // Then
        expect(plan, 1);
        expect(find.text('Lights need Home Assistant'), findsOneWidget);
      });

      testWidgets('Given the hub runs without Home Assistant, '
          'when tapping Connect Home Assistant on the lights page, '
          'then the setup opens and can be left again', (tester) async {
        // Given
        service = FakeConnectionConfigService(initial: const ConnectionConfig.standalone());
        await pumpApp(tester);
        await tester.tap(find.text('Lights').first);
        await tester.pumpAndSettle();

        // When
        await tester.tap(find.text('Connect Home Assistant'));
        await tester.pumpAndSettle();
        final setup = find.byType(SetupScreen).evaluate().length;
        await tester.tap(find.bySemanticsLabel('Back'));
        await tester.pumpAndSettle();

        // Then
        expect(setup, 1);
        expect(find.byType(SetupScreen), findsNothing);
        expect(find.text('Lights need Home Assistant'), findsOneWidget);
      });
    });
  });
}

class _ZenOff extends ZenIdleService {
  @override
  Stream<int> build() => Stream.value(0);
}

class _NoWeather extends WeatherService {
  @override
  Future<Forecast> build() async => throw const WeatherLocationUnavailableException();
}
