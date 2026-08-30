// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserDto _$UserDtoFromJson(Map<String, dynamic> json) => _UserDto(
  id: json['id'] as String,
  displayName: json['displayName'] as String,
  email: json['email'] as String?,
  phone: json['phone'] as String?,
  avatarUrl: json['avatarUrl'] as String?,
  licenseLevel: json['licenseLevel'] as String?,
  totalJumps: (json['totalJumps'] as num?)?.toInt() ?? 0,
  createdAt: json['createdAt'] as String?,
  lastActiveAt: json['lastActiveAt'] as String?,
);

Map<String, dynamic> _$UserDtoToJson(_UserDto instance) => <String, dynamic>{
  'id': instance.id,
  'displayName': instance.displayName,
  'email': instance.email,
  'phone': instance.phone,
  'avatarUrl': instance.avatarUrl,
  'licenseLevel': instance.licenseLevel,
  'totalJumps': instance.totalJumps,
  'createdAt': instance.createdAt,
  'lastActiveAt': instance.lastActiveAt,
};
