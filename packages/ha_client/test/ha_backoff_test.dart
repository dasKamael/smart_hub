import 'package:ha_client/ha_client.dart';
import 'package:test/test.dart';

void main() {
  group('HaBackoff', () {
    test('Given a fresh backoff, '
        'when asking for consecutive delays, '
        'then they double from 1 s and are capped at 30 s', () {
      // Given
      final backoff = HaBackoff();

      // When
      final delays = [for (var i = 0; i < 8; i++) backoff.next().inSeconds];

      // Then
      expect(delays, [1, 2, 4, 8, 16, 30, 30, 30]);
    });

    test('Given a backoff after several attempts, '
        'when it is reset, '
        'then it starts again at the initial delay', () {
      // Given
      final backoff = HaBackoff()
        ..next()
        ..next()
        ..next();

      // When
      backoff.reset();

      // Then
      expect(backoff.next(), const Duration(seconds: 1));
    });
  });
}
