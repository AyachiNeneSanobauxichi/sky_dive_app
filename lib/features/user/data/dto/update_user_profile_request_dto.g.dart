// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_user_profile_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpdateUserProfileRequestDto _$UpdateUserProfileRequestDtoFromJson(
  Map<String, dynamic> json,
) => _UpdateUserProfileRequestDto(
  id: json['id'] as String,
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
);

Map<String, dynamic> _$UpdateUserProfileRequestDtoToJson(
  _UpdateUserProfileRequestDto instance,
) => <String, dynamic>{
  'id': instance.id,
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
};
