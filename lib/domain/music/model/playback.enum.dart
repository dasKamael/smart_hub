enum Playback {
  playing,
  paused,

  /// On, but nothing loaded.
  idle,

  /// Off or unreachable.
  off;

  bool get isPlaying => this == playing;
}
