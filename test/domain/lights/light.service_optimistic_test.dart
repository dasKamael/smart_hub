import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_hub/data/lights/light.repository.dart';
import 'package:smart_hub/domain/lights/light.service.dart';
import 'package:smart_hub/domain/lights/model/light_state.dart';
import 'package:smart_hub/domain/lights/model/rgb_color.dart';

class _MockLightRepository extends Mock implements LightRepository {}

void main() {
  group('LightsService optimistic updates', () {
    late _MockLightRepository repository;
    late StreamController<List<LightState>> reports;
    const desk = LightState(id: 'light.desk', name: 'Desk', isOn: false);

    setUp(() {
      repository = _MockLightRepository();
      reports = StreamController<List<LightState>>.broadcast();
      when(() => repository.watchLights()).thenAnswer((_) => reports.stream);
      when(
        () => repository.turnOn(
          any(),
          brightnessPercent: any(named: 'brightnessPercent'),
          color: any(named: 'color'),
          kelvin: any(named: 'kelvin'),
        ),
      ).thenAnswer((_) async {});
      when(() => repository.turnOff(any())).thenAnswer((_) async {});
    });

    /// Runs [body] in fake time with a started service that knows [desk].
    void withService(void Function(FakeAsync async, ProviderContainer container, LightsService service) body) {
      fakeAsync((async) {
        final container = ProviderContainer(
          overrides: [lightRepositoryProvider.overrideWithValue(repository)],
          retry: (_, _) => null,
        );
        container.listen(lightsServiceProvider, (_, _) {});
        async.flushMicrotasks();
        reports.add(const [desk]);
        async.flushMicrotasks();
        body(async, container, container.read(lightsServiceProvider.notifier));
        container.dispose();
        async.flushMicrotasks();
      });
    }

    LightState current(ProviderContainer container) => container.read(lightsServiceProvider).requireValue.single;

    test('Given a light that is off, '
        'when turning it on, '
        'then it shows on before Home Assistant reports it', () {
      withService((async, container, service) {
        // When
        unawaited(service.setOn(['light.desk'], on: true));
        async.flushMicrotasks();

        // Then
        expect(current(container).isOn, isTrue);
        expect(current(container).brightnessPercent, 100);
      });
    });

    test('Given a pending change, '
        'when Home Assistant does not confirm it within 3 s, '
        'then the light shows its reported state again', () {
      withService((async, container, service) {
        // Given
        unawaited(service.setOn(['light.desk'], on: true));
        async.flushMicrotasks();

        // When
        async.elapse(const Duration(seconds: 3, milliseconds: 100));

        // Then
        expect(current(container).isOn, isFalse);
      });
    });

    test('Given a pending change, '
        'when Home Assistant confirms it, '
        'then the reported state stays after the timeout', () {
      withService((async, container, service) {
        // Given
        unawaited(service.setBrightness('light.desk', 40));
        async.flushMicrotasks();

        // When
        reports.add([desk.copyWith(isOn: true, brightnessPercent: 41)]);
        async.flushMicrotasks();
        async.elapse(const Duration(seconds: 4));

        // Then
        expect(current(container).brightnessPercent, 41);
      });
    });

    test('Given Home Assistant rejects a command, '
        'when setting a color, '
        'then the change rolls back at once', () {
      withService((async, container, service) {
        // Given
        when(() => repository.turnOn(any(), color: any(named: 'color'))).thenAnswer((_) async => throw Exception('no'));

        // When
        Object? error;
        unawaited(service.setColor('light.desk', const RgbColor(1, 2, 3)).catchError((Object e) => error = e));
        async.flushMicrotasks();

        // Then
        expect(error, isNotNull);
        expect(current(container).isOn, isFalse);
        expect(current(container).color, isNull);
      });
    });

    test('Given a light in color mode, '
        'when setting a color temperature, '
        'then it shows white light of that temperature', () {
      withService((async, container, service) {
        // When
        unawaited(service.setKelvin('light.desk', 3000));
        async.flushMicrotasks();

        // Then
        expect(current(container).kelvin, 3000);
        expect(current(container).color, isNull);
        verify(() => repository.turnOn(['light.desk'], kelvin: 3000)).called(1);
      });
    });
  });
}
