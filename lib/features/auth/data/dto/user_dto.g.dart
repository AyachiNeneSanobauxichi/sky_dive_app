// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserDto _$UserDtoFromJson(Map<String, dynamic> json) => _UserDto(
  id: json['id'] as String,
  phone: json['phone'] as String,
  account: json['account'] as String?,
  username: json['username'] as String?,
  nickname: json['nickname'] as String?,
  status: (json['status'] as num?)?.toInt(),
  memberLevel: json['memberLevel'] as String?,
  totalDays: (json['totalDays'] as num?)?.toInt() ?? 0,
  lastActiveTime: json['lastActiveTime'] as String?,
  createTime: json['createTime'] as String?,
);

Map<String, dynamic> _$UserDtoToJson(_UserDto instance) => <String, dynamic>{
  'id': instance.id,
  'phone': instance.phone,
  'account': instance.account,
  'username': instance.username,
  'nickname': instance.nickname,
  'status': instance.status,
  'memberLevel': instance.memberLevel,
  'totalDays': instance.totalDays,
  'lastActiveTime': instance.lastActiveTime,
  'createTime': instance.createTime,
};
