import "package:freezed_annotation/freezed_annotation.dart";

part "sms_code_challenge.freezed.dart";

/// 一次「发送验证码」成功后服务端回执。
///
/// 注意 [expiresIn] 是**验证码有效期**（v1 = 300 秒），不是重发冷却时间——
/// v1 接口并不下发冷却秒数，按它倒计时会让用户五分钟内发不出第二条短信。
/// 重发节流仍由客户端本地承担（见 `SmsCodeController`）。
@freezed
abstract class SmsCodeChallenge with _$SmsCodeChallenge {
  const factory SmsCodeChallenge({
    /// 验证码有效期。
    required Duration expiresIn,

    /// 服务端回显的验证码。
    ///
    /// v1 接口在响应里直接带明文验证码（联调期便利），**生产环境不应存在**，
    /// 所以这里可空、且业务代码不得依赖它走登录主流程。
    // TODO(auth): 后端上线前会去掉回显，届时删除本字段。
    String? code,

    /// 服务端提示文案（如「验证码已发送，用于登录验证，有效期5分钟」）。
    /// 直接来自服务端，不走 i18n。
    String? message,
  }) = _SmsCodeChallenge;
}
