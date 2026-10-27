import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/connection/connection.service.dart';
import 'package:smart_hub/domain/connection/model/connect_result.enum.dart';
import 'package:smart_hub/domain/connection/model/connection_config.dart';
import 'package:smart_hub/presentation/screens/setup/setup.screen.dart';

import '../../../mocks/connection.mock.dart';
import '../../../mocks/floorplan.mock.dart';
import '../../../utils/widget.test_util.dart';

void main() {
  group('SetupScreen', () {
    late FakeConnectionConfigService service;

    Future<void> pumpScreen(WidgetTester tester) async {
      await loadWidgetTestApp(
        tester: tester,
        container: createTestContainer(
          overrides: [connectionConfigServiceProvider.overrideWith(() => service), ...floorplanTestOverrides()],
        ),
        underTestWidget: const SetupScreen(),
      );
    }

    setUp(() => service = FakeConnectionConfigService());

    testWidgets('Given the setup screen, '
        'when entering address and token and tapping Connect, '
        'then the hub connects with these values', (tester) async {
      // Given
      await pumpScreen(tester);

      // When
      await tester.enterText(find.byType(TextFormField).at(0), '192.168.1.20');
      await tester.enterText(find.byType(TextFormField).at(1), 'secret');
      await tester.tap(find.text('Connect'));
      await tester.pumpAndSettle();

      // Then
      expect(
        service.connectCalls.single,
        ConnectionConfig.homeAssistant(baseUrl: Uri.parse('http://192.168.1.20:8123'), token: 'secret'),
      );
    });

    testWidgets('Given Home Assistant rejects the token, '
        'when connecting, '
        'then the error is shown', (tester) async {
      // Given
      service.result = ConnectResult.authFailed;
      await pumpScreen(tester);

      // When
      await tester.enterText(find.byType(TextFormField).at(0), 'ha.local');
      await tester.enterText(find.byType(TextFormField).at(1), 'wrong');
      await tester.tap(find.text('Connect'));
      await tester.pumpAndSettle();

      // Then
      expect(find.text('Home Assistant rejected the token.'), findsOneWidget);
    });

    testWidgets('Given the setup screen, '
        'when tapping Try demo, '
        'then the demo is started', (tester) async {
      // Given
      await pumpScreen(tester);

      // When
      await tester.tap(find.text('Try demo'));
      await tester.pumpAndSettle();

      // Then
      expect(service.connectCalls.single, const ConnectionConfig.demo());
    });

    testWidgets('Given the setup screen, '
        'when rendering, '
        'then the token field hides its input', (tester) async {
      // When
      await pumpScreen(tester);

      // Then
      final tokenField = tester.widget<EditableText>(find.byType(EditableText).at(1));
      expect(tokenField.obscureText, isTrue);
    });

    testWidgets('Given the setup screen, '
        'when choosing to start without Home Assistant, '
        'then the hub runs without it', (tester) async {
      // Given
      await pumpScreen(tester);

      // When
      await tester.tap(find.textContaining('No Home Assistant?'));
      await tester.pumpAndSettle();

      // Then
      expect(service.connectCalls.single, const ConnectionConfig.standalone());
    });
  });
}
