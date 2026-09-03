import "package:flutter/material.dart";
import "package:sky_dive/core/theme/index.dart";
import "package:sky_dive/features/account/widgets/account_section.dart";

/// 设置项的**二级选择弹层**（外观 / 语言）。
///
/// ## 为什么不平铺在设置页上
/// 外观 3 档 + 语言 4 档一起铺开就是 7 行，把「关于」「退出登录」这些真正需要
/// 被找到的入口挤到了屏幕外，而这两项**一年也改不了两次**。收进二级菜单后，
/// 设置页第一屏只剩「外观 · 跟随系统」「语言 · 跟随系统」两行，当前值还在行尾
/// 一眼可见——想改的人点一下就到，不想改的人不必滚过它们。
///
/// 用弹层而不是新路由：这是一次性的选择动作，不值得占一层返回栈（航线的
/// 选人弹层同理）。
///
/// [optionsBuilder] 收的是**弹层自己的 context**：选项行要靠它把弹层关掉，
/// 用外面页面的 context 去 pop 是在赌"栈顶正好是这个弹层"。
Future<void> showAccountChoiceSheet(
  BuildContext context, {
  required String title,
  required List<Widget> Function(BuildContext sheetContext) optionsBuilder,
}) => showModalBottomSheet<void>(
  context: context,
  // useRootNavigator 必需：账号页在 `StatefulShellRoute` 的分支 Navigator 里，
  // 默认的弹层会挂到分支 Navigator 上，而底部导航条在外壳 Scaffold 上——
  // 结果就是条子盖住弹层底部（最后一个选项点不到）。挂到根 Navigator 才盖得住它。
  useRootNavigator: true,
  useSafeArea: true,
  builder: (sheetContext) => SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(
      SkySemanticSpacing.screenPadding,
      SkySpacing.none,
      SkySemanticSpacing.screenPadding,
      SkySemanticSpacing.sectionGap,
    ),
    // 复用设置页的分组卡片：二级菜单和一级菜单长得一样，才不会读成两套东西。
    child: AccountSection(title: title, children: optionsBuilder(sheetContext)),
  ),
);
