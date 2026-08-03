import "package:freezed_annotation/freezed_annotation.dart";

part "send_sms_code_response_dto.freezed.dart";
part "send_sms_code_response_dto.g.dart";

/// 发送验证码响应体（信封解包后的 data）。
///
/// 冷却秒数由**后端**下发而不是客户端写死：短信网关的限频规则在服务端，
/// 客户端猜一个 60 秒，遇到风控加严时就会出现「倒计时结束了却仍然发不出去」。
@freezed
abstract class SendSmsCodeResponseDto with _$SendSmsCodeResponseDto {
  const factory SendSmsCodeResponseDto({required int resendAfterSeconds}) =
      _SendSmsCodeResponseDto;

  factory SendSmsCodeResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SendSmsCodeResponseDtoFromJson(json);
}
