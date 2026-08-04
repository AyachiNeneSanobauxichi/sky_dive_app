import "package:flutter/material.dart";
import "package:happy_os/core/theme/index.dart";
import "package:happy_os/l10n/app_localizations.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 长按中间 story 圆弹出的快捷创作菜单。
///
/// 为什么用底部弹层而不是长按浮层：拇指刚好停在屏幕底部，弹层从同一侧升起、
/// 单手可达；`PopupMenu` 会飘到屏幕中间，还要抬手去点。
///
/// ⚠️ 隐藏手势不能是唯一入口（规范要求）：这里两项都另有可见路径——「新建故事」
/// 对应 story 页空态里的主按钮；「继续上次生成」目前还没有可见入口，等 story 页
/// 有草稿列表后补上。
class HomeStoryQuickActions extends StatelessWidget {
  const HomeStoryQuickActions({
    super.key,
    required this.onNewStory,
    required this.onContinueLast,
  });

  final VoidCallback onNewStory;
  final VoidCallback onContinueLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.only(bottom: HappySpacing.s8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: HappySemanticSpacing.screenPadding,
                vertical: HappySpacing.s8,
              ),
              child: Text(
                l10n.homeStoryQuickTitle,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(LucideIcons.sparkles),
              title: Text(l10n.homeStoryQuickNew),
              onTap: onNewStory,
            ),
            ListTile(
              leading: const Icon(LucideIcons.rotateCcw),
              title: Text(l10n.homeStoryQuickContinue),
              onTap: onContinueLast,
            ),
          ],
        ),
      ),
    );
  }
}
