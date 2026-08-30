// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_response_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LoginResponseDto {

 String get accessToken; String get refreshToken;/// accessToken 有效期（秒）。
 int get expiresIn; UserDto get userInfo; String? get loginTime;/// 本次是否为**新建账号**（注册，或短信首登时后端顺手建的号）。
 bool get isNewAccount;
/// Create a copy of LoginResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginResponseDtoCopyWith<LoginResponseDto> get copyWith => _$LoginResponseDtoCopyWithImpl<LoginResponseDto>(this as LoginResponseDto, _$identity);

  /// Serializes this LoginResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginResponseDto&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.expiresIn, expiresIn) || other.expiresIn == expiresIn)&&(identical(other.userInfo, userInfo) || other.userInfo == userInfo)&&(identical(other.loginTime, loginTime) || other.loginTime == loginTime)&&(identical(other.isNewAccount, isNewAccount) || other.isNewAccount == isNewAccount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accessToken,refreshToken,expiresIn,userInfo,loginTime,isNewAccount);

@override
String toString() {
  return 'LoginResponseDto(accessToken: $accessToken, refreshToken: $refreshToken, expiresIn: $expiresIn, userInfo: $userInfo, loginTime: $loginTime, isNewAccount: $isNewAccount)';
}


}

/// @nodoc
abstract mixin class $LoginResponseDtoCopyWith<$Res>  {
  factory $LoginResponseDtoCopyWith(LoginResponseDto value, $Res Function(LoginResponseDto) _then) = _$LoginResponseDtoCopyWithImpl;
@useResult
$Res call({
 String accessToken, String refreshToken, int expiresIn, UserDto userInfo, String? loginTime, bool isNewAccount
});


$UserDtoCopyWith<$Res> get userInfo;

}
/// @nodoc
class _$LoginResponseDtoCopyWithImpl<$Res>
    implements $LoginResponseDtoCopyWith<$Res> {
  _$LoginResponseDtoCopyWithImpl(this._self, this._then);

  final LoginResponseDto _self;
  final $Res Function(LoginResponseDto) _then;

/// Create a copy of LoginResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accessToken = null,Object? refreshToken = null,Object? expiresIn = null,Object? userInfo = null,Object? loginTime = freezed,Object? isNewAccount = null,}) {
  return _then(_self.copyWith(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,expiresIn: null == expiresIn ? _self.expiresIn : expiresIn // ignore: cast_nullable_to_non_nullable
as int,userInfo: null == userInfo ? _self.userInfo : userInfo // ignore: cast_nullable_to_non_nullable
as UserDto,loginTime: freezed == loginTime ? _self.loginTime : loginTime // ignore: cast_nullable_to_non_nullable
as String?,isNewAccount: null == isNewAccount ? _self.isNewAccount : isNewAccount // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of LoginResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserDtoCopyWith<$Res> get userInfo {
  
  return $UserDtoCopyWith<$Res>(_self.userInfo, (value) {
    return _then(_self.copyWith(userInfo: value));
  });
}
}


/// Adds pattern-matching-related methods to [LoginResponseDto].
extension LoginResponseDtoPatterns on LoginResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoginResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoginResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoginResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _LoginResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoginResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _LoginResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String accessToken,  String refreshToken,  int expiresIn,  UserDto userInfo,  String? loginTime,  bool isNewAccount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoginResponseDto() when $default != null:
return $default(_that.accessToken,_that.refreshToken,_that.expiresIn,_that.userInfo,_that.loginTime,_that.isNewAccount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String accessToken,  String refreshToken,  int expiresIn,  UserDto userInfo,  String? loginTime,  bool isNewAccount)  $default,) {final _that = this;
switch (_that) {
case _LoginResponseDto():
return $default(_that.accessToken,_that.refreshToken,_that.expiresIn,_that.userInfo,_that.loginTime,_that.isNewAccount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String accessToken,  String refreshToken,  int expiresIn,  UserDto userInfo,  String? loginTime,  bool isNewAccount)?  $default,) {final _that = this;
switch (_that) {
case _LoginResponseDto() when $default != null:
return $default(_that.accessToken,_that.refreshToken,_that.expiresIn,_that.userInfo,_that.loginTime,_that.isNewAccount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LoginResponseDto extends LoginResponseDto {
  const _LoginResponseDto({required this.accessToken, required this.refreshToken, this.expiresIn = 0, required this.userInfo, this.loginTime, this.isNewAccount = false}): super._();
  factory _LoginResponseDto.fromJson(Map<String, dynamic> json) => _$LoginResponseDtoFromJson(json);

@override final  String accessToken;
@override final  String refreshToken;
/// accessToken 有效期（秒）。
@override@JsonKey() final  int expiresIn;
@override final  UserDto userInfo;
@override final  String? loginTime;
/// 本次是否为**新建账号**（注册，或短信首登时后端顺手建的号）。
@override@JsonKey() final  bool isNewAccount;

/// Create a copy of LoginResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginResponseDtoCopyWith<_LoginResponseDto> get copyWith => __$LoginResponseDtoCopyWithImpl<_LoginResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LoginResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginResponseDto&&(identical(other.accessToken, accessToken) || other.accessToken == accessToken)&&(identical(other.refreshToken, refreshToken) || other.refreshToken == refreshToken)&&(identical(other.expiresIn, expiresIn) || other.expiresIn == expiresIn)&&(identical(other.userInfo, userInfo) || other.userInfo == userInfo)&&(identical(other.loginTime, loginTime) || other.loginTime == loginTime)&&(identical(other.isNewAccount, isNewAccount) || other.isNewAccount == isNewAccount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,accessToken,refreshToken,expiresIn,userInfo,loginTime,isNewAccount);

@override
String toString() {
  return 'LoginResponseDto(accessToken: $accessToken, refreshToken: $refreshToken, expiresIn: $expiresIn, userInfo: $userInfo, loginTime: $loginTime, isNewAccount: $isNewAccount)';
}


}

/// @nodoc
abstract mixin class _$LoginResponseDtoCopyWith<$Res> implements $LoginResponseDtoCopyWith<$Res> {
  factory _$LoginResponseDtoCopyWith(_LoginResponseDto value, $Res Function(_LoginResponseDto) _then) = __$LoginResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 String accessToken, String refreshToken, int expiresIn, UserDto userInfo, String? loginTime, bool isNewAccount
});


@override $UserDtoCopyWith<$Res> get userInfo;

}
/// @nodoc
class __$LoginResponseDtoCopyWithImpl<$Res>
    implements _$LoginResponseDtoCopyWith<$Res> {
  __$LoginResponseDtoCopyWithImpl(this._self, this._then);

  final _LoginResponseDto _self;
  final $Res Function(_LoginResponseDto) _then;

/// Create a copy of LoginResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accessToken = null,Object? refreshToken = null,Object? expiresIn = null,Object? userInfo = null,Object? loginTime = freezed,Object? isNewAccount = null,}) {
  return _then(_LoginResponseDto(
accessToken: null == accessToken ? _self.accessToken : accessToken // ignore: cast_nullable_to_non_nullable
as String,refreshToken: null == refreshToken ? _self.refreshToken : refreshToken // ignore: cast_nullable_to_non_nullable
as String,expiresIn: null == expiresIn ? _self.expiresIn : expiresIn // ignore: cast_nullable_to_non_nullable
as int,userInfo: null == userInfo ? _self.userInfo : userInfo // ignore: cast_nullable_to_non_nullable
as UserDto,loginTime: freezed == loginTime ? _self.loginTime : loginTime // ignore: cast_nullable_to_non_nullable
as String?,isNewAccount: null == isNewAccount ? _self.isNewAccount : isNewAccount // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of LoginResponseDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserDtoCopyWith<$Res> get userInfo {
  
  return $UserDtoCopyWith<$Res>(_self.userInfo, (value) {
    return _then(_self.copyWith(userInfo: value));
  });
}
}

// dart format on
