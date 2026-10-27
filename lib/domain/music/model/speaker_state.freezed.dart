// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'speaker_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SpeakerState {

 String get id; String get name;/// The name Home Assistant reports, set when the speaker was renamed in the hub.
 String? get reportedName; Playback get playback;/// 0–100.
 int get volumePercent;/// Ids of all speakers in the same group including this one; just this one when not grouped.
 List<String> get groupMembers; String? get title; String? get artist; String? get album;/// Playlist or source the track comes from, if the player reports it.
 String? get playlist;/// Absolute URL of the cover.
 String? get artworkUrl;/// Length of the track in seconds.
 int? get durationSeconds;/// Position in seconds at [positionUpdatedAt]; it keeps running while playing.
 double? get positionSeconds; DateTime? get positionUpdatedAt;
/// Create a copy of SpeakerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpeakerStateCopyWith<SpeakerState> get copyWith => _$SpeakerStateCopyWithImpl<SpeakerState>(this as SpeakerState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SpeakerState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpeakerState&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.reportedName, _this.reportedName) || other.reportedName == _this.reportedName)&&(identical(other.playback, _this.playback) || other.playback == _this.playback)&&(identical(other.volumePercent, _this.volumePercent) || other.volumePercent == _this.volumePercent)&&const DeepCollectionEquality().equals(other.groupMembers, _this.groupMembers)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.artist, _this.artist) || other.artist == _this.artist)&&(identical(other.album, _this.album) || other.album == _this.album)&&(identical(other.playlist, _this.playlist) || other.playlist == _this.playlist)&&(identical(other.artworkUrl, _this.artworkUrl) || other.artworkUrl == _this.artworkUrl)&&(identical(other.durationSeconds, _this.durationSeconds) || other.durationSeconds == _this.durationSeconds)&&(identical(other.positionSeconds, _this.positionSeconds) || other.positionSeconds == _this.positionSeconds)&&(identical(other.positionUpdatedAt, _this.positionUpdatedAt) || other.positionUpdatedAt == _this.positionUpdatedAt));
}


@override
int get hashCode {
  final _this = this as SpeakerState;
  return Object.hash(runtimeType,_this.id,_this.name,_this.reportedName,_this.playback,_this.volumePercent,const DeepCollectionEquality().hash(_this.groupMembers),_this.title,_this.artist,_this.album,_this.playlist,_this.artworkUrl,_this.durationSeconds,_this.positionSeconds,_this.positionUpdatedAt);
}

@override
String toString() {
  final _this = this as SpeakerState;
  return 'SpeakerState(id: ${_this.id}, name: ${_this.name}, reportedName: ${_this.reportedName}, playback: ${_this.playback}, volumePercent: ${_this.volumePercent}, groupMembers: ${_this.groupMembers}, title: ${_this.title}, artist: ${_this.artist}, album: ${_this.album}, playlist: ${_this.playlist}, artworkUrl: ${_this.artworkUrl}, durationSeconds: ${_this.durationSeconds}, positionSeconds: ${_this.positionSeconds}, positionUpdatedAt: ${_this.positionUpdatedAt})';
}


}

/// @nodoc
abstract mixin class $SpeakerStateCopyWith<$Res>  {
  factory $SpeakerStateCopyWith(SpeakerState value, $Res Function(SpeakerState) _then) = _$SpeakerStateCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? reportedName, Playback playback, int volumePercent, List<String> groupMembers, String? title, String? artist, String? album, String? playlist, String? artworkUrl, int? durationSeconds, double? positionSeconds, DateTime? positionUpdatedAt
});




}
/// @nodoc
class _$SpeakerStateCopyWithImpl<$Res>
    implements $SpeakerStateCopyWith<$Res> {
  _$SpeakerStateCopyWithImpl(this._self, this._then);

  final SpeakerState _self;
  final $Res Function(SpeakerState) _then;

/// Create a copy of SpeakerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? reportedName = freezed,Object? playback = null,Object? volumePercent = null,Object? groupMembers = null,Object? title = freezed,Object? artist = freezed,Object? album = freezed,Object? playlist = freezed,Object? artworkUrl = freezed,Object? durationSeconds = freezed,Object? positionSeconds = freezed,Object? positionUpdatedAt = freezed,}) {
  return _then(SpeakerState(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,reportedName: freezed == reportedName ? _self.reportedName : reportedName // ignore: cast_nullable_to_non_nullable
as String?,playback: null == playback ? _self.playback : playback // ignore: cast_nullable_to_non_nullable
as Playback,volumePercent: null == volumePercent ? _self.volumePercent : volumePercent // ignore: cast_nullable_to_non_nullable
as int,groupMembers: null == groupMembers ? _self.groupMembers : groupMembers // ignore: cast_nullable_to_non_nullable
as List<String>,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,artist: freezed == artist ? _self.artist : artist // ignore: cast_nullable_to_non_nullable
as String?,album: freezed == album ? _self.album : album // ignore: cast_nullable_to_non_nullable
as String?,playlist: freezed == playlist ? _self.playlist : playlist // ignore: cast_nullable_to_non_nullable
as String?,artworkUrl: freezed == artworkUrl ? _self.artworkUrl : artworkUrl // ignore: cast_nullable_to_non_nullable
as String?,durationSeconds: freezed == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int?,positionSeconds: freezed == positionSeconds ? _self.positionSeconds : positionSeconds // ignore: cast_nullable_to_non_nullable
as double?,positionUpdatedAt: freezed == positionUpdatedAt ? _self.positionUpdatedAt : positionUpdatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [SpeakerState].
extension SpeakerStatePatterns on SpeakerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpeakerState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpeakerState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpeakerState value)  $default,){
final _that = this;
switch (_that) {
case _SpeakerState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpeakerState value)?  $default,){
final _that = this;
switch (_that) {
case _SpeakerState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? reportedName,  Playback playback,  int volumePercent,  List<String> groupMembers,  String? title,  String? artist,  String? album,  String? playlist,  String? artworkUrl,  int? durationSeconds,  double? positionSeconds,  DateTime? positionUpdatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpeakerState() when $default != null:
return $default(_that.id,_that.name,_that.reportedName,_that.playback,_that.volumePercent,_that.groupMembers,_that.title,_that.artist,_that.album,_that.playlist,_that.artworkUrl,_that.durationSeconds,_that.positionSeconds,_that.positionUpdatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? reportedName,  Playback playback,  int volumePercent,  List<String> groupMembers,  String? title,  String? artist,  String? album,  String? playlist,  String? artworkUrl,  int? durationSeconds,  double? positionSeconds,  DateTime? positionUpdatedAt)  $default,) {final _that = this;
switch (_that) {
case _SpeakerState():
return $default(_that.id,_that.name,_that.reportedName,_that.playback,_that.volumePercent,_that.groupMembers,_that.title,_that.artist,_that.album,_that.playlist,_that.artworkUrl,_that.durationSeconds,_that.positionSeconds,_that.positionUpdatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? reportedName,  Playback playback,  int volumePercent,  List<String> groupMembers,  String? title,  String? artist,  String? album,  String? playlist,  String? artworkUrl,  int? durationSeconds,  double? positionSeconds,  DateTime? positionUpdatedAt)?  $default,) {final _that = this;
switch (_that) {
case _SpeakerState() when $default != null:
return $default(_that.id,_that.name,_that.reportedName,_that.playback,_that.volumePercent,_that.groupMembers,_that.title,_that.artist,_that.album,_that.playlist,_that.artworkUrl,_that.durationSeconds,_that.positionSeconds,_that.positionUpdatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _SpeakerState extends SpeakerState {
  const _SpeakerState({required this.id, required this.name, this.reportedName, required this.playback, this.volumePercent = 0,  List<String> groupMembers = const [], this.title, this.artist, this.album, this.playlist, this.artworkUrl, this.durationSeconds, this.positionSeconds, this.positionUpdatedAt}): _groupMembers = groupMembers,super._();
  

@override final  String id;
@override final  String name;
/// The name Home Assistant reports, set when the speaker was renamed in the hub.
@override final  String? reportedName;
@override final  Playback playback;
/// 0–100.
@override@JsonKey() final  int volumePercent;
/// Ids of all speakers in the same group including this one; just this one when not grouped.
 final  List<String> _groupMembers;
/// Ids of all speakers in the same group including this one; just this one when not grouped.
@override@JsonKey() List<String> get groupMembers {
  if (_groupMembers is EqualUnmodifiableListView) return _groupMembers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_groupMembers);
}

@override final  String? title;
@override final  String? artist;
@override final  String? album;
/// Playlist or source the track comes from, if the player reports it.
@override final  String? playlist;
/// Absolute URL of the cover.
@override final  String? artworkUrl;
/// Length of the track in seconds.
@override final  int? durationSeconds;
/// Position in seconds at [positionUpdatedAt]; it keeps running while playing.
@override final  double? positionSeconds;
@override final  DateTime? positionUpdatedAt;

/// Create a copy of SpeakerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpeakerStateCopyWith<_SpeakerState> get copyWith => __$SpeakerStateCopyWithImpl<_SpeakerState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpeakerState&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.reportedName, reportedName) || other.reportedName == reportedName)&&(identical(other.playback, playback) || other.playback == playback)&&(identical(other.volumePercent, volumePercent) || other.volumePercent == volumePercent)&&const DeepCollectionEquality().equals(other.groupMembers, _groupMembers)&&(identical(other.title, title) || other.title == title)&&(identical(other.artist, artist) || other.artist == artist)&&(identical(other.album, album) || other.album == album)&&(identical(other.playlist, playlist) || other.playlist == playlist)&&(identical(other.artworkUrl, artworkUrl) || other.artworkUrl == artworkUrl)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.positionSeconds, positionSeconds) || other.positionSeconds == positionSeconds)&&(identical(other.positionUpdatedAt, positionUpdatedAt) || other.positionUpdatedAt == positionUpdatedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,reportedName,playback,volumePercent,const DeepCollectionEquality().hash(_groupMembers),title,artist,album,playlist,artworkUrl,durationSeconds,positionSeconds,positionUpdatedAt);
}

@override
String toString() {
    return 'SpeakerState(id: $id, name: $name, reportedName: $reportedName, playback: $playback, volumePercent: $volumePercent, groupMembers: $groupMembers, title: $title, artist: $artist, album: $album, playlist: $playlist, artworkUrl: $artworkUrl, durationSeconds: $durationSeconds, positionSeconds: $positionSeconds, positionUpdatedAt: $positionUpdatedAt)';
}


}

/// @nodoc
abstract mixin class _$SpeakerStateCopyWith<$Res> implements $SpeakerStateCopyWith<$Res> {
  factory _$SpeakerStateCopyWith(_SpeakerState value, $Res Function(_SpeakerState) _then) = __$SpeakerStateCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? reportedName, Playback playback, int volumePercent, List<String> groupMembers, String? title, String? artist, String? album, String? playlist, String? artworkUrl, int? durationSeconds, double? positionSeconds, DateTime? positionUpdatedAt
});




}
/// @nodoc
class __$SpeakerStateCopyWithImpl<$Res>
    implements _$SpeakerStateCopyWith<$Res> {
  __$SpeakerStateCopyWithImpl(this._self, this._then);

  final _SpeakerState _self;
  final $Res Function(_SpeakerState) _then;

/// Create a copy of SpeakerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? reportedName = freezed,Object? playback = null,Object? volumePercent = null,Object? groupMembers = null,Object? title = freezed,Object? artist = freezed,Object? album = freezed,Object? playlist = freezed,Object? artworkUrl = freezed,Object? durationSeconds = freezed,Object? positionSeconds = freezed,Object? positionUpdatedAt = freezed,}) {
  return _then(_SpeakerState(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,reportedName: freezed == reportedName ? _self.reportedName : reportedName // ignore: cast_nullable_to_non_nullable
as String?,playback: null == playback ? _self.playback : playback // ignore: cast_nullable_to_non_nullable
as Playback,volumePercent: null == volumePercent ? _self.volumePercent : volumePercent // ignore: cast_nullable_to_non_nullable
as int,groupMembers: null == groupMembers ? _self._groupMembers : groupMembers // ignore: cast_nullable_to_non_nullable
as List<String>,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,artist: freezed == artist ? _self.artist : artist // ignore: cast_nullable_to_non_nullable
as String?,album: freezed == album ? _self.album : album // ignore: cast_nullable_to_non_nullable
as String?,playlist: freezed == playlist ? _self.playlist : playlist // ignore: cast_nullable_to_non_nullable
as String?,artworkUrl: freezed == artworkUrl ? _self.artworkUrl : artworkUrl // ignore: cast_nullable_to_non_nullable
as String?,durationSeconds: freezed == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int?,positionSeconds: freezed == positionSeconds ? _self.positionSeconds : positionSeconds // ignore: cast_nullable_to_non_nullable
as double?,positionUpdatedAt: freezed == positionUpdatedAt ? _self.positionUpdatedAt : positionUpdatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
