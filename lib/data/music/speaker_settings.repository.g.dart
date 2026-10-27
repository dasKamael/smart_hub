// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'speaker_settings.repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Providers

@ProviderFor(speakerSettingsRepository)
final speakerSettingsRepositoryProvider = SpeakerSettingsRepositoryProvider._();

/// Providers

final class SpeakerSettingsRepositoryProvider
    extends $FunctionalProvider<SpeakerSettingsRepository, SpeakerSettingsRepository, SpeakerSettingsRepository>
    with $Provider<SpeakerSettingsRepository> {
  /// Providers
  SpeakerSettingsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'speakerSettingsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$speakerSettingsRepositoryHash();

  @$internal
  @override
  $ProviderElement<SpeakerSettingsRepository> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  SpeakerSettingsRepository create(Ref ref) {
    return speakerSettingsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SpeakerSettingsRepository value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<SpeakerSettingsRepository>(value));
  }
}

String _$speakerSettingsRepositoryHash() => r'fb6cd553e26d16f8e8a3b5dffdbe39979a06e317';
