import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/connection/connection.service.dart';
import 'package:smart_hub/domain/connection/model/connection_status.enum.dart';
import 'package:smart_hub/presentation/design_system/atoms/status_pill.dart';
import 'package:smart_hub/presentation/shared_widgets/connection_indicator.dart';

import '../../utils/widget.test_util.dart';

void main() {
  group('ConnectionIndicator', () {
    Future<void> pumpWithStatus(WidgetTester tester, ConnectionStatus status) async {
      await loadWidgetTestApp(
        tester: tester,
        container: createTestContainer(
          overrides: [connectionStatusServiceProvider.overrideWith((ref) => Stream.value(status))],
        ),
        underTestWidget: const ConnectionIndicator(),
      );
    }

    final expectedLabels = {
      ConnectionStatus.offline: 'Offline',
      ConnectionStatus.connecting: 'Connecting',
      ConnectionStatus.authFailed: 'Token rejected',
    };
    for (final MapEntry(key: status, value: label) in expectedLabels.entries) {
      testWidgets('Given the hub is ${status.name}, when rendering, then the pill says "$label"', (tester) async {
        await pumpWithStatus(tester, status);
        expect(find.text(label), findsOneWidget);
      });
    }

    for (final status in [ConnectionStatus.online, ConnectionStatus.notConfigured]) {
      testWidgets('Given the hub is ${status.name}, when rendering, then no pill is shown', (tester) async {
        await pumpWithStatus(tester, status);
        expect(find.byType(StatusPill), findsNothing);
      });
    }
  });
}
