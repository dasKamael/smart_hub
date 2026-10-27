// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hub_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HubEntity {

/// Stable id, e.g. `light.desk_lamp`.
 String get id;/// Kind of entity, e.g. `light` or `media_player`.
 String get domain;/// Human readable name; falls back to [id].
 String get name;/// Raw state, e.g. `on`, `off`, `playing`, `unavailable`.
 String get state;
/// Create a copy of HubEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HubEntityCopyWith<HubEntity> get copyWith => _$HubEntityCopyWithImpl<HubEntity>(this as HubEntity, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as HubEntity;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HubEntity&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.domain, _this.domain) || other.domain == _this.domain)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.state, _this.state) || other.state == _this.state));
}


@override
int get hashCode {
  final _this = this as HubEntity;
  return Object.hash(runtimeType,_this.id,_this.domain,_this.name,_this.state);
}

@override
String toString() {
  final _this = this as HubEntity;
  return 'HubEntity(id: ${_this.id}, domain: ${_this.domain}, name: ${_this.name}, state: ${_this.state})';
}


}

/// @nodoc
abstract mixin class $HubEntityCopyWith<$Res>  {
  factory $HubEntityCopyWith(HubEntity value, $Res Function(HubEntity) _then) = _$HubEntityCopyWithImpl;
@useResult
$Res call({
 String id, String domain, String name, String state
});




}
/// @nodoc
class _$HubEntityCopyWithImpl<$Res>
    implements $HubEntityCopyWith<$Res> {
  _$HubEntityCopyWithImpl(this._self, this._then);

  final HubEntity _self;
  final $Res Function(HubEntity) _then;

/// Create a copy of HubEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? domain = null,Object? name = null,Object? state = null,}) {
  return _then(HubEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,domain: null == domain ? _self.domain : domain // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [HubEntity].
extension HubEntityPatterns on HubEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HubEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HubEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HubEntity value)  $default,){
final _that = this;
switch (_that) {
case _HubEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HubEntity value)?  $default,){
final _that = this;
switch (_that) {
case _HubEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String domain,  String name,  String state)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HubEntity() when $default != null:
return $default(_that.id,_that.domain,_that.name,_that.state);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String domain,  String name,  String state)  $default,) {final _that = this;
switch (_that) {
case _HubEntity():
return $default(_that.id,_that.domain,_that.name,_that.state);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String domain,  String name,  String state)?  $default,) {final _that = this;
switch (_that) {
case _HubEntity() when $default != null:
return $default(_that.id,_that.domain,_that.name,_that.state);case _:
  return null;

}
}

}

/// @nodoc


class _HubEntity implements HubEntity {
  const _HubEntity({required this.id, required this.domain, required this.name, required this.state});
  

/// Stable id, e.g. `light.desk_lamp`.
@override final  String id;
/// Kind of entity, e.g. `light` or `media_player`.
@override final  String domain;
/// Human readable name; falls back to [id].
@override final  String name;
/// Raw state, e.g. `on`, `off`, `playing`, `unavailable`.
@override final  String state;

/// Create a copy of HubEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HubEntityCopyWith<_HubEntity> get copyWith => __$HubEntityCopyWithImpl<_HubEntity>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HubEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.domain, domain) || other.domain == domain)&&(identical(other.name, name) || other.name == name)&&(identical(other.state, state) || other.state == state));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,domain,name,state);
}

@override
String toString() {
    return 'HubEntity(id: $id, domain: $domain, name: $name, state: $state)';
}


}

/// @nodoc
abstract mixin class _$HubEntityCopyWith<$Res> implements $HubEntityCopyWith<$Res> {
  factory _$HubEntityCopyWith(_HubEntity value, $Res Function(_HubEntity) _then) = __$HubEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String domain, String name, String state
});




}
/// @nodoc
class __$HubEntityCopyWithImpl<$Res>
    implements _$HubEntityCopyWith<$Res> {
  __$HubEntityCopyWithImpl(this._self, this._then);

  final _HubEntity _self;
  final $Res Function(_HubEntity) _then;

/// Create a copy of HubEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? domain = null,Object? name = null,Object? state = null,}) {
  return _then(_HubEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,domain: null == domain ? _self.domain : domain // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
