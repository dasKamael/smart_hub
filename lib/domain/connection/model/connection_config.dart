import 'package:freezed_annotation/freezed_annotation.dart';

part 'connection_config.freezed.dart';

/// How the hub reaches its devices.
@freezed
sealed class ConnectionConfig with _$ConnectionConfig {
  /// A real Home Assistant instance. [baseUrl] is normalized, e.g. `http://homeassistant.local:8123`.
  const factory ConnectionConfig.homeAssistant({required Uri baseUrl, required String token}) =
      HomeAssistantConnectionConfig;

  /// Built-in demo home without Home Assistant.
  const factory ConnectionConfig.demo() = DemoConnectionConfig;

  /// No Home Assistant: plants, the floor plan and Spotify work, lights and speakers are not there.
  const factory ConnectionConfig.standalone() = StandaloneConnectionConfig;
}
