import "package:freezed_annotation/freezed_annotation.dart";
import "package:happy_os/features/auth/domain/user.dart";

part "auth_state.freezed.dart";

/// 全局登录态。用 sealed union 便于 `switch` 穷尽，并驱动路由守卫（v2）。
///
/// - [AuthUnknown]：尚未确定（启动静默 refresh 进行中），**不应据此重定向**。
/// - [Authenticated]：已登录，携带当前用户。
/// - [Unauthenticated]：未登录 / 已登出 / 会话失效。
@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.unknown() = AuthUnknown;
  const factory AuthState.authenticated(User user) = Authenticated;
  const factory AuthState.unauthenticated() = Unauthenticated;
}
