import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/common/utils/throttler.dart';

void main() {
  group('Throttler', () {
    test('Given a burst of calls, '
        'when they come faster than the interval, '
        'then the first runs at once and only the last runs after the interval', () {
      fakeAsync((async) {
        // Given
        final throttler = Throttler(const Duration(milliseconds: 200));
        final values = <int>[];

        // When
        for (var i = 1; i <= 5; i++) {
          throttler(() => values.add(i));
          async.elapse(const Duration(milliseconds: 30));
        }
        async.elapse(const Duration(milliseconds: 200));

        // Then
        expect(values, [1, 5]);
      });
    });

    test('Given calls over one second, '
        'when calling every 20 ms, '
        'then at most 5–6 actions run', () {
      fakeAsync((async) {
        // Given
        final throttler = Throttler(const Duration(milliseconds: 200));
        var runs = 0;

        // When
        for (var i = 0; i < 50; i++) {
          throttler(() => runs++);
          async.elapse(const Duration(milliseconds: 20));
        }

        // Then
        expect(runs, inInclusiveRange(5, 6));
      });
    });

    test('Given a pending call, '
        'when flushing with the final value, '
        'then the final value runs at once and the pending one never runs', () {
      fakeAsync((async) {
        // Given
        final throttler = Throttler(const Duration(milliseconds: 200));
        final values = <int>[];
        throttler(() => values.add(1));
        throttler(() => values.add(2));

        // When
        throttler.flush(() => values.add(3));
        async.elapse(const Duration(seconds: 1));

        // Then
        expect(values, [1, 3]);
      });
    });

    test('Given a pending call, when disposing, then it never runs', () {
      fakeAsync((async) {
        // Given
        final throttler = Throttler(const Duration(milliseconds: 200));
        final values = <int>[];
        throttler(() => values.add(1));
        throttler(() => values.add(2));

        // When
        throttler.dispose();
        async.elapse(const Duration(seconds: 1));

        // Then
        expect(values, [1]);
      });
    });
  });
}
