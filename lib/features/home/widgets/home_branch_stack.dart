import "package:flutter/material.dart";
import "package:sky_dive/core/theme/index.dart";

/// 首页外壳的分支容器：三个 tab **全部常驻挂载**，切换时交叉淡入。
///
/// ## 为什么不用 `StatefulShellRoute.indexedStack`
/// `IndexedStack` 满足"全部挂载"，但切 tab 是硬切——上一屏瞬间消失、下一屏瞬间出现，
/// 在一个以视觉为卖点的 C 端产品里显得廉价。自己实现容器才能既保住挂载
/// （滚动位置、筛选条件、输入草稿都不丢），又给一次 160ms 的交叉淡入。
///
/// ## 为什么不是简单地给所有分支套 `AnimatedOpacity`
/// 透明度为 0 的子树**照样布局、照样绘制**，三个 tab 就等于每帧画三遍。
/// 这里的做法是：只有**当前分支**和**正在退场的上一个分支**处于 onstage，
/// 其余用 [Offstage] 摘掉——`Offstage` 跳过布局与绘制但保留 State，正是要的语义。
///
/// ## ⚠️ 淡出动画必须由**父级**驱动，不能用 `AnimatedOpacity`
/// 后台分支要 `TickerMode(enabled: false)` 停掉动画时钟（不然三个 tab 的入场动效、
/// 骨架流光都在后台空转）。但 `AnimatedOpacity` 自带的 controller 也是一个 ticker——
/// 一旦它长在被禁用的 `TickerMode` **里面**，退场分支刚变成 inactive，
/// 它的淡出就当场冻结在不透明度 1，`onEnd` 永不触发，于是那一层**永远盖在新 tab 上**，
/// 表现为两个页面的文字叠着渲染。
///
/// 所以淡入淡出改由本 State 持有的 [_controller] 驱动，`FadeTransition` 挂在
/// `TickerMode` **外面**——控制器活在父级，不受任何分支的 ticker 开关影响。
class HomeBranchStack extends StatefulWidget {
  const HomeBranchStack({
    super.key,
    required this.currentIndex,
    required this.children,
  });

  final int currentIndex;
  final List<Widget> children;

  @override
  State<HomeBranchStack> createState() => _HomeBranchStackState();
}

class _HomeBranchStackState extends State<HomeBranchStack>
    with SingleTickerProviderStateMixin {
  /// 交叉淡入的进度：0 = 刚开始切，1 = 新分支完全就位。
  /// 初值给 1，首帧就是完整不透明的——进 app 不该先淡入一次。
  late final AnimationController _controller = AnimationController(
    duration: SkyMotion.fast,
    vsync: this,
    value: 1,
  );

  /// 正在退场的分支下标。淡出结束后置回 null，把它重新 offstage 掉。
  int? _outgoingIndex;

  @override
  void initState() {
    super.initState();
    _controller.addStatusListener(_onStatusChanged);
  }

  @override
  void dispose() {
    _controller
      ..removeStatusListener(_onStatusChanged)
      ..dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(HomeBranchStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex == widget.currentIndex) return;
    setState(() => _outgoingIndex = oldWidget.currentIndex);
    _controller.forward(from: 0);
  }

  /// 淡出播完就把退场分支摘回 offstage，省掉它的布局与绘制。
  void _onStatusChanged(AnimationStatus status) {
    if (status != AnimationStatus.completed || _outgoingIndex == null) return;
    setState(() => _outgoingIndex = null);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        for (var i = 0; i < widget.children.length; i++)
          _BranchLayer(
            // 稳定的 key：分支的 State（滚动位置、输入草稿）靠它在重建间存活。
            key: ValueKey<int>(i),
            progress: _controller,
            isActive: i == widget.currentIndex,
            // 当前分支永远 onstage；退场分支在淡出期间暂留。
            isOnstage: i == widget.currentIndex || i == _outgoingIndex,
            child: widget.children[i],
          ),
      ],
    );
  }
}

class _BranchLayer extends StatelessWidget {
  const _BranchLayer({
    super.key,
    required this.progress,
    required this.isActive,
    required this.isOnstage,
    required this.child,
  });

  /// 父级持有的切换进度。进场分支跟着它涨，退场分支跟着它的反相落。
  final Animation<double> progress;

  final bool isActive;
  final bool isOnstage;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: !isOnstage,
      // FadeTransition 必须在 TickerMode **外面**，理由见 [HomeBranchStack] 的类注释。
      child: FadeTransition(
        opacity: isActive ? progress : ReverseAnimation(progress),
        child: TickerMode(
          // 非当前分支停掉动画时钟：后台 tab 的入场动效、骨架屏流光没必要跑。
          enabled: isActive,
          child: IgnorePointer(ignoring: !isActive, child: child),
        ),
      ),
    );
  }
}
