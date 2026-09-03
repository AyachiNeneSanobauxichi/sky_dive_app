import "package:flutter/material.dart";
import "package:sky_dive/core/theme/index.dart";
import "package:sky_dive/features/flight/domain/index.dart";
import "package:sky_dive/features/flight/widgets/load_card_shell.dart";
import "package:sky_dive/features/flight/widgets/load_formatters.dart";
import "package:sky_dive/features/flight/widgets/load_seat_summary.dart";
import "package:sky_dive/features/flight/widgets/load_status_pill.dart";
import "package:sky_dive/features/flight/widgets/load_time_rail.dart";
import "package:sky_dive/l10n/app_localizations.dart";
import "package:sky_dive/shared/widgets/index.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 列表里的一条航线。
///
/// ## 排版意图
/// 左边一栏**时刻**（时刻表就是靠它扫的），右边是这一班的身份：
/// **地点做标题**（客人认的是"去哪儿跳"），机型 · 高度 · 代号并成一行次要信息，
/// 底下一行名额结论。原来的版本把地点、机型、名额各写成一行带图标的小灰字，
/// 四行等重的信息堆在一起，读起来像后台报表——没有主角，就没有层级。
///
/// 代号（`L-204`）降级并进次要行：它是**运营内部叫法**，客人关心的是几点去哪儿。
/// 运营也不会因此找不到——它就在机型旁边，且搜索框按代号搜得到。
class LoadCard extends StatelessWidget {
  const LoadCard({
    super.key,
    required this.load,
    required this.now,
    required this.isAdmin,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.isBooked = false,
    this.isBooking = false,
    this.onBook,
  });

  final Load load;

  /// 判定"已起飞 / 今天 / 明天"的参照时刻。由列表统一传入而不是各自
  /// `DateTime.now()`：同一屏上的卡片必须用同一个"现在"，否则跨零点时
  /// 上下两张卡会一个写"今天"一个写"明天"。
  final DateTime now;

  final bool isAdmin;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  /// 当前客人是否已经约了这一班。
  final bool isBooked;

  /// 预约请求在途（客人视角）。
  final bool isBooking;

  /// 客人视角的预约行动。为空表示不给这个入口（运营视角 / 未登录）。
  final VoidCallback? onBook;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final hasDeparted = load.hasDepartedBy(now);
    final dropZone = load.dropZone;

    // 客人视角的预约入口：只在**真的能约**时出现。
    // 满员 / 已起飞时不摆一个灰按钮——「满员」角标已经把原因说清楚了，
    // 再放个点不动的按钮只是噪音（详情页里仍然保留禁用态按钮）。
    final canBook =
        onBook != null && !hasDeparted && !isBooked && !load.isSoldOut;

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
                    if (hasDeparted)
                      LoadStatusPill(
                        label: l10n.loadDeparted,
                        color: scheme.onSurfaceVariant,
                      )
                    // "已预约"排在"满员"前面：对已经约上的人来说，
                    // 这班满没满已经不是他要关心的事了。
                    else if (isBooked)
                      LoadStatusPill(
                        label: l10n.bookingBookedBadge,
                        color: scheme.primary,
                      )
                    else if (load.isSoldOut)
                      LoadStatusPill(
                        label: l10n.loadFullBadge,
                        color: scheme.tertiary,
                      ),
                  ],
                ),
                const SizedBox(height: SkySpacing.s2),
                Text(
                  // 地区 · 机型 · 高度：全是"补充说明"，并成一行、压到最弱的
                  // 字色，不再一行一个图标各占一行（代号在左边时刻栏里）。
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
                const SizedBox(height: SkySemanticSpacing.itemGap),
                LoadSeatSummary(
                  load: load,
                  isAdmin: isAdmin,
                  isMuted: hasDeparted,
                ),
                if (canBook) ...<Widget>[
                  const SizedBox(height: SkySemanticSpacing.itemGap),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: SkyButton(
                      label: l10n.bookingActionBook,
                      icon: LucideIcons.ticketCheck,
                      // 卡片上用 secondary：一屏最多一个 primary 的额度
                      // 留给详情页那个真正的主行动。
                      variant: SkyButtonVariant.secondary,
                      size: SkyButtonSize.small,
                      isFullWidth: false,
                      isLoading: isBooking,
                      onPressed: onBook,
                    ),
                  ),
                ],
                // 管理入口只给运营。客人看到的是同一张卡，少了这一排。
                if (isAdmin) ...<Widget>[
                  const SizedBox(height: SkySpacing.s4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                        onPressed: onEdit,
                        tooltip: l10n.loadEditTooltip,
                        icon: const Icon(
                          LucideIcons.pencil,
                          size: SkyIconSize.md,
                        ),
                      ),
                      IconButton(
                        onPressed: onDelete,
                        tooltip: l10n.loadDeleteTooltip,
                        // 删除给 error 色：破坏性操作要看得出来，不能和编辑长一样。
                        color: scheme.error,
                        icon: const Icon(
                          LucideIcons.trash2,
                          size: SkyIconSize.md,
                        ),
                      ),
                    ],
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
