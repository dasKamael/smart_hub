// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'spotify_account.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SpotifyAccount {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SpotifyAccount);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SpotifyAccount()';
}


}

/// @nodoc
class $SpotifyAccountCopyWith<$Res>  {
$SpotifyAccountCopyWith(SpotifyAccount _, $Res Function(SpotifyAccount) __);
}


/// Adds pattern-matching-related methods to [SpotifyAccount].
extension SpotifyAccountPatterns on SpotifyAccount {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SpotifyNotConfigured value)?  notConfigured,TResult Function( SpotifySignedOut value)?  signedOut,TResult Function( SpotifySignedIn value)?  signedIn,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SpotifyNotConfigured() when notConfigured != null:
return notConfigured(_that);case SpotifySignedOut() when signedOut != null:
return signedOut(_that);case SpotifySignedIn() when signedIn != null:
return signedIn(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SpotifyNotConfigured value)  notConfigured,required TResult Function( SpotifySignedOut value)  signedOut,required TResult Function( SpotifySignedIn value)  signedIn,}){
final _that = this;
switch (_that) {
case SpotifyNotConfigured():
return notConfigured(_that);case SpotifySignedOut():
return signedOut(_that);case SpotifySignedIn():
return signedIn(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SpotifyNotConfigured value)?  notConfigured,TResult? Function( SpotifySignedOut value)?  signedOut,TResult? Function( SpotifySignedIn value)?  signedIn,}){
final _that = this;
switch (_that) {
case SpotifyNotConfigured() when notConfigured != null:
return notConfigured(_that);case SpotifySignedOut() when signedOut != null:
return signedOut(_that);case SpotifySignedIn() when signedIn != null:
return signedIn(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  notConfigured,TResult Function()?  signedOut,TResult Function( String displayName)?  signedIn,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SpotifyNotConfigured() when notConfigured != null:
return notConfigured();case SpotifySignedOut() when signedOut != null:
return signedOut();case SpotifySignedIn() when signedIn != null:
return signedIn(_that.displayName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  notConfigured,required TResult Function()  signedOut,required TResult Function( String displayName)  signedIn,}) {final _that = this;
switch (_that) {
case SpotifyNotConfigured():
return notConfigured();case SpotifySignedOut():
return signedOut();case SpotifySignedIn():
return signedIn(_that.displayName);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  notConfigured,TResult? Function()?  signedOut,TResult? Function( String displayName)?  signedIn,}) {final _that = this;
switch (_that) {
case SpotifyNotConfigured() when notConfigured != null:
return notConfigured();case SpotifySignedOut() when signedOut != null:
return signedOut();case SpotifySignedIn() when signedIn != null:
return signedIn(_that.displayName);case _:
  return null;

}
}

}

/// @nodoc


class SpotifyNotConfigured implements SpotifyAccount {
  const SpotifyNotConfigured();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SpotifyNotConfigured);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SpotifyAccount.notConfigured()';
}


}




/// @nodoc


class SpotifySignedOut implements SpotifyAccount {
  const SpotifySignedOut();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SpotifySignedOut);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'SpotifyAccount.signedOut()';
}


}




/// @nodoc


class SpotifySignedIn implements SpotifyAccount {
  const SpotifySignedIn({required this.displayName});
  

 final  String displayName;

/// Create a copy of SpotifyAccount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SpotifySignedInCopyWith<SpotifySignedIn> get copyWith => _$SpotifySignedInCopyWithImpl<SpotifySignedIn>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is SpotifySignedIn&&(identical(other.displayName, displayName) || other.displayName == displayName));
}


@override
int get hashCode {
    return Object.hash(runtimeType,displayName);
}

@override
String toString() {
    return 'SpotifyAccount.signedIn(displayName: $displayName)';
}


}

/// @nodoc
abstract mixin class $SpotifySignedInCopyWith<$Res> implements $SpotifyAccountCopyWith<$Res> {
  factory $SpotifySignedInCopyWith(SpotifySignedIn value, $Res Function(SpotifySignedIn) _then) = _$SpotifySignedInCopyWithImpl;
@useResult
$Res call({
 String displayName
});




}
/// @nodoc
class _$SpotifySignedInCopyWithImpl<$Res>
    implements $SpotifySignedInCopyWith<$Res> {
  _$SpotifySignedInCopyWithImpl(this._self, this._then);

  final SpotifySignedIn _self;
  final $Res Function(SpotifySignedIn) _then;

/// Create a copy of SpotifyAccount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? displayName = null,}) {
  return _then(SpotifySignedIn(
displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
