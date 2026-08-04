import "package:freezed_annotation/freezed_annotation.dart";

part "auth_tokens.freezed.dart";

/// 鉴权令牌对。登录返回 access + refresh；刷新接口只回新的 access
/// （不再下发 refresh），故 [refreshToken] 可空。
@freezed
abstract class AuthTokens with _$AuthTokens {
  const factory AuthTokens({
    required String accessToken,
    String? refreshToken,

    /// accessToken 有效期（v1 登录返回 86400 秒）。
    ///
    /// 记着它是为了将来能"到期前主动刷新"：只靠 401 被动刷新，用户每次都要先吃一个
    /// 失败请求的延迟。当前 v2 拦截器仍是被动刷新，此字段暂无消费方。
    Duration? expiresIn,
  }) = _AuthTokens;
}
