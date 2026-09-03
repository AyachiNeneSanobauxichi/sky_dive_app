import "dart:ui";

import "package:flutter/material.dart";
import "package:sky_dive/core/theme/index.dart";
import "package:sky_dive/features/flight/widgets/load_formatters.dart";
import "package:sky_dive/l10n/app_localizations.dart";

/// 列表里按天分段的**吸顶**段头：日期 + 该天有几班。
///
/// 段头必须盖得住从底下滚过的卡片，但这一屏的底是**天空**——一条不透明的色带
/// 会把天幕拦腰切断。所以用和底部导航条同一套毛玻璃：模糊 + 半透明画布色，
/// 读成"天幕蒙了一层雾"而不是贴上去的一块板。
///
/// `BackdropFilter` 每帧重采样，但整屏只有这一条（加底部导航条共两处），
/// 在"一屏 1–3 个玻璃层"的预算内。
class LoadDayHeaderDelegate extends SliverPersistentHeaderDelegate {
  const LoadDayHeaderDelegate({
    required this.day,
    required this.count,
    required this.now,
    required this.textScaler,
  });

  final DateTime day;

  /// 这一天有几班。段头本身就把"今天还有 4 班"说完了，卡片不必再重复日期。
  final int count;

  /// 判定"今天 / 明天"的参照时刻，由列表统一传入。
  final DateTime now;

  /// 当前系统字体缩放。min/maxExtent 是没有 context 的 getter，量不到文字实际
  /// 高度，所以缩放系数由页面传进来——用户把字体调大时段头要跟着长高。
  final TextScaler textScaler;

  double get _height => textScaler.scale(SkyControlSize.minTapTarget);

  @override
  double get minExtent => _height;

  @override
  double get maxExtent => _height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    final isDark = theme.brightness == Brightness.dark;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: _blur, sigmaY: _blur),
        child: Container(
          height: _height,
          padding: const EdgeInsets.symmetric(
            horizontal: SkySemanticSpacing.screenPadding,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLowest.withValues(
              alpha: isDark ? _fillAlphaDark : _fillAlphaLight,
            ),
            border: Border(
              bottom: BorderSide(
                // 只有真的压住内容时才画分割线，段头浮在空白处时保持干净。
                color: overlapsContent
                    ? theme.colorScheme.outlineVariant
                    : Colors.transparent,
                width: SkyBorderWidth.hairline,
              ),
            ),
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  formatLoadDay(context, day, now: now),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall,
                ),
              ),
              Text(
                l10n.loadResultCount(count),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(LoadDayHeaderDelegate oldDelegate) =>
      oldDelegate.day != day ||
      oldDelegate.count != count ||
      oldDelegate.now != now ||
      oldDelegate.textScaler != textScaler;
}

/// 毛玻璃参数。与底部导航条取同一套，两条"雾带"才是同一种材质。
const double _blur = 22;
const double _fillAlphaDark = 0.72;
const double _fillAlphaLight = 0.78;
