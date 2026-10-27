// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plant_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlantProfile {

/// Species in the plant database; `null` for imported profiles.
 int? get speciesId; PlantProfileSource get source; String get commonName; String? get scientificName; String? get imageUrl;/// E.g. "Average".
 String? get watering;/// Typical days between waterings in the growing season, e.g. 7–10.
 int? get wateringMinDays; int? get wateringMaxDays;/// Days between waterings from October to February; `null` when unknown.
 int? get wateringWinterMinDays; int? get wateringWinterMaxDays;/// Weeks between feeding in the growing season, as the source suggests; only imported profiles know it.
 int? get fertilizeEveryWeeks;/// E.g. ["part shade", "full sun"].
 List<String> get sunlight;/// "Low", "Medium" or "High".
 String? get careLevel; bool? get indoor; bool? get poisonousToPets;/// Months in which to prune, e.g. ["March", "April"].
 List<String> get pruningMonths; String? get wateringGuide; String? get sunlightGuide; String? get pruningGuide; DateTime get fetchedAt;
/// Create a copy of PlantProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlantProfileCopyWith<PlantProfile> get copyWith => _$PlantProfileCopyWithImpl<PlantProfile>(this as PlantProfile, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PlantProfile;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlantProfile&&(identical(other.speciesId, _this.speciesId) || other.speciesId == _this.speciesId)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.commonName, _this.commonName) || other.commonName == _this.commonName)&&(identical(other.scientificName, _this.scientificName) || other.scientificName == _this.scientificName)&&(identical(other.imageUrl, _this.imageUrl) || other.imageUrl == _this.imageUrl)&&(identical(other.watering, _this.watering) || other.watering == _this.watering)&&(identical(other.wateringMinDays, _this.wateringMinDays) || other.wateringMinDays == _this.wateringMinDays)&&(identical(other.wateringMaxDays, _this.wateringMaxDays) || other.wateringMaxDays == _this.wateringMaxDays)&&(identical(other.wateringWinterMinDays, _this.wateringWinterMinDays) || other.wateringWinterMinDays == _this.wateringWinterMinDays)&&(identical(other.wateringWinterMaxDays, _this.wateringWinterMaxDays) || other.wateringWinterMaxDays == _this.wateringWinterMaxDays)&&(identical(other.fertilizeEveryWeeks, _this.fertilizeEveryWeeks) || other.fertilizeEveryWeeks == _this.fertilizeEveryWeeks)&&const DeepCollectionEquality().equals(other.sunlight, _this.sunlight)&&(identical(other.careLevel, _this.careLevel) || other.careLevel == _this.careLevel)&&(identical(other.indoor, _this.indoor) || other.indoor == _this.indoor)&&(identical(other.poisonousToPets, _this.poisonousToPets) || other.poisonousToPets == _this.poisonousToPets)&&const DeepCollectionEquality().equals(other.pruningMonths, _this.pruningMonths)&&(identical(other.wateringGuide, _this.wateringGuide) || other.wateringGuide == _this.wateringGuide)&&(identical(other.sunlightGuide, _this.sunlightGuide) || other.sunlightGuide == _this.sunlightGuide)&&(identical(other.pruningGuide, _this.pruningGuide) || other.pruningGuide == _this.pruningGuide)&&(identical(other.fetchedAt, _this.fetchedAt) || other.fetchedAt == _this.fetchedAt));
}


@override
int get hashCode {
  final _this = this as PlantProfile;
  return Object.hashAll([runtimeType,_this.speciesId,_this.source,_this.commonName,_this.scientificName,_this.imageUrl,_this.watering,_this.wateringMinDays,_this.wateringMaxDays,_this.wateringWinterMinDays,_this.wateringWinterMaxDays,_this.fertilizeEveryWeeks,const DeepCollectionEquality().hash(_this.sunlight),_this.careLevel,_this.indoor,_this.poisonousToPets,const DeepCollectionEquality().hash(_this.pruningMonths),_this.wateringGuide,_this.sunlightGuide,_this.pruningGuide,_this.fetchedAt]);
}

@override
String toString() {
  final _this = this as PlantProfile;
  return 'PlantProfile(speciesId: ${_this.speciesId}, source: ${_this.source}, commonName: ${_this.commonName}, scientificName: ${_this.scientificName}, imageUrl: ${_this.imageUrl}, watering: ${_this.watering}, wateringMinDays: ${_this.wateringMinDays}, wateringMaxDays: ${_this.wateringMaxDays}, wateringWinterMinDays: ${_this.wateringWinterMinDays}, wateringWinterMaxDays: ${_this.wateringWinterMaxDays}, fertilizeEveryWeeks: ${_this.fertilizeEveryWeeks}, sunlight: ${_this.sunlight}, careLevel: ${_this.careLevel}, indoor: ${_this.indoor}, poisonousToPets: ${_this.poisonousToPets}, pruningMonths: ${_this.pruningMonths}, wateringGuide: ${_this.wateringGuide}, sunlightGuide: ${_this.sunlightGuide}, pruningGuide: ${_this.pruningGuide}, fetchedAt: ${_this.fetchedAt})';
}


}

/// @nodoc
abstract mixin class $PlantProfileCopyWith<$Res>  {
  factory $PlantProfileCopyWith(PlantProfile value, $Res Function(PlantProfile) _then) = _$PlantProfileCopyWithImpl;
@useResult
$Res call({
 int? speciesId, PlantProfileSource source, String commonName, String? scientificName, String? imageUrl, String? watering, int? wateringMinDays, int? wateringMaxDays, int? wateringWinterMinDays, int? wateringWinterMaxDays, int? fertilizeEveryWeeks, List<String> sunlight, String? careLevel, bool? indoor, bool? poisonousToPets, List<String> pruningMonths, String? wateringGuide, String? sunlightGuide, String? pruningGuide, DateTime fetchedAt
});




}
/// @nodoc
class _$PlantProfileCopyWithImpl<$Res>
    implements $PlantProfileCopyWith<$Res> {
  _$PlantProfileCopyWithImpl(this._self, this._then);

  final PlantProfile _self;
  final $Res Function(PlantProfile) _then;

/// Create a copy of PlantProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? speciesId = freezed,Object? source = null,Object? commonName = null,Object? scientificName = freezed,Object? imageUrl = freezed,Object? watering = freezed,Object? wateringMinDays = freezed,Object? wateringMaxDays = freezed,Object? wateringWinterMinDays = freezed,Object? wateringWinterMaxDays = freezed,Object? fertilizeEveryWeeks = freezed,Object? sunlight = null,Object? careLevel = freezed,Object? indoor = freezed,Object? poisonousToPets = freezed,Object? pruningMonths = null,Object? wateringGuide = freezed,Object? sunlightGuide = freezed,Object? pruningGuide = freezed,Object? fetchedAt = null,}) {
  return _then(PlantProfile(
speciesId: freezed == speciesId ? _self.speciesId : speciesId // ignore: cast_nullable_to_non_nullable
as int?,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as PlantProfileSource,commonName: null == commonName ? _self.commonName : commonName // ignore: cast_nullable_to_non_nullable
as String,scientificName: freezed == scientificName ? _self.scientificName : scientificName // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,watering: freezed == watering ? _self.watering : watering // ignore: cast_nullable_to_non_nullable
as String?,wateringMinDays: freezed == wateringMinDays ? _self.wateringMinDays : wateringMinDays // ignore: cast_nullable_to_non_nullable
as int?,wateringMaxDays: freezed == wateringMaxDays ? _self.wateringMaxDays : wateringMaxDays // ignore: cast_nullable_to_non_nullable
as int?,wateringWinterMinDays: freezed == wateringWinterMinDays ? _self.wateringWinterMinDays : wateringWinterMinDays // ignore: cast_nullable_to_non_nullable
as int?,wateringWinterMaxDays: freezed == wateringWinterMaxDays ? _self.wateringWinterMaxDays : wateringWinterMaxDays // ignore: cast_nullable_to_non_nullable
as int?,fertilizeEveryWeeks: freezed == fertilizeEveryWeeks ? _self.fertilizeEveryWeeks : fertilizeEveryWeeks // ignore: cast_nullable_to_non_nullable
as int?,sunlight: null == sunlight ? _self.sunlight : sunlight // ignore: cast_nullable_to_non_nullable
as List<String>,careLevel: freezed == careLevel ? _self.careLevel : careLevel // ignore: cast_nullable_to_non_nullable
as String?,indoor: freezed == indoor ? _self.indoor : indoor // ignore: cast_nullable_to_non_nullable
as bool?,poisonousToPets: freezed == poisonousToPets ? _self.poisonousToPets : poisonousToPets // ignore: cast_nullable_to_non_nullable
as bool?,pruningMonths: null == pruningMonths ? _self.pruningMonths : pruningMonths // ignore: cast_nullable_to_non_nullable
as List<String>,wateringGuide: freezed == wateringGuide ? _self.wateringGuide : wateringGuide // ignore: cast_nullable_to_non_nullable
as String?,sunlightGuide: freezed == sunlightGuide ? _self.sunlightGuide : sunlightGuide // ignore: cast_nullable_to_non_nullable
as String?,pruningGuide: freezed == pruningGuide ? _self.pruningGuide : pruningGuide // ignore: cast_nullable_to_non_nullable
as String?,fetchedAt: null == fetchedAt ? _self.fetchedAt : fetchedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PlantProfile].
extension PlantProfilePatterns on PlantProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlantProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlantProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlantProfile value)  $default,){
final _that = this;
switch (_that) {
case _PlantProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlantProfile value)?  $default,){
final _that = this;
switch (_that) {
case _PlantProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? speciesId,  PlantProfileSource source,  String commonName,  String? scientificName,  String? imageUrl,  String? watering,  int? wateringMinDays,  int? wateringMaxDays,  int? wateringWinterMinDays,  int? wateringWinterMaxDays,  int? fertilizeEveryWeeks,  List<String> sunlight,  String? careLevel,  bool? indoor,  bool? poisonousToPets,  List<String> pruningMonths,  String? wateringGuide,  String? sunlightGuide,  String? pruningGuide,  DateTime fetchedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlantProfile() when $default != null:
return $default(_that.speciesId,_that.source,_that.commonName,_that.scientificName,_that.imageUrl,_that.watering,_that.wateringMinDays,_that.wateringMaxDays,_that.wateringWinterMinDays,_that.wateringWinterMaxDays,_that.fertilizeEveryWeeks,_that.sunlight,_that.careLevel,_that.indoor,_that.poisonousToPets,_that.pruningMonths,_that.wateringGuide,_that.sunlightGuide,_that.pruningGuide,_that.fetchedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? speciesId,  PlantProfileSource source,  String commonName,  String? scientificName,  String? imageUrl,  String? watering,  int? wateringMinDays,  int? wateringMaxDays,  int? wateringWinterMinDays,  int? wateringWinterMaxDays,  int? fertilizeEveryWeeks,  List<String> sunlight,  String? careLevel,  bool? indoor,  bool? poisonousToPets,  List<String> pruningMonths,  String? wateringGuide,  String? sunlightGuide,  String? pruningGuide,  DateTime fetchedAt)  $default,) {final _that = this;
switch (_that) {
case _PlantProfile():
return $default(_that.speciesId,_that.source,_that.commonName,_that.scientificName,_that.imageUrl,_that.watering,_that.wateringMinDays,_that.wateringMaxDays,_that.wateringWinterMinDays,_that.wateringWinterMaxDays,_that.fertilizeEveryWeeks,_that.sunlight,_that.careLevel,_that.indoor,_that.poisonousToPets,_that.pruningMonths,_that.wateringGuide,_that.sunlightGuide,_that.pruningGuide,_that.fetchedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? speciesId,  PlantProfileSource source,  String commonName,  String? scientificName,  String? imageUrl,  String? watering,  int? wateringMinDays,  int? wateringMaxDays,  int? wateringWinterMinDays,  int? wateringWinterMaxDays,  int? fertilizeEveryWeeks,  List<String> sunlight,  String? careLevel,  bool? indoor,  bool? poisonousToPets,  List<String> pruningMonths,  String? wateringGuide,  String? sunlightGuide,  String? pruningGuide,  DateTime fetchedAt)?  $default,) {final _that = this;
switch (_that) {
case _PlantProfile() when $default != null:
return $default(_that.speciesId,_that.source,_that.commonName,_that.scientificName,_that.imageUrl,_that.watering,_that.wateringMinDays,_that.wateringMaxDays,_that.wateringWinterMinDays,_that.wateringWinterMaxDays,_that.fertilizeEveryWeeks,_that.sunlight,_that.careLevel,_that.indoor,_that.poisonousToPets,_that.pruningMonths,_that.wateringGuide,_that.sunlightGuide,_that.pruningGuide,_that.fetchedAt);case _:
  return null;

}
}

}

/// @nodoc


class _PlantProfile implements PlantProfile {
  const _PlantProfile({this.speciesId, this.source = PlantProfileSource.perenual, required this.commonName, this.scientificName, this.imageUrl, this.watering, this.wateringMinDays, this.wateringMaxDays, this.wateringWinterMinDays, this.wateringWinterMaxDays, this.fertilizeEveryWeeks,  List<String> sunlight = const [], this.careLevel, this.indoor, this.poisonousToPets,  List<String> pruningMonths = const [], this.wateringGuide, this.sunlightGuide, this.pruningGuide, required this.fetchedAt}): _sunlight = sunlight,_pruningMonths = pruningMonths;
  

/// Species in the plant database; `null` for imported profiles.
@override final  int? speciesId;
@override@JsonKey() final  PlantProfileSource source;
@override final  String commonName;
@override final  String? scientificName;
@override final  String? imageUrl;
/// E.g. "Average".
@override final  String? watering;
/// Typical days between waterings in the growing season, e.g. 7–10.
@override final  int? wateringMinDays;
@override final  int? wateringMaxDays;
/// Days between waterings from October to February; `null` when unknown.
@override final  int? wateringWinterMinDays;
@override final  int? wateringWinterMaxDays;
/// Weeks between feeding in the growing season, as the source suggests; only imported profiles know it.
@override final  int? fertilizeEveryWeeks;
/// E.g. ["part shade", "full sun"].
 final  List<String> _sunlight;
/// E.g. ["part shade", "full sun"].
@override@JsonKey() List<String> get sunlight {
  if (_sunlight is EqualUnmodifiableListView) return _sunlight;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sunlight);
}

/// "Low", "Medium" or "High".
@override final  String? careLevel;
@override final  bool? indoor;
@override final  bool? poisonousToPets;
/// Months in which to prune, e.g. ["March", "April"].
 final  List<String> _pruningMonths;
/// Months in which to prune, e.g. ["March", "April"].
@override@JsonKey() List<String> get pruningMonths {
  if (_pruningMonths is EqualUnmodifiableListView) return _pruningMonths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pruningMonths);
}

@override final  String? wateringGuide;
@override final  String? sunlightGuide;
@override final  String? pruningGuide;
@override final  DateTime fetchedAt;

/// Create a copy of PlantProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlantProfileCopyWith<_PlantProfile> get copyWith => __$PlantProfileCopyWithImpl<_PlantProfile>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlantProfile&&(identical(other.speciesId, speciesId) || other.speciesId == speciesId)&&(identical(other.source, source) || other.source == source)&&(identical(other.commonName, commonName) || other.commonName == commonName)&&(identical(other.scientificName, scientificName) || other.scientificName == scientificName)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.watering, watering) || other.watering == watering)&&(identical(other.wateringMinDays, wateringMinDays) || other.wateringMinDays == wateringMinDays)&&(identical(other.wateringMaxDays, wateringMaxDays) || other.wateringMaxDays == wateringMaxDays)&&(identical(other.wateringWinterMinDays, wateringWinterMinDays) || other.wateringWinterMinDays == wateringWinterMinDays)&&(identical(other.wateringWinterMaxDays, wateringWinterMaxDays) || other.wateringWinterMaxDays == wateringWinterMaxDays)&&(identical(other.fertilizeEveryWeeks, fertilizeEveryWeeks) || other.fertilizeEveryWeeks == fertilizeEveryWeeks)&&const DeepCollectionEquality().equals(other.sunlight, _sunlight)&&(identical(other.careLevel, careLevel) || other.careLevel == careLevel)&&(identical(other.indoor, indoor) || other.indoor == indoor)&&(identical(other.poisonousToPets, poisonousToPets) || other.poisonousToPets == poisonousToPets)&&const DeepCollectionEquality().equals(other.pruningMonths, _pruningMonths)&&(identical(other.wateringGuide, wateringGuide) || other.wateringGuide == wateringGuide)&&(identical(other.sunlightGuide, sunlightGuide) || other.sunlightGuide == sunlightGuide)&&(identical(other.pruningGuide, pruningGuide) || other.pruningGuide == pruningGuide)&&(identical(other.fetchedAt, fetchedAt) || other.fetchedAt == fetchedAt));
}


@override
int get hashCode {
    return Object.hashAll([runtimeType,speciesId,source,commonName,scientificName,imageUrl,watering,wateringMinDays,wateringMaxDays,wateringWinterMinDays,wateringWinterMaxDays,fertilizeEveryWeeks,const DeepCollectionEquality().hash(_sunlight),careLevel,indoor,poisonousToPets,const DeepCollectionEquality().hash(_pruningMonths),wateringGuide,sunlightGuide,pruningGuide,fetchedAt]);
}

@override
String toString() {
    return 'PlantProfile(speciesId: $speciesId, source: $source, commonName: $commonName, scientificName: $scientificName, imageUrl: $imageUrl, watering: $watering, wateringMinDays: $wateringMinDays, wateringMaxDays: $wateringMaxDays, wateringWinterMinDays: $wateringWinterMinDays, wateringWinterMaxDays: $wateringWinterMaxDays, fertilizeEveryWeeks: $fertilizeEveryWeeks, sunlight: $sunlight, careLevel: $careLevel, indoor: $indoor, poisonousToPets: $poisonousToPets, pruningMonths: $pruningMonths, wateringGuide: $wateringGuide, sunlightGuide: $sunlightGuide, pruningGuide: $pruningGuide, fetchedAt: $fetchedAt)';
}


}

/// @nodoc
abstract mixin class _$PlantProfileCopyWith<$Res> implements $PlantProfileCopyWith<$Res> {
  factory _$PlantProfileCopyWith(_PlantProfile value, $Res Function(_PlantProfile) _then) = __$PlantProfileCopyWithImpl;
@override @useResult
$Res call({
 int? speciesId, PlantProfileSource source, String commonName, String? scientificName, String? imageUrl, String? watering, int? wateringMinDays, int? wateringMaxDays, int? wateringWinterMinDays, int? wateringWinterMaxDays, int? fertilizeEveryWeeks, List<String> sunlight, String? careLevel, bool? indoor, bool? poisonousToPets, List<String> pruningMonths, String? wateringGuide, String? sunlightGuide, String? pruningGuide, DateTime fetchedAt
});




}
/// @nodoc
class __$PlantProfileCopyWithImpl<$Res>
    implements _$PlantProfileCopyWith<$Res> {
  __$PlantProfileCopyWithImpl(this._self, this._then);

  final _PlantProfile _self;
  final $Res Function(_PlantProfile) _then;

/// Create a copy of PlantProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? speciesId = freezed,Object? source = null,Object? commonName = null,Object? scientificName = freezed,Object? imageUrl = freezed,Object? watering = freezed,Object? wateringMinDays = freezed,Object? wateringMaxDays = freezed,Object? wateringWinterMinDays = freezed,Object? wateringWinterMaxDays = freezed,Object? fertilizeEveryWeeks = freezed,Object? sunlight = null,Object? careLevel = freezed,Object? indoor = freezed,Object? poisonousToPets = freezed,Object? pruningMonths = null,Object? wateringGuide = freezed,Object? sunlightGuide = freezed,Object? pruningGuide = freezed,Object? fetchedAt = null,}) {
  return _then(_PlantProfile(
speciesId: freezed == speciesId ? _self.speciesId : speciesId // ignore: cast_nullable_to_non_nullable
as int?,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as PlantProfileSource,commonName: null == commonName ? _self.commonName : commonName // ignore: cast_nullable_to_non_nullable
as String,scientificName: freezed == scientificName ? _self.scientificName : scientificName // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,watering: freezed == watering ? _self.watering : watering // ignore: cast_nullable_to_non_nullable
as String?,wateringMinDays: freezed == wateringMinDays ? _self.wateringMinDays : wateringMinDays // ignore: cast_nullable_to_non_nullable
as int?,wateringMaxDays: freezed == wateringMaxDays ? _self.wateringMaxDays : wateringMaxDays // ignore: cast_nullable_to_non_nullable
as int?,wateringWinterMinDays: freezed == wateringWinterMinDays ? _self.wateringWinterMinDays : wateringWinterMinDays // ignore: cast_nullable_to_non_nullable
as int?,wateringWinterMaxDays: freezed == wateringWinterMaxDays ? _self.wateringWinterMaxDays : wateringWinterMaxDays // ignore: cast_nullable_to_non_nullable
as int?,fertilizeEveryWeeks: freezed == fertilizeEveryWeeks ? _self.fertilizeEveryWeeks : fertilizeEveryWeeks // ignore: cast_nullable_to_non_nullable
as int?,sunlight: null == sunlight ? _self._sunlight : sunlight // ignore: cast_nullable_to_non_nullable
as List<String>,careLevel: freezed == careLevel ? _self.careLevel : careLevel // ignore: cast_nullable_to_non_nullable
as String?,indoor: freezed == indoor ? _self.indoor : indoor // ignore: cast_nullable_to_non_nullable
as bool?,poisonousToPets: freezed == poisonousToPets ? _self.poisonousToPets : poisonousToPets // ignore: cast_nullable_to_non_nullable
as bool?,pruningMonths: null == pruningMonths ? _self._pruningMonths : pruningMonths // ignore: cast_nullable_to_non_nullable
as List<String>,wateringGuide: freezed == wateringGuide ? _self.wateringGuide : wateringGuide // ignore: cast_nullable_to_non_nullable
as String?,sunlightGuide: freezed == sunlightGuide ? _self.sunlightGuide : sunlightGuide // ignore: cast_nullable_to_non_nullable
as String?,pruningGuide: freezed == pruningGuide ? _self.pruningGuide : pruningGuide // ignore: cast_nullable_to_non_nullable
as String?,fetchedAt: null == fetchedAt ? _self.fetchedAt : fetchedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
