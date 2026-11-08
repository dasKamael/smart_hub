// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'floorplan_editor.controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The floor plan editor: tools, selection, drawing and dragging, undo / redo. Every change is saved at once.
///
/// Positions come in plan centimeters. [cmPerPx] tells how many centimeters one pixel is at the current zoom, so
/// touch radii stay the same on screen.

@ProviderFor(FloorplanEditorController)
final floorplanEditorControllerProvider = FloorplanEditorControllerProvider._();

/// The floor plan editor: tools, selection, drawing and dragging, undo / redo. Every change is saved at once.
///
/// Positions come in plan centimeters. [cmPerPx] tells how many centimeters one pixel is at the current zoom, so
/// touch radii stay the same on screen.
final class FloorplanEditorControllerProvider
    extends $NotifierProvider<FloorplanEditorController, FloorplanEditorState> {
  /// The floor plan editor: tools, selection, drawing and dragging, undo / redo. Every change is saved at once.
  ///
  /// Positions come in plan centimeters. [cmPerPx] tells how many centimeters one pixel is at the current zoom, so
  /// touch radii stay the same on screen.
  FloorplanEditorControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'floorplanEditorControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$floorplanEditorControllerHash();

  @$internal
  @override
  FloorplanEditorController create() => FloorplanEditorController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FloorplanEditorState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FloorplanEditorState>(value),
    );
  }
}

String _$floorplanEditorControllerHash() =>
    r'49cefcda3805b1c074ab0b5138a28f563f5c8040';

/// The floor plan editor: tools, selection, drawing and dragging, undo / redo. Every change is saved at once.
///
/// Positions come in plan centimeters. [cmPerPx] tells how many centimeters one pixel is at the current zoom, so
/// touch radii stay the same on screen.

abstract class _$FloorplanEditorController
    extends $Notifier<FloorplanEditorState> {
  FloorplanEditorState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<FloorplanEditorState, FloorplanEditorState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FloorplanEditorState, FloorplanEditorState>,
              FloorplanEditorState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
