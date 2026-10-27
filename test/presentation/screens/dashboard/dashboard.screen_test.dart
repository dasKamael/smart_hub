import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/lights/light.service.dart';
import 'package:smart_hub/domain/lights/model/light_state.dart';
import 'package:smart_hub/domain/music/model/playback.enum.dart';
import 'package:smart_hub/domain/music/model/speaker_state.dart';
import 'package:smart_hub/domain/music/speaker.service.dart';
import 'package:smart_hub/domain/music/speaker_settings.service.dart';
import 'package:smart_hub/domain/plants/model/plant.dart';
import 'package:smart_hub/domain/weather/weather.service.dart';
import 'package:smart_hub/presentation/screens/dashboard/dashboard.screen.dart';

import '../../../mocks/devices.mock.dart';
import '../../../mocks/floorplan.mock.dart';
import '../../../mocks/weather.mock.dart';
import '../../../utils/widget.test_util.dart';

void main() {
  group('DashboardScreen', () {
    testWidgets('Given lights on, an overdue plant and a playing group, '
        'when opening the dashboard, '
        'then the Home widget sums them up next to the weather', (tester) async {
      // When
      await loadWidgetTestApp(
        tester: tester,
        container: createTestContainer(
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
          ],
        ),
        underTestWidget: const DashboardScreen(),
      );

      // Then
      expect(find.text('2 on'), findsOneWidget);
      expect(find.text('1 overdue'), findsOneWidget);
      expect(find.text('Office'), findsOneWidget);
      expect(find.text('Mainz'), findsOneWidget);
    });
  });
}
