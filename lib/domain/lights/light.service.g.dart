// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'light.service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// All lights, sorted by name, and the commands to control them.
///
/// Commands show at once (optimistic) and roll back when the light does not report the change within 3 s or the
/// command fails (`README` → "Optimistic UI").

@ProviderFor(LightsService)
final lightsServiceProvider = LightsServiceProvider._();

/// All lights, sorted by name, and the commands to control them.
///
/// Commands show at once (optimistic) and roll back when the light does not report the change within 3 s or the
/// command fails (`README` → "Optimistic UI").
final class LightsServiceProvider extends $AsyncNotifierProvider<LightsService, List<LightState>> {
  /// All lights, sorted by name, and the commands to control them.
  ///
  /// Commands show at once (optimistic) and roll back when the light does not report the change within 3 s or the
  /// command fails (`README` → "Optimistic UI").
  LightsServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lightsServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lightsServiceHash();

  @$internal
  @override
  LightsService create() => LightsService();
}

String _$lightsServiceHash() => r'48867c2c9171c6023171ca6239c3c8386d0f3951';

/// All lights, sorted by name, and the commands to control them.
///
/// Commands show at once (optimistic) and roll back when the light does not report the change within 3 s or the
/// command fails (`README` → "Optimistic UI").

abstract class _$LightsService extends $AsyncNotifier<List<LightState>> {
  FutureOr<List<LightState>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<LightState>>, List<LightState>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<LightState>>, List<LightState>>,
              AsyncValue<List<LightState>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
