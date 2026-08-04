import "package:flutter/material.dart";

/// 首页外壳向下传递的分支上下文（v2）。
///
/// 目前只传一件事：**每个 tab 分支各自的 [ScrollController]**。
///
/// 为什么需要它：「再次点击当前 tab 把内容滚回顶部」这个交互的**触发方**在外壳的
/// 导航条上，而**执行方**（滚动位置）在分支页面里，两者隔着 go_router 的分支容器。
/// 外壳持有控制器、分支容器用它做 [PrimaryScrollController]，页面里的可滚动区
/// （`primary` 默认为 true）就会自动挂上去，页面自己一行都不用改。
///
/// 每个分支一个控制器而不是共用一个：共用的话滚顶会把三个 tab 一起拽回顶部，
/// 违反"tab 切换回来不重置到顶部"。
class HomeBranchScope extends InheritedWidget {
  const HomeBranchScope({
    super.key,
    required this.controllerFor,
    required super.child,
  });

  /// 取第 [index] 个分支的滚动控制器（不存在则由外壳惰性创建）。
  final ScrollController Function(int index) controllerFor;

  static HomeBranchScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<HomeBranchScope>();

  @override
  bool updateShouldNotify(HomeBranchScope oldWidget) =>
      controllerFor != oldWidget.controllerFor;
}
