import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:smart_hub/data/music/sonos/sonos_speaker.repository.dart';
import 'package:smart_hub/domain/music/model/speaker_state.dart';

/// A small Sonos system: Küche (playing a stream) and Büro (paused) on their own, Wohnzimmer with a hidden sub.
class _FakeSonos {
  final calls = <String>[];
  var kitchenPlaying = true;

  static String _escape(String xml) => xml.replaceAll('&', '&amp;').replaceAll('<', '&lt;').replaceAll('>', '&gt;');

  static const _topology =
      '<ZoneGroupState><ZoneGroups>'
      '<ZoneGroup Coordinator="RINCON_K" ID="1"><ZoneGroupMember UUID="RINCON_K" Location="http://10.0.0.24:1400/xml/device_description.xml" ZoneName="K&#252;che"/></ZoneGroup>'
      '<ZoneGroup Coordinator="RINCON_B" ID="2"><ZoneGroupMember UUID="RINCON_B" Location="http://10.0.0.25:1400/xml/device_description.xml" ZoneName="Büro"/></ZoneGroup>'
      '<ZoneGroup Coordinator="RINCON_W" ID="3"><ZoneGroupMember UUID="RINCON_W" Location="http://10.0.0.26:1400/xml/device_description.xml" ZoneName="Wohnzimmer"/>'
      '<ZoneGroupMember UUID="RINCON_SUB" Location="http://10.0.0.27:1400/xml/device_description.xml" ZoneName="Wohnzimmer" Invisible="1"/></ZoneGroup>'
      '</ZoneGroups></ZoneGroupState>';

  Future<http.Response> handle(http.Request request) async {
    final action = request.headers['SOAPACTION']!.split('#').last.replaceAll('"', '');
    final host = request.url.host;
    calls.add(
      '$host $action${action == 'SetVolume' ? ' ${RegExp('<DesiredVolume>(.*?)<').firstMatch(request.body)!.group(1)}' : ''}',
    );
    final body = switch (action) {
      'GetZoneGroupState' => '<ZoneGroupState>${_escape(_topology)}</ZoneGroupState>',
      'GetTransportInfo' => switch (host) {
        '10.0.0.24' =>
          '<CurrentTransportState>${kitchenPlaying ? 'PLAYING' : 'PAUSED_PLAYBACK'}</CurrentTransportState>',
        '10.0.0.25' => '<CurrentTransportState>PAUSED_PLAYBACK</CurrentTransportState>',
        _ => '<CurrentTransportState>STOPPED</CurrentTransportState>',
      },
      'GetPositionInfo' when host == '10.0.0.24' =>
        '<TrackDuration>0:03:01</TrackDuration><RelTime>0:01:04</RelTime><TrackMetaData>${_escape('<DIDL-Lite><item><dc:title>Take U There</dc:title><dc:creator>Cramoki</dc:creator><upnp:albumArtURI>/getaa?s=1&amp;u=x</upnp:albumArtURI></item></DIDL-Lite>')}</TrackMetaData>',
      'GetPositionInfo' => '<TrackDuration>NOT_IMPLEMENTED</TrackDuration><RelTime>NOT_IMPLEMENTED</RelTime><TrackMetaData></TrackMetaData>',
      'GetVolume' => '<CurrentVolume>${host == '10.0.0.24' ? 30 : 20}</CurrentVolume>',
      _ => '',
    };
    // Like the speakers, in UTF-8.
    return http.Response.bytes(utf8.encode('<s:Envelope><s:Body>$body</s:Body></s:Envelope>'), 200);
  }
}

void main() {
  group('SonosSpeakerRepository', () {
    late _FakeSonos sonos;
    late SonosSpeakerRepository repository;

    Future<List<SpeakerState>> firstRead() => repository.watchSpeakers().firstWhere((speakers) => speakers.isNotEmpty);

    setUp(() {
      sonos = _FakeSonos();
      repository = SonosSpeakerRepository(
        hosts: const ['10.0.0.24'],
        client: MockClient(sonos.handle),
        interval: const Duration(hours: 1),
      );
      addTearDown(repository.dispose);
    });

    test(
      'Given a system of three rooms and a hidden sub, when reading, then each room is a speaker with its state',
      () async {
        // When
        final speakers = await firstRead();

        // Then
        expect(speakers.map((speaker) => '${speaker.name} ${speaker.playback.name} ${speaker.volumePercent}'), [
          'Küche playing 30',
          'Büro paused 20',
          'Wohnzimmer idle 20',
        ]);
        final kitchen = speakers.first;
        expect(
          (kitchen.title, kitchen.artist, kitchen.durationSeconds, kitchen.positionSeconds),
          ('Take U There', 'Cramoki', 181, 64.0),
        );
        expect(kitchen.artworkUrl, 'http://10.0.0.24:1400/getaa?s=1&u=x');
        expect(await repository.watchOnline().firstWhere((online) => online), isTrue);
      },
    );

    test(
      'Given the kitchen plays, when pausing it and setting the office volume, then the right speakers get it',
      () async {
        // Given
        await firstRead();
        sonos.calls.clear();

        // When
        await repository.playPause('RINCON_K');
        await repository.setVolume('RINCON_B', 45);

        // Then
        expect(sonos.calls, containsAllInOrder(['10.0.0.24 Pause', '10.0.0.25 SetVolume 45']));
      },
    );

    test(
      'Given two single rooms, when the office joins the kitchen and leaves again, then the office is told so',
      () async {
        // Given
        await firstRead();
        sonos.calls.clear();

        // When
        await repository.join('RINCON_K', 'RINCON_B');
        await repository.leave('RINCON_B');

        // Then
        expect(
          sonos.calls,
          containsAllInOrder(['10.0.0.25 SetAVTransportURI', '10.0.0.25 BecomeCoordinatorOfStandaloneGroup']),
        );
      },
    );

    test('Given a group state with a group of two, when parsing, then the coordinator leads it', () {
      // When
      final groups = SonosSpeakerRepository.parseGroups(
        '<ZoneGroup Coordinator="RINCON_K" ID="1">'
        '<ZoneGroupMember UUID="RINCON_B" Location="http://10.0.0.25:1400/x" ZoneName="Büro"/>'
        '<ZoneGroupMember UUID="RINCON_K" Location="http://10.0.0.24:1400/x" ZoneName="Küche"/></ZoneGroup>',
      );

      // Then
      expect(groups.single.coordinator, 'RINCON_K');
      expect(groups.single.members.map((member) => '${member.name} ${member.host}'), [
        'Büro 10.0.0.25',
        'Küche 10.0.0.24',
      ]);
    });
  });
}
