// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'music.controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Music page: which target is shown, which tile shows its options, and the playback commands.

@ProviderFor(MusicController)
final musicControllerProvider = MusicControllerProvider._();

/// Music page: which target is shown, which tile shows its options, and the playback commands.
final class MusicControllerProvider extends $NotifierProvider<MusicController, MusicPageState> {
  /// Music page: which target is shown, which tile shows its options, and the playback commands.
  MusicControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'musicControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$musicControllerHash();

  @$internal
  @override
  MusicController create() => MusicController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MusicPageState value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<MusicPageState>(value));
  }
}

String _$musicControllerHash() => r'6c6d3ff46f7570a2017cd49eb4b3166913b43fa8';

/// Music page: which target is shown, which tile shows its options, and the playback commands.

abstract class _$MusicController extends $Notifier<MusicPageState> {
  MusicPageState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<MusicPageState, MusicPageState>;
    final element =
        ref.element
            as $ClassProviderElement<AnyNotifier<MusicPageState, MusicPageState>, MusicPageState, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}

/// Speakers grouped by their leader, members by name, groups by their first member – so tiles keep their order when
/// groups change. Hidden speakers are left out.

@ProviderFor(speakerGroups)
final speakerGroupsProvider = SpeakerGroupsProvider._();

/// Speakers grouped by their leader, members by name, groups by their first member – so tiles keep their order when
/// groups change. Hidden speakers are left out.

final class SpeakerGroupsProvider
    extends $FunctionalProvider<List<SpeakerGroup>, List<SpeakerGroup>, List<SpeakerGroup>>
    with $Provider<List<SpeakerGroup>> {
  /// Speakers grouped by their leader, members by name, groups by their first member – so tiles keep their order when
  /// groups change. Hidden speakers are left out.
  SpeakerGroupsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'speakerGroupsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$speakerGroupsHash();

  @$internal
  @override
  $ProviderElement<List<SpeakerGroup>> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  List<SpeakerGroup> create(Ref ref) {
    return speakerGroups(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<SpeakerGroup> value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<List<SpeakerGroup>>(value));
  }
}

String _$speakerGroupsHash() => r'0dcb589ceed2739d0842e8b1c7a1b3fbf5941433';

/// Devices with Spotify open that are not hidden and not already a speaker from Home Assistant (speakers show up in
/// both). Only polled while [visible], i.e. while the music page is on screen.

@ProviderFor(connectTargets)
final connectTargetsProvider = ConnectTargetsFamily._();

/// Devices with Spotify open that are not hidden and not already a speaker from Home Assistant (speakers show up in
/// both). Only polled while [visible], i.e. while the music page is on screen.

final class ConnectTargetsProvider
    extends $FunctionalProvider<List<ConnectTarget>, List<ConnectTarget>, List<ConnectTarget>>
    with $Provider<List<ConnectTarget>> {
  /// Devices with Spotify open that are not hidden and not already a speaker from Home Assistant (speakers show up in
  /// both). Only polled while [visible], i.e. while the music page is on screen.
  ConnectTargetsProvider._({required ConnectTargetsFamily super.from, required bool super.argument})
    : super(
        retry: null,
        name: r'connectTargetsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$connectTargetsHash();

  @override
  String toString() {
    return r'connectTargetsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<ConnectTarget>> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  List<ConnectTarget> create(Ref ref) {
    final argument = this.argument as bool;
    return connectTargets(ref, visible: argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<ConnectTarget> value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<List<ConnectTarget>>(value));
  }

  @override
  bool operator ==(Object other) {
    return other is ConnectTargetsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$connectTargetsHash() => r'67e625dd75a14d59031d696dd0276cc91c34e036';

/// Devices with Spotify open that are not hidden and not already a speaker from Home Assistant (speakers show up in
/// both). Only polled while [visible], i.e. while the music page is on screen.

final class ConnectTargetsFamily extends $Family with $FunctionalFamilyOverride<List<ConnectTarget>, bool> {
  ConnectTargetsFamily._()
    : super(
        retry: null,
        name: r'connectTargetsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Devices with Spotify open that are not hidden and not already a speaker from Home Assistant (speakers show up in
  /// both). Only polled while [visible], i.e. while the music page is on screen.

  ConnectTargetsProvider call({required bool visible}) => ConnectTargetsProvider._(argument: visible, from: this);

  @override
  String toString() => r'connectTargetsProvider';
}

/// Every place music can play: speakers first, then Spotify devices. The order stays put while playback changes, so
/// nothing moves under the finger.

@ProviderFor(playbackTargets)
final playbackTargetsProvider = PlaybackTargetsFamily._();

/// Every place music can play: speakers first, then Spotify devices. The order stays put while playback changes, so
/// nothing moves under the finger.

final class PlaybackTargetsProvider
    extends $FunctionalProvider<List<PlaybackTarget>, List<PlaybackTarget>, List<PlaybackTarget>>
    with $Provider<List<PlaybackTarget>> {
  /// Every place music can play: speakers first, then Spotify devices. The order stays put while playback changes, so
  /// nothing moves under the finger.
  PlaybackTargetsProvider._({required PlaybackTargetsFamily super.from, required bool super.argument})
    : super(
        retry: null,
        name: r'playbackTargetsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playbackTargetsHash();

  @override
  String toString() {
    return r'playbackTargetsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<PlaybackTarget>> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  List<PlaybackTarget> create(Ref ref) {
    final argument = this.argument as bool;
    return playbackTargets(ref, visible: argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<PlaybackTarget> value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<List<PlaybackTarget>>(value));
  }

  @override
  bool operator ==(Object other) {
    return other is PlaybackTargetsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$playbackTargetsHash() => r'7e6c12650e8adb0699feb6d1135429cbe2133ab3';

/// Every place music can play: speakers first, then Spotify devices. The order stays put while playback changes, so
/// nothing moves under the finger.

final class PlaybackTargetsFamily extends $Family with $FunctionalFamilyOverride<List<PlaybackTarget>, bool> {
  PlaybackTargetsFamily._()
    : super(
        retry: null,
        name: r'playbackTargetsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Every place music can play: speakers first, then Spotify devices. The order stays put while playback changes, so
  /// nothing moves under the finger.

  PlaybackTargetsProvider call({required bool visible}) => PlaybackTargetsProvider._(argument: visible, from: this);

  @override
  String toString() => r'playbackTargetsProvider';
}

/// The target shown in "Now playing". Music plays in one place only, so a target that plays wins: when music
/// starts somewhere else (e.g. from the laptop), the card follows it. Without anything playing it is the selected
/// one, otherwise the one shown before, otherwise the default speaker.
///
/// Right after a target is selected it stays for [selectionHold], while music moves there and the old place still
/// reports playing. Pausing never swaps the card.

@ProviderFor(CurrentTarget)
final currentTargetProvider = CurrentTargetFamily._();

/// The target shown in "Now playing". Music plays in one place only, so a target that plays wins: when music
/// starts somewhere else (e.g. from the laptop), the card follows it. Without anything playing it is the selected
/// one, otherwise the one shown before, otherwise the default speaker.
///
/// Right after a target is selected it stays for [selectionHold], while music moves there and the old place still
/// reports playing. Pausing never swaps the card.
final class CurrentTargetProvider extends $NotifierProvider<CurrentTarget, PlaybackTarget?> {
  /// The target shown in "Now playing". Music plays in one place only, so a target that plays wins: when music
  /// starts somewhere else (e.g. from the laptop), the card follows it. Without anything playing it is the selected
  /// one, otherwise the one shown before, otherwise the default speaker.
  ///
  /// Right after a target is selected it stays for [selectionHold], while music moves there and the old place still
  /// reports playing. Pausing never swaps the card.
  CurrentTargetProvider._({required CurrentTargetFamily super.from, required bool super.argument})
    : super(
        retry: null,
        name: r'currentTargetProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentTargetHash();

  @override
  String toString() {
    return r'currentTargetProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  CurrentTarget create() => CurrentTarget();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlaybackTarget? value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<PlaybackTarget?>(value));
  }

  @override
  bool operator ==(Object other) {
    return other is CurrentTargetProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$currentTargetHash() => r'02f44db40ba2c0a3717132a8d9aec449d4d2c9ea';

/// The target shown in "Now playing". Music plays in one place only, so a target that plays wins: when music
/// starts somewhere else (e.g. from the laptop), the card follows it. Without anything playing it is the selected
/// one, otherwise the one shown before, otherwise the default speaker.
///
/// Right after a target is selected it stays for [selectionHold], while music moves there and the old place still
/// reports playing. Pausing never swaps the card.

final class CurrentTargetFamily extends $Family
    with $ClassFamilyOverride<CurrentTarget, PlaybackTarget?, PlaybackTarget?, PlaybackTarget?, bool> {
  CurrentTargetFamily._()
    : super(
        retry: null,
        name: r'currentTargetProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The target shown in "Now playing". Music plays in one place only, so a target that plays wins: when music
  /// starts somewhere else (e.g. from the laptop), the card follows it. Without anything playing it is the selected
  /// one, otherwise the one shown before, otherwise the default speaker.
  ///
  /// Right after a target is selected it stays for [selectionHold], while music moves there and the old place still
  /// reports playing. Pausing never swaps the card.

  CurrentTargetProvider call({required bool visible}) => CurrentTargetProvider._(argument: visible, from: this);

  @override
  String toString() => r'currentTargetProvider';
}

/// The target shown in "Now playing". Music plays in one place only, so a target that plays wins: when music
/// starts somewhere else (e.g. from the laptop), the card follows it. Without anything playing it is the selected
/// one, otherwise the one shown before, otherwise the default speaker.
///
/// Right after a target is selected it stays for [selectionHold], while music moves there and the old place still
/// reports playing. Pausing never swaps the card.

abstract class _$CurrentTarget extends $Notifier<PlaybackTarget?> {
  late final _$args = ref.$arg as bool;
  bool get visible => _$args;

  PlaybackTarget? build({required bool visible});
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<PlaybackTarget?, PlaybackTarget?>;
    final element =
        ref.element
            as $ClassProviderElement<AnyNotifier<PlaybackTarget?, PlaybackTarget?>, PlaybackTarget?, Object?, Object?>;
    return element.handleCreate(ref, () => build(visible: _$args));
  }
}

/// The track after the current one in the active target's queue, e.g. to load its cover ahead of time.

@ProviderFor(upNext)
final upNextProvider = UpNextFamily._();

/// The track after the current one in the active target's queue, e.g. to load its cover ahead of time.

final class UpNextProvider extends $FunctionalProvider<QueueItem?, QueueItem?, QueueItem?> with $Provider<QueueItem?> {
  /// The track after the current one in the active target's queue, e.g. to load its cover ahead of time.
  UpNextProvider._({required UpNextFamily super.from, required bool super.argument})
    : super(
        retry: null,
        name: r'upNextProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$upNextHash();

  @override
  String toString() {
    return r'upNextProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<QueueItem?> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  QueueItem? create(Ref ref) {
    final argument = this.argument as bool;
    return upNext(ref, visible: argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(QueueItem? value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<QueueItem?>(value));
  }

  @override
  bool operator ==(Object other) {
    return other is UpNextProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$upNextHash() => r'd021feb0134ea9a8fb6ebe745b1ce29801600c48';

/// The track after the current one in the active target's queue, e.g. to load its cover ahead of time.

final class UpNextFamily extends $Family with $FunctionalFamilyOverride<QueueItem?, bool> {
  UpNextFamily._()
    : super(
        retry: null,
        name: r'upNextProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The track after the current one in the active target's queue, e.g. to load its cover ahead of time.

  UpNextProvider call({required bool visible}) => UpNextProvider._(argument: visible, from: this);

  @override
  String toString() => r'upNextProvider';
}

/// The color of the music area: the cover's, paler while nothing plays.

@ProviderFor(musicTint)
final musicTintProvider = MusicTintFamily._();

/// The color of the music area: the cover's, paler while nothing plays.

final class MusicTintProvider extends $FunctionalProvider<Color, Color, Color> with $Provider<Color> {
  /// The color of the music area: the cover's, paler while nothing plays.
  MusicTintProvider._({required MusicTintFamily super.from, required bool super.argument})
    : super(
        retry: null,
        name: r'musicTintProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$musicTintHash();

  @override
  String toString() {
    return r'musicTintProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Color> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  Color create(Ref ref) {
    final argument = this.argument as bool;
    return musicTint(ref, visible: argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Color value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<Color>(value));
  }

  @override
  bool operator ==(Object other) {
    return other is MusicTintProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$musicTintHash() => r'e0aac7ea9a3a006a217b8d434084bc4bc4018272';

/// The color of the music area: the cover's, paler while nothing plays.

final class MusicTintFamily extends $Family with $FunctionalFamilyOverride<Color, bool> {
  MusicTintFamily._()
    : super(
        retry: null,
        name: r'musicTintProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The color of the music area: the cover's, paler while nothing plays.

  MusicTintProvider call({required bool visible}) => MusicTintProvider._(argument: visible, from: this);

  @override
  String toString() => r'musicTintProvider';
}
