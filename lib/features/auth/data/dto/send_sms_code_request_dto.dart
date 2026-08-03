import "package:freezed_annotation/freezed_annotation.dart";

part "send_sms_code_request_dto.freezed.dart";
part "send_sms_code_request_dto.g.dart";

/// 发送登录短信验证码请求体。
///
// TODO(auth): 真实接口大概率还需要 scene（登录/换绑）与风控票据（图形验证码 token），
//   等 auth.api.md 定稿后补字段。
@freezed
abstract class SendSmsCodeRequestDto with _$SendSmsCodeRequestDto {
  const factory SendSmsCodeRequestDto({required String phone}) =
      _SendSmsCodeRequestDto;

  factory SendSmsCodeRequestDto.fromJson(Map<String, dynamic> json) =>
      _$SendSmsCodeRequestDtoFromJson(json);
}
