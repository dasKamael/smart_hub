enum ConnectionStatus {
  /// No Home Assistant: not set up yet, or the hub runs without one.
  notConfigured,

  /// Opening the connection and loading states.
  connecting,

  /// Connected; states are live.
  online,

  /// Connection lost or not reachable; retrying. Last known states are kept, controls are disabled.
  offline,

  /// Credentials were rejected. Needs a new token.
  authFailed;

  bool get isOnline => this == online;
}
