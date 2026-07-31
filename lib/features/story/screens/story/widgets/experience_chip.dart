import "package:flutter/material.dart";
import "package:happy_os/core/theme/index.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 已提交经历的折叠展示。
///
/// 生成过程中和读故事时，原始经历要一直可见但不能占地方——它是"这篇故事从哪来"的
/// 上下文锚点。折叠成两行，点一下回到编辑态。
class ExperienceChip extends StatelessWidget {
  const ExperienceChip({
    super.key,
    required this.experience,
    required this.label,
    required this.editTooltip,
    this.onEdit,
  });

  final String experience;

  /// 区块标题（如"你的经历"）。
  final String label;

  final String editTooltip;

  /// 传 null 表示当前不可编辑（生成进行中）。
  final VoidCallback? onEdit;

  static const int _maxLines = 2;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(HappySpacing.s12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(HappyRadius.md),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: HappySpacing.s12,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: HappySpacing.s4,
              children: <Widget>[
                Text(label, style: theme.textTheme.labelSmall),
                Text(
                  experience,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: _maxLines,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onEdit,
            tooltip: editTooltip,
            icon: const Icon(LucideIcons.pencil, size: HappyIconSize.sm),
          ),
        ],
      ),
    );
  }
}
