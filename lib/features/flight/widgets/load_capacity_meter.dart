import "package:flutter/material.dart";
import "package:sky_dive/core/theme/index.dart";
import "package:sky_dive/features/flight/domain/index.dart";
import "package:sky_dive/l10n/app_localizations.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 一个角色的名额占用（顾客 / 摄影师各一个）。
///
/// 顾客和摄影师**分开显示**而不是合成一个总数：两者占的不是同一种位置，
/// 合并后"还剩 3 位"会让人以为客人还能上 3 个，实际可能只剩摄影位。
///
/// ## 为什么是点阵而不是进度条
/// 名额是**可数的座位**，不是百分比。进度条要靠"条有多长"去反推还剩几个，
/// 点阵一眼就能数出来——排班的人问的从来是"还能上几个"，不是"占了百分之几"。
/// 满员、或只剩 [LoadRules.scarceSeats] 位以内时整组换成强调色，
/// 不靠"6/6 自己做减法"来表达。
///
/// 座位太多（[_dotLimit] 以上）时点阵会挤成一片糊，那时才退回进度条。
class LoadCapacityMeter extends StatelessWidget {
  const LoadCapacityMeter({
    super.key,
    required this.load,
    required this.role,
    this.isDimmed = false,
  });

  final Load load;
  final ParticipantRole role;

  /// 已起飞的航线整块压暗：名额还看得见，但不再是"可操作"的信息。
  final bool isDimmed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    final filled = load.assignedCountOf(role);
    final capacity = load.capacityOf(role);
    final hasSeats = capacity > 0;
    final seatsLeft = load.seatsLeftOf(role);

    // 与列表卡片（LoadSeatSummary）取同一个阈值：同一条航线"还剩 1 位"，
    // 在列表上是强调色、点进详情页却变回普通色，会读成两种不同的状态。
    final isTight = hasSeats && seatsLeft <= LoadRules.scarceSeats;
    final accent = isDimmed
        ? scheme.onSurfaceVariant
        : (isTight ? scheme.tertiary : scheme.primary);

    return Semantics(
      // 点阵对读屏软件没有意义，整块用一句话代替：「顾客 3/6，还剩 3 位」。
      label:
          "${role == ParticipantRole.customer ? l10n.loadRoleCustomers : l10n.loadRolePhotographers} "
          "${l10n.loadSeats(filled, capacity)} ${l10n.loadSeatsLeft(seatsLeft)}",
      child: ExcludeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  role == ParticipantRole.customer
                      ? LucideIcons.users
                      : LucideIcons.camera,
                  size: SkyIconSize.xs,
                  color: scheme.onSurfaceVariant,
                ),
                const SizedBox(width: SkySpacing.s6),
                Expanded(
                  child: Text(
                    role == ParticipantRole.customer
                        ? l10n.loadRoleCustomers
                        : l10n.loadRolePhotographers,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
                if (hasSeats)
                  Text(
                    l10n.loadSeats(filled, capacity),
                    style: theme.textTheme.labelMedium?.copyWith(color: accent),
                  ),
              ],
            ),
            const SizedBox(height: SkySpacing.s6),
            if (!hasSeats)
              // 这条航线不配摄影师。写"0/0 满员"是误导——它不是满了，是压根没有。
              Text(
                l10n.loadSeatsUnavailable,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              )
            else ...<Widget>[
              if (capacity <= _dotLimit)
                _SeatDots(filled: filled, capacity: capacity, accent: accent)
              else
                _SeatBar(filled: filled, capacity: capacity, accent: accent),
              const SizedBox(height: SkySpacing.s6),
              Text(
                l10n.loadSeatsLeft(seatsLeft),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelSmall?.copyWith(
                  // 紧张时这句话本身也要跳出来，不能只有上面的数字变色。
                  color: isTight ? accent : scheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 超过这个座位数就不画点阵了：再多就挤成一片糊，反而不如一条进度条好读。
const int _dotLimit = 12;

/// 座位点阵：已占实心，空位只留一圈描边。
class _SeatDots extends StatelessWidget {
  const _SeatDots({
    required this.filled,
    required this.capacity,
    required this.accent,
  });

  final int filled;
  final int capacity;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Wrap(
      spacing: SkySpacing.s4,
      runSpacing: SkySpacing.s4,
      children: <Widget>[
        for (int i = 0; i < capacity; i++)
          // 逐个"点亮"：新排进来的那个座位会自己亮起来，不是整排闪一下。
          AnimatedContainer(
            duration: SkyMotion.normal,
            curve: SkyMotion.standard,
            width: _dotSize,
            height: _dotSize,
            decoration: BoxDecoration(
              color: i < filled ? accent : Colors.transparent,
              shape: BoxShape.circle,
              border: i < filled
                  ? null
                  : Border.all(
                      color: scheme.outlineVariant,
                      width: SkyBorderWidth.hairline,
                    ),
            ),
          ),
      ],
    );
  }
}

/// 单个座位点的直径。
const double _dotSize = SkySpacing.s8;

/// 座位很多时的退化形态：占用条。
class _SeatBar extends StatelessWidget {
  const _SeatBar({
    required this.filled,
    required this.capacity,
    required this.accent,
  });

  final int filled;
  final int capacity;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ratio = (filled / capacity).clamp(0.0, 1.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular(SkyRadius.pill),
      child: Container(
        // 显式占满宽度：不给宽度的话，Container 会被里面的
        // FractionallySizedBox 反过来缩成"填充部分"那么宽，底槽就没了。
        width: double.infinity,
        height: SkySpacing.s6,
        color: scheme.surfaceContainerHighest,
        child: FractionallySizedBox(
          alignment: AlignmentDirectional.centerStart,
          widthFactor: ratio,
          child: AnimatedContainer(
            duration: SkyMotion.normal,
            curve: SkyMotion.standard,
            color: accent,
          ),
        ),
      ),
    );
  }
}
