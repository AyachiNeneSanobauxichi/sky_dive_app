import "package:freezed_annotation/freezed_annotation.dart";

part "send_sms_code_request_dto.freezed.dart";
part "send_sms_code_request_dto.g.dart";

/// 发送登录短信验证码的请求参数（v1 是 GET，[toJson] 作为 **query 参数**使用）。
///
/// 明明只有一个手机号还包一层 DTO：接口参数是会长的（风控票据、场景 scene），
/// 到时候只改这里，DataSource 与 Repository 的签名不动。
@freezed
abstract class SendSmsCodeRequestDto with _$SendSmsCodeRequestDto {
  const factory SendSmsCodeRequestDto({required String phone}) =
      _SendSmsCodeRequestDto;

  factory SendSmsCodeRequestDto.fromJson(Map<String, dynamic> json) =>
      _$SendSmsCodeRequestDtoFromJson(json);
}
