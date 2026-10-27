import 'dart:async';

import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/domain/floorplan/floorplan.service.dart';
import 'package:smart_hub/domain/floorplan/model/placement.dart';
import 'package:smart_hub/domain/music/model/connect_device.dart';
import 'package:smart_hub/domain/music/model/speaker_setting.dart';
import 'package:smart_hub/domain/music/model/speaker_state.dart';
import 'package:smart_hub/domain/music/speaker.service.dart';
import 'package:smart_hub/domain/music/speaker_settings.service.dart';
import 'package:smart_hub/domain/music/spotify_connect.service.dart';

part 'speakers.controller.g.dart';

enum SpeakerSource { homeAssistant, spotify }

/// One row of the speaker settings: a speaker from Home Assistant or a Spotify device.
typedef SpeakerEntry = ({
  String id,
  String name,

  /// How the device is known at its source: the entity id, or the name Spotify reports.
  String reportedName,
  SpeakerSource source,
  ConnectDeviceType? deviceType,
  SpeakerSetting setting,

  /// Home Assistant speakers only: whether it stands on the floor plan.
  bool placed,

  /// Spotify devices only: Spotify is open there right now.
  bool online,
});

/// Speaker settings page: which row shows its options, and the changes.
@riverpod
class SpeakersController extends _$SpeakersController {
  static final _log = Logger('SpeakersController');

  /// Id of the row whose options are shown.
  @override
  String? build() => null;

  void toggleOptions(String id) => state = state == id ? null : id;

  void closeOptions() => state = null;

  void rename(String id, String? name) => _run('rename', _settings.rename(id, name));

  void setHidden(String id, {required bool hidden}) => _run('hide', _settings.setHidden(id, hidden: hidden));

  void setDefault(String id) => _run('set default', _settings.setDefault(id));

  SpeakerSettingsService get _settings => ref.read(speakerSettingsServiceProvider.notifier);

  void _run(String action, Future<void> command) {
    closeOptions();
    unawaited(command.catchError((Object e) => _log.warning('Could not $action: $e')));
  }
}

/// Speakers from Home Assistant first, then Spotify devices – the ones open now and the ones set up before.
@riverpod
List<SpeakerEntry> speakerEntries(Ref ref) {
  final settings = ref.watch(speakerSettingsServiceProvider).value ?? const <String, SpeakerSetting>{};
  final placed = {
    for (final placement in ref.watch(placementServiceProvider).value ?? const <Placement>[]) placement.deviceId,
  };
  final speakers = ref.watch(speakersServiceProvider).value ?? const <SpeakerState>[];
  final devices = ref.watch(spotifyConnectServiceProvider).value?.devices ?? const <ConnectDevice>[];
  final speakerNames = {
    for (final speaker in speakers) ...[speaker.name.toLowerCase(), ?speaker.reportedName?.toLowerCase()],
  };

  SpeakerSetting settingOf(String id) => settings[id] ?? SpeakerSetting(id: id);

  final spotify = <String, SpeakerEntry>{};
  for (final device in devices.where((device) => !speakerNames.contains(device.name.toLowerCase()))) {
    final id = SpeakerSettingsService.spotifyId(device.name);
    spotify[id] = (
      id: id,
      name: settingOf(id).displayName ?? device.name,
      reportedName: device.name,
      source: SpeakerSource.spotify,
      deviceType: device.type,
      setting: settingOf(id),
      placed: false,
      online: true,
    );
  }
  // Devices with settings that are not open right now.
  for (final setting in settings.values.where((setting) => setting.id.startsWith('spotify:'))) {
    final reported = setting.id.substring('spotify:'.length);
    spotify.putIfAbsent(
      setting.id,
      () => (
        id: setting.id,
        name: setting.displayName ?? reported,
        reportedName: reported,
        source: SpeakerSource.spotify,
        deviceType: null,
        setting: setting,
        placed: false,
        online: false,
      ),
    );
  }

  return [
    for (final speaker in speakers)
      (
        id: speaker.id,
        name: speaker.name,
        reportedName: speaker.id,
        source: SpeakerSource.homeAssistant,
        deviceType: null,
        setting: settingOf(speaker.id),
        placed: placed.contains(speaker.id),
        online: true,
      ),
    ...spotify.values,
  ];
}
