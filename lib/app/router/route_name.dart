/// 路由名与路径常量：跳转只用这里的常量，禁止裸字符串。
///
/// - [RouteName]：`goNamed` / `pushNamed` 用的路由名。
/// - [RoutePath]：`GoRoute.path` 与深链接用的路径。
abstract final class RouteName {
  static const splash = "splash";
  static const login = "login";
  static const register = "register";

  /// 首页三个 tab（`StatefulShellRoute` 的分支根）。
  static const flights = "flights";
  static const bookings = "bookings";
  static const account = "account";

  /// 航线子页面。挂在 flights 分支下，因此保留底部 tab 与该分支的独立返回栈。
  static const loadCreate = "loadCreate";
  static const loadDetail = "loadDetail";
  static const loadEdit = "loadEdit";
}

abstract final class RoutePath {
  /// 启动占位页，作为 initialLocation：登录态未定时停留于此。
  static const splash = "/";

  /// 登录页（邮箱密码 / 手机验证码两种方式）。
  static const login = "/login";

  /// 注册页（邮箱 + 密码）。手机验证码那条路首登即建号，不经过这里。
  static const register = "/register";

  /// 首页三个 tab 各自的路径。底部 tab 由 `StatefulShellRoute` 承载：
  /// 每个 tab 是一个分支根，因此可以被深链接直达，也各自维护独立返回栈。
  ///
  /// 顺序 flights → bookings → account：先看有什么可跳（发现），再看自己约了什么
  /// （履约），最后才是账号设置。转化路径放在动线起点。
  static const flights = "/flights";
  static const bookings = "/bookings";
  static const account = "/account";

  /// 航线子路由的**相对**路径段。完整深链接分别是：
  /// `/flights/new`、`/flights/:loadId`、`/flights/:loadId/edit`。
  ///
  /// ⚠️ 注册顺序上 [loadCreateSegment] 必须排在 [loadDetailSegment] **前面**，
  /// 否则 `/flights/new` 会被 `:loadId` 当成一个 id 吃掉，永远进不了新建页。
  static const loadCreateSegment = "new";
  static const loadDetailSegment = ":loadId";
  static const loadEditSegment = "edit";

  /// 登录后落地的默认 tab（= 第一个分支）。守卫与登录成功跳转都用它，
  /// 这样以后调整"首屏是哪个 tab"只改这一行。
  static const home = flights;
}

/// 路径参数名。和路径常量一样集中定义，避免声明方与解析方各写一个字符串写错。
abstract final class RouteParam {
  /// 航线 id（`/flights/:loadId`）。
  static const loadId = "loadId";
}

/// 查询参数名。和路径一样集中定义，避免调用方与解析方各写一个字符串写错。
abstract final class RouteQuery {
  /// 带进注册页的邮箱预填值。
  ///
  /// 用户在登录页填了邮箱、发现自己还没注册时，点"去注册"不该让他把邮箱再敲一遍。
  /// 用 query 而不是 `extra`：深链接 / 热重启后要能恢复。
  static const email = "email";
}
