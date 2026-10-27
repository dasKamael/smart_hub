// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'music.state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MusicPageState {

/// Target shown in "Now playing" (`PlaybackTarget.id`); `null` picks what plays.
 String? get targetId;/// The tile whose options (volume, group) are shown.
 String? get openTileId; LibraryView get libraryView;
/// Create a copy of MusicPageState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MusicPageStateCopyWith<MusicPageState> get copyWith => _$MusicPageStateCopyWithImpl<MusicPageState>(this as MusicPageState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MusicPageState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MusicPageState&&(identical(other.targetId, _this.targetId) || other.targetId == _this.targetId)&&(identical(other.openTileId, _this.openTileId) || other.openTileId == _this.openTileId)&&(identical(other.libraryView, _this.libraryView) || other.libraryView == _this.libraryView));
}


@override
int get hashCode {
  final _this = this as MusicPageState;
  return Object.hash(runtimeType,_this.targetId,_this.openTileId,_this.libraryView);
}

@override
String toString() {
  final _this = this as MusicPageState;
  return 'MusicPageState(targetId: ${_this.targetId}, openTileId: ${_this.openTileId}, libraryView: ${_this.libraryView})';
}


}

/// @nodoc
abstract mixin class $MusicPageStateCopyWith<$Res>  {
  factory $MusicPageStateCopyWith(MusicPageState value, $Res Function(MusicPageState) _then) = _$MusicPageStateCopyWithImpl;
@useResult
$Res call({
 String? targetId, String? openTileId, LibraryView libraryView
});




}
/// @nodoc
class _$MusicPageStateCopyWithImpl<$Res>
    implements $MusicPageStateCopyWith<$Res> {
  _$MusicPageStateCopyWithImpl(this._self, this._then);

  final MusicPageState _self;
  final $Res Function(MusicPageState) _then;

/// Create a copy of MusicPageState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? targetId = freezed,Object? openTileId = freezed,Object? libraryView = null,}) {
  return _then(MusicPageState(
targetId: freezed == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as String?,openTileId: freezed == openTileId ? _self.openTileId : openTileId // ignore: cast_nullable_to_non_nullable
as String?,libraryView: null == libraryView ? _self.libraryView : libraryView // ignore: cast_nullable_to_non_nullable
as LibraryView,
  ));
}

}


/// Adds pattern-matching-related methods to [MusicPageState].
extension MusicPageStatePatterns on MusicPageState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MusicPageState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MusicPageState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MusicPageState value)  $default,){
final _that = this;
switch (_that) {
case _MusicPageState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MusicPageState value)?  $default,){
final _that = this;
switch (_that) {
case _MusicPageState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? targetId,  String? openTileId,  LibraryView libraryView)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MusicPageState() when $default != null:
return $default(_that.targetId,_that.openTileId,_that.libraryView);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? targetId,  String? openTileId,  LibraryView libraryView)  $default,) {final _that = this;
switch (_that) {
case _MusicPageState():
return $default(_that.targetId,_that.openTileId,_that.libraryView);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? targetId,  String? openTileId,  LibraryView libraryView)?  $default,) {final _that = this;
switch (_that) {
case _MusicPageState() when $default != null:
return $default(_that.targetId,_that.openTileId,_that.libraryView);case _:
  return null;

}
}

}

/// @nodoc


class _MusicPageState implements MusicPageState {
  const _MusicPageState({this.targetId, this.openTileId, this.libraryView = LibraryView.recent});
  

/// Target shown in "Now playing" (`PlaybackTarget.id`); `null` picks what plays.
@override final  String? targetId;
/// The tile whose options (volume, group) are shown.
@override final  String? openTileId;
@override@JsonKey() final  LibraryView libraryView;

/// Create a copy of MusicPageState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MusicPageStateCopyWith<_MusicPageState> get copyWith => __$MusicPageStateCopyWithImpl<_MusicPageState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MusicPageState&&(identical(other.targetId, targetId) || other.targetId == targetId)&&(identical(other.openTileId, openTileId) || other.openTileId == openTileId)&&(identical(other.libraryView, libraryView) || other.libraryView == libraryView));
}


@override
int get hashCode {
    return Object.hash(runtimeType,targetId,openTileId,libraryView);
}

@override
String toString() {
    return 'MusicPageState(targetId: $targetId, openTileId: $openTileId, libraryView: $libraryView)';
}


}

/// @nodoc
abstract mixin class _$MusicPageStateCopyWith<$Res> implements $MusicPageStateCopyWith<$Res> {
  factory _$MusicPageStateCopyWith(_MusicPageState value, $Res Function(_MusicPageState) _then) = __$MusicPageStateCopyWithImpl;
@override @useResult
$Res call({
 String? targetId, String? openTileId, LibraryView libraryView
});




}
/// @nodoc
class __$MusicPageStateCopyWithImpl<$Res>
    implements _$MusicPageStateCopyWith<$Res> {
  __$MusicPageStateCopyWithImpl(this._self, this._then);

  final _MusicPageState _self;
  final $Res Function(_MusicPageState) _then;

/// Create a copy of MusicPageState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? targetId = freezed,Object? openTileId = freezed,Object? libraryView = null,}) {
  return _then(_MusicPageState(
targetId: freezed == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as String?,openTileId: freezed == openTileId ? _self.openTileId : openTileId // ignore: cast_nullable_to_non_nullable
as String?,libraryView: null == libraryView ? _self.libraryView : libraryView // ignore: cast_nullable_to_non_nullable
as LibraryView,
  ));
}


}

// dart format on
