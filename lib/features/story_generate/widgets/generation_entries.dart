import "package:flutter/material.dart";
import "package:happy_os/core/theme/index.dart";
import "package:happy_os/shared/widgets/index.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 心愿条：用户那句话，时间线第一条。
///
/// 用玻璃卡而不是普通卡：它是**这场生成的由头**，整页只有它一张玻璃，
/// 视觉上自然成为起点（`HappyGlassCard` 的注释也要求一屏 1–3 张封顶）。
class WishEntryView extends StatelessWidget {
  const WishEntryView({super.key, required this.text, required this.label});

  final String text;

  /// 「你的心愿」这类标签。
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return HappyGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: HappySemanticSpacing.labelGap,
        children: <Widget>[
          Row(
            spacing: HappySemanticSpacing.labelGap,
            children: <Widget>[
              Icon(
                LucideIcons.quote,
                size: HappyIconSize.sm,
                color: scheme.primary,
              ),
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          Text(text, style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }
}

/// 正文条：流式生成中的故事本体。
///
/// 生成中用 [HappyStreamingText]（带光标，是"还在写"的唯一视觉证据）；写完切成
/// [SelectableText] —— 长文写完了就该能选中复制，而流式态因为尾部挂着 `WidgetSpan`
/// 光标没法可靠选中（见 `HappyStreamingText` 的注释）。
class NovelEntryView extends StatelessWidget {
  const NovelEntryView({
    super.key,
    required this.content,
    required this.isStreaming,
    required this.label,
  });

  final String content;
  final bool isStreaming;

  /// 「你的爽文」这类标签。
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(HappySemanticSpacing.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: HappySemanticSpacing.itemGap,
          children: <Widget>[
            Row(
              spacing: HappySemanticSpacing.labelGap,
              children: <Widget>[
                Icon(
                  LucideIcons.bookOpen,
                  size: HappyIconSize.sm,
                  color: scheme.tertiary,
                ),
                Text(
                  label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            if (isStreaming)
              HappyStreamingText(text: content, isStreaming: true)
            else
              SelectableText(content, style: theme.textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
