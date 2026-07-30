// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'register_response_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RegisterResponseDto {

 String get email; String get userName;
/// Create a copy of RegisterResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegisterResponseDtoCopyWith<RegisterResponseDto> get copyWith => _$RegisterResponseDtoCopyWithImpl<RegisterResponseDto>(this as RegisterResponseDto, _$identity);

  /// Serializes this RegisterResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegisterResponseDto&&(identical(other.email, email) || other.email == email)&&(identical(other.userName, userName) || other.userName == userName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,userName);

@override
String toString() {
  return 'RegisterResponseDto(email: $email, userName: $userName)';
}


}

/// @nodoc
abstract mixin class $RegisterResponseDtoCopyWith<$Res>  {
  factory $RegisterResponseDtoCopyWith(RegisterResponseDto value, $Res Function(RegisterResponseDto) _then) = _$RegisterResponseDtoCopyWithImpl;
@useResult
$Res call({
 String email, String userName
});




}
/// @nodoc
class _$RegisterResponseDtoCopyWithImpl<$Res>
    implements $RegisterResponseDtoCopyWith<$Res> {
  _$RegisterResponseDtoCopyWithImpl(this._self, this._then);

  final RegisterResponseDto _self;
  final $Res Function(RegisterResponseDto) _then;

/// Create a copy of RegisterResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? email = null,Object? userName = null,}) {
  return _then(_self.copyWith(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RegisterResponseDto].
extension RegisterResponseDtoPatterns on RegisterResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RegisterResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RegisterResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RegisterResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _RegisterResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RegisterResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _RegisterResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String email,  String userName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RegisterResponseDto() when $default != null:
return $default(_that.email,_that.userName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String email,  String userName)  $default,) {final _that = this;
switch (_that) {
case _RegisterResponseDto():
return $default(_that.email,_that.userName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String email,  String userName)?  $default,) {final _that = this;
switch (_that) {
case _RegisterResponseDto() when $default != null:
return $default(_that.email,_that.userName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RegisterResponseDto extends RegisterResponseDto {
  const _RegisterResponseDto({required this.email, required this.userName}): super._();
  factory _RegisterResponseDto.fromJson(Map<String, dynamic> json) => _$RegisterResponseDtoFromJson(json);

@override final  String email;
@override final  String userName;

/// Create a copy of RegisterResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegisterResponseDtoCopyWith<_RegisterResponseDto> get copyWith => __$RegisterResponseDtoCopyWithImpl<_RegisterResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RegisterResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RegisterResponseDto&&(identical(other.email, email) || other.email == email)&&(identical(other.userName, userName) || other.userName == userName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,userName);

@override
String toString() {
  return 'RegisterResponseDto(email: $email, userName: $userName)';
}


}

/// @nodoc
abstract mixin class _$RegisterResponseDtoCopyWith<$Res> implements $RegisterResponseDtoCopyWith<$Res> {
  factory _$RegisterResponseDtoCopyWith(_RegisterResponseDto value, $Res Function(_RegisterResponseDto) _then) = __$RegisterResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 String email, String userName
});




}
/// @nodoc
class __$RegisterResponseDtoCopyWithImpl<$Res>
    implements _$RegisterResponseDtoCopyWith<$Res> {
  __$RegisterResponseDtoCopyWithImpl(this._self, this._then);

  final _RegisterResponseDto _self;
  final $Res Function(_RegisterResponseDto) _then;

/// Create a copy of RegisterResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? email = null,Object? userName = null,}) {
  return _then(_RegisterResponseDto(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
