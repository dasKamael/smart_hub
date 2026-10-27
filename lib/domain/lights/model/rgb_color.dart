/// An sRGB color, independent of any UI framework.
final class RgbColor {
  const RgbColor(this.red, this.green, this.blue);

  final int red;
  final int green;
  final int blue;

  /// `0xFFRRGGBB`.
  int get argb => 0xFF000000 | (red << 16) | (green << 8) | blue;

  @override
  bool operator ==(Object other) => other is RgbColor && other.red == red && other.green == green && other.blue == blue;

  @override
  int get hashCode => Object.hash(red, green, blue);

  @override
  String toString() => 'RgbColor($red, $green, $blue)';
}
