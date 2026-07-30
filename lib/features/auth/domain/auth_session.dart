import "package:freezed_annotation/freezed_annotation.dart";
import "package:happy_os/features/auth/domain/auth_tokens.dart";
import "package:happy_os/features/auth/domain/user.dart";

part "auth_session.freezed.dart";

/// 一次成功登录的完整结果：用户信息 + 令牌。
/// Repository 返回给 controller，由后者持久化令牌并置为已登录态。
@freezed
abstract class AuthSession with _$AuthSession {
  const factory AuthSession({required User user, required AuthTokens tokens}) =
      _AuthSession;
}
