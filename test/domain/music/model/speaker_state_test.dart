import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/music/model/playback.enum.dart';
import 'package:smart_hub/domain/music/model/speaker_state.dart';

void main() {
  group('SpeakerState.positionAt', () {
    final updated = DateTime.utc(2026, 10, 26, 9);
    SpeakerState speaker(Playback playback) => SpeakerState(
      id: 'media_player.office',
      name: 'Office',
      playback: playback,
      durationSeconds: 200,
      positionSeconds: 60,
      positionUpdatedAt: updated,
    );

    test('Given a playing track, when time passes, then the position runs on', () {
      expect(speaker(Playback.playing).positionAt(updated.add(const Duration(seconds: 15))), 75);
    });

    test('Given a paused track, when time passes, then the position stays', () {
      expect(speaker(Playback.paused).positionAt(updated.add(const Duration(seconds: 15))), 60);
    });

    test('Given a playing track near its end, when time passes, then the position stops at the length', () {
      expect(speaker(Playback.playing).positionAt(updated.add(const Duration(minutes: 10))), 200);
    });

    test('Given no position, when asking, then there is none', () {
      expect(const SpeakerState(id: 'x', name: 'X', playback: Playback.idle).positionAt(updated), isNull);
    });

    test('Given a group, when asking for the leader, then it is the first member', () {
      const grouped = SpeakerState(
        id: 'media_player.kitchen',
        name: 'Kitchen',
        playback: Playback.playing,
        groupMembers: ['media_player.office', 'media_player.kitchen'],
      );

      expect(grouped.leaderId, 'media_player.office');
      expect(const SpeakerState(id: 'x', name: 'X', playback: Playback.idle).leaderId, 'x');
    });
  });
}
