// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'email_login_request_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EmailLoginRequestDto {

 String get email; String get password;
/// Create a copy of EmailLoginRequestDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EmailLoginRequestDtoCopyWith<EmailLoginRequestDto> get copyWith => _$EmailLoginRequestDtoCopyWithImpl<EmailLoginRequestDto>(this as EmailLoginRequestDto, _$identity);

  /// Serializes this EmailLoginRequestDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EmailLoginRequestDto&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,password);

@override
String toString() {
  return 'EmailLoginRequestDto(email: $email, password: $password)';
}


}

/// @nodoc
abstract mixin class $EmailLoginRequestDtoCopyWith<$Res>  {
  factory $EmailLoginRequestDtoCopyWith(EmailLoginRequestDto value, $Res Function(EmailLoginRequestDto) _then) = _$EmailLoginRequestDtoCopyWithImpl;
@useResult
$Res call({
 String email, String password
});




}
/// @nodoc
class _$EmailLoginRequestDtoCopyWithImpl<$Res>
    implements $EmailLoginRequestDtoCopyWith<$Res> {
  _$EmailLoginRequestDtoCopyWithImpl(this._self, this._then);

  final EmailLoginRequestDto _self;
  final $Res Function(EmailLoginRequestDto) _then;

/// Create a copy of EmailLoginRequestDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? email = null,Object? password = null,}) {
  return _then(_self.copyWith(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [EmailLoginRequestDto].
extension EmailLoginRequestDtoPatterns on EmailLoginRequestDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EmailLoginRequestDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EmailLoginRequestDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EmailLoginRequestDto value)  $default,){
final _that = this;
switch (_that) {
case _EmailLoginRequestDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EmailLoginRequestDto value)?  $default,){
final _that = this;
switch (_that) {
case _EmailLoginRequestDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String email,  String password)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EmailLoginRequestDto() when $default != null:
return $default(_that.email,_that.password);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String email,  String password)  $default,) {final _that = this;
switch (_that) {
case _EmailLoginRequestDto():
return $default(_that.email,_that.password);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String email,  String password)?  $default,) {final _that = this;
switch (_that) {
case _EmailLoginRequestDto() when $default != null:
return $default(_that.email,_that.password);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EmailLoginRequestDto implements EmailLoginRequestDto {
  const _EmailLoginRequestDto({required this.email, required this.password});
  factory _EmailLoginRequestDto.fromJson(Map<String, dynamic> json) => _$EmailLoginRequestDtoFromJson(json);

@override final  String email;
@override final  String password;

/// Create a copy of EmailLoginRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EmailLoginRequestDtoCopyWith<_EmailLoginRequestDto> get copyWith => __$EmailLoginRequestDtoCopyWithImpl<_EmailLoginRequestDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EmailLoginRequestDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EmailLoginRequestDto&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,email,password);

@override
String toString() {
  return 'EmailLoginRequestDto(email: $email, password: $password)';
}


}

/// @nodoc
abstract mixin class _$EmailLoginRequestDtoCopyWith<$Res> implements $EmailLoginRequestDtoCopyWith<$Res> {
  factory _$EmailLoginRequestDtoCopyWith(_EmailLoginRequestDto value, $Res Function(_EmailLoginRequestDto) _then) = __$EmailLoginRequestDtoCopyWithImpl;
@override @useResult
$Res call({
 String email, String password
});




}
/// @nodoc
class __$EmailLoginRequestDtoCopyWithImpl<$Res>
    implements _$EmailLoginRequestDtoCopyWith<$Res> {
  __$EmailLoginRequestDtoCopyWithImpl(this._self, this._then);

  final _EmailLoginRequestDto _self;
  final $Res Function(_EmailLoginRequestDto) _then;

/// Create a copy of EmailLoginRequestDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? email = null,Object? password = null,}) {
  return _then(_EmailLoginRequestDto(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
