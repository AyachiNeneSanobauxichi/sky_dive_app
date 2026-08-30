import "package:freezed_annotation/freezed_annotation.dart";

part "sms_login_request_dto.freezed.dart";
part "sms_login_request_dto.g.dart";

/// `POST /auth/login/sms` 请求体：手机号 + 短信验证码。
///
/// 未注册的手机号由后端**直接建号**——现场排队的客人没时间先去注册再回来登录。
@freezed
abstract class SmsLoginRequestDto with _$SmsLoginRequestDto {
  const factory SmsLoginRequestDto({
    required String phone,
    required String smsCode,
  }) = _SmsLoginRequestDto;

  factory SmsLoginRequestDto.fromJson(Map<String, dynamic> json) =>
      _$SmsLoginRequestDtoFromJson(json);
}
