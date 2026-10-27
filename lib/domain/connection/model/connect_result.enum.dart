enum ConnectResult {
  connected,

  /// The server rejected the access token.
  authFailed,

  /// The server could not be reached in time.
  unreachable,
}
