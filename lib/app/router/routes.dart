import "package:go_router/go_router.dart";
import "package:sky_dive/app/router/route_name.dart";
import "package:sky_dive/app/splash_screen.dart";
import "package:sky_dive/features/account/index.dart";
import "package:sky_dive/features/auth/index.dart";
import "package:sky_dive/features/booking/index.dart";
import "package:sky_dive/features/flight/index.dart";
import "package:sky_dive/features/home/index.dart";

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
  // 注册页。`?email=...` 把登录页已填的邮箱带过来预填，用户不必再敲一遍。
  GoRoute(
    name: RouteName.register,
    path: RoutePath.register,
    builder: (context, state) => RegisterScreen(
      initialEmail: state.uri.queryParameters[RouteQuery.email],
    ),
  ),
  // 首页底部 tab：用 StatefulShellRoute 而不是页面内 setState 切换。
  //
  // 换成分支式外壳解决了三件页面内状态做不到的事：
  // 1. 每个 tab 是真实路由（/flights · /bookings · /account）→ 可深链接、可埋点、可分享；
  // 2. 每个分支有独立 Navigator → 在 flights 里 push 航线详情，切到 bookings 再切回来，
  //    flights 的返回栈还在（页面内状态方案下详情页会盖住整个 tab 栏）；
  // 3. 三个分支常驻挂载 → 滚动位置与筛选条件不丢（规范要求）。
  //
  // 这里用 StatefulShellRoute 默认构造而非 `.indexedStack`：默认的 IndexedStack
  // 容器切 tab 是硬切，自己实现容器（[HomeBranchStack]）才能做交叉淡入，
  // 同时保住"全部分支挂载"这一点。
  StatefulShellRoute(
    builder: (context, state, navigationShell) =>
        HomeShell(navigationShell: navigationShell),
    navigatorContainerBuilder: (context, navigationShell, children) =>
        HomeBranchStack(
          currentIndex: navigationShell.currentIndex,
          children: children,
        ),
    branches: <StatefulShellBranch>[
      StatefulShellBranch(
        routes: <RouteBase>[
          GoRoute(
            name: RouteName.flights,
            path: RoutePath.flights,
            builder: (context, state) => const FlightScreen(),
            // 航线详情 / 新建 / 编辑作为**子路由**挂在这里，而不是弹层：
            // 1. 可深链接（推送点进来直达某条航线、分享给同事）；
            // 2. 沿用本分支的返回栈，切到别的 tab 再回来还停在原页；
            // 3. 底部 tab 栏保持可见——排班的人常常要在航线与预约之间来回跳。
            routes: <RouteBase>[
              // "new" 必须排在 ":loadId" 前面，否则会被当成一个 id 吃掉。
              GoRoute(
                name: RouteName.loadCreate,
                path: RoutePath.loadCreateSegment,
                builder: (context, state) => const LoadFormScreen(),
              ),
              GoRoute(
                name: RouteName.loadDetail,
                path: RoutePath.loadDetailSegment,
                builder: (context, state) => LoadDetailScreen(
                  loadId: state.pathParameters[RouteParam.loadId]!,
                ),
                routes: <RouteBase>[
                  GoRoute(
                    name: RouteName.loadEdit,
                    path: RoutePath.loadEditSegment,
                    builder: (context, state) => LoadFormScreen(
                      loadId: state.pathParameters[RouteParam.loadId],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      StatefulShellBranch(
        routes: <RouteBase>[
          GoRoute(
            name: RouteName.bookings,
            path: RoutePath.bookings,
            builder: (context, state) => const BookingScreen(),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: <RouteBase>[
          GoRoute(
            name: RouteName.account,
            path: RoutePath.account,
            builder: (context, state) => const AccountScreen(),
          ),
        ],
      ),
    ],
  ),
];
