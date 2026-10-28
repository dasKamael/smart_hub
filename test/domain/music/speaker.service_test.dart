import 'dart:async';

import 'package:clock/clock.dart';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_hub/data/music/speaker.repository.dart';
import 'package:smart_hub/domain/music/model/media_item.dart';
import 'package:smart_hub/domain/music/model/playback.enum.dart';
import 'package:smart_hub/domain/music/model/queue_item.dart';
import 'package:smart_hub/domain/music/model/speaker_setting.dart';
import 'package:smart_hub/domain/music/model/speaker_state.dart';
import 'package:smart_hub/domain/music/speaker.service.dart';
import 'package:smart_hub/domain/music/speaker_settings.service.dart';

import '../../mocks/devices.mock.dart';
import '../../utils/riverpod.test_util.dart';

class _MockSpeakerRepository extends Mock implements SpeakerRepository {}

void main() {
  group('SpeakersService', () {
    late _MockSpeakerRepository repository;

    void givenSpeakers(List<SpeakerState> speakers) {
      when(() => repository.watchSpeakers()).thenAnswer((_) => Stream.value(speakers));
    }

    setUpAll(() => registerFallbackValue(const MediaItem(title: '', contentId: '', contentType: '')));

    setUp(() {
      repository = _MockSpeakerRepository();
      givenSpeakers(const []);
      when(() => repository.playPause(any())).thenAnswer((_) async {});
      when(() => repository.setVolume(any(), any())).thenAnswer((_) async {});
      when(() => repository.join(any(), any())).thenAnswer((_) async {});
      when(() => repository.leave(any())).thenAnswer((_) async {});
    });

    Future<SpeakersService> createService({Map<String, SpeakerSetting> settings = const {}}) async {
      final container = createTestContainer(
        overrides: [
          speakerRepositoryProvider.overrideWithValue(repository),
          speakerSettingsServiceProvider.overrideWith(() => FakeSpeakerSettingsService(settings)),
        ],
      );
      container.listen(speakersServiceProvider, (_, _) {});
      await container.read(speakerSettingsServiceProvider.future);
      await container.read(speakersServiceProvider.future);
      return container.read(speakersServiceProvider.notifier);
    }

    test('Given a speaker renamed in the hub, '
        'when reading the speakers, '
        'then it carries the hub name, keeps the reported name and is sorted by the hub name', () async {
      // Given
      givenSpeakers(const [
        SpeakerState(id: 'media_player.office', name: 'Office', playback: Playback.idle),
        SpeakerState(id: 'media_player.kitchen', name: 'Kitchen', playback: Playback.idle),
      ]);

      // When
      final service = await createService(
        settings: const {'media_player.office': SpeakerSetting(id: 'media_player.office', displayName: 'Study')},
      );

      // Then
      final speakers = await service.future;
      expect(speakers.map((speaker) => '${speaker.name} ${speaker.reportedName}'), ['Kitchen null', 'Study Office']);
    });

    test('Given a group is playing, '
        'when a single speaker joins, '
        'then it joins the group leader', () async {
      // Given
      givenSpeakers(const [
        SpeakerState(
          id: 'media_player.kitchen',
          name: 'Kitchen',
          playback: Playback.playing,
          groupMembers: ['media_player.office', 'media_player.kitchen'],
        ),
        SpeakerState(
          id: 'media_player.sleep',
          name: 'Sleep',
          playback: Playback.paused,
          groupMembers: ['media_player.sleep'],
        ),
      ]);
      final service = await createService();

      // When
      await service.joinPlayingGroup('media_player.sleep');

      // Then
      verify(() => repository.join('media_player.office', 'media_player.sleep')).called(1);
    });

    test('Given nothing else plays, when joining, then nothing happens', () async {
      // Given
      givenSpeakers(const [SpeakerState(id: 'media_player.sleep', name: 'Sleep', playback: Playback.paused)]);
      final service = await createService();

      // When
      await service.joinPlayingGroup('media_player.sleep');

      // Then
      verifyNever(() => repository.join(any(), any()));
    });

    test('Given a speaker, when using playback, volume and leave, then the repository is called', () async {
      // Given
      final service = await createService();

      // When
      await service.playPause('media_player.office');
      await service.setVolume('media_player.office', 120);
      await service.leaveGroup('media_player.office');

      // Then
      verify(() => repository.playPause('media_player.office')).called(1);
      verify(() => repository.setVolume('media_player.office', 100)).called(1);
      verify(() => repository.leave('media_player.office')).called(1);
    });

    group('optimistic', () {
      const office = SpeakerState(
        id: 'media_player.office',
        name: 'Office',
        playback: Playback.playing,
        volumePercent: 35,
        groupMembers: ['media_player.office', 'media_player.kitchen'],
      );
      const kitchen = SpeakerState(
        id: 'media_player.kitchen',
        name: 'Kitchen',
        playback: Playback.playing,
        volumePercent: 30,
        groupMembers: ['media_player.office', 'media_player.kitchen'],
      );

      Future<(SpeakersService, ProviderContainer)> createWithContainer() async {
        givenSpeakers(const [kitchen, office]);
        final container = createTestContainer(
          overrides: [
            speakerRepositoryProvider.overrideWithValue(repository),
            speakerSettingsServiceProvider.overrideWith(FakeSpeakerSettingsService.new),
          ],
        );
        container.listen(speakersServiceProvider, (_, _) {});
        await container.read(speakerSettingsServiceProvider.future);
        await container.read(speakersServiceProvider.future);
        return (container.read(speakersServiceProvider.notifier), container);
      }

      List<String> shown(ProviderContainer container) => [
        for (final speaker in container.read(speakersServiceProvider).value ?? const <SpeakerState>[])
          '${speaker.name} ${speaker.playback.name} ${speaker.volumePercent}',
      ];

      test(
        'Given a playing group, when pausing it, then the whole group shows paused before the speakers report it',
        () {
          fakeAsync((async) {
            // Given
            late ProviderContainer container;
            createWithContainer().then((created) => container = created.$2);
            async.flushMicrotasks();

            // When
            container.read(speakersServiceProvider.notifier).playPause('media_player.office');
            async.flushMicrotasks();

            // Then
            expect(shown(container), ['Kitchen paused 30', 'Office paused 35']);
          });
        },
      );

      test('Given a speaker that never reports the change, when 3 s pass, then the reported state shows again', () {
        fakeAsync((async) {
          // Given
          late ProviderContainer container;
          createWithContainer().then((created) => container = created.$2);
          async.flushMicrotasks();

          // When
          container.read(speakersServiceProvider.notifier).setVolume('media_player.kitchen', 60);
          async.flushMicrotasks();
          final shownAtOnce = shown(container);
          async.elapse(const Duration(seconds: 3));

          // Then
          expect(shownAtOnce, ['Kitchen playing 60', 'Office playing 35']);
          expect(shown(container), ['Kitchen playing 30', 'Office playing 35']);
        });
      });

      test('Given the office group plays, '
          'when moving it to Sleep, '
          'then Sleep shows the track at once, the group dissolves and Sleep joins before the others leave', () {
        fakeAsync((async) {
          // Given
          when(() => repository.join(any(), any())).thenAnswer((_) async {});
          when(() => repository.leave(any())).thenAnswer((_) async {});
          givenSpeakers(const [
            kitchen,
            office,
            SpeakerState(id: 'media_player.sleep', name: 'Sleep', playback: Playback.idle, volumePercent: 20),
          ]);
          final container = createTestContainer(
            overrides: [
              speakerRepositoryProvider.overrideWithValue(repository),
              speakerSettingsServiceProvider.overrideWith(FakeSpeakerSettingsService.new),
            ],
          );
          container.listen(speakersServiceProvider, (_, _) {});
          async.elapse(Duration.zero);

          // When
          container.read(speakersServiceProvider.notifier).move('media_player.office', ['media_player.sleep']);
          async.flushMicrotasks();

          // Then
          expect(shown(container), ['Kitchen paused 30', 'Office paused 35', 'Sleep playing 20']);
          verifyInOrder([
            () => repository.join('media_player.office', 'media_player.sleep'),
            () => repository.leave('media_player.kitchen'),
            () => repository.leave('media_player.office'),
          ]);
        });
      });

      test(
        'Given the next track of the queue, when skipping, then the next track shows at once on the whole group',
        () async {
          // Given
          when(() => repository.next(any())).thenAnswer((_) async {});
          final (service, container) = await createWithContainer();

          // When
          unawaited(
            service.next(
              'media_player.office',
              upcoming: const QueueItem(title: 'Slow Rivers', artist: 'Nadia Hale', coverUrl: 'https://covers/slow'),
            ),
          );

          // Then
          final speakers = container.read(speakersServiceProvider).value!;
          expect(speakers.map((speaker) => '${speaker.title} ${speaker.artworkUrl}'), [
            'Slow Rivers https://covers/slow',
            'Slow Rivers https://covers/slow',
          ]);
        },
      );

      test('Given a group at 0:10, when jumping to 1:15, then the whole group shows 1:15 at once', () async {
        // Given
        when(() => repository.seek(any(), any())).thenAnswer((_) async {});
        final (service, container) = await createWithContainer();

        // When
        await withClock(Clock.fixed(DateTime(2026)), () => service.seek('media_player.office', 75));

        // Then
        final speakers = container.read(speakersServiceProvider).value!;
        expect(speakers.map((speaker) => speaker.positionAt(DateTime(2026))), [75, 75]);
        verify(() => repository.seek('media_player.office', 75)).called(1);
      });

      test('Given a track in the queue, when playing it, then it shows at once on the whole group', () async {
        // Given
        when(() => repository.playFromQueue(any(), any())).thenAnswer((_) async {});
        final (service, container) = await createWithContainer();

        // When
        unawaited(service.playFromQueue('media_player.office', const QueueItem(title: 'Late Tram', position: 4)));

        // Then
        expect(container.read(speakersServiceProvider).value!.map((speaker) => speaker.title), [
          'Late Tram',
          'Late Tram',
        ]);
        verify(() => repository.playFromQueue('media_player.office', 4)).called(1);
      });

      test('Given a playlist, when playing it, then its name and cover show at once', () async {
        // Given
        when(() => repository.play(any(), any())).thenAnswer((_) async {});
        final (service, container) = await createWithContainer();

        // When
        unawaited(
          service.play(
            'media_player.office',
            const MediaItem(title: 'Focus Flow', contentId: 'demo:1', contentType: 'playlist', artworkUrl: 'a'),
          ),
        );

        // Then
        final office = container.read(speakersServiceProvider).value!.last;
        expect((office.title, office.artworkUrl, office.playback), ('Focus Flow', 'a', Playback.playing));
      });

      test('Given a failing command, when pausing, then playing shows again at once', () async {
        // Given
        when(() => repository.playPause(any())).thenAnswer((_) async => throw Exception('offline'));
        final (service, container) = await createWithContainer();

        // When
        await expectLater(service.playPause('media_player.office'), throwsException);

        // Then
        expect(shown(container), ['Kitchen playing 30', 'Office playing 35']);
      });
    });
  });
}
