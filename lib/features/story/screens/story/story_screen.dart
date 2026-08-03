import "package:flutter/material.dart";
import "package:happy_os/l10n/app_localizations.dart";
import "package:happy_os/shared/widgets/index.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// story 模块占位页（v1）。
///
/// 模块职责：**生成并管理用户生成的爽文**——与 AI 聊天调试生成、保存、再编辑、
/// 列表管理都在这里。素材来自 track 模块的成长轨迹，风格取自 user 模块的设定。
/// 是产品主路径（首页第 1 个 tab）。
///
/// 本期只有空态：按规范空态必须带"引导下一步"，功能未上线时按钮给轻提示而不是
/// 静默无反应。真实内容落地后，这一页要补齐加载（骨架）/ 空 / 错误（可重试）/ 有数据四态。
// TODO(story): 接入真实生成与列表（等 agent/service/story/story.api.md 定稿）。
class StoryScreen extends StatelessWidget {
  const StoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      // 透明底：让外层首页的极光背景透上来。
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: Text(l10n.storyTitle)),
      body: HappyEmptyState(
        icon: LucideIcons.bookOpen,
        title: l10n.storyEmptyTitle,
        description: l10n.storyEmptyBody,
        actionLabel: l10n.storyEmptyAction,
        onAction: () => HappyToast.info(context, l10n.commonComingSoon),
      ),
    );
  }
}
