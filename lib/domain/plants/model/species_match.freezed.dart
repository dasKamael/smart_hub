// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'species_match.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SpeciesMatch {

 int get id; String get commonName; String? get scientificName; String? get thumbnailUrl;/// Care data of this species is part of the free plan of the plant database.
 bool get available;
/// Create a copy of SpeciesMatch
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpeciesMatchCopyWith<SpeciesMatch> get copyWith => _$SpeciesMatchCopyWithImpl<SpeciesMatch>(this as SpeciesMatch, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SpeciesMatch;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpeciesMatch&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.commonName, _this.commonName) || other.commonName == _this.commonName)&&(identical(other.scientificName, _this.scientificName) || other.scientificName == _this.scientificName)&&(identical(other.thumbnailUrl, _this.thumbnailUrl) || other.thumbnailUrl == _this.thumbnailUrl)&&(identical(other.available, _this.available) || other.available == _this.available));
}


@override
int get hashCode {
  final _this = this as SpeciesMatch;
  return Object.hash(runtimeType,_this.id,_this.commonName,_this.scientificName,_this.thumbnailUrl,_this.available);
}

@override
String toString() {
  final _this = this as SpeciesMatch;
  return 'SpeciesMatch(id: ${_this.id}, commonName: ${_this.commonName}, scientificName: ${_this.scientificName}, thumbnailUrl: ${_this.thumbnailUrl}, available: ${_this.available})';
}


}

/// @nodoc
abstract mixin class $SpeciesMatchCopyWith<$Res>  {
  factory $SpeciesMatchCopyWith(SpeciesMatch value, $Res Function(SpeciesMatch) _then) = _$SpeciesMatchCopyWithImpl;
@useResult
$Res call({
 int id, String commonName, String? scientificName, String? thumbnailUrl, bool available
});




}
/// @nodoc
class _$SpeciesMatchCopyWithImpl<$Res>
    implements $SpeciesMatchCopyWith<$Res> {
  _$SpeciesMatchCopyWithImpl(this._self, this._then);

  final SpeciesMatch _self;
  final $Res Function(SpeciesMatch) _then;

/// Create a copy of SpeciesMatch
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? commonName = null,Object? scientificName = freezed,Object? thumbnailUrl = freezed,Object? available = null,}) {
  return _then(SpeciesMatch(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,commonName: null == commonName ? _self.commonName : commonName // ignore: cast_nullable_to_non_nullable
as String,scientificName: freezed == scientificName ? _self.scientificName : scientificName // ignore: cast_nullable_to_non_nullable
as String?,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SpeciesMatch].
extension SpeciesMatchPatterns on SpeciesMatch {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpeciesMatch value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpeciesMatch() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpeciesMatch value)  $default,){
final _that = this;
switch (_that) {
case _SpeciesMatch():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpeciesMatch value)?  $default,){
final _that = this;
switch (_that) {
case _SpeciesMatch() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String commonName,  String? scientificName,  String? thumbnailUrl,  bool available)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpeciesMatch() when $default != null:
return $default(_that.id,_that.commonName,_that.scientificName,_that.thumbnailUrl,_that.available);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String commonName,  String? scientificName,  String? thumbnailUrl,  bool available)  $default,) {final _that = this;
switch (_that) {
case _SpeciesMatch():
return $default(_that.id,_that.commonName,_that.scientificName,_that.thumbnailUrl,_that.available);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String commonName,  String? scientificName,  String? thumbnailUrl,  bool available)?  $default,) {final _that = this;
switch (_that) {
case _SpeciesMatch() when $default != null:
return $default(_that.id,_that.commonName,_that.scientificName,_that.thumbnailUrl,_that.available);case _:
  return null;

}
}

}

/// @nodoc


class _SpeciesMatch implements SpeciesMatch {
  const _SpeciesMatch({required this.id, required this.commonName, this.scientificName, this.thumbnailUrl, this.available = true});
  

@override final  int id;
@override final  String commonName;
@override final  String? scientificName;
@override final  String? thumbnailUrl;
/// Care data of this species is part of the free plan of the plant database.
@override@JsonKey() final  bool available;

/// Create a copy of SpeciesMatch
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpeciesMatchCopyWith<_SpeciesMatch> get copyWith => __$SpeciesMatchCopyWithImpl<_SpeciesMatch>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpeciesMatch&&(identical(other.id, id) || other.id == id)&&(identical(other.commonName, commonName) || other.commonName == commonName)&&(identical(other.scientificName, scientificName) || other.scientificName == scientificName)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.available, available) || other.available == available));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,commonName,scientificName,thumbnailUrl,available);
}

@override
String toString() {
    return 'SpeciesMatch(id: $id, commonName: $commonName, scientificName: $scientificName, thumbnailUrl: $thumbnailUrl, available: $available)';
}


}

/// @nodoc
abstract mixin class _$SpeciesMatchCopyWith<$Res> implements $SpeciesMatchCopyWith<$Res> {
  factory _$SpeciesMatchCopyWith(_SpeciesMatch value, $Res Function(_SpeciesMatch) _then) = __$SpeciesMatchCopyWithImpl;
@override @useResult
$Res call({
 int id, String commonName, String? scientificName, String? thumbnailUrl, bool available
});




}
/// @nodoc
class __$SpeciesMatchCopyWithImpl<$Res>
    implements _$SpeciesMatchCopyWith<$Res> {
  __$SpeciesMatchCopyWithImpl(this._self, this._then);

  final _SpeciesMatch _self;
  final $Res Function(_SpeciesMatch) _then;

/// Create a copy of SpeciesMatch
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? commonName = null,Object? scientificName = freezed,Object? thumbnailUrl = freezed,Object? available = null,}) {
  return _then(_SpeciesMatch(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,commonName: null == commonName ? _self.commonName : commonName // ignore: cast_nullable_to_non_nullable
as String,scientificName: freezed == scientificName ? _self.scientificName : scientificName // ignore: cast_nullable_to_non_nullable
as String?,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
