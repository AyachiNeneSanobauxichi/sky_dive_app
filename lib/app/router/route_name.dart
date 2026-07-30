/// 路由名与路径常量：跳转只用这里的常量，禁止裸字符串。
///
/// - [RouteName]：`goNamed` / `pushNamed` 用的路由名。
/// - [RoutePath]：`GoRoute.path` 与深链接用的路径。
abstract final class RouteName {
  static const splash = "splash";
  static const login = "login";
  static const register = "register";
  static const home = "home";
}

abstract final class RoutePath {
  /// 启动占位页，作为 initialLocation：登录态未定时停留于此。
  static const splash = "/";
  static const login = "/login";
  static const register = "/register";
  static const home = "/home";
}
