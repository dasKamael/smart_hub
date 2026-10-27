// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ha_session.repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Providers

@ProviderFor(haSessionRepository)
final haSessionRepositoryProvider = HaSessionRepositoryProvider._();

/// Providers

final class HaSessionRepositoryProvider
    extends $FunctionalProvider<HaSessionRepository, HaSessionRepository, HaSessionRepository>
    with $Provider<HaSessionRepository> {
  /// Providers
  HaSessionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'haSessionRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$haSessionRepositoryHash();

  @$internal
  @override
  $ProviderElement<HaSessionRepository> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  HaSessionRepository create(Ref ref) {
    return haSessionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HaSessionRepository value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<HaSessionRepository>(value));
  }
}

String _$haSessionRepositoryHash() => r'3517ead69da4f016c267120b6abbbcbac52465c9';
