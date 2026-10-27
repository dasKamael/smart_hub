import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_hub/common/device/kiosk.dart';
import 'package:smart_hub/domain/connection/connection.service.dart';
import 'package:smart_hub/domain/connection/model/connection_config.dart';
import 'package:smart_hub/domain/connection/model/connection_status.enum.dart';
import 'package:smart_hub/domain/connection/model/hub_entity.dart';
import 'package:smart_hub/domain/music/model/spotify_account.dart';
import 'package:smart_hub/domain/music/spotify.service.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_switch.dart';
import 'package:smart_hub/presentation/screens/settings/settings.screen.dart';

import '../../../mocks/connection.mock.dart';
import '../../../mocks/kiosk.mock.dart';
import '../../../utils/widget.test_util.dart';

void main() {
  group('SettingsScreen', () {
    late FakeConnectionConfigService service;
    late MockKiosk kiosk;
    late _FakeSpotifyAccountService spotify;
    const entities = [
      HubEntity(id: 'light.desk', domain: 'light', name: 'Desk lamp', state: 'on'),
      HubEntity(id: 'light.hall', domain: 'light', name: 'Hall', state: 'off'),
      HubEntity(id: 'media_player.kitchen', domain: 'media_player', name: 'Kitchen', state: 'playing'),
      HubEntity(id: 'sun.sun', domain: 'sun', name: 'Sun', state: 'above_horizon'),
    ];

    Future<void> pumpScreen(WidgetTester tester) async {
      await loadWidgetTestApp(
        tester: tester,
        container: createTestContainer(
          overrides: [
            connectionConfigServiceProvider.overrideWith(() => service),
            connectionStatusServiceProvider.overrideWith((ref) => Stream.value(ConnectionStatus.online)),
            hubEntitiesServiceProvider.overrideWith((ref) => Stream.value(entities)),
            kioskProvider.overrideWithValue(kiosk),
            spotifyAccountServiceProvider.overrideWith(() => spotify),
          ],
        ),
        underTestWidget: const SettingsScreen(),
      );
    }

    setUp(() {
      kiosk = kioskReporting();
      spotify = _FakeSpotifyAccountService(const SpotifyAccount.signedOut());
      service = FakeConnectionConfigService(
        initial: ConnectionConfig.homeAssistant(baseUrl: Uri.parse('http://ha.local:8123'), token: 't'),
      );
    });

    testWidgets('Given lights, speakers and other entities, '
        'when rendering, '
        'then lights and speakers are listed and the rest is counted', (tester) async {
      // When
      await pumpScreen(tester);

      // Then
      expect(find.text('http://ha.local:8123'), findsOneWidget);
      expect(find.text('Desk lamp'), findsOneWidget);
      expect(find.text('Hall'), findsOneWidget);
      expect(find.text('Kitchen'), findsOneWidget);
      expect(find.text('Sun'), findsNothing);
      expect(find.text('1 other entities'), findsOneWidget);
    });

    testWidgets('Given a connected hub, '
        'when tapping Disconnect, '
        'then the connection is cleared', (tester) async {
      // Given
      await pumpScreen(tester);

      // When
      await tester.tap(find.text('Disconnect'));
      await tester.pumpAndSettle();

      // Then
      expect(service.clearCalls, 1);
    });

    testWidgets('Given the demo home, '
        'when rendering, '
        'then the demo is named instead of an address', (tester) async {
      // Given
      service = FakeConnectionConfigService(initial: const ConnectionConfig.demo());

      // When
      await pumpScreen(tester);

      // Then
      expect(find.textContaining('Demo home'), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('Given the hub is not the home app, '
        'when switching "Hub as home screen" on, '
        'then the kiosk makes it the home app', (tester) async {
      // Given
      await pumpScreen(tester);

      // When
      await tester.tap(find.byType(HubSwitch));
      await tester.pumpAndSettle();

      // Then
      verify(() => kiosk.setHomeApp(enabled: true)).called(1);
    });

    testWidgets('Given Spotify is not connected, when tapping Connect, then the sign-in starts', (tester) async {
      // Given
      await pumpScreen(tester);

      // When
      await tester.tap(find.text('Connect'));
      await tester.pumpAndSettle();

      // Then
      expect(spotify.signIns, 1);
    });

    testWidgets('Given Spotify is connected, when rendering, then the account is named and can be disconnected', (
      tester,
    ) async {
      // Given
      spotify = _FakeSpotifyAccountService(const SpotifyAccount.signedIn(displayName: 'Richard'));
      await pumpScreen(tester);

      // When
      await tester.tap(find.text('Disconnect').last);
      await tester.pumpAndSettle();

      // Then
      expect(find.text('Connected as Richard'), findsNothing, reason: 'signed out after tapping');
      expect(spotify.signOuts, 1);
    });

    testWidgets('Given no Spotify client id, when rendering, then there is no Spotify card', (tester) async {
      spotify = _FakeSpotifyAccountService(const SpotifyAccount.notConfigured());

      await pumpScreen(tester);

      expect(find.text('Spotify'), findsNothing);
    });

    testWidgets('Given the hub runs without Home Assistant, '
        'when rendering, '
        'then it offers to connect instead of listing devices', (tester) async {
      // Given
      service = FakeConnectionConfigService(initial: const ConnectionConfig.standalone());

      // When
      await pumpScreen(tester);

      // Then
      expect(find.text('Not connected'), findsOneWidget);
      expect(find.text('Disconnect'), findsNothing);
      expect(find.text('No Home Assistant'), findsOneWidget);
      expect(find.text('Connect Home Assistant'), findsNothing, reason: 'the card next to it connects already');
      expect(find.text('Desk lamp'), findsNothing);
    });
  });
}

class _FakeSpotifyAccountService extends SpotifyAccountService {
  _FakeSpotifyAccountService(this.initial);

  final SpotifyAccount initial;
  var signIns = 0;
  var signOuts = 0;

  @override
  Future<SpotifyAccount> build() async => initial;

  @override
  Future<void> signIn() async => signIns++;

  @override
  Future<void> signOut() async {
    signOuts++;
    state = const AsyncData(SpotifyAccount.signedOut());
  }
}
