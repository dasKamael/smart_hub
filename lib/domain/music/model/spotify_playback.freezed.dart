// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'spotify_playback.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SpotifyPlayback {

 String get deviceId; bool get isPlaying; String? get title;/// The playing track, e.g. `spotify:track:…`.
 String? get trackUri; String? get artist; String? get artworkUrl;/// Album or playlist the track plays from, e.g. `spotify:playlist:…`.
 String? get contextUri; int? get durationSeconds; double get positionSeconds;/// When [positionSeconds] was read; the position runs on from here while playing.
 DateTime get positionAt;
/// Create a copy of SpotifyPlayback
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpotifyPlaybackCopyWith<SpotifyPlayback> get copyWith => _$SpotifyPlaybackCopyWithImpl<SpotifyPlayback>(this as SpotifyPlayback, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SpotifyPlayback;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpotifyPlayback&&(identical(other.deviceId, _this.deviceId) || other.deviceId == _this.deviceId)&&(identical(other.isPlaying, _this.isPlaying) || other.isPlaying == _this.isPlaying)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.trackUri, _this.trackUri) || other.trackUri == _this.trackUri)&&(identical(other.artist, _this.artist) || other.artist == _this.artist)&&(identical(other.artworkUrl, _this.artworkUrl) || other.artworkUrl == _this.artworkUrl)&&(identical(other.contextUri, _this.contextUri) || other.contextUri == _this.contextUri)&&(identical(other.durationSeconds, _this.durationSeconds) || other.durationSeconds == _this.durationSeconds)&&(identical(other.positionSeconds, _this.positionSeconds) || other.positionSeconds == _this.positionSeconds)&&(identical(other.positionAt, _this.positionAt) || other.positionAt == _this.positionAt));
}


@override
int get hashCode {
  final _this = this as SpotifyPlayback;
  return Object.hash(runtimeType,_this.deviceId,_this.isPlaying,_this.title,_this.trackUri,_this.artist,_this.artworkUrl,_this.contextUri,_this.durationSeconds,_this.positionSeconds,_this.positionAt);
}

@override
String toString() {
  final _this = this as SpotifyPlayback;
  return 'SpotifyPlayback(deviceId: ${_this.deviceId}, isPlaying: ${_this.isPlaying}, title: ${_this.title}, trackUri: ${_this.trackUri}, artist: ${_this.artist}, artworkUrl: ${_this.artworkUrl}, contextUri: ${_this.contextUri}, durationSeconds: ${_this.durationSeconds}, positionSeconds: ${_this.positionSeconds}, positionAt: ${_this.positionAt})';
}


}

/// @nodoc
abstract mixin class $SpotifyPlaybackCopyWith<$Res>  {
  factory $SpotifyPlaybackCopyWith(SpotifyPlayback value, $Res Function(SpotifyPlayback) _then) = _$SpotifyPlaybackCopyWithImpl;
@useResult
$Res call({
 String deviceId, bool isPlaying, String? title, String? trackUri, String? artist, String? artworkUrl, String? contextUri, int? durationSeconds, double positionSeconds, DateTime positionAt
});




}
/// @nodoc
class _$SpotifyPlaybackCopyWithImpl<$Res>
    implements $SpotifyPlaybackCopyWith<$Res> {
  _$SpotifyPlaybackCopyWithImpl(this._self, this._then);

  final SpotifyPlayback _self;
  final $Res Function(SpotifyPlayback) _then;

/// Create a copy of SpotifyPlayback
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deviceId = null,Object? isPlaying = null,Object? title = freezed,Object? trackUri = freezed,Object? artist = freezed,Object? artworkUrl = freezed,Object? contextUri = freezed,Object? durationSeconds = freezed,Object? positionSeconds = null,Object? positionAt = null,}) {
  return _then(SpotifyPlayback(
deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,trackUri: freezed == trackUri ? _self.trackUri : trackUri // ignore: cast_nullable_to_non_nullable
as String?,artist: freezed == artist ? _self.artist : artist // ignore: cast_nullable_to_non_nullable
as String?,artworkUrl: freezed == artworkUrl ? _self.artworkUrl : artworkUrl // ignore: cast_nullable_to_non_nullable
as String?,contextUri: freezed == contextUri ? _self.contextUri : contextUri // ignore: cast_nullable_to_non_nullable
as String?,durationSeconds: freezed == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int?,positionSeconds: null == positionSeconds ? _self.positionSeconds : positionSeconds // ignore: cast_nullable_to_non_nullable
as double,positionAt: null == positionAt ? _self.positionAt : positionAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [SpotifyPlayback].
extension SpotifyPlaybackPatterns on SpotifyPlayback {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpotifyPlayback value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpotifyPlayback() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpotifyPlayback value)  $default,){
final _that = this;
switch (_that) {
case _SpotifyPlayback():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpotifyPlayback value)?  $default,){
final _that = this;
switch (_that) {
case _SpotifyPlayback() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String deviceId,  bool isPlaying,  String? title,  String? trackUri,  String? artist,  String? artworkUrl,  String? contextUri,  int? durationSeconds,  double positionSeconds,  DateTime positionAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpotifyPlayback() when $default != null:
return $default(_that.deviceId,_that.isPlaying,_that.title,_that.trackUri,_that.artist,_that.artworkUrl,_that.contextUri,_that.durationSeconds,_that.positionSeconds,_that.positionAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String deviceId,  bool isPlaying,  String? title,  String? trackUri,  String? artist,  String? artworkUrl,  String? contextUri,  int? durationSeconds,  double positionSeconds,  DateTime positionAt)  $default,) {final _that = this;
switch (_that) {
case _SpotifyPlayback():
return $default(_that.deviceId,_that.isPlaying,_that.title,_that.trackUri,_that.artist,_that.artworkUrl,_that.contextUri,_that.durationSeconds,_that.positionSeconds,_that.positionAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String deviceId,  bool isPlaying,  String? title,  String? trackUri,  String? artist,  String? artworkUrl,  String? contextUri,  int? durationSeconds,  double positionSeconds,  DateTime positionAt)?  $default,) {final _that = this;
switch (_that) {
case _SpotifyPlayback() when $default != null:
return $default(_that.deviceId,_that.isPlaying,_that.title,_that.trackUri,_that.artist,_that.artworkUrl,_that.contextUri,_that.durationSeconds,_that.positionSeconds,_that.positionAt);case _:
  return null;

}
}

}

/// @nodoc


class _SpotifyPlayback implements SpotifyPlayback {
  const _SpotifyPlayback({required this.deviceId, required this.isPlaying, this.title, this.trackUri, this.artist, this.artworkUrl, this.contextUri, this.durationSeconds, this.positionSeconds = 0, required this.positionAt});
  

@override final  String deviceId;
@override final  bool isPlaying;
@override final  String? title;
/// The playing track, e.g. `spotify:track:…`.
@override final  String? trackUri;
@override final  String? artist;
@override final  String? artworkUrl;
/// Album or playlist the track plays from, e.g. `spotify:playlist:…`.
@override final  String? contextUri;
@override final  int? durationSeconds;
@override@JsonKey() final  double positionSeconds;
/// When [positionSeconds] was read; the position runs on from here while playing.
@override final  DateTime positionAt;

/// Create a copy of SpotifyPlayback
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpotifyPlaybackCopyWith<_SpotifyPlayback> get copyWith => __$SpotifyPlaybackCopyWithImpl<_SpotifyPlayback>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpotifyPlayback&&(identical(other.deviceId, deviceId) || other.deviceId == deviceId)&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.title, title) || other.title == title)&&(identical(other.trackUri, trackUri) || other.trackUri == trackUri)&&(identical(other.artist, artist) || other.artist == artist)&&(identical(other.artworkUrl, artworkUrl) || other.artworkUrl == artworkUrl)&&(identical(other.contextUri, contextUri) || other.contextUri == contextUri)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.positionSeconds, positionSeconds) || other.positionSeconds == positionSeconds)&&(identical(other.positionAt, positionAt) || other.positionAt == positionAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,deviceId,isPlaying,title,trackUri,artist,artworkUrl,contextUri,durationSeconds,positionSeconds,positionAt);
}

@override
String toString() {
    return 'SpotifyPlayback(deviceId: $deviceId, isPlaying: $isPlaying, title: $title, trackUri: $trackUri, artist: $artist, artworkUrl: $artworkUrl, contextUri: $contextUri, durationSeconds: $durationSeconds, positionSeconds: $positionSeconds, positionAt: $positionAt)';
}


}

/// @nodoc
abstract mixin class _$SpotifyPlaybackCopyWith<$Res> implements $SpotifyPlaybackCopyWith<$Res> {
  factory _$SpotifyPlaybackCopyWith(_SpotifyPlayback value, $Res Function(_SpotifyPlayback) _then) = __$SpotifyPlaybackCopyWithImpl;
@override @useResult
$Res call({
 String deviceId, bool isPlaying, String? title, String? trackUri, String? artist, String? artworkUrl, String? contextUri, int? durationSeconds, double positionSeconds, DateTime positionAt
});




}
/// @nodoc
class __$SpotifyPlaybackCopyWithImpl<$Res>
    implements _$SpotifyPlaybackCopyWith<$Res> {
  __$SpotifyPlaybackCopyWithImpl(this._self, this._then);

  final _SpotifyPlayback _self;
  final $Res Function(_SpotifyPlayback) _then;

/// Create a copy of SpotifyPlayback
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deviceId = null,Object? isPlaying = null,Object? title = freezed,Object? trackUri = freezed,Object? artist = freezed,Object? artworkUrl = freezed,Object? contextUri = freezed,Object? durationSeconds = freezed,Object? positionSeconds = null,Object? positionAt = null,}) {
  return _then(_SpotifyPlayback(
deviceId: null == deviceId ? _self.deviceId : deviceId // ignore: cast_nullable_to_non_nullable
as String,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,trackUri: freezed == trackUri ? _self.trackUri : trackUri // ignore: cast_nullable_to_non_nullable
as String?,artist: freezed == artist ? _self.artist : artist // ignore: cast_nullable_to_non_nullable
as String?,artworkUrl: freezed == artworkUrl ? _self.artworkUrl : artworkUrl // ignore: cast_nullable_to_non_nullable
as String?,contextUri: freezed == contextUri ? _self.contextUri : contextUri // ignore: cast_nullable_to_non_nullable
as String?,durationSeconds: freezed == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int?,positionSeconds: null == positionSeconds ? _self.positionSeconds : positionSeconds // ignore: cast_nullable_to_non_nullable
as double,positionAt: null == positionAt ? _self.positionAt : positionAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
