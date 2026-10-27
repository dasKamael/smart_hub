import 'package:freezed_annotation/freezed_annotation.dart';

part 'connect_device.freezed.dart';

enum ConnectDeviceType { computer, smartphone, tablet, speaker, tv, other }

/// A device with Spotify open (Spotify Connect), e.g. a phone, a laptop or the tablet itself.
@freezed
abstract class ConnectDevice with _$ConnectDevice {
  const factory ConnectDevice({
    required String id,
    required String name,
    required ConnectDeviceType type,
    @Default(false) bool isActive,

    /// Spotify does not allow remote control of this device.
    @Default(false) bool isRestricted,
    int? volumePercent,
    @Default(false) bool supportsVolume,
  }) = _ConnectDevice;
}
