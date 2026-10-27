import 'package:freezed_annotation/freezed_annotation.dart';

part 'light_bridge.freezed.dart';

/// A light bridge in the home network the hub controls lights through directly, without Home Assistant.
@freezed
abstract class LightBridge with _$LightBridge {
  const factory LightBridge({
    /// IP address in the home network.
    required String host,

    /// The key the bridge handed out when its button was pressed; secret.
    required String appKey,

    /// The bridge's own name, e.g. as shown in its app.
    String? name,
  }) = _LightBridge;
}

/// The bridge's button was not pressed (yet) when pairing.
class BridgeButtonNotPressedException implements Exception {
  const BridgeButtonNotPressedException();
}
