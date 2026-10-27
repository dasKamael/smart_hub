// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plant.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Plant {

 String get id; String get name;/// Watering interval in days, at least 1.
 int get everyDays; DateTime get lastWatered;/// The watering before [lastWatered], kept to undo a watering on the same day.
 DateTime? get previousWatered;/// Photo in the app's documents directory.
 String? get photoPath;/// Weeks between fertilizing in the growing season; `null` = not fertilized.
 int? get fertilizeEveryWeeks; DateTime? get lastFertilized;
/// Create a copy of Plant
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlantCopyWith<Plant> get copyWith => _$PlantCopyWithImpl<Plant>(this as Plant, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Plant;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Plant&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.everyDays, _this.everyDays) || other.everyDays == _this.everyDays)&&(identical(other.lastWatered, _this.lastWatered) || other.lastWatered == _this.lastWatered)&&(identical(other.previousWatered, _this.previousWatered) || other.previousWatered == _this.previousWatered)&&(identical(other.photoPath, _this.photoPath) || other.photoPath == _this.photoPath)&&(identical(other.fertilizeEveryWeeks, _this.fertilizeEveryWeeks) || other.fertilizeEveryWeeks == _this.fertilizeEveryWeeks)&&(identical(other.lastFertilized, _this.lastFertilized) || other.lastFertilized == _this.lastFertilized));
}


@override
int get hashCode {
  final _this = this as Plant;
  return Object.hash(runtimeType,_this.id,_this.name,_this.everyDays,_this.lastWatered,_this.previousWatered,_this.photoPath,_this.fertilizeEveryWeeks,_this.lastFertilized);
}

@override
String toString() {
  final _this = this as Plant;
  return 'Plant(id: ${_this.id}, name: ${_this.name}, everyDays: ${_this.everyDays}, lastWatered: ${_this.lastWatered}, previousWatered: ${_this.previousWatered}, photoPath: ${_this.photoPath}, fertilizeEveryWeeks: ${_this.fertilizeEveryWeeks}, lastFertilized: ${_this.lastFertilized})';
}


}

/// @nodoc
abstract mixin class $PlantCopyWith<$Res>  {
  factory $PlantCopyWith(Plant value, $Res Function(Plant) _then) = _$PlantCopyWithImpl;
@useResult
$Res call({
 String id, String name, int everyDays, DateTime lastWatered, DateTime? previousWatered, String? photoPath, int? fertilizeEveryWeeks, DateTime? lastFertilized
});




}
/// @nodoc
class _$PlantCopyWithImpl<$Res>
    implements $PlantCopyWith<$Res> {
  _$PlantCopyWithImpl(this._self, this._then);

  final Plant _self;
  final $Res Function(Plant) _then;

/// Create a copy of Plant
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? everyDays = null,Object? lastWatered = null,Object? previousWatered = freezed,Object? photoPath = freezed,Object? fertilizeEveryWeeks = freezed,Object? lastFertilized = freezed,}) {
  return _then(Plant(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,everyDays: null == everyDays ? _self.everyDays : everyDays // ignore: cast_nullable_to_non_nullable
as int,lastWatered: null == lastWatered ? _self.lastWatered : lastWatered // ignore: cast_nullable_to_non_nullable
as DateTime,previousWatered: freezed == previousWatered ? _self.previousWatered : previousWatered // ignore: cast_nullable_to_non_nullable
as DateTime?,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,fertilizeEveryWeeks: freezed == fertilizeEveryWeeks ? _self.fertilizeEveryWeeks : fertilizeEveryWeeks // ignore: cast_nullable_to_non_nullable
as int?,lastFertilized: freezed == lastFertilized ? _self.lastFertilized : lastFertilized // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Plant].
extension PlantPatterns on Plant {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Plant value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Plant() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Plant value)  $default,){
final _that = this;
switch (_that) {
case _Plant():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Plant value)?  $default,){
final _that = this;
switch (_that) {
case _Plant() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int everyDays,  DateTime lastWatered,  DateTime? previousWatered,  String? photoPath,  int? fertilizeEveryWeeks,  DateTime? lastFertilized)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Plant() when $default != null:
return $default(_that.id,_that.name,_that.everyDays,_that.lastWatered,_that.previousWatered,_that.photoPath,_that.fertilizeEveryWeeks,_that.lastFertilized);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int everyDays,  DateTime lastWatered,  DateTime? previousWatered,  String? photoPath,  int? fertilizeEveryWeeks,  DateTime? lastFertilized)  $default,) {final _that = this;
switch (_that) {
case _Plant():
return $default(_that.id,_that.name,_that.everyDays,_that.lastWatered,_that.previousWatered,_that.photoPath,_that.fertilizeEveryWeeks,_that.lastFertilized);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int everyDays,  DateTime lastWatered,  DateTime? previousWatered,  String? photoPath,  int? fertilizeEveryWeeks,  DateTime? lastFertilized)?  $default,) {final _that = this;
switch (_that) {
case _Plant() when $default != null:
return $default(_that.id,_that.name,_that.everyDays,_that.lastWatered,_that.previousWatered,_that.photoPath,_that.fertilizeEveryWeeks,_that.lastFertilized);case _:
  return null;

}
}

}

/// @nodoc


class _Plant implements Plant {
  const _Plant({required this.id, required this.name, required this.everyDays, required this.lastWatered, this.previousWatered, this.photoPath, this.fertilizeEveryWeeks, this.lastFertilized});
  

@override final  String id;
@override final  String name;
/// Watering interval in days, at least 1.
@override final  int everyDays;
@override final  DateTime lastWatered;
/// The watering before [lastWatered], kept to undo a watering on the same day.
@override final  DateTime? previousWatered;
/// Photo in the app's documents directory.
@override final  String? photoPath;
/// Weeks between fertilizing in the growing season; `null` = not fertilized.
@override final  int? fertilizeEveryWeeks;
@override final  DateTime? lastFertilized;

/// Create a copy of Plant
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlantCopyWith<_Plant> get copyWith => __$PlantCopyWithImpl<_Plant>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Plant&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.everyDays, everyDays) || other.everyDays == everyDays)&&(identical(other.lastWatered, lastWatered) || other.lastWatered == lastWatered)&&(identical(other.previousWatered, previousWatered) || other.previousWatered == previousWatered)&&(identical(other.photoPath, photoPath) || other.photoPath == photoPath)&&(identical(other.fertilizeEveryWeeks, fertilizeEveryWeeks) || other.fertilizeEveryWeeks == fertilizeEveryWeeks)&&(identical(other.lastFertilized, lastFertilized) || other.lastFertilized == lastFertilized));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,everyDays,lastWatered,previousWatered,photoPath,fertilizeEveryWeeks,lastFertilized);
}

@override
String toString() {
    return 'Plant(id: $id, name: $name, everyDays: $everyDays, lastWatered: $lastWatered, previousWatered: $previousWatered, photoPath: $photoPath, fertilizeEveryWeeks: $fertilizeEveryWeeks, lastFertilized: $lastFertilized)';
}


}

/// @nodoc
abstract mixin class _$PlantCopyWith<$Res> implements $PlantCopyWith<$Res> {
  factory _$PlantCopyWith(_Plant value, $Res Function(_Plant) _then) = __$PlantCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int everyDays, DateTime lastWatered, DateTime? previousWatered, String? photoPath, int? fertilizeEveryWeeks, DateTime? lastFertilized
});




}
/// @nodoc
class __$PlantCopyWithImpl<$Res>
    implements _$PlantCopyWith<$Res> {
  __$PlantCopyWithImpl(this._self, this._then);

  final _Plant _self;
  final $Res Function(_Plant) _then;

/// Create a copy of Plant
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? everyDays = null,Object? lastWatered = null,Object? previousWatered = freezed,Object? photoPath = freezed,Object? fertilizeEveryWeeks = freezed,Object? lastFertilized = freezed,}) {
  return _then(_Plant(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,everyDays: null == everyDays ? _self.everyDays : everyDays // ignore: cast_nullable_to_non_nullable
as int,lastWatered: null == lastWatered ? _self.lastWatered : lastWatered // ignore: cast_nullable_to_non_nullable
as DateTime,previousWatered: freezed == previousWatered ? _self.previousWatered : previousWatered // ignore: cast_nullable_to_non_nullable
as DateTime?,photoPath: freezed == photoPath ? _self.photoPath : photoPath // ignore: cast_nullable_to_non_nullable
as String?,fertilizeEveryWeeks: freezed == fertilizeEveryWeeks ? _self.fertilizeEveryWeeks : fertilizeEveryWeeks // ignore: cast_nullable_to_non_nullable
as int?,lastFertilized: freezed == lastFertilized ? _self.lastFertilized : lastFertilized // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
