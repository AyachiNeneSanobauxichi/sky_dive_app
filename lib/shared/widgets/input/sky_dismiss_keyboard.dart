import "package:flutter/material.dart";

/// 收起软键盘：清掉当前焦点，输入法随之落下。
///
/// 为什么单独抽成函数：本项目"点其他区域收键盘"有两条触发路径——
/// 全屏兜底手势层 [SkyDismissKeyboard] 与输入框自己的 `onTapOutside`
/// （[skyDismissKeyboardOnTapOutside]）。两条路径必须共用同一套语义，
/// 否则会出现"有的页面点得动、有的点不动"这种最难排查的体验不一致。
void skyDismissKeyboard() {
  final focus = FocusManager.instance.primaryFocus;
  // 没有焦点就没有键盘：直接返回，避免无谓的焦点变更把按钮/选项的
  // 焦点态也一并清掉（键盘外的焦点是键控与无障碍导航要用的）。
  if (focus == null || !focus.hasFocus) return;
  focus.unfocus();
}

/// 直接挂给输入类控件 `onTapOutside` 的回调。
///
/// 移动端 `EditableText` 的默认 `onTapOutside` 是**保持焦点**，所以点到按钮、
/// 日期选择器这类"自己会处理点击"的控件时键盘不会收；显式传本回调即把行为
/// 改成"点输入框以外的任何地方都收键盘"。
///
/// 它由 `TapRegion` 在 pointer-down 阶段触发，**不参与手势竞技场**，
/// 因此不会和被点控件的 `onTap` 抢手势；且仅在该输入框持有焦点时启用。
void skyDismissKeyboardOnTapOutside(PointerDownEvent _) => skyDismissKeyboard();

/// 全屏兜底手势层：点击页面空白处收起键盘。
///
/// 挂在 `MaterialApp.builder` 上即覆盖全部路由（dialog / bottom sheet 也在被
/// 包裹的 Navigator overlay 之内），新增页面无需重复接线。
///
/// 与输入框 `onTapOutside` 的分工：本层负责"点到没人处理的空白"，
/// [skyDismissKeyboardOnTapOutside] 负责"点到别的可交互控件"。
class SkyDismissKeyboard extends StatelessWidget {
  const SkyDismissKeyboard({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // translucent：本层参与命中测试但不吞事件——下层按钮点击、列表滚动照常；
      // 点到有 tap 处理的控件时内层手势胜出，这里的 onTap 不会触发。
      behavior: HitTestBehavior.translucent,
      onTap: skyDismissKeyboard,
      // 纯手势兜底层，不该在无障碍树里凭空多出一个可点节点。
      excludeFromSemantics: true,
      child: child,
    );
  }
}
