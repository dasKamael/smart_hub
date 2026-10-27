// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'speaker.repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Providers
/// Speakers added from the home network provide the speakers; otherwise Home Assistant does.

@ProviderFor(speakerRepository)
final speakerRepositoryProvider = SpeakerRepositoryProvider._();

/// Providers
/// Speakers added from the home network provide the speakers; otherwise Home Assistant does.

final class SpeakerRepositoryProvider
    extends $FunctionalProvider<SpeakerRepository, SpeakerRepository, SpeakerRepository>
    with $Provider<SpeakerRepository> {
  /// Providers
  /// Speakers added from the home network provide the speakers; otherwise Home Assistant does.
  SpeakerRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'speakerRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$speakerRepositoryHash();

  @$internal
  @override
  $ProviderElement<SpeakerRepository> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  SpeakerRepository create(Ref ref) {
    return speakerRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SpeakerRepository value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<SpeakerRepository>(value));
  }
}

String _$speakerRepositoryHash() => r'11d9eefe01f170f5e81682842132e7545a623598';
