// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard.state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DashboardPageState {

 bool get editing;/// The widget under the finger.
 String? get draggedId;/// Where the dragged widget's top left was when the drag started, and how far it moved since.
 Offset get dragOrigin; Offset get dragOffset;/// Order of the widgets while dragging; others make room as the finger moves.
 List<String>? get order;/// The widget whose size is being dragged, how far its corner moved, and the size it would snap to.
 String? get resizedId; Offset get resizeDelta; DashboardWidgetSize? get resizeTo;
/// Create a copy of DashboardPageState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardPageStateCopyWith<DashboardPageState> get copyWith => _$DashboardPageStateCopyWithImpl<DashboardPageState>(this as DashboardPageState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DashboardPageState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardPageState&&(identical(other.editing, _this.editing) || other.editing == _this.editing)&&(identical(other.draggedId, _this.draggedId) || other.draggedId == _this.draggedId)&&(identical(other.dragOrigin, _this.dragOrigin) || other.dragOrigin == _this.dragOrigin)&&(identical(other.dragOffset, _this.dragOffset) || other.dragOffset == _this.dragOffset)&&const DeepCollectionEquality().equals(other.order, _this.order)&&(identical(other.resizedId, _this.resizedId) || other.resizedId == _this.resizedId)&&(identical(other.resizeDelta, _this.resizeDelta) || other.resizeDelta == _this.resizeDelta)&&(identical(other.resizeTo, _this.resizeTo) || other.resizeTo == _this.resizeTo));
}


@override
int get hashCode {
  final _this = this as DashboardPageState;
  return Object.hash(runtimeType,_this.editing,_this.draggedId,_this.dragOrigin,_this.dragOffset,const DeepCollectionEquality().hash(_this.order),_this.resizedId,_this.resizeDelta,_this.resizeTo);
}

@override
String toString() {
  final _this = this as DashboardPageState;
  return 'DashboardPageState(editing: ${_this.editing}, draggedId: ${_this.draggedId}, dragOrigin: ${_this.dragOrigin}, dragOffset: ${_this.dragOffset}, order: ${_this.order}, resizedId: ${_this.resizedId}, resizeDelta: ${_this.resizeDelta}, resizeTo: ${_this.resizeTo})';
}


}

/// @nodoc
abstract mixin class $DashboardPageStateCopyWith<$Res>  {
  factory $DashboardPageStateCopyWith(DashboardPageState value, $Res Function(DashboardPageState) _then) = _$DashboardPageStateCopyWithImpl;
@useResult
$Res call({
 bool editing, String? draggedId, Offset dragOrigin, Offset dragOffset, List<String>? order, String? resizedId, Offset resizeDelta, DashboardWidgetSize? resizeTo
});




}
/// @nodoc
class _$DashboardPageStateCopyWithImpl<$Res>
    implements $DashboardPageStateCopyWith<$Res> {
  _$DashboardPageStateCopyWithImpl(this._self, this._then);

  final DashboardPageState _self;
  final $Res Function(DashboardPageState) _then;

/// Create a copy of DashboardPageState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? editing = null,Object? draggedId = freezed,Object? dragOrigin = null,Object? dragOffset = null,Object? order = freezed,Object? resizedId = freezed,Object? resizeDelta = null,Object? resizeTo = freezed,}) {
  return _then(DashboardPageState(
editing: null == editing ? _self.editing : editing // ignore: cast_nullable_to_non_nullable
as bool,draggedId: freezed == draggedId ? _self.draggedId : draggedId // ignore: cast_nullable_to_non_nullable
as String?,dragOrigin: null == dragOrigin ? _self.dragOrigin : dragOrigin // ignore: cast_nullable_to_non_nullable
as Offset,dragOffset: null == dragOffset ? _self.dragOffset : dragOffset // ignore: cast_nullable_to_non_nullable
as Offset,order: freezed == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as List<String>?,resizedId: freezed == resizedId ? _self.resizedId : resizedId // ignore: cast_nullable_to_non_nullable
as String?,resizeDelta: null == resizeDelta ? _self.resizeDelta : resizeDelta // ignore: cast_nullable_to_non_nullable
as Offset,resizeTo: freezed == resizeTo ? _self.resizeTo : resizeTo // ignore: cast_nullable_to_non_nullable
as DashboardWidgetSize?,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardPageState].
extension DashboardPageStatePatterns on DashboardPageState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardPageState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardPageState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardPageState value)  $default,){
final _that = this;
switch (_that) {
case _DashboardPageState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardPageState value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardPageState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool editing,  String? draggedId,  Offset dragOrigin,  Offset dragOffset,  List<String>? order,  String? resizedId,  Offset resizeDelta,  DashboardWidgetSize? resizeTo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardPageState() when $default != null:
return $default(_that.editing,_that.draggedId,_that.dragOrigin,_that.dragOffset,_that.order,_that.resizedId,_that.resizeDelta,_that.resizeTo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool editing,  String? draggedId,  Offset dragOrigin,  Offset dragOffset,  List<String>? order,  String? resizedId,  Offset resizeDelta,  DashboardWidgetSize? resizeTo)  $default,) {final _that = this;
switch (_that) {
case _DashboardPageState():
return $default(_that.editing,_that.draggedId,_that.dragOrigin,_that.dragOffset,_that.order,_that.resizedId,_that.resizeDelta,_that.resizeTo);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool editing,  String? draggedId,  Offset dragOrigin,  Offset dragOffset,  List<String>? order,  String? resizedId,  Offset resizeDelta,  DashboardWidgetSize? resizeTo)?  $default,) {final _that = this;
switch (_that) {
case _DashboardPageState() when $default != null:
return $default(_that.editing,_that.draggedId,_that.dragOrigin,_that.dragOffset,_that.order,_that.resizedId,_that.resizeDelta,_that.resizeTo);case _:
  return null;

}
}

}

/// @nodoc


class _DashboardPageState implements DashboardPageState {
  const _DashboardPageState({this.editing = false, this.draggedId, this.dragOrigin = Offset.zero, this.dragOffset = Offset.zero,  List<String>? order, this.resizedId, this.resizeDelta = Offset.zero, this.resizeTo}): _order = order;
  

@override@JsonKey() final  bool editing;
/// The widget under the finger.
@override final  String? draggedId;
/// Where the dragged widget's top left was when the drag started, and how far it moved since.
@override@JsonKey() final  Offset dragOrigin;
@override@JsonKey() final  Offset dragOffset;
/// Order of the widgets while dragging; others make room as the finger moves.
 final  List<String>? _order;
/// Order of the widgets while dragging; others make room as the finger moves.
@override List<String>? get order {
  final value = _order;
  if (value == null) return null;
  if (_order is EqualUnmodifiableListView) return _order;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

/// The widget whose size is being dragged, how far its corner moved, and the size it would snap to.
@override final  String? resizedId;
@override@JsonKey() final  Offset resizeDelta;
@override final  DashboardWidgetSize? resizeTo;

/// Create a copy of DashboardPageState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardPageStateCopyWith<_DashboardPageState> get copyWith => __$DashboardPageStateCopyWithImpl<_DashboardPageState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardPageState&&(identical(other.editing, editing) || other.editing == editing)&&(identical(other.draggedId, draggedId) || other.draggedId == draggedId)&&(identical(other.dragOrigin, dragOrigin) || other.dragOrigin == dragOrigin)&&(identical(other.dragOffset, dragOffset) || other.dragOffset == dragOffset)&&const DeepCollectionEquality().equals(other.order, _order)&&(identical(other.resizedId, resizedId) || other.resizedId == resizedId)&&(identical(other.resizeDelta, resizeDelta) || other.resizeDelta == resizeDelta)&&(identical(other.resizeTo, resizeTo) || other.resizeTo == resizeTo));
}


@override
int get hashCode {
    return Object.hash(runtimeType,editing,draggedId,dragOrigin,dragOffset,const DeepCollectionEquality().hash(_order),resizedId,resizeDelta,resizeTo);
}

@override
String toString() {
    return 'DashboardPageState(editing: $editing, draggedId: $draggedId, dragOrigin: $dragOrigin, dragOffset: $dragOffset, order: $order, resizedId: $resizedId, resizeDelta: $resizeDelta, resizeTo: $resizeTo)';
}


}

/// @nodoc
abstract mixin class _$DashboardPageStateCopyWith<$Res> implements $DashboardPageStateCopyWith<$Res> {
  factory _$DashboardPageStateCopyWith(_DashboardPageState value, $Res Function(_DashboardPageState) _then) = __$DashboardPageStateCopyWithImpl;
@override @useResult
$Res call({
 bool editing, String? draggedId, Offset dragOrigin, Offset dragOffset, List<String>? order, String? resizedId, Offset resizeDelta, DashboardWidgetSize? resizeTo
});




}
/// @nodoc
class __$DashboardPageStateCopyWithImpl<$Res>
    implements _$DashboardPageStateCopyWith<$Res> {
  __$DashboardPageStateCopyWithImpl(this._self, this._then);

  final _DashboardPageState _self;
  final $Res Function(_DashboardPageState) _then;

/// Create a copy of DashboardPageState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? editing = null,Object? draggedId = freezed,Object? dragOrigin = null,Object? dragOffset = null,Object? order = freezed,Object? resizedId = freezed,Object? resizeDelta = null,Object? resizeTo = freezed,}) {
  return _then(_DashboardPageState(
editing: null == editing ? _self.editing : editing // ignore: cast_nullable_to_non_nullable
as bool,draggedId: freezed == draggedId ? _self.draggedId : draggedId // ignore: cast_nullable_to_non_nullable
as String?,dragOrigin: null == dragOrigin ? _self.dragOrigin : dragOrigin // ignore: cast_nullable_to_non_nullable
as Offset,dragOffset: null == dragOffset ? _self.dragOffset : dragOffset // ignore: cast_nullable_to_non_nullable
as Offset,order: freezed == order ? _self._order : order // ignore: cast_nullable_to_non_nullable
as List<String>?,resizedId: freezed == resizedId ? _self.resizedId : resizedId // ignore: cast_nullable_to_non_nullable
as String?,resizeDelta: null == resizeDelta ? _self.resizeDelta : resizeDelta // ignore: cast_nullable_to_non_nullable
as Offset,resizeTo: freezed == resizeTo ? _self.resizeTo : resizeTo // ignore: cast_nullable_to_non_nullable
as DashboardWidgetSize?,
  ));
}


}

// dart format on
