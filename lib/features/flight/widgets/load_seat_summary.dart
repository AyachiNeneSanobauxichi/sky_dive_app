import "package:flutter/material.dart";
import "package:sky_dive/core/theme/index.dart";
import "package:sky_dive/features/flight/domain/index.dart";
import "package:sky_dive/l10n/app_localizations.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 列表卡片上的**紧凑**名额行：顾客座位点阵 + 剩余位数 + 摄影位。
///
/// 详情页那两块 [LoadCapacityMeter] 是"看清楚"，这里是"扫一眼"——所以只留一句
/// 结论（还剩几位）加一排点，不再重复"2/6"和标题文字。
/// 原来卡片上三样东西说同一件事（`2/6` + 点阵 + `还剩 4 位`），信息密度看着高，
/// 实际读起来更慢。
class LoadSeatSummary extends StatelessWidget {
  const LoadSeatSummary({super.key, required this.load, this.isMuted = false});

  final Load load;
  final bool isMuted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    final filled = load.assignedCountOf(ParticipantRole.customer);
    final capacity = load.customerCapacity;
    final isFull = load.isFullOf(ParticipantRole.customer);
    final accent = isMuted
        ? scheme.onSurfaceVariant
        : (isFull ? scheme.tertiary : scheme.primary);

    final photographerCapacity = load.photographerCapacity;

    return Row(
      children: <Widget>[
        // 座位太多时点阵会挤成一条糊线，那时直接给"3/24"。
        if (capacity <= _dotLimit)
          Padding(
            padding: const EdgeInsets.only(right: SkySemanticSpacing.labelGap),
            child: Wrap(
              spacing: SkySpacing.s4,
              children: <Widget>[
                for (int i = 0; i < capacity; i++)
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
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.only(right: SkySemanticSpacing.labelGap),
            child: Text(
              l10n.loadSeats(filled, capacity),
              style: theme.textTheme.labelMedium?.copyWith(color: accent),
            ),
          ),
        Flexible(
          child: Text(
            l10n.loadSeatsLeft(load.seatsLeftOf(ParticipantRole.customer)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelMedium?.copyWith(color: accent),
          ),
        ),
        // 摄影位是次要信息（大多数客人不关心），压到最右、用最小字号。
        // 这条航线不配摄影师时整个隐掉，不显示"0/0"。
        if (photographerCapacity > 0) ...<Widget>[
          const SizedBox(width: SkySemanticSpacing.itemGap),
          Icon(
            LucideIcons.camera,
            size: SkyIconSize.xs,
            color: scheme.onSurfaceVariant,
          ),
          const SizedBox(width: SkySpacing.s4),
          Text(
            l10n.loadSeats(
              load.assignedCountOf(ParticipantRole.photographer),
              photographerCapacity,
            ),
            style: theme.textTheme.labelSmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}

/// 超过这个座位数就不画点阵。
const int _dotLimit = 10;

/// 单个座位点的直径。
const double _dotSize = SkySpacing.s8;
