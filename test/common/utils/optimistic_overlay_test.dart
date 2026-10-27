import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_hub/common/utils/optimistic_overlay.dart';

typedef _Lamp = ({String id, bool on});

void main() {
  group('OptimisticOverlay', () {
    late OptimisticOverlay<_Lamp> overlay;
    late int changes;
    const off = (id: 'a', on: false);

    setUp(() {
      changes = 0;
      overlay = OptimisticOverlay<_Lamp>(idOf: (lamp) => lamp.id, onChanged: () => changes++);
    });

    tearDown(() => overlay.dispose());

    void turnOn() => overlay.add('a', apply: (lamp) => (id: lamp.id, on: true), isConfirmed: (lamp) => lamp.on);

    test('Given a pending change, when applying it to the reported state, then the desired state shows', () {
      turnOn();

      expect(overlay.applyTo([off]), [(id: 'a', on: true)]);
      expect(changes, 1);
    });

    test('Given a pending change, when the report confirms it, then it is dropped', () {
      turnOn();

      overlay.applyTo([(id: 'a', on: true)]);

      expect(overlay.isPending('a'), isFalse);
      expect(overlay.applyTo([off]), [off], reason: 'later reports are shown as they are');
    });

    test('Given a pending change, when no confirmation arrives within 3 s, then it rolls back', () {
      fakeAsync((async) {
        turnOn();

        async.elapse(const Duration(milliseconds: 2900));
        expect(overlay.applyTo([off]).single.on, isTrue);

        async.elapse(const Duration(milliseconds: 200));
        expect(overlay.applyTo([off]).single.on, isFalse);
        expect(changes, 2, reason: 'listeners re-render the rolled back state');
      });
    });

    test('Given a pending change, when the command fails, then removing it rolls back at once', () {
      turnOn();

      overlay.remove(['a']);

      expect(overlay.applyTo([off]), [off]);
      expect(changes, 2);
    });

    test('Given a pending change, when a newer one for the same item arrives, then only the newer counts', () {
      fakeAsync((async) {
        turnOn();
        async.elapse(const Duration(seconds: 2));

        overlay.add('a', apply: (lamp) => (id: lamp.id, on: false), isConfirmed: (lamp) => !lamp.on);
        async.elapse(const Duration(seconds: 2));

        expect(overlay.isPending('a'), isTrue, reason: 'the timeout restarts with the newer change');
      });
    });

    test('Given other items, when applying, then they are untouched', () {
      turnOn();

      expect(overlay.applyTo([(id: 'b', on: false)]), [(id: 'b', on: false)]);
    });
  });
}
