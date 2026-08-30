import "package:freezed_annotation/freezed_annotation.dart";
import "package:sky_dive/features/auth/domain/auth_tokens.dart";
import "package:sky_dive/features/auth/domain/user.dart";

part "auth_session.freezed.dart";

/// 一次成功登录 / 注册的完整结果：用户信息 + 令牌。
/// Repository 返回给 controller，由后者持久化令牌并置为已登录态。
@freezed
abstract class AuthSession with _$AuthSession {
  const factory AuthSession({
    required User user,
    required AuthTokens tokens,

    /// 服务端记录的本次登录时刻（解析失败则为 null）。
    DateTime? loginTime,

    /// 这次会话是不是**刚注册**出来的。
    ///
    /// 首页据此决定要不要走新人引导（第一次跳伞的人需要先看安全须知与体重限制），
    /// 老客直接进航线列表。放在会话里而不是靠 `totalJumps == 0` 猜：
    /// 老客也可能一次都还没跳（约了还没到日子）。
    @Default(false) bool isNewAccount,
  }) = _AuthSession;
}
