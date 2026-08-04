import "package:go_router/go_router.dart";
import "package:happy_os/app/router/route_name.dart";
import "package:happy_os/app/splash_screen.dart";
import "package:happy_os/features/auth/index.dart";
import "package:happy_os/features/home/index.dart";
import "package:happy_os/features/story/index.dart";
import "package:happy_os/features/track/index.dart";
import "package:happy_os/features/user/index.dart";

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
  // 首页底部 tab（v2）：用 StatefulShellRoute 而不是页面内 setState 切换。
  //
  // 换成分支式外壳解决了三件页面内状态做不到的事：
  // 1. 每个 tab 是真实路由（/track · /story · /user）→ 可深链接、可埋点、可分享；
  // 2. 每个分支有独立 Navigator → 在 story 里 push 详情页，切到 track 再切回来，
  //    story 的返回栈还在（页面内状态方案下详情页会盖住整个 tab 栏）；
  // 3. 三个分支常驻挂载 → 滚动位置与输入草稿不丢（规范要求）。
  //
  // tab 顺序 track → story → user：先记轨迹才有素材可改写，把"素材源"放在
  // 动线起点；但**落地页仍是 story**（见 [RoutePath.home]），主路径不因排序变化。
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
            name: RouteName.track,
            path: RoutePath.track,
            builder: (context, state) => const TrackScreen(),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: <RouteBase>[
          GoRoute(
            name: RouteName.story,
            path: RoutePath.story,
            builder: (context, state) => const StoryScreen(),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: <RouteBase>[
          GoRoute(
            name: RouteName.user,
            path: RoutePath.user,
            builder: (context, state) => const UserScreen(),
          ),
        ],
      ),
    ],
  ),
  // 个人档案设置：刻意放在 shell **外面**（不是 user 分支的子路由）。
  // 分支子路由会渲染在外壳内部、底部 tab 栏照旧显示；而这是一张要独占屏幕的表单页
  // （日后有保存按钮，底部再顶一条导航会抢位置），所以让它盖住整个外壳。
  // 代价：它不在 user 分支的返回栈里，切到别的 tab 再切回来不会停在这一页。
  GoRoute(
    name: RouteName.userProfileSettings,
    path: RoutePath.userProfileSettings,
    // `?field=company`：从档案卡某一行点进来时告知要定位到哪一项。
    // 用 query 参数而不是 `extra`：它必须能在深链接/刷新后恢复。
    builder: (context, state) => ProfileSettingsScreen(
      targetField: UserProfileFieldKey.tryParse(
        state.uri.queryParameters[RouteQuery.profileField],
      ),
    ),
  ),
];
