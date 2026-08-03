import "package:flutter/material.dart";
import "package:happy_os/l10n/app_localizations.dart";
import "package:happy_os/shared/widgets/index.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// track 模块占位页（v1）。
///
/// 模块职责：**用户的成长轨迹**——用户在这里记录真实经历（时间 / 事件 / 感受 / 结果）。
/// 这些条目是 story 生成爽文的 **key**：素材与真实骨架都来自它，没有轨迹就没有可
/// 改写的原料。首页第 2 个 tab。
///
/// 本期只有空态，且空态必须解释"轨迹是拿来干什么的"——否则用户不理解为什么要先记这个。
// TODO(track): 接入轨迹记录与列表（等 agent/service/track/track.api.md 定稿）。
class TrackScreen extends StatelessWidget {
  const TrackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      // 透明底：让外层首页的极光背景透上来。
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: Text(l10n.trackTitle)),
      body: HappyEmptyState(
        icon: LucideIcons.footprints,
        title: l10n.trackEmptyTitle,
        description: l10n.trackEmptyBody,
        actionLabel: l10n.trackEmptyAction,
        onAction: () => HappyToast.info(context, l10n.commonComingSoon),
      ),
    );
  }
}
