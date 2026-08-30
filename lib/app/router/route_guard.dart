import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:sky_dive/app/router/route_name.dart";
import "package:sky_dive/features/auth/index.dart";

/// 鉴权守卫：依据登录态集中处理重定向。
///
/// 三态：
/// - 未定（冷启动静默刷新中，`AsyncLoading`）→ 停在 splash，不干预。
/// - 已登录 → 不该停在 splash / 认证页，跳首页默认 tab（[RoutePath.home]）。
/// - 未登录 → 只能待在认证页（登录 / 注册），其余一律回登录页。
String? guardRedirect(AsyncValue<AuthState> auth, GoRouterState state) {
  final loc = state.matchedLocation;
  final onSplash = loc == RoutePath.splash;
  final onAuthPages = loc == RoutePath.login || loc == RoutePath.register;

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
