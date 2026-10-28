// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'focus_point.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FocusPoint {

 String get id; String get title;/// The day it has to be done.
 DateTime get dueDate; DateTime get createdAt;/// Order in the widget, smallest first.
 int get position; DateTime? get achievedAt;
/// Create a copy of FocusPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FocusPointCopyWith<FocusPoint> get copyWith => _$FocusPointCopyWithImpl<FocusPoint>(this as FocusPoint, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as FocusPoint;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FocusPoint&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.dueDate, _this.dueDate) || other.dueDate == _this.dueDate)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.position, _this.position) || other.position == _this.position)&&(identical(other.achievedAt, _this.achievedAt) || other.achievedAt == _this.achievedAt));
}


@override
int get hashCode {
  final _this = this as FocusPoint;
  return Object.hash(runtimeType,_this.id,_this.title,_this.dueDate,_this.createdAt,_this.position,_this.achievedAt);
}

@override
String toString() {
  final _this = this as FocusPoint;
  return 'FocusPoint(id: ${_this.id}, title: ${_this.title}, dueDate: ${_this.dueDate}, createdAt: ${_this.createdAt}, position: ${_this.position}, achievedAt: ${_this.achievedAt})';
}


}

/// @nodoc
abstract mixin class $FocusPointCopyWith<$Res>  {
  factory $FocusPointCopyWith(FocusPoint value, $Res Function(FocusPoint) _then) = _$FocusPointCopyWithImpl;
@useResult
$Res call({
 String id, String title, DateTime dueDate, DateTime createdAt, int position, DateTime? achievedAt
});




}
/// @nodoc
class _$FocusPointCopyWithImpl<$Res>
    implements $FocusPointCopyWith<$Res> {
  _$FocusPointCopyWithImpl(this._self, this._then);

  final FocusPoint _self;
  final $Res Function(FocusPoint) _then;

/// Create a copy of FocusPoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? dueDate = null,Object? createdAt = null,Object? position = null,Object? achievedAt = freezed,}) {
  return _then(FocusPoint(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,achievedAt: freezed == achievedAt ? _self.achievedAt : achievedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [FocusPoint].
extension FocusPointPatterns on FocusPoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FocusPoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FocusPoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FocusPoint value)  $default,){
final _that = this;
switch (_that) {
case _FocusPoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FocusPoint value)?  $default,){
final _that = this;
switch (_that) {
case _FocusPoint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  DateTime dueDate,  DateTime createdAt,  int position,  DateTime? achievedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FocusPoint() when $default != null:
return $default(_that.id,_that.title,_that.dueDate,_that.createdAt,_that.position,_that.achievedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  DateTime dueDate,  DateTime createdAt,  int position,  DateTime? achievedAt)  $default,) {final _that = this;
switch (_that) {
case _FocusPoint():
return $default(_that.id,_that.title,_that.dueDate,_that.createdAt,_that.position,_that.achievedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  DateTime dueDate,  DateTime createdAt,  int position,  DateTime? achievedAt)?  $default,) {final _that = this;
switch (_that) {
case _FocusPoint() when $default != null:
return $default(_that.id,_that.title,_that.dueDate,_that.createdAt,_that.position,_that.achievedAt);case _:
  return null;

}
}

}

/// @nodoc


class _FocusPoint extends FocusPoint {
  const _FocusPoint({required this.id, required this.title, required this.dueDate, required this.createdAt, this.position = 0, this.achievedAt}): super._();
  

@override final  String id;
@override final  String title;
/// The day it has to be done.
@override final  DateTime dueDate;
@override final  DateTime createdAt;
/// Order in the widget, smallest first.
@override@JsonKey() final  int position;
@override final  DateTime? achievedAt;

/// Create a copy of FocusPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FocusPointCopyWith<_FocusPoint> get copyWith => __$FocusPointCopyWithImpl<_FocusPoint>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FocusPoint&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.position, position) || other.position == position)&&(identical(other.achievedAt, achievedAt) || other.achievedAt == achievedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,title,dueDate,createdAt,position,achievedAt);
}

@override
String toString() {
    return 'FocusPoint(id: $id, title: $title, dueDate: $dueDate, createdAt: $createdAt, position: $position, achievedAt: $achievedAt)';
}


}

/// @nodoc
abstract mixin class _$FocusPointCopyWith<$Res> implements $FocusPointCopyWith<$Res> {
  factory _$FocusPointCopyWith(_FocusPoint value, $Res Function(_FocusPoint) _then) = __$FocusPointCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, DateTime dueDate, DateTime createdAt, int position, DateTime? achievedAt
});




}
/// @nodoc
class __$FocusPointCopyWithImpl<$Res>
    implements _$FocusPointCopyWith<$Res> {
  __$FocusPointCopyWithImpl(this._self, this._then);

  final _FocusPoint _self;
  final $Res Function(_FocusPoint) _then;

/// Create a copy of FocusPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? dueDate = null,Object? createdAt = null,Object? position = null,Object? achievedAt = freezed,}) {
  return _then(_FocusPoint(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,achievedAt: freezed == achievedAt ? _self.achievedAt : achievedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
