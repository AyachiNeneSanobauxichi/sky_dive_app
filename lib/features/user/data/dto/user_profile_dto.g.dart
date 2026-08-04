// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserProfileDto _$UserProfileDtoFromJson(Map<String, dynamic> json) =>
    _UserProfileDto(
      id: json['id'] as String,
      userId: json['userId'] as String?,
      nickname: json['nickname'] as String?,
      gender: json['gender'] as String?,
      zodiac: json['zodiac'] as String?,
      profession: json['profession'] as String?,
      mbti: json['mbti'] as String?,
      hobbies: json['hobbies'] as String?,
      idealLife: json['idealLife'] as String?,
      city: json['city'] as String?,
      industry: json['industry'] as String?,
      company: json['company'] as String?,
      personalityTags: json['personalityTags'] as String?,
      birthday: json['birthday'] as String?,
      status: (json['status'] as num?)?.toInt(),
      createTime: json['createTime'] as String?,
      updateTime: json['updateTime'] as String?,
    );

Map<String, dynamic> _$UserProfileDtoToJson(_UserProfileDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'nickname': instance.nickname,
      'gender': instance.gender,
      'zodiac': instance.zodiac,
      'profession': instance.profession,
      'mbti': instance.mbti,
      'hobbies': instance.hobbies,
      'idealLife': instance.idealLife,
      'city': instance.city,
      'industry': instance.industry,
      'company': instance.company,
      'personalityTags': instance.personalityTags,
      'birthday': instance.birthday,
      'status': instance.status,
      'createTime': instance.createTime,
      'updateTime': instance.updateTime,
    };
