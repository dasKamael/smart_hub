// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'speaker_settings.service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Local names, hidden speakers and the default speaker, by speaker id.

@ProviderFor(SpeakerSettingsService)
final speakerSettingsServiceProvider = SpeakerSettingsServiceProvider._();

/// Local names, hidden speakers and the default speaker, by speaker id.
final class SpeakerSettingsServiceProvider
    extends $StreamNotifierProvider<SpeakerSettingsService, Map<String, SpeakerSetting>> {
  /// Local names, hidden speakers and the default speaker, by speaker id.
  SpeakerSettingsServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'speakerSettingsServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$speakerSettingsServiceHash();

  @$internal
  @override
  SpeakerSettingsService create() => SpeakerSettingsService();
}

String _$speakerSettingsServiceHash() => r'bc2924cbc1f524393ecf4d640fa982c243a80e62';

/// Local names, hidden speakers and the default speaker, by speaker id.

abstract class _$SpeakerSettingsService extends $StreamNotifier<Map<String, SpeakerSetting>> {
  Stream<Map<String, SpeakerSetting>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Map<String, SpeakerSetting>>, Map<String, SpeakerSetting>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Map<String, SpeakerSetting>>, Map<String, SpeakerSetting>>,
              AsyncValue<Map<String, SpeakerSetting>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
