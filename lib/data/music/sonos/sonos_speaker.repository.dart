import 'dart:async';

import 'package:clock/clock.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:smart_hub/data/music/sonos/sonos_soap.dart';
import 'package:smart_hub/data/music/speaker.repository.dart';
import 'package:smart_hub/domain/music/model/media_item.dart';
import 'package:smart_hub/domain/music/model/playback.enum.dart';
import 'package:smart_hub/domain/music/model/queue_item.dart';
import 'package:smart_hub/domain/music/model/speaker_state.dart';

/// Sonos speakers controlled directly in the home network – no Home Assistant, no cloud, no Sonos app.
///
/// Reads the groups from any of [hosts], then each group's playback from its coordinator and each speaker's volume,
/// every [interval]; a command is followed by a read at once. Speaker ids are the speakers' own ids (`RINCON_…`).
class SonosSpeakerRepository implements SpeakerRepository {
  SonosSpeakerRepository({
    required this.hosts,
    required this.client,
    this.interval = const Duration(milliseconds: 1500),
  });

  static final _log = Logger('SonosSpeakerRepository');

  final List<String> hosts;
  final http.Client client;
  final Duration interval;

  final _speakers = StreamController<List<SpeakerState>>.broadcast();
  final _online = StreamController<bool>.broadcast();

  /// The speakers as last read, and where each one is.
  var _latest = const <SpeakerState>[];
  final _hostOf = <String, String>{};
  final _coordinatorOf = <String, String>{};
  final _playingOf = <String, bool>{};

  var _isOnline = false;
  var _started = false;
  var _disposed = false;
  var _reading = false;
  Timer? _timer;

  @override
  Stream<List<SpeakerState>> watchSpeakers() async* {
    _start();
    if (_latest.isNotEmpty) yield _latest;
    yield* _speakers.stream;
  }

  @override
  Stream<bool> watchOnline() async* {
    _start();
    yield _isOnline;
    yield* _online.stream;
  }

  @override
  Future<void> playPause(String id) {
    final coordinator = _coordinator(id);
    return _command(
      () => _playingOf[coordinator] == true
          ? _soap(coordinator).avTransport('Pause')
          : _soap(coordinator).avTransport('Play', {'Speed': '1'}),
    );
  }

  @override
  Future<void> next(String id) => _command(() => _soap(_coordinator(id)).avTransport('Next'));

  @override
  Future<void> previous(String id) => _command(() => _soap(_coordinator(id)).avTransport('Previous'));

  @override
  Future<void> setVolume(String id, int percent) {
    return _command(() => _soap(id).renderingControl('SetVolume', {'DesiredVolume': '${percent.clamp(0, 100)}'}));
  }

  @override
  Future<void> join(String leaderId, String memberId) {
    return _command(
      () => _soap(memberId).avTransport('SetAVTransportURI', {
        'CurrentURI': 'x-rincon:${_coordinator(leaderId)}',
        'CurrentURIMetaData': '',
      }),
    );
  }

  @override
  Future<void> leave(String id) => _command(() => _soap(id).avTransport('BecomeCoordinatorOfStandaloneGroup'));

  /// The group's queue; `null` while it plays a stream without one (e.g. music sent from a phone).
  @override
  Future<List<QueueItem>?> queue(String id) async {
    final soap = _soap(_coordinator(id));
    final media = await soap.avTransport('GetMediaInfo');
    if (!(SonosSoap.value(media, 'CurrentURI') ?? '').startsWith('x-rincon-queue:')) return null;
    final reply = await soap.contentDirectory('Browse', {
      'ObjectID': 'Q:0',
      'BrowseFlag': 'BrowseDirectChildren',
      'Filter': '*',
      'StartingIndex': '0',
      'RequestedCount': '100',
      'SortCriteria': '',
    });
    final didl = SonosSoap.value(reply, 'Result') ?? '';
    return [
      for (final (position, item) in RegExp(r'<item .*?</item>', dotAll: true).allMatches(didl).indexed)
        QueueItem(
          position: position,
          title: SonosSoap.value(item.group(0)!, 'dc:title') ?? 'Unknown',
          artist: SonosSoap.value(item.group(0)!, 'dc:creator'),
          artworkUrl: _artwork(soap.host, SonosSoap.value(item.group(0)!, 'upnp:albumArtURI')),
          coverUrl: _artwork(soap.host, SonosSoap.value(item.group(0)!, 'upnp:albumArtURI')),
        ),
    ];
  }

  @override
  Future<void> playFromQueue(String id, int position) {
    final soap = _soap(_coordinator(id));
    return _command(() async {
      await soap.avTransport('Seek', {'Unit': 'TRACK_NR', 'Target': '${position + 1}'});
      await soap.avTransport('Play', {'Speed': '1'});
    });
  }

  /// Favorites are made in the speakers' own app; without it there are none.
  @override
  Future<List<MediaItem>> favorites(String id) async => const [];

  @override
  Future<void> play(String id, MediaItem item) =>
      Future.error(UnsupportedError('Starting ${item.title} on the speaker directly is not possible yet'));

  void dispose() {
    _disposed = true;
    _timer?.cancel();
    unawaited(_speakers.close());
    unawaited(_online.close());
  }

  void _start() {
    if (_started) return;
    _started = true;
    unawaited(_read());
    _timer = Timer.periodic(interval, (_) => unawaited(_read()));
  }

  Future<void> _command(Future<void> Function() call) async {
    await call();
    unawaited(_read());
  }

  SonosSoap _soap(String id) {
    final host = _hostOf[id];
    if (host == null) throw SonosException('Unknown speaker $id');
    return SonosSoap(host: host, client: client);
  }

  String _coordinator(String id) => _coordinatorOf[id] ?? id;

  Future<void> _read() async {
    if (_reading || _disposed) return;
    _reading = true;
    try {
      final groups = await _groups();
      final speakers = <SpeakerState>[];
      await Future.wait([
        for (final group in groups)
          () async {
            final coordinator = group.members.firstWhere((member) => member.id == group.coordinator);
            final soap = SonosSoap(host: coordinator.host, client: client);
            final (transport, position) = await (
              soap.avTransport('GetTransportInfo'),
              soap.avTransport('GetPositionInfo'),
            ).wait;
            final volumes = await Future.wait([
              for (final member in group.members)
                SonosSoap(host: member.host, client: client).renderingControl('GetVolume'),
            ]);
            final playback = switch (SonosSoap.value(transport, 'CurrentTransportState')) {
              'PLAYING' || 'TRANSITIONING' => Playback.playing,
              'PAUSED_PLAYBACK' => Playback.paused,
              _ => Playback.idle,
            };
            _playingOf[group.coordinator] = playback == Playback.playing;
            final track = SonosSoap.value(position, 'TrackMetaData') ?? '';
            final now = clock.now();
            for (final (index, member) in group.members.indexed) {
              speakers.add(
                SpeakerState(
                  id: member.id,
                  name: member.name,
                  playback: playback,
                  volumePercent: int.tryParse(SonosSoap.value(volumes[index], 'CurrentVolume') ?? '') ?? 0,
                  // The coordinator first: it leads the group.
                  groupMembers: [
                    group.coordinator,
                    for (final other in group.members)
                      if (other.id != group.coordinator) other.id,
                  ],
                  title: SonosSoap.value(track, 'dc:title'),
                  artist: SonosSoap.value(track, 'dc:creator'),
                  album: SonosSoap.value(track, 'upnp:album'),
                  artworkUrl: _artwork(coordinator.host, SonosSoap.value(track, 'upnp:albumArtURI')),
                  durationSeconds: SonosSoap.seconds(SonosSoap.value(position, 'TrackDuration')),
                  positionSeconds: SonosSoap.seconds(SonosSoap.value(position, 'RelTime'))?.toDouble(),
                  positionUpdatedAt: now,
                ),
              );
            }
          }(),
      ]);
      if (_disposed) return;
      _latest = speakers;
      _speakers.add(speakers);
      _setOnline(true);
    } on Object catch (e) {
      _log.warning('Could not read the speakers: $e');
      _setOnline(false);
    } finally {
      _reading = false;
    }
  }

  /// The groups as the system reports them, from the first speaker that answers. Hidden members (e.g. a sub) are
  /// left out.
  Future<List<({String coordinator, List<({String id, String name, String host})> members})>> _groups() async {
    Object? lastError;
    for (final host in [
      ...{..._hostOf.values, ...hosts},
    ]) {
      try {
        final reply = await SonosSoap(host: host, client: client).zoneGroupTopology('GetZoneGroupState');
        final groups = parseGroups(SonosSoap.value(reply, 'ZoneGroupState') ?? '');
        for (final group in groups) {
          for (final member in group.members) {
            _hostOf[member.id] = member.host;
            _coordinatorOf[member.id] = group.coordinator;
          }
        }
        return groups;
      } on Object catch (e) {
        lastError = e;
      }
    }
    throw SonosException('No speaker answers: $lastError');
  }

  /// The groups of a `ZoneGroupState` document.
  static List<({String coordinator, List<({String id, String name, String host})> members})> parseGroups(String state) {
    String? attribute(String tag, String name) => RegExp('$name="([^"]*)"').firstMatch(tag)?.group(1);
    return [
      for (final group in RegExp(r'<ZoneGroup (.*?)</ZoneGroup>', dotAll: true).allMatches(state))
        if (attribute(group.group(1)!, 'Coordinator') case final coordinator?)
          (
            coordinator: coordinator,
            members: [
              for (final member in RegExp(r'<ZoneGroupMember [^>]*>').allMatches(group.group(1)!))
                if (attribute(member.group(0)!, 'Invisible') != '1')
                  if ((
                        attribute(member.group(0)!, 'UUID'),
                        attribute(member.group(0)!, 'ZoneName'),
                        RegExp(r'Location="http://([\d.]+):').firstMatch(member.group(0)!)?.group(1),
                      )
                      case (final id?, final name?, final host?))
                    (id: id, name: SonosSoap.unescape(name), host: host),
            ],
          ),
    ].where((group) => group.members.any((member) => member.id == group.coordinator)).toList();
  }

  void _setOnline(bool online) {
    if (online == _isOnline || _disposed) return;
    _isOnline = online;
    _online.add(online);
  }

  static String? _artwork(String host, String? uri) {
    if (uri == null || uri.isEmpty) return null;
    return uri.startsWith('http') ? uri : 'http://$host:1400$uri';
  }
}
