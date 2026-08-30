import "package:freezed_annotation/freezed_annotation.dart";
import "package:sky_dive/features/auth/domain/index.dart";

part "send_sms_code_response_dto.freezed.dart";
part "send_sms_code_response_dto.g.dart";

/// `GET /auth/sms-code` 响应体（信封解包后的 data）。
///
/// 三个字段全部给默认值 / 可空：发码这一步只要服务端说成功就算成功，
/// 不该因为某个提示字段没下发就把「短信已经发出去了」这件事判成失败。
@freezed
abstract class SendSmsCodeResponseDto with _$SendSmsCodeResponseDto {
  const SendSmsCodeResponseDto._();

  const factory SendSmsCodeResponseDto({
    /// 服务端回显的验证码（联调期便利，生产应移除）。
    String? code,

    /// 验证码有效期（秒），**不是**重发冷却秒数。
    @Default(0) int expiresIn,
    String? message,
  }) = _SendSmsCodeResponseDto;

  factory SendSmsCodeResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SendSmsCodeResponseDtoFromJson(json);

  SmsCodeChallenge toEntity() => SmsCodeChallenge(
    expiresIn: Duration(seconds: expiresIn),
    code: code,
    message: message,
  );
}
