enum HaConnectionStatus {
  /// Not connected; the client retries with backoff while it is running.
  disconnected,

  /// Opening the socket and authenticating.
  connecting,

  /// Authenticated, states loaded and subscribed to changes.
  connected,

  /// The access token was rejected. The client stops retrying until it is started again.
  authFailed,
}
