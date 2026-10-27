import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:smart_hub/domain/lights/color_temperature.util.dart';
import 'package:smart_hub/domain/lights/model/light_capability.enum.dart';
import 'package:smart_hub/domain/lights/model/rgb_color.dart';

part 'light_state.freezed.dart';

@freezed
abstract class LightState with _$LightState {
  const factory LightState({
    required String id,
    required String name,
    required bool isOn,

    /// `false` while the light is unreachable.
    @Default(true) bool isAvailable,

    /// 1–100 while on, `null` while off or for on/off-only lights.
    int? brightnessPercent,

    /// Color while the light is in a color mode; `null` while off or in white mode.
    RgbColor? color,

    /// Color temperature while the light is in white mode.
    int? kelvin,

    /// Range of the color temperature, for lights that support it.
    @Default(2000) int minKelvin,
    @Default(6500) int maxKelvin,
    @Default({}) Set<LightCapability> capabilities,
  }) = _LightState;

  const LightState._();

  /// The color the light shines in, also for white light; `null` while off or unknown.
  RgbColor? get displayColor {
    if (!isOn) return null;
    if (kelvin case final kelvin?) return ColorTemperatureUtil.toRgb(kelvin);
    return color;
  }
}
