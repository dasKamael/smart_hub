import 'package:freezed_annotation/freezed_annotation.dart';

part 'speaker_setting.freezed.dart';

/// How the hub shows one speaker or Spotify device.
@freezed
abstract class SpeakerSetting with _$SpeakerSetting {
  const factory SpeakerSetting({
    required String id,
    String? displayName,
    @Default(false) bool hidden,
    @Default(false) bool isDefault,
  }) = _SpeakerSetting;
}
