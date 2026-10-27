import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_hub/domain/lights/light.service.dart';
import 'package:smart_hub/domain/lights/model/room_scene.dart';
import 'package:smart_hub/domain/lights/room_scenes.service.dart';
import 'package:smart_hub/domain/lights/model/light_state.dart';
import 'package:smart_hub/domain/lights/model/rgb_color.dart';
import 'package:smart_hub/domain/music/model/media_item.dart';
import 'package:smart_hub/domain/music/model/queue_item.dart';
import 'package:smart_hub/domain/music/model/speaker_setting.dart';
import 'package:smart_hub/domain/music/model/speaker_state.dart';
import 'package:smart_hub/domain/music/speaker_settings.service.dart';
import 'package:smart_hub/domain/music/speaker.service.dart';
import 'package:smart_hub/domain/music/spotify_connect.service.dart';

/// [LightsService] with fixed [lights] that records every command as text, e.g. `on light.desk`.
class FakeLightsService extends LightsService {
  FakeLightsService([this.lights = const []]);

  final List<LightState> lights;
  final commands = <String>[];

  @override
  Future<List<LightState>> build() async => lights;

  @override
  Future<void> setOn(List<String> ids, {required bool on}) async =>
      commands.add('${on ? 'on' : 'off'} ${ids.join(',')}');

  @override
  Future<void> setBrightness(String id, int percent) async => commands.add('brightness $id $percent');

  @override
  Future<void> setColor(String id, RgbColor color) async =>
      commands.add('color $id ${color.red},${color.green},${color.blue}');

  @override
  Future<void> setKelvin(String id, int kelvin) async => commands.add('kelvin $id $kelvin');

  @override
  Future<void> setBrightnessOf(List<String> ids, int percent) async =>
      commands.add('brightness ${ids.join(',')} $percent');

  @override
  Future<void> applyScene(List<LightState> lights, RoomScene scene) async =>
      commands.add('scene ${scene.name} ${lights.map((light) => light.id).join(',')}');
}

/// [RoomScenesService] in memory, without a database: every room starts with the templates.
class FakeRoomScenesService extends RoomScenesService {
  @override
  Future<Map<String, List<RoomScene>>> build() async => const {};

  @override
  Future<bool> addFromCurrent(String roomId, String name, List<LightState> lights) async {
    state = AsyncData({
      ...?state.value,
      roomId: [
        ...scenesOf(roomId),
        RoomScene(
          id: '$roomId/$name',
          roomId: roomId,
          name: name,
          brightnessPercent: 50,
          color: const RgbColor(255, 255, 255),
          kelvin: 3000,
        ),
      ],
    });
    return true;
  }
}

/// [SpeakersService] with fixed [speakers] that records every command as text.
class FakeSpeakersService extends SpeakersService {
  FakeSpeakersService([this.speakers = const []]);

  final List<SpeakerState> speakers;
  final commands = <String>[];

  @override
  Future<List<SpeakerState>> build() async => speakers;

  @override
  Future<void> playPause(String id) async => commands.add('playPause $id');

  @override
  Future<void> setVolume(String id, int percent) async => commands.add('volume $id $percent');

  @override
  Future<void> joinPlayingGroup(String id) async => commands.add('join $id');

  @override
  Future<void> leaveGroup(String id) async => commands.add('leave $id');

  @override
  Future<void> joinGroup(String id, String leaderId) async => commands.add('join $id to $leaderId');

  @override
  Future<void> next(String id, {QueueItem? upcoming}) async =>
      commands.add('next $id${upcoming == null ? '' : ' to ${upcoming.title}'}');

  @override
  Future<void> previous(String id) async => commands.add('previous $id');

  @override
  Future<void> play(String id, MediaItem item) async => commands.add('play ${item.title} on $id');

  @override
  Future<void> playFromQueue(String id, QueueItem item) async => commands.add('queue ${item.title} on $id');

  @override
  Future<void> move(String fromId, List<String> toIds) async => commands.add('move $fromId to ${toIds.join(',')}');
}

/// [SpeakerSettingsService] with fixed [settings] that records changes as text.
class FakeSpeakerSettingsService extends SpeakerSettingsService {
  FakeSpeakerSettingsService([this.settings = const {}]);

  final Map<String, SpeakerSetting> settings;
  final commands = <String>[];

  @override
  Stream<Map<String, SpeakerSetting>> build() => Stream.value(settings);

  @override
  Future<void> rename(String id, String? name) async => commands.add('rename $id ${name ?? '-'}');

  @override
  Future<void> setHidden(String id, {required bool hidden}) async => commands.add('${hidden ? 'hide' : 'show'} $id');

  @override
  Future<void> setDefault(String id) async => commands.add('default $id');
}

/// [SpotifyConnectService] with a fixed [state] that records every command as text.
class FakeSpotifyConnectService extends SpotifyConnectService {
  FakeSpotifyConnectService([this.initial = (devices: const [], playback: null)]);

  final SpotifyConnectState initial;
  final commands = <String>[];

  @override
  Future<SpotifyConnectState> build() async => initial;

  @override
  Future<void> play(String deviceId, MediaItem item) async => commands.add('play ${item.title} on $deviceId');

  @override
  Future<void> resume(String deviceId) async => commands.add('resume $deviceId');

  @override
  Future<void> pause(String deviceId) async => commands.add('pause $deviceId');

  @override
  Future<void> next(String deviceId, {QueueItem? upcoming}) async =>
      commands.add('next $deviceId${upcoming == null ? '' : ' to ${upcoming.title}'}');

  @override
  Future<void> previous(String deviceId) async => commands.add('previous $deviceId');

  @override
  Future<void> setVolume(String deviceId, int percent) async => commands.add('volume $deviceId $percent');

  @override
  Future<void> transfer(String deviceId) async => commands.add('transfer $deviceId');

  @override
  Future<void> skipTo(String deviceId, QueueItem item, {required int steps}) async =>
      commands.add('skip $steps to ${item.title} on $deviceId');
}
