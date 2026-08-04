// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sms_code_challenge.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SmsCodeChallenge {

/// 验证码有效期。
 Duration get expiresIn;/// 服务端回显的验证码。
///
/// v1 接口在响应里直接带明文验证码（联调期便利），**生产环境不应存在**，
/// 所以这里可空、且业务代码不得依赖它走登录主流程。
// TODO(auth): 后端上线前会去掉回显，届时删除本字段。
 String? get code;/// 服务端提示文案（如「验证码已发送，用于登录验证，有效期5分钟」）。
/// 直接来自服务端，不走 i18n。
 String? get message;
/// Create a copy of SmsCodeChallenge
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SmsCodeChallengeCopyWith<SmsCodeChallenge> get copyWith => _$SmsCodeChallengeCopyWithImpl<SmsCodeChallenge>(this as SmsCodeChallenge, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SmsCodeChallenge&&(identical(other.expiresIn, expiresIn) || other.expiresIn == expiresIn)&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,expiresIn,code,message);

@override
String toString() {
  return 'SmsCodeChallenge(expiresIn: $expiresIn, code: $code, message: $message)';
}


}

/// @nodoc
abstract mixin class $SmsCodeChallengeCopyWith<$Res>  {
  factory $SmsCodeChallengeCopyWith(SmsCodeChallenge value, $Res Function(SmsCodeChallenge) _then) = _$SmsCodeChallengeCopyWithImpl;
@useResult
$Res call({
 Duration expiresIn, String? code, String? message
});




}
/// @nodoc
class _$SmsCodeChallengeCopyWithImpl<$Res>
    implements $SmsCodeChallengeCopyWith<$Res> {
  _$SmsCodeChallengeCopyWithImpl(this._self, this._then);

  final SmsCodeChallenge _self;
  final $Res Function(SmsCodeChallenge) _then;

/// Create a copy of SmsCodeChallenge
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? expiresIn = null,Object? code = freezed,Object? message = freezed,}) {
  return _then(_self.copyWith(
expiresIn: null == expiresIn ? _self.expiresIn : expiresIn // ignore: cast_nullable_to_non_nullable
as Duration,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SmsCodeChallenge].
extension SmsCodeChallengePatterns on SmsCodeChallenge {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SmsCodeChallenge value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SmsCodeChallenge() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SmsCodeChallenge value)  $default,){
final _that = this;
switch (_that) {
case _SmsCodeChallenge():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SmsCodeChallenge value)?  $default,){
final _that = this;
switch (_that) {
case _SmsCodeChallenge() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Duration expiresIn,  String? code,  String? message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SmsCodeChallenge() when $default != null:
return $default(_that.expiresIn,_that.code,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Duration expiresIn,  String? code,  String? message)  $default,) {final _that = this;
switch (_that) {
case _SmsCodeChallenge():
return $default(_that.expiresIn,_that.code,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Duration expiresIn,  String? code,  String? message)?  $default,) {final _that = this;
switch (_that) {
case _SmsCodeChallenge() when $default != null:
return $default(_that.expiresIn,_that.code,_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _SmsCodeChallenge implements SmsCodeChallenge {
  const _SmsCodeChallenge({required this.expiresIn, this.code, this.message});
  

/// 验证码有效期。
@override final  Duration expiresIn;
/// 服务端回显的验证码。
///
/// v1 接口在响应里直接带明文验证码（联调期便利），**生产环境不应存在**，
/// 所以这里可空、且业务代码不得依赖它走登录主流程。
// TODO(auth): 后端上线前会去掉回显，届时删除本字段。
@override final  String? code;
/// 服务端提示文案（如「验证码已发送，用于登录验证，有效期5分钟」）。
/// 直接来自服务端，不走 i18n。
@override final  String? message;

/// Create a copy of SmsCodeChallenge
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SmsCodeChallengeCopyWith<_SmsCodeChallenge> get copyWith => __$SmsCodeChallengeCopyWithImpl<_SmsCodeChallenge>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SmsCodeChallenge&&(identical(other.expiresIn, expiresIn) || other.expiresIn == expiresIn)&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,expiresIn,code,message);

@override
String toString() {
  return 'SmsCodeChallenge(expiresIn: $expiresIn, code: $code, message: $message)';
}


}

/// @nodoc
abstract mixin class _$SmsCodeChallengeCopyWith<$Res> implements $SmsCodeChallengeCopyWith<$Res> {
  factory _$SmsCodeChallengeCopyWith(_SmsCodeChallenge value, $Res Function(_SmsCodeChallenge) _then) = __$SmsCodeChallengeCopyWithImpl;
@override @useResult
$Res call({
 Duration expiresIn, String? code, String? message
});




}
/// @nodoc
class __$SmsCodeChallengeCopyWithImpl<$Res>
    implements _$SmsCodeChallengeCopyWith<$Res> {
  __$SmsCodeChallengeCopyWithImpl(this._self, this._then);

  final _SmsCodeChallenge _self;
  final $Res Function(_SmsCodeChallenge) _then;

/// Create a copy of SmsCodeChallenge
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? expiresIn = null,Object? code = freezed,Object? message = freezed,}) {
  return _then(_SmsCodeChallenge(
expiresIn: null == expiresIn ? _self.expiresIn : expiresIn // ignore: cast_nullable_to_non_nullable
as Duration,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
