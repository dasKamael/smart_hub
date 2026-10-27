import 'dart:typed_data';

/// An app on the tablet that can be opened from the hub.
final class InstalledApp {
  const InstalledApp({required this.packageName, required this.label, required this.isVideo, required this.icon});

  final String packageName;
  final String label;

  /// Streaming and video apps; the apps widget shows them until other apps are chosen.
  final bool isVideo;

  /// PNG.
  final Uint8List icon;
}
