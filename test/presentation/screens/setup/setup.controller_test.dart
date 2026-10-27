import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/data/database/app_database.dart';
import 'package:smart_hub/data/floorplan/placement.repository.dart';
import 'package:smart_hub/data/plants/plant.repository.dart';
import 'package:smart_hub/domain/floorplan/model/plan_point.dart';
import 'package:smart_hub/presentation/screens/setup/demo_layout.dart';
import 'package:smart_hub/domain/connection/connection.service.dart';
import 'package:smart_hub/domain/connection/model/connect_result.enum.dart';
import 'package:smart_hub/domain/connection/model/connection_config.dart';
import 'package:smart_hub/presentation/screens/setup/setup.controller.dart';
import 'package:smart_hub/presentation/screens/setup/setup.state.dart';

import '../../../mocks/connection.mock.dart';
import '../../../utils/riverpod.test_util.dart';

void main() {
  group('SetupController', () {
    late FakeConnectionConfigService service;
    late PlacementRepository placements;
    late PlantRepository plants;

    SetupController createController() {
      final database = AppDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      placements = PlacementRepository(database: database);
      plants = PlantRepository(database: database);
      final container = createTestContainer(
        overrides: [
          connectionConfigServiceProvider.overrideWith(() => service),
          placementRepositoryProvider.overrideWithValue(placements),
          plantRepositoryProvider.overrideWithValue(plants),
        ],
      );
      container.listen(setupControllerProvider, (_, _) {});
      return container.read(setupControllerProvider.notifier);
    }

    setUp(() => service = FakeConnectionConfigService());

    test('Given an invalid address, '
        'when connecting, '
        'then the error is invalidAddress and nothing is tried', () async {
      // Given
      final controller = createController()
        ..updateAddress('ftp://nope')
        ..updateToken('token');

      // When
      await controller.connect();

      // Then
      expect(controller.state.error, SetupError.invalidAddress);
      expect(service.connectCalls, isEmpty);
    });

    test('Given an address but no token, '
        'when connecting, '
        'then the error is missingToken', () async {
      // Given
      final controller = createController()..updateAddress('homeassistant.local');

      // When
      await controller.connect();

      // Then
      expect(controller.state.error, SetupError.missingToken);
    });

    test('Given address and token, '
        'when connecting, '
        'then the service gets the normalized address and the trimmed token', () async {
      // Given
      final controller = createController()
        ..updateAddress('homeassistant.local')
        ..updateToken('  secret  ');

      // When
      await controller.connect();

      // Then
      expect(
        service.connectCalls.single,
        ConnectionConfig.homeAssistant(baseUrl: Uri.parse('http://homeassistant.local:8123'), token: 'secret'),
      );
      expect(controller.state.error, isNull);
      expect(controller.state.isConnecting, isFalse);
    });

    test('Given Home Assistant rejects the token, '
        'when connecting, '
        'then the error is authFailed', () async {
      // Given
      service.result = ConnectResult.authFailed;
      final controller = createController()
        ..updateAddress('ha.local')
        ..updateToken('wrong');

      // When
      await controller.connect();

      // Then
      expect(controller.state.error, SetupError.authFailed);
    });

    test('Given an error is shown, '
        'when the token is edited, '
        'then the error disappears', () async {
      // Given
      final controller = createController()..updateAddress('ha.local');
      await controller.connect();

      // When
      controller.updateToken('t');

      // Then
      expect(controller.state.error, isNull);
    });

    test('Given the setup, '
        'when starting the demo, '
        'then the demo config is connected and the demo devices are placed', () async {
      // Given
      final controller = createController();

      // When
      await controller.startDemo();

      // Then
      expect(service.connectCalls.single, const ConnectionConfig.demo());
      expect(await placements.all(), unorderedEquals(demoLayout));
      expect((await plants.all()).map((plant) => plant.name), contains('Monstera'));
      expect(controller.state.isStartingDemo, isFalse);
    });

    test('Given devices are already placed, '
        'when starting the demo, '
        'then the existing layout is kept', () async {
      // Given
      final controller = createController();
      await placements.save(demoLayout.first.copyWith(position: const PlanPoint(300, 300)));

      // When
      await controller.startDemo();

      // Then
      expect(await placements.all(), [demoLayout.first.copyWith(position: const PlanPoint(300, 300))]);
    });
  });
}
