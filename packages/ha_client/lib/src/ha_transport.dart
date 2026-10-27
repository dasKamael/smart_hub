import 'package:stream_channel/stream_channel.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Opens the text channel to HA. Replaced by `FakeHomeAssistant` in tests and the demo mode.
abstract interface class HaTransport {
  Future<StreamChannel<String>> connect(Uri uri);
}

final class WebSocketHaTransport implements HaTransport {
  const WebSocketHaTransport();

  @override
  Future<StreamChannel<String>> connect(Uri uri) async {
    final channel = WebSocketChannel.connect(uri);
    await channel.ready;
    return channel.cast<String>();
  }
}
