import "package:go_router/go_router.dart";
import "package:happy_os/app/router/route_name.dart";
import "package:happy_os/app/splash_screen.dart";
import "package:happy_os/features/auth/index.dart";
import "package:happy_os/features/home/index.dart";

/// 应用路由表：所有页面在此声明式注册。
final List<RouteBase> appRoutes = [
  GoRoute(
    name: RouteName.splash,
    path: RoutePath.splash,
    builder: (context, state) => const SplashScreen(),
  ),
  GoRoute(
    name: RouteName.login,
    path: RoutePath.login,
    builder: (context, state) => const LoginScreen(),
  ),
  GoRoute(
    name: RouteName.home,
    path: RoutePath.home,
    builder: (context, state) => const HomeScreen(),
  ),
];
