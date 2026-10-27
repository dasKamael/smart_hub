sealed class HaException implements Exception {
  const HaException(this.message);

  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

/// HA rejected the access token.
final class HaAuthException extends HaException {
  const HaAuthException([super.message = 'Invalid access token']);
}

/// HA answered a command with `success: false`.
final class HaCommandException extends HaException {
  const HaCommandException({required this.code, required String message}) : super(message);

  /// HA error code, e.g. `service_not_found` or `invalid_format`.
  final String code;

  @override
  String toString() => 'HaCommandException($code): $message';
}

/// A command was sent while no authenticated connection exists.
final class HaNotConnectedException extends HaException {
  const HaNotConnectedException([super.message = 'Not connected to Home Assistant']);
}

/// The connection closed before the answer arrived.
final class HaConnectionClosedException extends HaException {
  const HaConnectionClosedException([super.message = 'Connection to Home Assistant closed']);
}

/// No answer within the timeout.
final class HaTimeoutException extends HaException {
  const HaTimeoutException(super.message);
}
