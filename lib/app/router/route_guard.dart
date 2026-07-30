import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:happy_os/app/router/route_name.dart";
import "package:happy_os/features/auth/index.dart";

/// 鉴权守卫（v2）：依据登录态集中处理重定向。
///
/// 三态：
/// - 未定（冷启动静默刷新中，`AsyncLoading`）→ 停在 splash，不干预。
/// - 已登录 → 不该停在 splash / login / register，跳 home。
/// - 未登录 → 只能待在 login / register，其余一律回 login。
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
