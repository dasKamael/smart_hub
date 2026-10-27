import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_hub/common/device/kiosk.dart';
import 'package:smart_hub/presentation/screens/settings/settings.controller.dart';

import '../../../mocks/kiosk.mock.dart';
import '../../../utils/riverpod.test_util.dart';

void main() {
  group('HomeAppController', () {
    Future<HomeAppController> createController(Kiosk kiosk) async {
      final container = createTestContainer(overrides: [kioskProvider.overrideWithValue(kiosk)]);
      container.listen(homeAppControllerProvider, (_, _) {});
      await container.read(homeAppControllerProvider.future);
      return container.read(homeAppControllerProvider.notifier);
    }

    test('Given the hub is not the home app, when switching it on, then the kiosk is enabled', () async {
      // Given
      final kiosk = kioskReporting();
      final controller = await createController(kiosk);

      // When
      await controller.setHomeApp(enabled: true);

      // Then
      verify(() => kiosk.setHomeApp(enabled: true)).called(1);
      expect(controller.state.value, isTrue);
    });

    test('Given changing the home app fails, when switching it on, then the switch goes back to off', () async {
      // Given
      final kiosk = kioskReporting();
      when(() => kiosk.setHomeApp(enabled: any(named: 'enabled'))).thenThrow(PlatformExceptionLike());
      final controller = await createController(kiosk);

      // When
      await controller.setHomeApp(enabled: true);

      // Then
      expect(controller.state.value, isFalse);
    });

    test('Given the platform does not support it, when reading, then the hub is not the home app', () async {
      // Given
      final kiosk = MockKiosk();
      when(kiosk.isHomeApp).thenThrow(PlatformExceptionLike());

      // When
      final controller = await createController(kiosk);

      // Then
      expect(controller.state.value, isFalse);
    });
  });
}

class PlatformExceptionLike implements Exception {}
