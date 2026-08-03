// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_sms_code_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SendSmsCodeResponseDto _$SendSmsCodeResponseDtoFromJson(
  Map<String, dynamic> json,
) => _SendSmsCodeResponseDto(
  resendAfterSeconds: (json['resendAfterSeconds'] as num).toInt(),
);

Map<String, dynamic> _$SendSmsCodeResponseDtoToJson(
  _SendSmsCodeResponseDto instance,
) => <String, dynamic>{'resendAfterSeconds': instance.resendAfterSeconds};
