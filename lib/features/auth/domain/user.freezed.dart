// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$User {

 String get id;/// 显示名。注册时用户自己填，短信首登时后端按手机号后四位派生一个占位名。
 String get displayName;/// 登录邮箱。短信首登建号时为空，可在账号设置里补。
 String? get email;/// 手机号（日本国内格式，含前导 0）。邮箱注册时为空。
 String? get phone;/// 头像地址。
 String? get avatarUrl;/// 跳伞执照等级原始值（v1 已知 `"none"` / `"aff"` / `"a"` / `"b"` / `"c"` / `"d"`）。
///
/// 刻意保留 String 而非枚举：等级全集由运营方定义、还会随课程体系调整，
/// 过早枚举化会把后端新加的等级静默吞成 unknown——把持证跳伞员当成体验客处理，
/// 是比"多一个字符串"严重得多的事故（体验跳要配教练，持证跳不用）。
// TODO(auth): auth.api.md 补齐等级全集后改 enum + @JsonValue + unknown 兜底。
 String? get licenseLevel;/// 累计跳伞次数。老客要看到这个数字，这是他们的资历。
 int get totalJumps;/// 注册时间 / 最近活跃时间（后端以 ISO-8601 下发，解析失败则为 null）。
 DateTime? get createdAt; DateTime? get lastActiveAt;
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserCopyWith<User> get copyWith => _$UserCopyWithImpl<User>(this as User, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is User&&(identical(other.id, id) || other.id == id)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.licenseLevel, licenseLevel) || other.licenseLevel == licenseLevel)&&(identical(other.totalJumps, totalJumps) || other.totalJumps == totalJumps)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastActiveAt, lastActiveAt) || other.lastActiveAt == lastActiveAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,displayName,email,phone,avatarUrl,licenseLevel,totalJumps,createdAt,lastActiveAt);

@override
String toString() {
  return 'User(id: $id, displayName: $displayName, email: $email, phone: $phone, avatarUrl: $avatarUrl, licenseLevel: $licenseLevel, totalJumps: $totalJumps, createdAt: $createdAt, lastActiveAt: $lastActiveAt)';
}


}

/// @nodoc
abstract mixin class $UserCopyWith<$Res>  {
  factory $UserCopyWith(User value, $Res Function(User) _then) = _$UserCopyWithImpl;
@useResult
$Res call({
 String id, String displayName, String? email, String? phone, String? avatarUrl, String? licenseLevel, int totalJumps, DateTime? createdAt, DateTime? lastActiveAt
});




}
/// @nodoc
class _$UserCopyWithImpl<$Res>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._self, this._then);

  final User _self;
  final $Res Function(User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? displayName = null,Object? email = freezed,Object? phone = freezed,Object? avatarUrl = freezed,Object? licenseLevel = freezed,Object? totalJumps = null,Object? createdAt = freezed,Object? lastActiveAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,licenseLevel: freezed == licenseLevel ? _self.licenseLevel : licenseLevel // ignore: cast_nullable_to_non_nullable
as String?,totalJumps: null == totalJumps ? _self.totalJumps : totalJumps // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastActiveAt: freezed == lastActiveAt ? _self.lastActiveAt : lastActiveAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [User].
extension UserPatterns on User {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _User value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _User() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _User value)  $default,){
final _that = this;
switch (_that) {
case _User():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _User value)?  $default,){
final _that = this;
switch (_that) {
case _User() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String displayName,  String? email,  String? phone,  String? avatarUrl,  String? licenseLevel,  int totalJumps,  DateTime? createdAt,  DateTime? lastActiveAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.displayName,_that.email,_that.phone,_that.avatarUrl,_that.licenseLevel,_that.totalJumps,_that.createdAt,_that.lastActiveAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String displayName,  String? email,  String? phone,  String? avatarUrl,  String? licenseLevel,  int totalJumps,  DateTime? createdAt,  DateTime? lastActiveAt)  $default,) {final _that = this;
switch (_that) {
case _User():
return $default(_that.id,_that.displayName,_that.email,_that.phone,_that.avatarUrl,_that.licenseLevel,_that.totalJumps,_that.createdAt,_that.lastActiveAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String displayName,  String? email,  String? phone,  String? avatarUrl,  String? licenseLevel,  int totalJumps,  DateTime? createdAt,  DateTime? lastActiveAt)?  $default,) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.displayName,_that.email,_that.phone,_that.avatarUrl,_that.licenseLevel,_that.totalJumps,_that.createdAt,_that.lastActiveAt);case _:
  return null;

}
}

}

/// @nodoc


class _User extends User {
  const _User({required this.id, required this.displayName, this.email, this.phone, this.avatarUrl, this.licenseLevel, this.totalJumps = 0, this.createdAt, this.lastActiveAt}): super._();
  

@override final  String id;
/// 显示名。注册时用户自己填，短信首登时后端按手机号后四位派生一个占位名。
@override final  String displayName;
/// 登录邮箱。短信首登建号时为空，可在账号设置里补。
@override final  String? email;
/// 手机号（日本国内格式，含前导 0）。邮箱注册时为空。
@override final  String? phone;
/// 头像地址。
@override final  String? avatarUrl;
/// 跳伞执照等级原始值（v1 已知 `"none"` / `"aff"` / `"a"` / `"b"` / `"c"` / `"d"`）。
///
/// 刻意保留 String 而非枚举：等级全集由运营方定义、还会随课程体系调整，
/// 过早枚举化会把后端新加的等级静默吞成 unknown——把持证跳伞员当成体验客处理，
/// 是比"多一个字符串"严重得多的事故（体验跳要配教练，持证跳不用）。
// TODO(auth): auth.api.md 补齐等级全集后改 enum + @JsonValue + unknown 兜底。
@override final  String? licenseLevel;
/// 累计跳伞次数。老客要看到这个数字，这是他们的资历。
@override@JsonKey() final  int totalJumps;
/// 注册时间 / 最近活跃时间（后端以 ISO-8601 下发，解析失败则为 null）。
@override final  DateTime? createdAt;
@override final  DateTime? lastActiveAt;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserCopyWith<_User> get copyWith => __$UserCopyWithImpl<_User>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _User&&(identical(other.id, id) || other.id == id)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.licenseLevel, licenseLevel) || other.licenseLevel == licenseLevel)&&(identical(other.totalJumps, totalJumps) || other.totalJumps == totalJumps)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastActiveAt, lastActiveAt) || other.lastActiveAt == lastActiveAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,displayName,email,phone,avatarUrl,licenseLevel,totalJumps,createdAt,lastActiveAt);

@override
String toString() {
  return 'User(id: $id, displayName: $displayName, email: $email, phone: $phone, avatarUrl: $avatarUrl, licenseLevel: $licenseLevel, totalJumps: $totalJumps, createdAt: $createdAt, lastActiveAt: $lastActiveAt)';
}


}

/// @nodoc
abstract mixin class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) _then) = __$UserCopyWithImpl;
@override @useResult
$Res call({
 String id, String displayName, String? email, String? phone, String? avatarUrl, String? licenseLevel, int totalJumps, DateTime? createdAt, DateTime? lastActiveAt
});




}
/// @nodoc
class __$UserCopyWithImpl<$Res>
    implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(this._self, this._then);

  final _User _self;
  final $Res Function(_User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? displayName = null,Object? email = freezed,Object? phone = freezed,Object? avatarUrl = freezed,Object? licenseLevel = freezed,Object? totalJumps = null,Object? createdAt = freezed,Object? lastActiveAt = freezed,}) {
  return _then(_User(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,licenseLevel: freezed == licenseLevel ? _self.licenseLevel : licenseLevel // ignore: cast_nullable_to_non_nullable
as String?,totalJumps: null == totalJumps ? _self.totalJumps : totalJumps // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastActiveAt: freezed == lastActiveAt ? _self.lastActiveAt : lastActiveAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
