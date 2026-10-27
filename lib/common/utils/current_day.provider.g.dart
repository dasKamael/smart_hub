// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_day.provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Today at midnight; emits again right after every midnight, so day based states (e.g. plants due today)
/// update on their own.

@ProviderFor(currentDay)
final currentDayProvider = CurrentDayProvider._();

/// Today at midnight; emits again right after every midnight, so day based states (e.g. plants due today)
/// update on their own.

final class CurrentDayProvider extends $FunctionalProvider<AsyncValue<DateTime>, DateTime, Stream<DateTime>>
    with $FutureModifier<DateTime>, $StreamProvider<DateTime> {
  /// Today at midnight; emits again right after every midnight, so day based states (e.g. plants due today)
  /// update on their own.
  CurrentDayProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentDayProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentDayHash();

  @$internal
  @override
  $StreamProviderElement<DateTime> $createElement($ProviderPointer pointer) => $StreamProviderElement(pointer);

  @override
  Stream<DateTime> create(Ref ref) {
    return currentDay(ref);
  }
}

String _$currentDayHash() => r'008baeff2a554d7c76312ea4cb56804584f7fb1c';
