import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/domain/zen/zen.service.dart';
import 'package:smart_hub/presentation/screens/zen/zen.controller.dart';

import '../../../utils/riverpod.test_util.dart';

void main() {
  group('ZenController', () {
    ProviderContainer createContainer(int minutes) {
      final container = createTestContainer(overrides: [zenIdleServiceProvider.overrideWith(() => _Idle(minutes))]);
      container
        ..listen(zenIdleServiceProvider, (_, _) {})
        ..listen(zenControllerProvider, (_, _) {});
      return container;
    }

    test('Given 2 minutes idle time, when nobody touches the hub for 2 minutes, then the zen mode starts', () {
      fakeAsync((async) {
        // Given
        final container = createContainer(2);
        async.flushMicrotasks();

        // When
        async.elapse(const Duration(minutes: 1, seconds: 59));
        final before = container.read(zenControllerProvider);
        async.elapse(const Duration(seconds: 1));

        // Then
        expect(before, isFalse);
        expect(container.read(zenControllerProvider), isTrue);
      });
    });

    test('Given a touch after one minute, when the second minute passes, then the idle time starts over', () {
      fakeAsync((async) {
        // Given
        final container = createContainer(2);
        async
          ..flushMicrotasks()
          ..elapse(const Duration(minutes: 1));

        // When
        container.read(zenControllerProvider.notifier).activity();
        async.elapse(const Duration(minutes: 1, seconds: 30));

        // Then
        expect(container.read(zenControllerProvider), isFalse);
      });
    });

    test('Given the zen mode is off, when waiting long, then it only starts by hand', () {
      fakeAsync((async) {
        // Given
        final container = createContainer(0);
        async
          ..flushMicrotasks()
          ..elapse(const Duration(hours: 2));
        final waited = container.read(zenControllerProvider);

        // When
        container.read(zenControllerProvider.notifier).enter();

        // Then
        expect(waited, isFalse);
        expect(container.read(zenControllerProvider), isTrue);
      });
    });

    test('Given the zen mode, when leaving it, then it starts again after the idle time', () {
      fakeAsync((async) {
        // Given
        final container = createContainer(1);
        async
          ..flushMicrotasks()
          ..elapse(const Duration(minutes: 1));

        // When
        container.read(zenControllerProvider.notifier).exit();
        final left = container.read(zenControllerProvider);
        async.elapse(const Duration(minutes: 1));

        // Then
        expect(left, isFalse);
        expect(container.read(zenControllerProvider), isTrue);
      });
    });
  });
}

class _Idle extends ZenIdleService {
  _Idle(this.minutes);

  final int minutes;

  @override
  Stream<int> build() => Stream.value(minutes);
}
