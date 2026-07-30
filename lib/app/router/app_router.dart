import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:happy_os/app/router/route_guard.dart";
import "package:happy_os/app/router/route_name.dart";
import "package:happy_os/app/router/routes.dart";
import "package:happy_os/features/auth/index.dart";
import "package:happy_os/l10n/app_localizations.dart";

/// 应用路由器（v2）：登录态驱动重定向。
///
/// 用 provider 装配，以便 watch [authControllerProvider]：登录态变化通过
/// [GoRouter.refreshListenable] 触发 go_router 重算 redirect
/// （登录 → home、登出/失效 → login）。
final routerProvider = Provider<GoRouter>((ref) {
  // ValueNotifier 作 refreshListenable：登录态每次变化就自增，驱动 redirect 重跑。
  final refresh = ValueNotifier<int>(0);
  ref.listen(authControllerProvider, (_, _) => refresh.value++);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: RoutePath.splash,
    routes: appRoutes,
    refreshListenable: refresh,
    redirect: (context, state) =>
        guardRedirect(ref.read(authControllerProvider), state),
    errorBuilder: (context, state) => const _RouteErrorScreen(),
  );
});

/// 未知路由的兜底页面。
class _RouteErrorScreen extends StatelessWidget {
  const _RouteErrorScreen();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(body: Center(child: Text(l10n.routeNotFound)));
  }
}
