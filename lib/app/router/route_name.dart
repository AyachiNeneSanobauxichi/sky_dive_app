/// 路由名与路径常量：跳转只用这里的常量，禁止裸字符串。
///
/// - [RouteName]：`goNamed` / `pushNamed` 用的路由名。
/// - [RoutePath]：`GoRoute.path` 与深链接用的路径。
abstract final class RouteName {
  static const splash = "splash";
  static const login = "login";

  /// 首页三个 tab（`StatefulShellRoute` 的分支根）。v2 起各自是真实路由。
  static const story = "story";
  static const track = "track";
  static const user = "user";

  /// 个人档案设置（user tab 下的深入页）。
  static const userProfileSettings = "userProfileSettings";
}

abstract final class RoutePath {
  /// 启动占位页，作为 initialLocation：登录态未定时停留于此。
  static const splash = "/";

  /// 登录页（手机号 + 验证码）。v3 起没有独立注册页——未注册手机号直接建号。
  static const login = "/login";

  /// 首页三个 tab 各自的路径。v2 起底部 tab 由 `StatefulShellRoute` 承载：
  /// 每个 tab 是一个分支根，因此可以被深链接直达，也各自维护独立返回栈。
  static const story = "/story";
  static const track = "/track";
  static const user = "/user";

  /// 个人档案设置。路径写成 `/user/...` 表达归属，但**注册在 shell 外**，
  /// push 进去会盖住底部 tab 栏（表单页独占屏幕）。详见 `routes.dart` 的注释。
  static const userProfileSettings = "/user/profile-settings";

  /// 登录后落地的默认 tab（= 第一个分支）。守卫与登录成功跳转都用它，
  /// 这样以后调整"首屏是哪个 tab"只改这一行。
  static const home = story;
}

/// 查询参数名。和路径一样集中定义，避免调用方与解析方各写一个字符串写错。
abstract final class RouteQuery {
  /// 档案设置页要定位到哪个字段（值取 `UserProfileFieldKey.name`）。
  static const profileField = "field";
}
