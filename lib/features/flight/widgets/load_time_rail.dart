import "package:flutter/material.dart";
import "package:sky_dive/core/theme/index.dart";
import "package:sky_dive/features/flight/widgets/load_formatters.dart";

/// 卡片左侧的时刻栏：大号起飞时刻 + 一行日期。
///
/// 时刻表类产品的第一信息永远是"几点"，所以它被单独拎成一栏、给到标题档字号。
/// 扫一竖列时刻，远比一行行读"08:00 今天 L-201 藤岡…"快——字体全档开了等宽数字
/// （`tabularFigures`），上下几条的时刻天然对齐。
///
/// 刻意**不画竖分隔线**：那需要 `IntrinsicHeight` 才能撑到内容等高，
/// 而它在长列表里是实打实的额外测量开销。分栏感由固定栏宽 + 字号落差表达。
class LoadTimeRail extends StatelessWidget {
  const LoadTimeRail({
    super.key,
    required this.departureAt,
    required this.now,
    this.code,
    this.isMuted = false,
  });

  final DateTime departureAt;
  final DateTime now;

  /// 航线代号。放在时刻底下而不是塞进右边那行次要信息里——右边那行本来就要
  /// 挤下"地区 · 机型 · 高度"，代号排在最后必被省略号吃掉（实测过）。
  /// 放这儿之后整栏读起来就是一块航班牌：时刻 / 日期 / 班次号。
  final String? code;

  final bool isMuted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return SizedBox(
      width: _railWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            formatLoadTime(context, departureAt),
            style: theme.textTheme.headlineSmall?.copyWith(
              color: isMuted ? scheme.onSurfaceVariant : null,
            ),
          ),
          const SizedBox(height: SkySpacing.s2),
          Text(
            formatLoadDay(context, departureAt, now: now),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          if (code != null) ...<Widget>[
            const SizedBox(height: SkySpacing.s4),
            Text(
              code!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                color: scheme.outline,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// 时刻栏宽度。放得下 `08:00` 与"9月5日周五"这种最长的日期写法。
const double _railWidth = SkySpacing.s80;
