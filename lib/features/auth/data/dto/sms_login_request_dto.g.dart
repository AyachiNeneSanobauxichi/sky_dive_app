// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sms_login_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SmsLoginRequestDto _$SmsLoginRequestDtoFromJson(Map<String, dynamic> json) =>
    _SmsLoginRequestDto(
      phone: json['phone'] as String,
      smsCode: json['smsCode'] as String,
    );

Map<String, dynamic> _$SmsLoginRequestDtoToJson(_SmsLoginRequestDto instance) =>
    <String, dynamic>{'phone': instance.phone, 'smsCode': instance.smsCode};
