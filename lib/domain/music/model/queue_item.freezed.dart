// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'queue_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$QueueItem {

 String get title; String? get artist;/// Small cover for lists.
 String? get artworkUrl;/// Full size cover, as "Now playing" shows it once the track plays; loaded ahead of time.
 String? get coverUrl;
/// Create a copy of QueueItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QueueItemCopyWith<QueueItem> get copyWith => _$QueueItemCopyWithImpl<QueueItem>(this as QueueItem, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as QueueItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QueueItem&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.artist, _this.artist) || other.artist == _this.artist)&&(identical(other.artworkUrl, _this.artworkUrl) || other.artworkUrl == _this.artworkUrl)&&(identical(other.coverUrl, _this.coverUrl) || other.coverUrl == _this.coverUrl));
}


@override
int get hashCode {
  final _this = this as QueueItem;
  return Object.hash(runtimeType,_this.title,_this.artist,_this.artworkUrl,_this.coverUrl);
}

@override
String toString() {
  final _this = this as QueueItem;
  return 'QueueItem(title: ${_this.title}, artist: ${_this.artist}, artworkUrl: ${_this.artworkUrl}, coverUrl: ${_this.coverUrl})';
}


}

/// @nodoc
abstract mixin class $QueueItemCopyWith<$Res>  {
  factory $QueueItemCopyWith(QueueItem value, $Res Function(QueueItem) _then) = _$QueueItemCopyWithImpl;
@useResult
$Res call({
 String title, String? artist, String? artworkUrl, String? coverUrl
});




}
/// @nodoc
class _$QueueItemCopyWithImpl<$Res>
    implements $QueueItemCopyWith<$Res> {
  _$QueueItemCopyWithImpl(this._self, this._then);

  final QueueItem _self;
  final $Res Function(QueueItem) _then;

/// Create a copy of QueueItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? artist = freezed,Object? artworkUrl = freezed,Object? coverUrl = freezed,}) {
  return _then(QueueItem(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,artist: freezed == artist ? _self.artist : artist // ignore: cast_nullable_to_non_nullable
as String?,artworkUrl: freezed == artworkUrl ? _self.artworkUrl : artworkUrl // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [QueueItem].
extension QueueItemPatterns on QueueItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QueueItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QueueItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QueueItem value)  $default,){
final _that = this;
switch (_that) {
case _QueueItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QueueItem value)?  $default,){
final _that = this;
switch (_that) {
case _QueueItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String? artist,  String? artworkUrl,  String? coverUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QueueItem() when $default != null:
return $default(_that.title,_that.artist,_that.artworkUrl,_that.coverUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String? artist,  String? artworkUrl,  String? coverUrl)  $default,) {final _that = this;
switch (_that) {
case _QueueItem():
return $default(_that.title,_that.artist,_that.artworkUrl,_that.coverUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String? artist,  String? artworkUrl,  String? coverUrl)?  $default,) {final _that = this;
switch (_that) {
case _QueueItem() when $default != null:
return $default(_that.title,_that.artist,_that.artworkUrl,_that.coverUrl);case _:
  return null;

}
}

}

/// @nodoc


class _QueueItem implements QueueItem {
  const _QueueItem({required this.title, this.artist, this.artworkUrl, this.coverUrl});
  

@override final  String title;
@override final  String? artist;
/// Small cover for lists.
@override final  String? artworkUrl;
/// Full size cover, as "Now playing" shows it once the track plays; loaded ahead of time.
@override final  String? coverUrl;

/// Create a copy of QueueItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QueueItemCopyWith<_QueueItem> get copyWith => __$QueueItemCopyWithImpl<_QueueItem>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _QueueItem&&(identical(other.title, title) || other.title == title)&&(identical(other.artist, artist) || other.artist == artist)&&(identical(other.artworkUrl, artworkUrl) || other.artworkUrl == artworkUrl)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl));
}


@override
int get hashCode {
    return Object.hash(runtimeType,title,artist,artworkUrl,coverUrl);
}

@override
String toString() {
    return 'QueueItem(title: $title, artist: $artist, artworkUrl: $artworkUrl, coverUrl: $coverUrl)';
}


}

/// @nodoc
abstract mixin class _$QueueItemCopyWith<$Res> implements $QueueItemCopyWith<$Res> {
  factory _$QueueItemCopyWith(_QueueItem value, $Res Function(_QueueItem) _then) = __$QueueItemCopyWithImpl;
@override @useResult
$Res call({
 String title, String? artist, String? artworkUrl, String? coverUrl
});




}
/// @nodoc
class __$QueueItemCopyWithImpl<$Res>
    implements _$QueueItemCopyWith<$Res> {
  __$QueueItemCopyWithImpl(this._self, this._then);

  final _QueueItem _self;
  final $Res Function(_QueueItem) _then;

/// Create a copy of QueueItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? artist = freezed,Object? artworkUrl = freezed,Object? coverUrl = freezed,}) {
  return _then(_QueueItem(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,artist: freezed == artist ? _self.artist : artist // ignore: cast_nullable_to_non_nullable
as String?,artworkUrl: freezed == artworkUrl ? _self.artworkUrl : artworkUrl // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
