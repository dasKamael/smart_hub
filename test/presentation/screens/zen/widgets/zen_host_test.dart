import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/common/utils/current_day.provider.dart';
import 'package:smart_hub/domain/connection/connection.service.dart';
import 'package:smart_hub/domain/focus/focus.service.dart';
import 'package:smart_hub/domain/focus/model/focus_point.dart';
import 'package:smart_hub/domain/connection/model/connection_config.dart';
import 'package:smart_hub/domain/connection/model/connection_status.enum.dart';
import 'package:smart_hub/domain/music/model/playback.enum.dart';
import 'package:smart_hub/domain/music/model/speaker_state.dart';
import 'package:smart_hub/domain/music/speaker.service.dart';
import 'package:smart_hub/domain/music/speaker_settings.service.dart';
import 'package:smart_hub/domain/music/spotify_connect.service.dart';
import 'package:smart_hub/domain/zen/zen.service.dart';
import 'package:smart_hub/presentation/screens/zen/widgets/zen_host.dart';
import 'package:smart_hub/presentation/screens/zen/zen.screen.dart';

import '../../../../mocks/connection.mock.dart';
import '../../../../mocks/devices.mock.dart';
import '../../../../utils/widget.test_util.dart';

/// Instead of `pumpAndSettle`, which never ends while the record turns with the music: past the zen mode's fades, then
/// one more frame for what arrived meanwhile (e.g. the connection status).
Future<void> _settle(WidgetTester tester) async {
  await tester.pump(const Duration(seconds: 3));
  await tester.pump();
}

void main() {
  group('ZenHost', () {
    late FakeSpeakersService speakers;
    late ProviderContainer container;

    Future<void> pumpHost(
      WidgetTester tester, {
      ConnectionConfig? config = const ConnectionConfig.demo(),
      List<FocusPoint> focusPoints = const [],
    }) async {
      speakers = FakeSpeakersService(const [
        SpeakerState(
          id: 'media_player.office',
          name: 'Office',
          playback: Playback.playing,
          groupMembers: ['media_player.office'],
          title: 'Morning Light',
          artist: 'Lumen Quartet',
        ),
      ]);
      container = createTestContainer(
        overrides: [
          connectionConfigServiceProvider.overrideWith(() => FakeConnectionConfigService(initial: config)),
          connectionStatusServiceProvider.overrideWith((ref) => Stream.value(ConnectionStatus.online)),
          zenIdleServiceProvider.overrideWith(_OneMinute.new),
          speakersServiceProvider.overrideWith(() => speakers),
          speakerSettingsServiceProvider.overrideWith(FakeSpeakerSettingsService.new),
          spotifyConnectServiceProvider.overrideWith(FakeSpotifyConnectService.new),
          focusServiceProvider.overrideWith(() => _Focus(focusPoints)),
          currentDayProvider.overrideWith((ref) => Stream.value(DateTime(2026, 10, 26))),
        ],
      );
      await loadWidgetTestApp(
        tester: tester,
        container: container,
        underTestWidget: const ZenHost(child: Center(child: Text('Hub'))),
      );
    }

    testWidgets('Given one minute idle time, '
        'when nobody touches the hub for a minute, '
        'then the zen mode shows the time and what plays', (tester) async {
      await withClock(Clock.fixed(DateTime(2026, 10, 26, 14, 5)), () async {
        // Given
        await pumpHost(tester);

        // When
        await tester.pump(const Duration(minutes: 1));
        await _settle(tester);

        // Then
        expect(find.byType(ZenScreen), findsOneWidget);
        expect(find.text('14:05'), findsOneWidget);
        expect(find.text('Monday, 26 October'), findsOneWidget);
        expect(find.text('Morning Light'), findsOneWidget);
      });
    });

    testWidgets('Given the zen mode, when tapping play / pause, then it plays on and stays', (tester) async {
      // Given
      await pumpHost(tester);
      await tester.pump(const Duration(minutes: 1));
      await _settle(tester);

      // When
      await tester.tap(find.bySemanticsLabel('Pause'));
      await _settle(tester);

      // Then
      expect(speakers.commands, ['playPause media_player.office']);
      expect(find.byType(ZenScreen), findsOneWidget);
    });

    testWidgets('Given the zen mode, when tapping next, then the next track is asked for and it stays', (tester) async {
      // Given
      await pumpHost(tester);
      await tester.pump(const Duration(minutes: 1));
      await _settle(tester);

      // When
      await tester.tap(find.bySemanticsLabel('Next'));
      await tester.pump();

      // Then
      expect(speakers.commands, ['next media_player.office']);
      expect(find.byType(ZenScreen), findsOneWidget);
    });

    testWidgets('Given the zen mode, when tapping anywhere else, then the hub shows again', (tester) async {
      // Given
      await pumpHost(tester);
      await tester.pump(const Duration(minutes: 1));
      await _settle(tester);

      // When
      await tester.tapAt(const Offset(1200, 60));
      await _settle(tester);

      // Then
      expect(find.byType(ZenScreen), findsNothing);
      container.dispose(); // stops the idle timer that started over
    });

    testWidgets('Given touches every half minute, when two minutes pass, then the zen mode does not start', (
      tester,
    ) async {
      // Given
      await pumpHost(tester);

      // When
      for (var i = 0; i < 4; i++) {
        await tester.pump(const Duration(seconds: 30));
        await tester.tap(find.text('Hub'));
      }
      await tester.pump();

      // Then
      expect(find.byType(ZenScreen), findsNothing);
      container.dispose(); // stops the idle timer
    });

    testWidgets('Given the hub is not set up, when idle, then no zen mode', (tester) async {
      // Given
      await pumpHost(tester, config: null);

      // When
      await tester.pump(const Duration(minutes: 2));
      await tester.pump();

      // Then
      expect(find.byType(ZenScreen), findsNothing);
    });

    testWidgets('Given a focus point, '
        'when the zen mode shows, '
        'then it stands under the clock', (tester) async {
      await withClock(Clock.fixed(DateTime(2026, 10, 26, 14, 5)), () async {
        // Given
        await pumpHost(
          tester,
          focusPoints: [
            FocusPoint(
              id: 'f1',
              title: 'Hub on the wall',
              dueDate: DateTime(2026, 11, 4),
              createdAt: DateTime(2026, 10, 15),
            ),
          ],
        );

        // When
        await tester.pump(const Duration(minutes: 1));
        await _settle(tester);

        // Then
        expect(find.text('Hub on the wall'), findsOneWidget);
        expect(find.text('in 9 days'), findsOneWidget);
      });
    });

    testWidgets('Given it is night, when the zen mode shows, then it is dimmed', (tester) async {
      await withClock(Clock.fixed(DateTime(2026, 10, 26, 23, 10)), () async {
        // Given
        await pumpHost(tester);

        // When
        await tester.pump(const Duration(minutes: 1));
        await _settle(tester);

        // Then
        final dim = tester.widget<AnimatedOpacity>(
          find.descendant(of: find.byType(ZenScreen), matching: find.byType(AnimatedOpacity)).last,
        );
        expect(dim.opacity, ZenScreen.nightDim);
      });
    });
  });
}

/// The focus points the zen mode whispers, without a database.
class _Focus extends FocusService {
  _Focus(this.points);

  final List<FocusPoint> points;

  @override
  Stream<List<FocusPoint>> build() => Stream.value(points);
}

class _OneMinute extends ZenIdleService {
  @override
  Stream<int> build() => Stream.value(1);
}
