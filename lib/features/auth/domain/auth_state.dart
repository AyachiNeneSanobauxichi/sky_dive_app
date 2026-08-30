import "package:freezed_annotation/freezed_annotation.dart";
import "package:sky_dive/features/auth/domain/user.dart";

part "auth_state.freezed.dart";

/// 全局登录态。用 sealed union 便于 `switch` 穷尽，并驱动路由守卫。
///
/// - [AuthUnknown]：尚未确定（启动静默 refresh 进行中），**不应据此重定向**。
/// - [Authenticated]：已登录，携带当前用户。
/// - [Unauthenticated]：未登录 / 已登出 / 会话失效。
@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.unknown() = AuthUnknown;
  const factory AuthState.authenticated(User user) = Authenticated;
  const factory AuthState.unauthenticated() = Unauthenticated;

  const AuthState._();

  /// 已登录则取当前用户，否则 null。
  ///
  /// 需要它是因为绝大多数页面只关心"用户是谁"，不关心未登录的两种子态——
  /// 让每个页面各写一次 `switch` 只会把同一个模式抄十遍。
  User? get userOrNull => switch (this) {
    Authenticated(:final user) => user,
    _ => null,
  };
}
