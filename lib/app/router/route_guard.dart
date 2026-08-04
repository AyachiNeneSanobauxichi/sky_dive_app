import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:happy_os/app/router/route_name.dart";
import "package:happy_os/features/auth/index.dart";

/// 鉴权守卫（v3）：依据登录态集中处理重定向。
///
/// 三态：
/// - 未定（冷启动静默刷新中，`AsyncLoading`）→ 停在 splash，不干预。
/// - 已登录 → 不该停在 splash / login，跳首页默认 tab（[RoutePath.home]）。
/// - 未登录 → 只能待在 login，其余一律回 login。
String? guardRedirect(AsyncValue<AuthState> auth, GoRouterState state) {
  final loc = state.matchedLocation;
  final onSplash = loc == RoutePath.splash;
  // v3 起认证只有登录页一个入口（验证码登录即注册）。
  final onAuthPages = loc == RoutePath.login;

  if (auth.isLoading) {
    return onSplash ? null : RoutePath.splash;
  }

  final authed = switch (auth) {
    AsyncData(value: Authenticated()) => true,
    _ => false,
  };

  if (authed) {
    return (onSplash || onAuthPages) ? RoutePath.home : null;
  }
  return onAuthPages ? null : RoutePath.login;
}
