import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/floorplan/model/device_kind.enum.dart';
import 'package:smart_hub/domain/floorplan/model/placement.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/domain/floorplan/floorplan.service.dart';
import 'package:smart_hub/domain/music/model/connect_device.dart';
import 'package:smart_hub/domain/music/model/playback.enum.dart';
import 'package:smart_hub/domain/music/model/speaker_setting.dart';
import 'package:smart_hub/domain/music/model/speaker_state.dart';
import 'package:smart_hub/domain/music/speaker.service.dart';
import 'package:smart_hub/domain/music/speaker_settings.service.dart';
import 'package:smart_hub/domain/music/spotify_connect.service.dart';
import 'package:smart_hub/presentation/screens/settings/speakers.controller.dart';

import '../../../mocks/devices.mock.dart';
import '../../../mocks/floorplan.mock.dart';
import '../../../utils/riverpod.test_util.dart';

void main() {
  group('SpeakersController', () {
    late FakeSpeakerSettingsService settings;

    Future<ProviderContainer> createContainer() async {
      settings = FakeSpeakerSettingsService(const {
        'media_player.office': SpeakerSetting(id: 'media_player.office', displayName: 'Study', isDefault: true),
        'spotify:Old Laptop': SpeakerSetting(id: 'spotify:Old Laptop', displayName: 'Laptop', hidden: true),
      });
      final container = createTestContainer(
        overrides: [
          speakerSettingsServiceProvider.overrideWith(() => settings),
          placementServiceProvider.overrideWith(
            () => FakePlacementService(const [
              Placement(deviceId: 'media_player.office', kind: DeviceKind.speaker, position: PlanPoint(100, 60)),
            ]),
          ),
          speakersServiceProvider.overrideWith(
            () => FakeSpeakersService(const [
              SpeakerState(id: 'media_player.office', name: 'Study', reportedName: 'Office', playback: Playback.idle),
              SpeakerState(id: 'media_player.sleep', name: 'Sleep', playback: Playback.idle),
            ]),
          ),
          spotifyConnectServiceProvider.overrideWith(
            () => FakeSpotifyConnectService((
              devices: const [
                ConnectDevice(id: 'd-office', name: 'Office', type: ConnectDeviceType.speaker),
                ConnectDevice(id: 'd-phone', name: 'Pixel 9', type: ConnectDeviceType.smartphone),
              ],
              playback: null,
            )),
          ),
        ],
      );
      container.listen(speakerEntriesProvider, (_, _) {});
      await container.read(speakerSettingsServiceProvider.future);
      await container.read(placementServiceProvider.future);
      await container.read(speakersServiceProvider.future);
      await container.read(spotifyConnectServiceProvider.future);
      return container;
    }

    test('Given speakers, open Spotify devices and a known device that is closed, '
        'when listing the entries, '
        'then speakers come first and a speaker is not listed again as Spotify device', () async {
      // Given
      final container = await createContainer();

      // When
      final entries = container.read(speakerEntriesProvider);

      // Then
      expect(
        entries.map((entry) => '${entry.source.name} ${entry.name} placed:${entry.placed} online:${entry.online}'),
        [
          'homeAssistant Study placed:true online:true',
          'homeAssistant Sleep placed:false online:true',
          'spotify Pixel 9 placed:false online:true',
          'spotify Laptop placed:false online:false',
        ],
      );
      expect(entries.first.setting.isDefault, isTrue);
      expect(entries[2].deviceType, ConnectDeviceType.smartphone);
      expect(entries.last.reportedName, 'Old Laptop');
      expect(entries.last.setting.hidden, isTrue);
    });

    test('Given open options, when changing a setting, then it is saved and the options close', () async {
      // Given
      final container = await createContainer();
      final controller = container.read(speakersControllerProvider.notifier);
      controller.toggleOptions('spotify:Pixel 9');
      expect(container.read(speakersControllerProvider), 'spotify:Pixel 9');

      // When
      controller.rename('spotify:Pixel 9', 'Phone');
      controller.setHidden('media_player.sleep', hidden: true);
      controller.setDefault('media_player.sleep');
      await Future<void>.delayed(Duration.zero);

      // Then
      expect(settings.commands, [
        'rename spotify:Pixel 9 Phone',
        'hide media_player.sleep',
        'default media_player.sleep',
      ]);
      expect(container.read(speakersControllerProvider), isNull);
    });
  });
}
