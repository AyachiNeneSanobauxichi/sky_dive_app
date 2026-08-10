import "package:flutter/material.dart";
import "package:happy_os/core/theme/index.dart";

/// 时间线条目的统一头部：图标 + 归属标签 + 右侧时间。
///
/// 四种条目（心愿 / 澄清 / 大纲 / 正文）共用同一条头部，是为了让**时间戳始终落在
/// 同一个位置**——时间是用来扫的，不是用来读的，只有位置固定才扫得动。
///
/// 时间用 `labelSmall` + 次要色：它是元信息，任何时候都不该抢内容的注意力。
class TimelineEntryHeader extends StatelessWidget {
  const TimelineEntryHeader({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.timeLabel,
  });

  final IconData icon;

  /// 图标色。按条目归属取：用户的用 `primary`，AI 的用 `tertiary`。
  final Color iconColor;

  /// 「你的心愿」这类归属标签。
  final String label;

  /// 已格式化好的时间（如 `14:32`）。格式化在调用方做——它要拿 locale。
  final String timeLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Row(
      spacing: HappySemanticSpacing.labelGap,
      children: <Widget>[
        Icon(icon, size: HappyIconSize.sm, color: iconColor),
        // 标签用 Expanded 吃掉中间空档，把时间顶到最右——比 Spacer 少一个节点，
        // 且标签过长时会自己截断而不是把时间挤出屏幕。
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ),
        Text(
          timeLabel,
          style: theme.textTheme.labelSmall?.copyWith(
            color: scheme.onSurfaceVariant.withValues(alpha: _timeAlpha),
            // 等宽数字：秒数跳动时时间戳不会左右抖。
            fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}

/// 时间戳的透明度。比普通次要文字再淡一档——它是元信息里最次要的一层。
const double _timeAlpha = 0.7;
