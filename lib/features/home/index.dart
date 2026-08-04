/// **home 模块：首页外壳。**
///
/// 只承载底部 tab 导航（story · track · user 三个路由分支的容器），本身没有业务内容；
/// tab 的当前位置由路由持有，见 `app/router/routes.dart` 的 `StatefulShellRoute`。
library;

export "screens/index.dart";
export "widgets/index.dart";
