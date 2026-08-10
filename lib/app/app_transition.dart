import "package:flutter/material.dart";
import "package:happy_os/core/settings/index.dart";
import "package:happy_os/core/theme/index.dart";

/// 切换语言 / 深浅色时的整屏过渡。
///
/// ## 为什么需要它
/// `MaterialApp.locale` 一变，全屏文字同帧替换；`themeMode` 一变，整屏亮度反转。
/// 两者都是"啪"一下完成的，在一个视觉上很讲究的产品里显得很硬，深浅色互切时还晃眼。
///
/// ## 为什么不是把新旧两棵树交叉淡入
/// 交叉淡入要同时挂着新旧两棵树，而 go_router 的 Navigator 带 `GlobalKey`——
/// 同一个 GlobalKey 在一帧里出现两次会直接抛错。所以这里只有**一棵树**：
/// 新内容从透明淡入，底下垫一层**新主题的画布色**。用户看到的是"屏幕在新底色上
/// 重新长出来"，而不是两套界面互相穿透。
///
/// 顺带把 `HappyStarfieldBackground` 也一起盖住了：星野在深浅两色下是**结构性**
/// 不同的（深色才有星点层、浅色多一团云絮），颜色插值补不了这个差，
/// 整屏淡入才是唯一能把它一起带过去的做法。
///
/// 系统开了"减弱动态效果"时直接返回子树：过渡是氛围，不是信息。
class AppSettingsTransition extends StatefulWidget {
  const AppSettingsTransition({
    super.key,
    required this.settings,
    required this.child,
  });

  /// 当前偏好。它一变就播一次过渡（Freezed 的值相等，改回原值不会误触发）。
  final AppSettings settings;

  final Widget child;

  @override
  State<AppSettingsTransition> createState() => _AppSettingsTransitionState();
}

class _AppSettingsTransitionState extends State<AppSettingsTransition>
    with SingleTickerProviderStateMixin {
  /// 起始值给 1：首帧就是完整不透明的，冷启动不该先淡入一次
  /// ——那会让每次打开 app 都慢半拍。
  late final AnimationController _controller = AnimationController(
    duration: HappyMotion.normal,
    vsync: this,
    value: 1,
  );

  late final Animation<double> _opacity = CurvedAnimation(
    parent: _controller,
    curve: HappyMotion.entrance,
  );

  @override
  void didUpdateWidget(covariant AppSettingsTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.settings == widget.settings) return;
    // 从 0 重播：这一帧内容已经是新语言/新主题的了，让它从画布色里淡出来。
    _controller.forward(from: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) return widget.child;

    return ColoredBox(
      // 垫的是**新主题**的画布色：淡入过程中露出来的底不能还是旧主题的黑，
      // 否则从深色切浅色会先闪一下黑。
      color: Theme.of(context).scaffoldBackgroundColor,
      child: FadeTransition(opacity: _opacity, child: widget.child),
    );
  }
}
