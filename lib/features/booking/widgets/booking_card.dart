import "package:flutter/material.dart";
import "package:sky_dive/core/theme/index.dart";
import "package:sky_dive/features/flight/index.dart";
import "package:sky_dive/l10n/app_localizations.dart";
import "package:sky_dive/shared/widgets/index.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 「我的预约」里的一条行程。
///
/// 和航线列表的卡片用**同一套材质与排版**（时刻栏 + 地点做标题 + 一行次要信息），
/// 但说的不是一件事：那边回答"这班还能不能上"（名额是主角），这边回答
/// "我几点要到哪儿"——所以没有座位点阵，取而代之的是行程状态与取消入口。
///
/// 已起飞的行程压暗保留：客人要回看自己跳过哪几班，删掉等于把跳伞记录抹了。
class BookingCard extends StatelessWidget {
  const BookingCard({
    super.key,
    required this.load,
    required this.now,
    this.isCancelling = false,
    this.onTap,
    this.onCancel,
  });

  final Load load;

  /// 判定"已起飞 / 今天 / 明天"的参照时刻，由列表统一传入。
  final DateTime now;

  final bool isCancelling;
  final VoidCallback? onTap;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final hasDeparted = load.hasDepartedBy(now);
    final dropZone = load.dropZone;

    return LoadCardShell(
      onTap: onTap,
      isMuted: hasDeparted,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          LoadTimeRail(
            departureAt: load.departureAt,
            now: now,
            code: load.code,
            isMuted: hasDeparted,
          ),
          const SizedBox(width: SkySemanticSpacing.cardPadding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        dropZone.name,
                        // 场地名很长（「藤岡スカイダイビングクラブ」），
                        // 卡住一行必然吃省略号——它是这张卡的标题，值得两行。
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: hasDeparted ? scheme.onSurfaceVariant : null,
                        ),
                      ),
                    ),
                    LoadStatusPill(
                      label: hasDeparted
                          ? l10n.loadDeparted
                          : l10n.bookingUpcoming,
                      color: hasDeparted
                          ? scheme.onSurfaceVariant
                          : scheme.primary,
                    ),
                  ],
                ),
                const SizedBox(height: SkySpacing.s2),
                Text(
                  <String>[
                    if (dropZone.area != null) dropZone.area!,
                    load.aircraft,
                    formatAltitude(context, load.altitudeFt),
                  ].join(" · "),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                // 已经飞完的行程不给取消入口——那不是"还能操作"的东西。
                if (!hasDeparted && onCancel != null) ...<Widget>[
                  const SizedBox(height: SkySemanticSpacing.itemGap),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: SkyButton(
                      label: l10n.bookingActionCancel,
                      icon: LucideIcons.ticketX,
                      variant: SkyButtonVariant.ghost,
                      size: SkyButtonSize.small,
                      isFullWidth: false,
                      isLoading: isCancelling,
                      onPressed: onCancel,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
