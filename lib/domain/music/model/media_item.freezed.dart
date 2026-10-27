// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MediaItem {

 String get title; String get contentId; String get contentType; String? get artworkUrl;
/// Create a copy of MediaItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaItemCopyWith<MediaItem> get copyWith => _$MediaItemCopyWithImpl<MediaItem>(this as MediaItem, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MediaItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaItem&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.contentId, _this.contentId) || other.contentId == _this.contentId)&&(identical(other.contentType, _this.contentType) || other.contentType == _this.contentType)&&(identical(other.artworkUrl, _this.artworkUrl) || other.artworkUrl == _this.artworkUrl));
}


@override
int get hashCode {
  final _this = this as MediaItem;
  return Object.hash(runtimeType,_this.title,_this.contentId,_this.contentType,_this.artworkUrl);
}

@override
String toString() {
  final _this = this as MediaItem;
  return 'MediaItem(title: ${_this.title}, contentId: ${_this.contentId}, contentType: ${_this.contentType}, artworkUrl: ${_this.artworkUrl})';
}


}

/// @nodoc
abstract mixin class $MediaItemCopyWith<$Res>  {
  factory $MediaItemCopyWith(MediaItem value, $Res Function(MediaItem) _then) = _$MediaItemCopyWithImpl;
@useResult
$Res call({
 String title, String contentId, String contentType, String? artworkUrl
});




}
/// @nodoc
class _$MediaItemCopyWithImpl<$Res>
    implements $MediaItemCopyWith<$Res> {
  _$MediaItemCopyWithImpl(this._self, this._then);

  final MediaItem _self;
  final $Res Function(MediaItem) _then;

/// Create a copy of MediaItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? contentId = null,Object? contentType = null,Object? artworkUrl = freezed,}) {
  return _then(MediaItem(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,contentId: null == contentId ? _self.contentId : contentId // ignore: cast_nullable_to_non_nullable
as String,contentType: null == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String,artworkUrl: freezed == artworkUrl ? _self.artworkUrl : artworkUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MediaItem].
extension MediaItemPatterns on MediaItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MediaItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MediaItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MediaItem value)  $default,){
final _that = this;
switch (_that) {
case _MediaItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MediaItem value)?  $default,){
final _that = this;
switch (_that) {
case _MediaItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String contentId,  String contentType,  String? artworkUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MediaItem() when $default != null:
return $default(_that.title,_that.contentId,_that.contentType,_that.artworkUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String contentId,  String contentType,  String? artworkUrl)  $default,) {final _that = this;
switch (_that) {
case _MediaItem():
return $default(_that.title,_that.contentId,_that.contentType,_that.artworkUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String contentId,  String contentType,  String? artworkUrl)?  $default,) {final _that = this;
switch (_that) {
case _MediaItem() when $default != null:
return $default(_that.title,_that.contentId,_that.contentType,_that.artworkUrl);case _:
  return null;

}
}

}

/// @nodoc


class _MediaItem extends MediaItem {
  const _MediaItem({required this.title, required this.contentId, required this.contentType, this.artworkUrl}): super._();
  

@override final  String title;
@override final  String contentId;
@override final  String contentType;
@override final  String? artworkUrl;

/// Create a copy of MediaItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MediaItemCopyWith<_MediaItem> get copyWith => __$MediaItemCopyWithImpl<_MediaItem>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MediaItem&&(identical(other.title, title) || other.title == title)&&(identical(other.contentId, contentId) || other.contentId == contentId)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.artworkUrl, artworkUrl) || other.artworkUrl == artworkUrl));
}


@override
int get hashCode {
    return Object.hash(runtimeType,title,contentId,contentType,artworkUrl);
}

@override
String toString() {
    return 'MediaItem(title: $title, contentId: $contentId, contentType: $contentType, artworkUrl: $artworkUrl)';
}


}

/// @nodoc
abstract mixin class _$MediaItemCopyWith<$Res> implements $MediaItemCopyWith<$Res> {
  factory _$MediaItemCopyWith(_MediaItem value, $Res Function(_MediaItem) _then) = __$MediaItemCopyWithImpl;
@override @useResult
$Res call({
 String title, String contentId, String contentType, String? artworkUrl
});




}
/// @nodoc
class __$MediaItemCopyWithImpl<$Res>
    implements _$MediaItemCopyWith<$Res> {
  __$MediaItemCopyWithImpl(this._self, this._then);

  final _MediaItem _self;
  final $Res Function(_MediaItem) _then;

/// Create a copy of MediaItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? contentId = null,Object? contentType = null,Object? artworkUrl = freezed,}) {
  return _then(_MediaItem(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,contentId: null == contentId ? _self.contentId : contentId // ignore: cast_nullable_to_non_nullable
as String,contentType: null == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String,artworkUrl: freezed == artworkUrl ? _self.artworkUrl : artworkUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
