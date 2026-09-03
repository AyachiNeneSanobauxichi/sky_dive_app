import "package:flutter/material.dart";
import "package:sky_dive/core/theme/index.dart";
import "package:sky_dive/features/flight/domain/index.dart";
import "package:sky_dive/l10n/app_localizations.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 列表卡片上的**紧凑**名额行：一句结论 + 一枚图标。
///
/// ## 为什么不是座位点阵
/// 点阵（●○○○）在卡片这个尺寸下要求用户先数点、再对照颜色，才能反推出"还能上
/// 几个"。可卡片是**扫一眼**的场景，真正要的结论只有一句"还剩 7 位"；图标则把
/// "这说的是顾客座位"一眼交代清楚，比一排小圆点直观得多（深色下那排点几乎看不见）。
///
/// 需要逐个数座位的是详情页——那里空间够、也有标题给上下文，点阵留在
/// [LoadCapacityMeter]。
class LoadSeatSummary extends StatelessWidget {
  const LoadSeatSummary({super.key, required this.load, this.isMuted = false});

  final Load load;
  final bool isMuted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    final seatsLeft = load.seatsLeftOf(ParticipantRole.customer);
    // 满员和"就剩一两位"都走强调色：一个是"约不上了"、一个是"要抢"，两种都得从
    // "还有很多"里跳出来。区分这两者靠文案本身（「已满」对「还剩 1 位」），
    // 不再多占一个颜色——一屏最多一处重音。
    final isTight = seatsLeft <= LoadRules.scarceSeats;
    final accent = isMuted
        ? scheme.onSurfaceVariant
        : (isTight ? scheme.tertiary : scheme.primary);

    final photographerCapacity = load.photographerCapacity;

    return Row(
      children: <Widget>[
        // 图标跟着 accent 走：满员时和文字一起转成强调色，一眼就知道这班没位了。
        Icon(
          LucideIcons.users,
          size: SkyIconSize.sm,
          color: accent,
          // 读屏软件靠它知道这个数说的是顾客位而不是摄影位。
          semanticLabel: l10n.loadRoleCustomers,
        ),
        const SizedBox(width: SkySpacing.s6),
        Flexible(
          child: Text(
            l10n.loadSeatsLeft(seatsLeft),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelMedium?.copyWith(color: accent),
          ),
        ),
        // 摄影位是次要信息（大多数客人不关心），压到最右、用最小字号。
        // 这条航线不配摄影师时整个隐掉，不显示"0/0"。
        if (photographerCapacity > 0) ...<Widget>[
          const SizedBox(width: SkySemanticSpacing.itemGap),
          // 文案自带"摄影"字样，图标就不必再报一次角色名，否则读屏会念两遍。
          Icon(
            LucideIcons.camera,
            size: SkyIconSize.xs,
            color: scheme.onSurfaceVariant,
          ),
          const SizedBox(width: SkySpacing.s4),
          // 也说结论（"摄影 2 位"）而不是 `0/2`：顾客位已经改成"还剩 N 位"之后，
          // 这里若还留着分数式，就成了这一行里唯一要做减法的地方。
          Text(
            l10n.loadPhotographerSeatsLeft(
              load.seatsLeftOf(ParticipantRole.photographer),
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
