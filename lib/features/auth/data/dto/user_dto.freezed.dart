// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserDto {

 String get id; String get phone; String? get account; String? get username; String? get nickname; int? get status; String? get memberLevel; int get totalDays; String? get lastActiveTime; String? get createTime;
/// Create a copy of UserDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserDtoCopyWith<UserDto> get copyWith => _$UserDtoCopyWithImpl<UserDto>(this as UserDto, _$identity);

  /// Serializes this UserDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserDto&&(identical(other.id, id) || other.id == id)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.account, account) || other.account == account)&&(identical(other.username, username) || other.username == username)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.status, status) || other.status == status)&&(identical(other.memberLevel, memberLevel) || other.memberLevel == memberLevel)&&(identical(other.totalDays, totalDays) || other.totalDays == totalDays)&&(identical(other.lastActiveTime, lastActiveTime) || other.lastActiveTime == lastActiveTime)&&(identical(other.createTime, createTime) || other.createTime == createTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,phone,account,username,nickname,status,memberLevel,totalDays,lastActiveTime,createTime);

@override
String toString() {
  return 'UserDto(id: $id, phone: $phone, account: $account, username: $username, nickname: $nickname, status: $status, memberLevel: $memberLevel, totalDays: $totalDays, lastActiveTime: $lastActiveTime, createTime: $createTime)';
}


}

/// @nodoc
abstract mixin class $UserDtoCopyWith<$Res>  {
  factory $UserDtoCopyWith(UserDto value, $Res Function(UserDto) _then) = _$UserDtoCopyWithImpl;
@useResult
$Res call({
 String id, String phone, String? account, String? username, String? nickname, int? status, String? memberLevel, int totalDays, String? lastActiveTime, String? createTime
});




}
/// @nodoc
class _$UserDtoCopyWithImpl<$Res>
    implements $UserDtoCopyWith<$Res> {
  _$UserDtoCopyWithImpl(this._self, this._then);

  final UserDto _self;
  final $Res Function(UserDto) _then;

/// Create a copy of UserDto
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
as String?,createTime: freezed == createTime ? _self.createTime : createTime // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserDto].
extension UserDtoPatterns on UserDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserDto value)  $default,){
final _that = this;
switch (_that) {
case _UserDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserDto value)?  $default,){
final _that = this;
switch (_that) {
case _UserDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String phone,  String? account,  String? username,  String? nickname,  int? status,  String? memberLevel,  int totalDays,  String? lastActiveTime,  String? createTime)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserDto() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String phone,  String? account,  String? username,  String? nickname,  int? status,  String? memberLevel,  int totalDays,  String? lastActiveTime,  String? createTime)  $default,) {final _that = this;
switch (_that) {
case _UserDto():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String phone,  String? account,  String? username,  String? nickname,  int? status,  String? memberLevel,  int totalDays,  String? lastActiveTime,  String? createTime)?  $default,) {final _that = this;
switch (_that) {
case _UserDto() when $default != null:
return $default(_that.id,_that.phone,_that.account,_that.username,_that.nickname,_that.status,_that.memberLevel,_that.totalDays,_that.lastActiveTime,_that.createTime);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserDto extends UserDto {
  const _UserDto({required this.id, required this.phone, this.account, this.username, this.nickname, this.status, this.memberLevel, this.totalDays = 0, this.lastActiveTime, this.createTime}): super._();
  factory _UserDto.fromJson(Map<String, dynamic> json) => _$UserDtoFromJson(json);

@override final  String id;
@override final  String phone;
@override final  String? account;
@override final  String? username;
@override final  String? nickname;
@override final  int? status;
@override final  String? memberLevel;
@override@JsonKey() final  int totalDays;
@override final  String? lastActiveTime;
@override final  String? createTime;

/// Create a copy of UserDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserDtoCopyWith<_UserDto> get copyWith => __$UserDtoCopyWithImpl<_UserDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserDto&&(identical(other.id, id) || other.id == id)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.account, account) || other.account == account)&&(identical(other.username, username) || other.username == username)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.status, status) || other.status == status)&&(identical(other.memberLevel, memberLevel) || other.memberLevel == memberLevel)&&(identical(other.totalDays, totalDays) || other.totalDays == totalDays)&&(identical(other.lastActiveTime, lastActiveTime) || other.lastActiveTime == lastActiveTime)&&(identical(other.createTime, createTime) || other.createTime == createTime));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,phone,account,username,nickname,status,memberLevel,totalDays,lastActiveTime,createTime);

@override
String toString() {
  return 'UserDto(id: $id, phone: $phone, account: $account, username: $username, nickname: $nickname, status: $status, memberLevel: $memberLevel, totalDays: $totalDays, lastActiveTime: $lastActiveTime, createTime: $createTime)';
}


}

/// @nodoc
abstract mixin class _$UserDtoCopyWith<$Res> implements $UserDtoCopyWith<$Res> {
  factory _$UserDtoCopyWith(_UserDto value, $Res Function(_UserDto) _then) = __$UserDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String phone, String? account, String? username, String? nickname, int? status, String? memberLevel, int totalDays, String? lastActiveTime, String? createTime
});




}
/// @nodoc
class __$UserDtoCopyWithImpl<$Res>
    implements _$UserDtoCopyWith<$Res> {
  __$UserDtoCopyWithImpl(this._self, this._then);

  final _UserDto _self;
  final $Res Function(_UserDto) _then;

/// Create a copy of UserDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? phone = null,Object? account = freezed,Object? username = freezed,Object? nickname = freezed,Object? status = freezed,Object? memberLevel = freezed,Object? totalDays = null,Object? lastActiveTime = freezed,Object? createTime = freezed,}) {
  return _then(_UserDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,account: freezed == account ? _self.account : account // ignore: cast_nullable_to_non_nullable
as String?,username: freezed == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String?,nickname: freezed == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int?,memberLevel: freezed == memberLevel ? _self.memberLevel : memberLevel // ignore: cast_nullable_to_non_nullable
as String?,totalDays: null == totalDays ? _self.totalDays : totalDays // ignore: cast_nullable_to_non_nullable
as int,lastActiveTime: freezed == lastActiveTime ? _self.lastActiveTime : lastActiveTime // ignore: cast_nullable_to_non_nullable
as String?,createTime: freezed == createTime ? _self.createTime : createTime // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
