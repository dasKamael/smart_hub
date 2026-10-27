// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'speaker.repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Providers

@ProviderFor(speakerRepository)
final speakerRepositoryProvider = SpeakerRepositoryProvider._();

/// Providers

final class SpeakerRepositoryProvider
    extends $FunctionalProvider<SpeakerRepository, SpeakerRepository, SpeakerRepository>
    with $Provider<SpeakerRepository> {
  /// Providers
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

String _$speakerRepositoryHash() => r'e01e3efbf8622fb462190f648ccf45f82942f483';
