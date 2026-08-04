// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LoginRequestDto _$LoginRequestDtoFromJson(Map<String, dynamic> json) =>
    _LoginRequestDto(
      phone: json['phone'] as String,
      smsCode: json['smsCode'] as String,
    );

Map<String, dynamic> _$LoginRequestDtoToJson(_LoginRequestDto instance) =>
    <String, dynamic>{'phone': instance.phone, 'smsCode': instance.smsCode};
