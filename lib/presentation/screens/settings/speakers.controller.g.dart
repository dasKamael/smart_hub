// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'speakers.controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Speaker settings page: which row shows its options, and the changes.

@ProviderFor(SpeakersController)
final speakersControllerProvider = SpeakersControllerProvider._();

/// Speaker settings page: which row shows its options, and the changes.
final class SpeakersControllerProvider extends $NotifierProvider<SpeakersController, String?> {
  /// Speaker settings page: which row shows its options, and the changes.
  SpeakersControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'speakersControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$speakersControllerHash();

  @$internal
  @override
  SpeakersController create() => SpeakersController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<String?>(value));
  }
}

String _$speakersControllerHash() => r'ffdac7b240ca163785c331b3f746225cad7dc672';

/// Speaker settings page: which row shows its options, and the changes.

abstract class _$SpeakersController extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element = ref.element as $ClassProviderElement<AnyNotifier<String?, String?>, String?, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}

/// Speakers from Home Assistant first, then Spotify devices – the ones open now and the ones set up before.

@ProviderFor(speakerEntries)
final speakerEntriesProvider = SpeakerEntriesProvider._();

/// Speakers from Home Assistant first, then Spotify devices – the ones open now and the ones set up before.

final class SpeakerEntriesProvider
    extends $FunctionalProvider<List<SpeakerEntry>, List<SpeakerEntry>, List<SpeakerEntry>>
    with $Provider<List<SpeakerEntry>> {
  /// Speakers from Home Assistant first, then Spotify devices – the ones open now and the ones set up before.
  SpeakerEntriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'speakerEntriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$speakerEntriesHash();

  @$internal
  @override
  $ProviderElement<List<SpeakerEntry>> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  List<SpeakerEntry> create(Ref ref) {
    return speakerEntries(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<SpeakerEntry> value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<List<SpeakerEntry>>(value));
  }
}

String _$speakerEntriesHash() => r'c93a73e7adc1d97779765cc26cc55df60a526ede';
