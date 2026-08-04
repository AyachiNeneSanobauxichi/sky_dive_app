// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_sms_code_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SendSmsCodeResponseDto _$SendSmsCodeResponseDtoFromJson(
  Map<String, dynamic> json,
) => _SendSmsCodeResponseDto(
  code: json['code'] as String?,
  expiresIn: (json['expiresIn'] as num?)?.toInt() ?? 0,
  message: json['message'] as String?,
);

Map<String, dynamic> _$SendSmsCodeResponseDtoToJson(
  _SendSmsCodeResponseDto instance,
) => <String, dynamic>{
  'code': instance.code,
  'expiresIn': instance.expiresIn,
  'message': instance.message,
};
