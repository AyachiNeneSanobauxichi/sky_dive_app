// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LoginResponseDto _$LoginResponseDtoFromJson(Map<String, dynamic> json) =>
    _LoginResponseDto(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresIn: (json['expiresIn'] as num?)?.toInt() ?? 0,
      userInfo: UserDto.fromJson(json['userInfo'] as Map<String, dynamic>),
      loginTime: json['loginTime'] as String?,
      isNewAccount: json['isNewAccount'] as bool? ?? false,
    );

Map<String, dynamic> _$LoginResponseDtoToJson(_LoginResponseDto instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'expiresIn': instance.expiresIn,
      'userInfo': instance.userInfo,
      'loginTime': instance.loginTime,
      'isNewAccount': instance.isNewAccount,
    };
