// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'speaker_setting.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SpeakerSetting {

 String get id; String? get displayName; bool get hidden; bool get isDefault;
/// Create a copy of SpeakerSetting
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpeakerSettingCopyWith<SpeakerSetting> get copyWith => _$SpeakerSettingCopyWithImpl<SpeakerSetting>(this as SpeakerSetting, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SpeakerSetting;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SpeakerSetting&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName)&&(identical(other.hidden, _this.hidden) || other.hidden == _this.hidden)&&(identical(other.isDefault, _this.isDefault) || other.isDefault == _this.isDefault));
}


@override
int get hashCode {
  final _this = this as SpeakerSetting;
  return Object.hash(runtimeType,_this.id,_this.displayName,_this.hidden,_this.isDefault);
}

@override
String toString() {
  final _this = this as SpeakerSetting;
  return 'SpeakerSetting(id: ${_this.id}, displayName: ${_this.displayName}, hidden: ${_this.hidden}, isDefault: ${_this.isDefault})';
}


}

/// @nodoc
abstract mixin class $SpeakerSettingCopyWith<$Res>  {
  factory $SpeakerSettingCopyWith(SpeakerSetting value, $Res Function(SpeakerSetting) _then) = _$SpeakerSettingCopyWithImpl;
@useResult
$Res call({
 String id, String? displayName, bool hidden, bool isDefault
});




}
/// @nodoc
class _$SpeakerSettingCopyWithImpl<$Res>
    implements $SpeakerSettingCopyWith<$Res> {
  _$SpeakerSettingCopyWithImpl(this._self, this._then);

  final SpeakerSetting _self;
  final $Res Function(SpeakerSetting) _then;

/// Create a copy of SpeakerSetting
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? displayName = freezed,Object? hidden = null,Object? isDefault = null,}) {
  return _then(SpeakerSetting(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,hidden: null == hidden ? _self.hidden : hidden // ignore: cast_nullable_to_non_nullable
as bool,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SpeakerSetting].
extension SpeakerSettingPatterns on SpeakerSetting {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SpeakerSetting value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SpeakerSetting() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SpeakerSetting value)  $default,){
final _that = this;
switch (_that) {
case _SpeakerSetting():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SpeakerSetting value)?  $default,){
final _that = this;
switch (_that) {
case _SpeakerSetting() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? displayName,  bool hidden,  bool isDefault)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SpeakerSetting() when $default != null:
return $default(_that.id,_that.displayName,_that.hidden,_that.isDefault);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? displayName,  bool hidden,  bool isDefault)  $default,) {final _that = this;
switch (_that) {
case _SpeakerSetting():
return $default(_that.id,_that.displayName,_that.hidden,_that.isDefault);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? displayName,  bool hidden,  bool isDefault)?  $default,) {final _that = this;
switch (_that) {
case _SpeakerSetting() when $default != null:
return $default(_that.id,_that.displayName,_that.hidden,_that.isDefault);case _:
  return null;

}
}

}

/// @nodoc


class _SpeakerSetting implements SpeakerSetting {
  const _SpeakerSetting({required this.id, this.displayName, this.hidden = false, this.isDefault = false});
  

@override final  String id;
@override final  String? displayName;
@override@JsonKey() final  bool hidden;
@override@JsonKey() final  bool isDefault;

/// Create a copy of SpeakerSetting
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SpeakerSettingCopyWith<_SpeakerSetting> get copyWith => __$SpeakerSettingCopyWithImpl<_SpeakerSetting>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SpeakerSetting&&(identical(other.id, id) || other.id == id)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.hidden, hidden) || other.hidden == hidden)&&(identical(other.isDefault, isDefault) || other.isDefault == isDefault));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,displayName,hidden,isDefault);
}

@override
String toString() {
    return 'SpeakerSetting(id: $id, displayName: $displayName, hidden: $hidden, isDefault: $isDefault)';
}


}

/// @nodoc
abstract mixin class _$SpeakerSettingCopyWith<$Res> implements $SpeakerSettingCopyWith<$Res> {
  factory _$SpeakerSettingCopyWith(_SpeakerSetting value, $Res Function(_SpeakerSetting) _then) = __$SpeakerSettingCopyWithImpl;
@override @useResult
$Res call({
 String id, String? displayName, bool hidden, bool isDefault
});




}
/// @nodoc
class __$SpeakerSettingCopyWithImpl<$Res>
    implements _$SpeakerSettingCopyWith<$Res> {
  __$SpeakerSettingCopyWithImpl(this._self, this._then);

  final _SpeakerSetting _self;
  final $Res Function(_SpeakerSetting) _then;

/// Create a copy of SpeakerSetting
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? displayName = freezed,Object? hidden = null,Object? isDefault = null,}) {
  return _then(_SpeakerSetting(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,hidden: null == hidden ? _self.hidden : hidden // ignore: cast_nullable_to_non_nullable
as bool,isDefault: null == isDefault ? _self.isDefault : isDefault // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
