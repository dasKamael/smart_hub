import 'package:clock/clock.dart';
import 'package:ha_client/ha_client.dart';
import 'package:ha_client/testing.dart';

/// Demo home for running the app without Home Assistant: lights and speakers for the rooms of
/// `floorplan.json` that react to service calls like real devices.
FakeHomeAssistant createDemoHomeAssistant() {
  final home = FakeHomeAssistant(accessToken: demoAccessToken, states: _demoStates(clock.now().toUtc()));
  final behavior = _DemoBehavior(home);
  home.onServiceCall = behavior.handle;
  home.commandHandlers['media_player/browse_media'] = (_) => _browseRoot();
  return home;
}

/// The demo favorites as HA's media browser reports them.
Map<String, Object?> _browseRoot() {
  return {
    'title': 'Favorites',
    'media_class': 'directory',
    'media_content_type': 'favorites',
    'media_content_id': '',
    'can_play': false,
    'can_expand': true,
    'children': [
      for (final (index, playlist) in _playlists.indexed)
        {
          'title': playlist.name,
          'media_class': 'playlist',
          'media_content_type': 'playlist',
          'media_content_id': 'demo:playlist:$index',
          'can_play': true,
          'can_expand': false,
          'thumbnail': null,
        },
    ],
  };
}

const demoAccessToken = 'demo';

List<HaEntityState> _demoStates(DateTime now) {
  HaEntityState entity(String id, String state, Map<String, Object?> attributes) {
    return HaEntityState(entityId: id, state: state, attributes: attributes, lastChanged: now, lastUpdated: now);
  }

  Map<String, Object?> light(String name, List<String> modes, {int? brightness, List<int>? rgb, int? kelvin}) {
    final supportsTemp = modes.contains('color_temp');
    final isOn = brightness != null || modes.contains('onoff');
    return {
      'friendly_name': name,
      'supported_color_modes': modes,
      'color_mode': isOn ? (kelvin != null ? 'color_temp' : modes.first) : null,
      'brightness': brightness,
      'rgb_color': rgb,
      'color_temp_kelvin': kelvin,
      if (supportsTemp) 'min_color_temp_kelvin': 2000,
      if (supportsTemp) 'max_color_temp_kelvin': 6500,
    };
  }

  Map<String, Object?> speaker(
    String name, {
    required double volume,
    required List<String> group,
    int track = 0,
    int playlist = 0,
    double position = 0,
  }) {
    return {
      'friendly_name': name,
      'volume_level': volume,
      'is_volume_muted': false,
      'group_members': group,
      ..._mediaOf(track, playlist: playlist, position: position, at: now),
      'supported_features': 4127295,
    };
  }

  return [
    entity('light.office_desk', 'on', light('Desk lamp', ['color_temp', 'xy'], brightness: 204, kelvin: 3000)),
    entity('light.office_ceiling', 'off', light('Office ceiling', ['color_temp'])),
    entity('light.hall', 'off', light('Hall', ['brightness'])),
    entity('light.kitchen_counter', 'on', light('Counter strip', ['hs'], brightness: 140, rgb: [255, 159, 107])),
    entity('light.kitchen_pendant', 'off', light('Pendant', ['color_temp', 'xy'])),
    entity('light.wc', 'off', light('WC', ['onoff'])),
    entity('light.sleep_bedside', 'on', light('Bedside', ['xy', 'color_temp'], brightness: 40, rgb: [191, 90, 242])),
    entity('light.sleep_ceiling', 'off', light('Bedroom ceiling', ['brightness'])),
    entity(
      'media_player.office',
      'playing',
      speaker('Office', volume: 0.35, group: ['media_player.office', 'media_player.kitchen'], position: 74),
    ),
    entity(
      'media_player.kitchen',
      'playing',
      speaker('Kitchen', volume: 0.3, group: ['media_player.office', 'media_player.kitchen'], position: 74),
    ),
    entity(
      'media_player.sleep',
      'paused',
      speaker('Sleep', volume: 0.2, group: ['media_player.sleep'], track: 5, playlist: 5, position: 31),
    ),
    entity('sun.sun', 'above_horizon', {'friendly_name': 'Sun'}),
  ];
}

typedef _Track = ({String title, String artist, String album, int duration});

const _tracks = <_Track>[
  (title: 'Morning Light', artist: 'Lumen Quartet', album: 'Daybreak', duration: 214),
  (title: 'Slow Rivers', artist: 'Nadia Hale', album: 'Currents', duration: 241),
  (title: 'Copper Sky', artist: 'The Field Notes', album: 'Weather Report', duration: 198),
  (title: 'Weekend Drift', artist: 'Ohno Club', album: 'Saturdays', duration: 263),
  (title: 'Paper Boats', artist: 'Mira Sol', album: 'Harbor', duration: 187),
  (title: 'Late Tram', artist: 'Kessler', album: 'Night Lines', duration: 226),
];

const _playlists = <({String name, int start})>[
  (name: 'Morning Coffee', start: 4),
  (name: 'Focus Flow', start: 1),
  (name: 'Daily Mix 1', start: 2),
  (name: 'Weekend Drift', start: 3),
  (name: 'Dinner Jazz', start: 0),
  (name: 'Nightline', start: 5),
];

/// Media attributes of a speaker playing [track] of [playlist], [position] seconds in at [at].
Map<String, Object?> _mediaOf(int track, {required int playlist, required double position, required DateTime at}) {
  final current = _tracks[track % _tracks.length];
  return {
    'media_content_id': 'demo:track:${track % _tracks.length}',
    'media_content_type': 'music',
    'media_title': current.title,
    'media_artist': current.artist,
    'media_album_name': current.album,
    'media_duration': current.duration,
    'media_position': position,
    'media_position_updated_at': at.toUtc().toIso8601String(),
    'media_playlist': _playlists[playlist % _playlists.length].name,
    'demo_playlist': playlist % _playlists.length,
  };
}

/// Keys that grouped speakers share.
const _sharedMediaKeys = [
  'media_content_id',
  'media_content_type',
  'media_title',
  'media_artist',
  'media_album_name',
  'media_duration',
  'media_position',
  'media_position_updated_at',
  'media_playlist',
  'demo_playlist',
];

/// Applies service calls to the demo states the way Home Assistant would report them.
final class _DemoBehavior {
  _DemoBehavior(this.home);

  final FakeHomeAssistant home;

  Object? handle(FakeServiceCall call) {
    if ((call.domain, call.service) == ('sonos', 'get_queue')) {
      return {for (final id in call.entityIds) id: ?_queueOf(home.states[id])};
    }
    for (final id in call.entityIds) {
      final current = home.states[id];
      if (current == null) continue;
      switch ((call.domain, call.service)) {
        case ('light', 'turn_on'):
          _lightOn(current, call.data);
        case ('light', 'turn_off'):
          home.setState(id, 'off', attributes: {...current.attributes, 'brightness': null, 'color_mode': null});
        case ('light', 'toggle'):
          current.state == 'on' ? handle(_call('light', 'turn_off', id)) : _lightOn(current, const {});
        case ('media_player', 'media_play_pause'):
          _setPlayback(current, current.state == 'playing' ? 'paused' : 'playing');
        case ('media_player', 'media_play'):
          _setPlayback(current, 'playing');
        case ('media_player', 'media_pause'):
          _setPlayback(current, 'paused');
        case ('media_player', 'media_next_track'):
          _skip(current, 1);
        case ('media_player', 'media_previous_track'):
          _skip(current, -1);
        // The demo queue starts at the current track, so a place in it is that many tracks ahead.
        case ('sonos', 'play_queue'):
          _skip(current, (call.data['queue_position'] as num?)?.toInt() ?? 0);
        case ('media_player', 'volume_set'):
          final volume = (call.data['volume_level'] as num?)?.toDouble() ?? 0;
          home.setState(id, current.state, attributes: {...current.attributes, 'volume_level': volume.clamp(0, 1)});
        case ('media_player', 'join'):
          _join(current, (call.data['group_members'] as List<Object?>? ?? const []).cast<String>());
        case ('media_player', 'unjoin'):
          _unjoin(current);
        case ('media_player', 'play_media'):
          final playlist = int.tryParse('${call.data['media_content_id']}'.split(':').last) ?? 0;
          _setMedia(
            current,
            _mediaOf(_playlists[playlist].start, playlist: playlist, position: 0, at: clock.now()),
            'playing',
          );
      }
    }
    return null;
  }

  int _trackOf(HaEntityState state) => int.tryParse('${state.attributes['media_content_id']}'.split(':').last) ?? 0;

  /// The current track and the ones after it, like `sonos.get_queue` reports them.
  List<Map<String, Object?>>? _queueOf(HaEntityState? state) {
    if (state == null) return null;
    final first = _trackOf(state);
    return [
      for (var offset = 0; offset < _tracks.length; offset++)
        {
          'media_title': _tracks[(first + offset) % _tracks.length].title,
          'media_artist': _tracks[(first + offset) % _tracks.length].artist,
          'media_album_name': _tracks[(first + offset) % _tracks.length].album,
          'media_content_id': 'demo:track:${(first + offset) % _tracks.length}',
        },
    ];
  }

  /// Seconds played right now.
  double _positionOf(HaEntityState state) {
    final position = (state.attributes['media_position'] as num?)?.toDouble() ?? 0;
    final updated = DateTime.tryParse('${state.attributes['media_position_updated_at']}');
    if (state.state != 'playing' || updated == null) return position;
    return position + clock.now().difference(updated).inMilliseconds / 1000;
  }

  /// Applies [media] and [playback] to the whole group of [current].
  void _setMedia(HaEntityState current, Map<String, Object?> media, String playback) {
    for (final member in _groupOf(current)) {
      final state = home.states[member];
      if (state != null) home.setState(member, playback, attributes: {...state.attributes, ...media});
    }
  }

  FakeServiceCall _call(String domain, String service, String id) {
    return FakeServiceCall(domain: domain, service: service, entityIds: [id]);
  }

  void _lightOn(HaEntityState current, Map<String, Object?> data) {
    final modes = (current.attributes['supported_color_modes'] as List<Object?>? ?? const []).cast<String>();
    final attributes = {...current.attributes};
    if (!modes.contains('onoff')) {
      final percent = (data['brightness_pct'] as num?)?.toDouble();
      final previous = current.attributes['brightness'] as int?;
      attributes['brightness'] = percent != null ? (percent.clamp(1, 100) * 255 / 100).round() : previous ?? 255;
    }
    final rgb = data['rgb_color'];
    final kelvin = data['color_temp_kelvin'];
    if (rgb is List<Object?> && modes.any((m) => const {'hs', 'xy', 'rgb'}.contains(m))) {
      attributes['rgb_color'] = rgb.cast<int>();
      attributes['color_temp_kelvin'] = null;
      attributes['color_mode'] = modes.firstWhere((m) => const {'hs', 'xy', 'rgb'}.contains(m));
    } else if (kelvin is num && modes.contains('color_temp')) {
      attributes['color_temp_kelvin'] = kelvin.round();
      attributes['color_mode'] = 'color_temp';
    } else {
      attributes['color_mode'] ??= modes.isEmpty ? null : modes.first;
    }
    home.setState(current.entityId, 'on', attributes: attributes);
  }

  List<String> _groupOf(HaEntityState state) {
    return (state.attributes['group_members'] as List<Object?>? ?? [state.entityId]).cast<String>();
  }

  void _setPlayback(HaEntityState current, String playback) {
    // Freeze or restart the position clock, like a real player reports it.
    _setMedia(current, {
      'media_position': _positionOf(current),
      'media_position_updated_at': clock.now().toUtc().toIso8601String(),
    }, playback);
  }

  void _skip(HaEntityState current, int direction) {
    final playlist = (current.attributes['demo_playlist'] as int?) ?? 0;
    final next = _mediaOf(
      _trackOf(current) + direction + _tracks.length,
      playlist: playlist,
      position: 0,
      at: clock.now(),
    );
    _setMedia(current, next, current.state == 'idle' ? 'playing' : current.state);
  }

  void _join(HaEntityState leader, List<String> members) {
    final group = {..._groupOf(leader), ...members}.toList();
    for (final id in group) {
      final state = home.states[id];
      if (state == null) continue;
      final media = {for (final key in _sharedMediaKeys) key: leader.attributes[key]};
      home.setState(id, leader.state, attributes: {...state.attributes, ...media, 'group_members': group});
    }
  }

  void _unjoin(HaEntityState current) {
    final rest = _groupOf(current).where((id) => id != current.entityId).toList();
    for (final id in rest) {
      final state = home.states[id];
      if (state != null) home.setState(id, state.state, attributes: {...state.attributes, 'group_members': rest});
    }
    home.setState(
      current.entityId,
      'paused',
      attributes: {
        ...current.attributes,
        'group_members': [current.entityId],
      },
    );
  }
}
