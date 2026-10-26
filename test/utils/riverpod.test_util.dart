import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';

Duration? _noRetry(int retryCount, Object error) => null;

/// `ProviderContainer` for tests: no retry, disposed at the end of the test.
///
/// Riverpod 3 retries failing providers with backoff – expected errors would never arrive and timers
/// would still be pending when the test ends. Pass [retry] explicitly to test retry behaviour.
ProviderContainer createTestContainer({
  ProviderContainer? parent,
  List<Override> overrides = const [],
  List<ProviderObserver>? observers,
  Duration? Function(int retryCount, Object error)? retry = _noRetry,
}) {
  final container = ProviderContainer(parent: parent, overrides: overrides, observers: observers, retry: retry);
  addTearDown(container.dispose);
  return container;
}
