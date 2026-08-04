import "dart:ui" show lerpDouble;

import "package:flutter/material.dart";
import "package:happy_os/core/theme/index.dart";
import "package:happy_os/features/home/widgets/home_branch_scope.dart";

/// 首页三个 tab 分支的容器（v2）。
///
/// 替代 `StatefulShellRoute.indexedStack` 的默认容器，目的只有一个：**切 tab 时
/// 新页有"落位感"**，而不是硬切。跨模块硬切会让人分不清"是换了页还是页面炸了"。
///
/// 动效形态是试过三版之后定的（结论写在这里，免得后人再踩）：
/// 1. **交叉溶解**（两页同时半透明）→ 三个 tab 的标题与空态文案落在相近位置，
///    叠起来是重影，像渲染出错。
/// 2. **旧页立即隐去 + 新页 0→1 淡入** → 切换起始那一两帧两页都不可见，
///    出现空白帧（浅色主题下是一下白闪）。
/// 3. ✅ **旧页立即隐去 + 新页从 [_enterOpacity] 微微升起** → 任一帧都恰好只有
///    一页可读，既没有重影也没有空窗，仍能感到"内容换了并落定"。
///
/// 为什么不用 `AnimatedSwitcher`：它靠"换 child"驱动动画，会把旧分支的 element
/// 树拆掉重建——滚动位置、输入草稿全丢，正是分支式外壳要解决的问题。这里三个分支
/// **始终挂在 Stack 里**，只动各自的不透明度与位移，状态一份不丢。
///
/// 三条配套约束：
/// - 非当前分支 [IgnorePointer]：它虽然还在树上，但不能吃掉手势。
/// - 非当前分支关 [TickerMode]：否则后台页的动效（极光、流式文本）继续烧帧。
/// - 不透明度为 0 时 Flutter 跳过绘制，所以代价只剩"三页都参与布局"；页数上到
///   5+ 或单页很重时要回退成 `Offstage`（会丢落位动效）或懒挂载。
class HomeBranchStack extends StatefulWidget {
  const HomeBranchStack({
    super.key,
    required this.currentIndex,
    required this.children,
  });

  final int currentIndex;

  /// go_router 提供的分支 Navigator 列表，顺序与 branches 声明一致。
  final List<Widget> children;

  @override
  State<HomeBranchStack> createState() => _HomeBranchStackState();
}

class _HomeBranchStackState extends State<HomeBranchStack>
    with SingleTickerProviderStateMixin {
  /// 入场起始不透明度。刻意不从 0 开始——从 0 起会先给一帧空画布（见类注释第 2 版）。
  static const double _enterOpacity = 0.85;

  late final AnimationController _controller = AnimationController(
    duration: HappyMotion.fast,
    vsync: this,
    // 首帧就位：进 app 时不该再播一次"落位"，那是给"切过来"用的。
    value: 1,
  );

  @override
  void didUpdateWidget(HomeBranchStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 只有真的换了 tab 才重播；主题切换等无关重建不该触发动效。
    if (oldWidget.currentIndex != widget.currentIndex) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      // expand：每个分支都撑满外壳的 body，而不是按内容缩成左上角一团。
      fit: StackFit.expand,
      children: <Widget>[
        for (final (int index, Widget child) in widget.children.indexed)
          _branch(context: context, index: index, child: child),
      ],
    );
  }

  /// 包一层"选中/未选中"的壳。
  ///
  /// ⚠️ 两种状态必须走**完全相同的 widget 结构**（只让参数变），否则 Flutter 在
  /// 该位置比对到不同类型，会把整棵分支子树拆掉重建——页面 State 丢失、入场动效
  /// 每次切 tab 都重播一遍（`HappyEmptyState` 的 fadeIn 就是这么暴露出来的）。
  /// 所以下面不写 `if (!isActive) return ...` 的短路分支。
  Widget _branch({
    required BuildContext context,
    required int index,
    required Widget child,
  }) {
    final isActive = index == widget.currentIndex;
    // 挂上本分支专属的滚动控制器：页面里的可滚动区（primary 默认 true）会自动
    // 附着，外壳才能实现"再次点击当前 tab 滚回顶部"，页面自身无需改动。
    final scope = HomeBranchScope.maybeOf(context);
    final branch = scope == null
        ? child
        : PrimaryScrollController(
            controller: scope.controllerFor(index),
            child: child,
          );

    return IgnorePointer(
      ignoring: !isActive,
      child: TickerMode(
        enabled: isActive,
        child: AnimatedBuilder(
          animation: _controller,
          // child 不随动画重建，只有外层的 Opacity / Transform 每帧变。
          child: branch,
          builder: (context, animatedChild) {
            // 未选中的分支停在"不可见"（也不参与位移），但仍然挂载守住状态。
            final t = isActive
                ? HappyMotion.entrance.transform(_controller.value)
                : 0.0;
            return Opacity(
              opacity: isActive ? lerpDouble(_enterOpacity, 1, t)! : 0,
              child: Transform.translate(
                // 极短的上浮，读作"内容落位"；再大就变成页面转场，抢戏。
                offset: Offset(
                  0,
                  isActive ? lerpDouble(HappySpacing.s6, 0, t)! : 0,
                ),
                child: animatedChild,
              ),
            );
          },
        ),
      ),
    );
  }
}
