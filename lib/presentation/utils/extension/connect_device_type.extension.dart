import 'package:smart_hub/domain/music/model/connect_device.dart';
import 'package:smart_hub/presentation/design_system/atoms/hub_glyph.dart';

extension ConnectDeviceTypeExtension on ConnectDeviceType {
  /// The symbol of a device with Spotify open.
  HubGlyph get glyph => switch (this) {
    ConnectDeviceType.smartphone => HubGlyph.phone,
    ConnectDeviceType.tablet => HubGlyph.tablet,
    ConnectDeviceType.computer => HubGlyph.computer,
    ConnectDeviceType.tv => HubGlyph.tv,
    ConnectDeviceType.speaker => HubGlyph.speaker,
    ConnectDeviceType.other => HubGlyph.note,
  };
}
