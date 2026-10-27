import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:smart_hub/common/utils/optimistic_overlay.dart';
import 'package:smart_hub/data/lights/light.repository.dart';
import 'package:smart_hub/domain/lights/model/room_scene.dart';
import 'package:smart_hub/domain/lights/model/light_state.dart';
import 'package:smart_hub/domain/lights/scene.util.dart';
import 'package:smart_hub/domain/lights/model/rgb_color.dart';

part 'light.service.g.dart';

/// All lights, sorted by name, and the commands to control them.
///
/// Commands show at once (optimistic) and roll back when the light does not report the change within 3 s or the
/// command fails (`README` → "Optimistic UI").
@Riverpod(keepAlive: true)
class LightsService extends _$LightsService {
  /// Lights report converted colors (e.g. via xy), so colors are compared with a tolerance.
  static const colorTolerance = 30;
  static const kelvinTolerance = 60;

  late OptimisticOverlay<LightState> _overlay;
  var _reported = const <LightState>[];

  @override
  Future<List<LightState>> build() {
    _overlay = OptimisticOverlay(idOf: (light) => light.id, onChanged: _publish);
    final first = Completer<List<LightState>>();
    final subscription = ref
        .watch(lightRepositoryProvider)
        .watchLights()
        .listen(
          (lights) {
            _reported = [...lights]..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
            if (first.isCompleted) {
              _publish();
            } else {
              first.complete(_overlay.applyTo(_reported));
            }
          },
          onError: (Object error, StackTrace stackTrace) {
            if (!first.isCompleted) first.completeError(error, stackTrace);
          },
        );
    ref.onDispose(() {
      unawaited(subscription.cancel());
      _overlay.dispose();
    });
    return first.future;
  }

  Future<void> setOn(List<String> ids, {required bool on}) async {
    if (ids.isEmpty) return;
    for (final id in ids) {
      _overlay.add(
        id,
        apply: (light) => on
            ? light.copyWith(isOn: true, brightnessPercent: light.brightnessPercent ?? 100)
            : light.copyWith(isOn: false, brightnessPercent: null, color: null, kelvin: null),
        isConfirmed: (light) => light.isOn == on,
      );
    }
    final repository = ref.read(lightRepositoryProvider);
    await _run(ids, on ? repository.turnOn(ids) : repository.turnOff(ids));
  }

  /// 1–100 %; turns the light on.
  Future<void> setBrightness(String id, int percent) async {
    final value = percent.clamp(1, 100);
    _overlay.add(
      id,
      apply: (light) => light.copyWith(isOn: true, brightnessPercent: value),
      isConfirmed: (light) => light.isOn && ((light.brightnessPercent ?? 0) - value).abs() <= 1,
    );
    await _run([id], ref.read(lightRepositoryProvider).turnOn([id], brightnessPercent: value));
  }

  /// Turns the light on in [color].
  Future<void> setColor(String id, RgbColor color) async {
    _overlay.add(
      id,
      apply: (light) => light.copyWith(isOn: true, color: color, kelvin: null),
      isConfirmed: (light) => light.isOn && _isClose(light.color, color),
    );
    await _run([id], ref.read(lightRepositoryProvider).turnOn([id], color: color));
  }

  /// Turns the light on in white light of [kelvin].
  Future<void> setKelvin(String id, int kelvin) async {
    _overlay.add(
      id,
      apply: (light) => light.copyWith(isOn: true, kelvin: kelvin, color: null),
      isConfirmed: (light) => light.isOn && ((light.kelvin ?? 0) - kelvin).abs() <= kelvinTolerance,
    );
    await _run([id], ref.read(lightRepositoryProvider).turnOn([id], kelvin: kelvin));
  }

  /// Sets the brightness of all [ids] (e.g. a room) and turns them on.
  Future<void> setBrightnessOf(List<String> ids, int percent) =>
      Future.wait([for (final id in ids) setBrightness(id, percent)]);

  /// Applies [scene] to [lights], each with what it supports: color, color temperature or just brightness.
  /// Each light as [scene] says, as far as it can (`SceneUtil.settingFor`).
  Future<void> applyScene(List<LightState> lights, RoomScene scene) {
    return Future.wait([
      for (final light in lights)
        switch (SceneUtil.settingFor(light, scene)) {
          SceneLight(on: false) => setOn([light.id], on: false),
          SceneLight(brightnessPercent: final brightness?, :final color, :final kelvin)
              when color != null || kelvin != null =>
            _turnOn(light.id, brightnessPercent: brightness, color: color, kelvin: kelvin),
          SceneLight(brightnessPercent: final brightness?) => setBrightness(light.id, brightness),
          _ => setOn([light.id], on: true),
        },
    ]);
  }

  Future<void> _turnOn(String id, {required int brightnessPercent, RgbColor? color, int? kelvin}) async {
    _overlay.add(
      id,
      apply: (light) => light.copyWith(isOn: true, brightnessPercent: brightnessPercent, color: color, kelvin: kelvin),
      isConfirmed: (light) => light.isOn && ((light.brightnessPercent ?? 0) - brightnessPercent).abs() <= 1,
    );
    await _run(
      [id],
      ref
          .read(lightRepositoryProvider)
          .turnOn([id], brightnessPercent: brightnessPercent, color: color, kelvin: kelvin),
    );
  }

  Future<void> _run(List<String> ids, Future<void> command) async {
    try {
      await command;
    } on Object {
      _overlay.remove(ids);
      rethrow;
    }
  }

  void _publish() {
    if (state.hasValue || _reported.isNotEmpty) state = AsyncData(_overlay.applyTo(_reported));
  }

  static bool _isClose(RgbColor? actual, RgbColor expected) {
    if (actual == null) return false;
    return (actual.red - expected.red).abs() +
            (actual.green - expected.green).abs() +
            (actual.blue - expected.blue).abs() <=
        colorTolerance;
  }
}
