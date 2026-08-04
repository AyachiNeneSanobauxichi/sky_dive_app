import "package:flutter/material.dart";
import "package:happy_os/core/theme/index.dart";
import "package:happy_os/features/story/domain/index.dart";
import "package:happy_os/shared/widgets/index.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 生成历史里的一条。
///
/// 状态用**图标 + 文字**双通道表达（不只靠颜色）：生成中带"生成中"字样、
/// 失败带"点开可重试"。生成是长任务，用户切走再回来必须能一眼分清哪篇写好了、
/// 哪篇断了。
///
/// **生成中的那行走流光**（[HappyShimmerText]）：静态文字表达不出"后台真的在写"，
/// 一道循环扫过的光比转圈安静、又比静态字有生命。切到别的 tab 时它会自动停——
/// 外壳的分支容器把非当前分支的 `TickerMode` 关了（见 `HomeBranchStack`），
/// 不会在后台白烧帧。
class StoryHistoryCard extends StatelessWidget {
  const StoryHistoryCard({
    super.key,
    required this.story,
    required this.timeLabel,
    required this.statusLabel,
    required this.onTap,
  });

  final Story story;

  /// 已格式化好的时间（格式化要 locale，交给调用方）。
  final String timeLabel;

  /// 已本地化的状态文案；`ready` 时传空串表示不显示状态行。
  final String statusLabel;

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final accent = switch (story.status) {
      StoryStatus.generating => scheme.primary,
      StoryStatus.failed => scheme.error,
      StoryStatus.ready => scheme.onSurfaceVariant,
    };

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(HappySemanticSpacing.cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      story.title,
                      style: theme.textTheme.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: HappySpacing.s8),
                  Text(
                    timeLabel,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: HappySpacing.s6),
              Text(
                story.excerpt,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (story.status != StoryStatus.ready) ...<Widget>[
                const SizedBox(height: HappySpacing.s8),
                Row(
                  children: <Widget>[
                    Icon(
                      story.status == StoryStatus.generating
                          ? LucideIcons.sparkles
                          : LucideIcons.circleAlert,
                      size: HappyIconSize.xs,
                      color: accent,
                    ),
                    const SizedBox(width: HappySpacing.s4),
                    if (story.status == StoryStatus.generating)
                      HappyShimmerText(
                        text: statusLabel,
                        style: theme.textTheme.labelMedium,
                      )
                    else
                      Text(
                        statusLabel,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: accent,
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
