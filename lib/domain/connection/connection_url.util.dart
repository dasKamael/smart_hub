/// Normalizes what a person types as server address.
abstract final class ConnectionUrlUtil {
  static const defaultPort = 8123;

  /// Turns `homeassistant.local`, `192.168.1.20:8123`, `http://ha:8123/` or a `ws(s)://…/api/websocket` URL into
  /// a base URL like `http://homeassistant.local:8123`. Without a port, `http` uses 8123 and `https` 443. Returns `null` when [input] is not a usable address.
  static Uri? normalizeBaseUrl(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) return null;
    final withScheme = trimmed.contains('://') ? trimmed : 'http://$trimmed';
    final parsed = Uri.tryParse(withScheme);
    if (parsed == null || parsed.host.isEmpty) return null;
    final scheme = switch (parsed.scheme) {
      'http' || 'ws' => 'http',
      'https' || 'wss' => 'https',
      _ => null,
    };
    if (scheme == null) return null;
    return Uri(
      scheme: scheme,
      host: parsed.host,
      port: parsed.hasPort ? parsed.port : (scheme == 'https' ? 443 : defaultPort),
    );
  }
}
