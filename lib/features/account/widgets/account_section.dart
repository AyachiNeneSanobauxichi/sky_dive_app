import "package:flutter/material.dart";
import "package:sky_dive/core/theme/index.dart";

/// 账号页的一个设置分组：小标题 + 一张卡片，卡片内的行由调用方给。
///
/// 抽成组件而不是每处各写一遍 `Column + Text + Card`，是为了让"分组标题该多大、
/// 离卡片多远、卡片里的行怎么分隔"只有一个答案——设置页最容易在这三件事上长歪。
class AccountSection extends StatelessWidget {
  const AccountSection({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;

  /// 分组内的行。行与行之间自动插分割线，调用方不用自己加。
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            left: SkySpacing.s4,
            bottom: SkySemanticSpacing.labelGap,
          ),
          child: Text(
            title,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Card(
          // clipBehavior 必需：行内的 InkWell 水波要被卡片圆角裁住，
          // 否则点第一行时水波会溢出到圆角外面，露出一个直角。
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: <Widget>[
              for (var i = 0; i < children.length; i++) ...<Widget>[
                if (i > 0)
                  const Divider(
                    height: SkyBorderWidth.hairline,
                    // 分割线从文字起始处开始，不顶到卡片边——顶到边会把一张卡
                    // 切成几张，视觉上就不再是一个分组了。
                    indent: SkySemanticSpacing.cardPadding,
                  ),
                children[i],
              ],
            ],
          ),
        ),
      ],
    );
  }
}
