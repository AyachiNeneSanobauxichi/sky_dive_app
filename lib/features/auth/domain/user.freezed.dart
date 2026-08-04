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

 String get id; String get phone;/// 登录账号。v1 与手机号同值，但语义不同：账号可改，手机号是凭据。
 String? get account;/// 系统生成的用户名（注册时按规则派生，如「开心oF6Jxq」）。
 String? get username;/// 用户可改的昵称。验证码登录会为新手机号直接建号，此时可能与 [username] 同值。
 String? get nickname;/// 账号状态原始值（v1 样例为 1）。
///
// TODO(auth): auth.api.md 未给出 status 取值表，补齐后改成枚举 + unknown 兜底。
 int? get status;/// 会员等级原始值（v1 已知 "free"）。
///
/// 刻意保留 String 而非枚举：等级全集未定，过早枚举化会把后端新加的付费等级
/// 静默吞成 unknown，付费用户被当免费用户处理是比"多一个字符串"严重得多的事故。
// TODO(auth): auth.api.md 补齐等级全集后改 enum + @JsonValue + unknown 兜底。
 String? get memberLevel;/// 累计使用天数。
 int get totalDays;/// 最近活跃时间 / 注册时间（后端以本地时间字符串下发，解析失败则为 null）。
 DateTime? get lastActiveTime; DateTime? get createTime;
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserCopyWith<User> get copyWith => _$UserCopyWithImpl<User>(this as User, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is User&&(identical(other.id, id) || other.id == id)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.account, account) || other.account == account)&&(identical(other.username, username) || other.username == username)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.status, status) || other.status == status)&&(identical(other.memberLevel, memberLevel) || other.memberLevel == memberLevel)&&(identical(other.totalDays, totalDays) || other.totalDays == totalDays)&&(identical(other.lastActiveTime, lastActiveTime) || other.lastActiveTime == lastActiveTime)&&(identical(other.createTime, createTime) || other.createTime == createTime));
}


@override
int get hashCode => Object.hash(runtimeType,id,phone,account,username,nickname,status,memberLevel,totalDays,lastActiveTime,createTime);

@override
String toString() {
  return 'User(id: $id, phone: $phone, account: $account, username: $username, nickname: $nickname, status: $status, memberLevel: $memberLevel, totalDays: $totalDays, lastActiveTime: $lastActiveTime, createTime: $createTime)';
}


}

/// @nodoc
abstract mixin class $UserCopyWith<$Res>  {
  factory $UserCopyWith(User value, $Res Function(User) _then) = _$UserCopyWithImpl;
@useResult
$Res call({
 String id, String phone, String? account, String? username, String? nickname, int? status, String? memberLevel, int totalDays, DateTime? lastActiveTime, DateTime? createTime
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? phone = null,Object? account = freezed,Object? username = freezed,Object? nickname = freezed,Object? status = freezed,Object? memberLevel = freezed,Object? totalDays = null,Object? lastActiveTime = freezed,Object? createTime = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,account: freezed == account ? _self.account : account // ignore: cast_nullable_to_non_nullable
as String?,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,nickname: freezed == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int?,memberLevel: freezed == memberLevel ? _self.memberLevel : memberLevel // ignore: cast_nullable_to_non_nullable
as String?,totalDays: null == totalDays ? _self.totalDays : totalDays // ignore: cast_nullable_to_non_nullable
as int,lastActiveTime: freezed == lastActiveTime ? _self.lastActiveTime : lastActiveTime // ignore: cast_nullable_to_non_nullable
as DateTime?,createTime: freezed == createTime ? _self.createTime : createTime // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String phone,  String? account,  String? username,  String? nickname,  int? status,  String? memberLevel,  int totalDays,  DateTime? lastActiveTime,  DateTime? createTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.phone,_that.account,_that.username,_that.nickname,_that.status,_that.memberLevel,_that.totalDays,_that.lastActiveTime,_that.createTime);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String phone,  String? account,  String? username,  String? nickname,  int? status,  String? memberLevel,  int totalDays,  DateTime? lastActiveTime,  DateTime? createTime)  $default,) {final _that = this;
switch (_that) {
case _User():
return $default(_that.id,_that.phone,_that.account,_that.username,_that.nickname,_that.status,_that.memberLevel,_that.totalDays,_that.lastActiveTime,_that.createTime);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String phone,  String? account,  String? username,  String? nickname,  int? status,  String? memberLevel,  int totalDays,  DateTime? lastActiveTime,  DateTime? createTime)?  $default,) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.phone,_that.account,_that.username,_that.nickname,_that.status,_that.memberLevel,_that.totalDays,_that.lastActiveTime,_that.createTime);case _:
  return null;

}
}

}

/// @nodoc


class _User implements User {
  const _User({required this.id, required this.phone, this.account, this.username, this.nickname, this.status, this.memberLevel, this.totalDays = 0, this.lastActiveTime, this.createTime});
  

@override final  String id;
@override final  String phone;
/// 登录账号。v1 与手机号同值，但语义不同：账号可改，手机号是凭据。
@override final  String? account;
/// 系统生成的用户名（注册时按规则派生，如「开心oF6Jxq」）。
@override final  String? username;
/// 用户可改的昵称。验证码登录会为新手机号直接建号，此时可能与 [username] 同值。
@override final  String? nickname;
/// 账号状态原始值（v1 样例为 1）。
///
// TODO(auth): auth.api.md 未给出 status 取值表，补齐后改成枚举 + unknown 兜底。
@override final  int? status;
/// 会员等级原始值（v1 已知 "free"）。
///
/// 刻意保留 String 而非枚举：等级全集未定，过早枚举化会把后端新加的付费等级
/// 静默吞成 unknown，付费用户被当免费用户处理是比"多一个字符串"严重得多的事故。
// TODO(auth): auth.api.md 补齐等级全集后改 enum + @JsonValue + unknown 兜底。
@override final  String? memberLevel;
/// 累计使用天数。
@override@JsonKey() final  int totalDays;
/// 最近活跃时间 / 注册时间（后端以本地时间字符串下发，解析失败则为 null）。
@override final  DateTime? lastActiveTime;
@override final  DateTime? createTime;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserCopyWith<_User> get copyWith => __$UserCopyWithImpl<_User>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _User&&(identical(other.id, id) || other.id == id)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.account, account) || other.account == account)&&(identical(other.username, username) || other.username == username)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.status, status) || other.status == status)&&(identical(other.memberLevel, memberLevel) || other.memberLevel == memberLevel)&&(identical(other.totalDays, totalDays) || other.totalDays == totalDays)&&(identical(other.lastActiveTime, lastActiveTime) || other.lastActiveTime == lastActiveTime)&&(identical(other.createTime, createTime) || other.createTime == createTime));
}


@override
int get hashCode => Object.hash(runtimeType,id,phone,account,username,nickname,status,memberLevel,totalDays,lastActiveTime,createTime);

@override
String toString() {
  return 'User(id: $id, phone: $phone, account: $account, username: $username, nickname: $nickname, status: $status, memberLevel: $memberLevel, totalDays: $totalDays, lastActiveTime: $lastActiveTime, createTime: $createTime)';
}


}

/// @nodoc
abstract mixin class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) _then) = __$UserCopyWithImpl;
@override @useResult
$Res call({
 String id, String phone, String? account, String? username, String? nickname, int? status, String? memberLevel, int totalDays, DateTime? lastActiveTime, DateTime? createTime
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? phone = null,Object? account = freezed,Object? username = freezed,Object? nickname = freezed,Object? status = freezed,Object? memberLevel = freezed,Object? totalDays = null,Object? lastActiveTime = freezed,Object? createTime = freezed,}) {
  return _then(_User(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,account: freezed == account ? _self.account : account // ignore: cast_nullable_to_non_nullable
as String?,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,nickname: freezed == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int?,memberLevel: freezed == memberLevel ? _self.memberLevel : memberLevel // ignore: cast_nullable_to_non_nullable
as String?,totalDays: null == totalDays ? _self.totalDays : totalDays // ignore: cast_nullable_to_non_nullable
as int,lastActiveTime: freezed == lastActiveTime ? _self.lastActiveTime : lastActiveTime // ignore: cast_nullable_to_non_nullable
as DateTime?,createTime: freezed == createTime ? _self.createTime : createTime // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
