import "package:flutter/material.dart";
import "package:happy_os/core/theme/index.dart";

/// 指标说明弹层（点指标卡弹出）。
///
/// 「深度觉醒等级」「星厉契合度」都是本产品自造的概念，用户第一次看到只会看到一个
/// 数字，不知道怎么涨、涨了有什么用。所以说明分两段写死结构：**这是什么** +
/// **怎么变高**——后者才是用户真正想知道的。
class UserMetricExplainer extends StatelessWidget {
  const UserMetricExplainer({
    super.key,
    required this.icon,
    required this.title,
    required this.whatItIs,
    required this.howToRaise,
    required this.howToRaiseTitle,
  });

  final IconData icon;
  final String title;

  /// 这是什么。
  final String whatItIs;

  /// "怎么变高"小标题与正文。
  final String howToRaiseTitle;
  final String howToRaise;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(
          left: HappySemanticSpacing.screenPadding,
          right: HappySemanticSpacing.screenPadding,
          bottom: HappySemanticSpacing.sectionGap,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(icon, size: HappyIconSize.lg, color: scheme.primary),
                const SizedBox(width: HappySpacing.s8),
                Expanded(child: Text(title, style: theme.textTheme.titleLarge)),
              ],
            ),
            const SizedBox(height: HappySemanticSpacing.itemGap),
            Text(whatItIs, style: theme.textTheme.bodyMedium),
            const SizedBox(height: HappySemanticSpacing.sectionGap),
            Text(
              howToRaiseTitle,
              style: theme.textTheme.labelMedium?.copyWith(
                color: scheme.primary,
              ),
            ),
            const SizedBox(height: HappySpacing.s8),
            Text(
              howToRaise,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
