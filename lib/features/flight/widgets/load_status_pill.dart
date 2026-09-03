import "package:flutter/material.dart";
import "package:sky_dive/core/theme/index.dart";

/// 状态角标（满员 / 已起飞 / 已预约 / 即将起飞）。
///
/// 语义色只做**低透明度底 + 同色文字**，不整块铺色：一列卡片上每张都顶着一块
/// 高饱和色卡，会把注意力全吸到状态上，而状态并不是这一屏的主角。
class LoadStatusPill extends StatelessWidget {
  const LoadStatusPill({super.key, required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(left: SkySemanticSpacing.labelGap),
      padding: const EdgeInsets.symmetric(
        horizontal: SkySpacing.s8,
        vertical: SkySpacing.s2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: _fillAlpha),
        borderRadius: BorderRadius.circular(SkyRadius.chip),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(color: color),
      ),
    );
  }
}

/// 语义色底的透明度。够读出是什么色，又不至于抢走整张卡的注意力。
const double _fillAlpha = 0.14;
