import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_hub/data/lights/hue/hue_bridge.repository.dart';
import 'package:smart_hub/domain/lights/light_bridge.service.dart';
import 'package:smart_hub/domain/lights/model/light_bridge.dart';

import '../../utils/riverpod.test_util.dart';

class _MockBridges extends Mock implements HueBridgeRepository {}

void main() {
  group('LightBridgeService', () {
    late _MockBridges bridges;
    const bridge = LightBridge(host: '192.168.1.20', appKey: 'key');

    setUpAll(() => registerFallbackValue(bridge));

    setUp(() {
      bridges = _MockBridges();
      when(() => bridges.load()).thenAnswer((_) async => null);
      when(() => bridges.save(any())).thenAnswer((_) async {});
    });

    ProviderContainer createContainer() {
      final container = createTestContainer(overrides: [hueBridgeRepositoryProvider.overrideWithValue(bridges)]);
      container.listen(lightBridgeServiceProvider, (_, _) {});
      return container;
    }

    test('Given the button is pressed after 5 s, when pairing, then the bridge is kept as the light source', () {
      fakeAsync((async) {
        // Given
        var asked = 0;
        when(() => bridges.pair(any())).thenAnswer((_) async {
          if (++asked < 3) throw const BridgeButtonNotPressedException();
          return bridge;
        });
        final container = createContainer();
        async.flushMicrotasks();

        // When
        bool? paired;
        container.read(lightBridgeServiceProvider.notifier).pair('192.168.1.20').then((value) => paired = value);
        async.elapse(const Duration(seconds: 5));

        // Then
        expect(paired, isTrue);
        expect(container.read(lightBridgeServiceProvider).value, bridge);
        verify(() => bridges.save(bridge)).called(1);
      });
    });

    test('Given the button is never pressed, when a minute has passed, then pairing gives up', () {
      fakeAsync((async) {
        // Given
        when(() => bridges.pair(any())).thenThrow(const BridgeButtonNotPressedException());
        final container = createContainer();
        async.flushMicrotasks();

        // When
        bool? paired;
        container.read(lightBridgeServiceProvider.notifier).pair('192.168.1.20').then((value) => paired = value);
        async.elapse(const Duration(seconds: 62));

        // Then
        expect(paired, isFalse);
        expect(container.read(lightBridgeServiceProvider).value, isNull);
      });
    });
  });
}
