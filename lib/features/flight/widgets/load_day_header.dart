import "package:flutter/material.dart";
import "package:sky_dive/core/theme/index.dart";
import "package:sky_dive/features/flight/widgets/load_formatters.dart";
import "package:sky_dive/l10n/app_localizations.dart";

/// 列表里按天分段的**吸顶**段头：日期 + 该天有几班。
///
/// ## 为什么不是一条色带
/// 这一屏的底是天幕渐变。段头原先铺一条毛玻璃色带把文字护住，代价是天幕被拦腰
/// 切断，而且它紧挨着上方的吸顶工具条，两条白带连成一大片发白的横区——那正是
/// "这块区域和背景割裂"的直接来源。
///
/// 改成**两枚胶囊标签**：只有文字底下那一小块是材质，胶囊之间留空，天幕与滚过的
/// 卡片都从中间穿过。段头从"一块板"变成"贴在天上的两个标签"，天幕保持连续。
///
/// 顺带把玻璃层从"每个日期段一个"降到零：整屏只剩底部导航条与吸顶工具条两处
/// `BackdropFilter`（后者还只在滚起来之后才开），回到"一屏 1–3 个玻璃层"的预算内。
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
    final fill = theme.colorScheme.surfaceContainerLowest;

    return DecoratedBox(
      // 一层**极淡**的顶浓底透渐变。没有它时，卡片从两枚胶囊之间穿过会显得
      // "卡片跑到日期上面去了"；浓度只有工具条雾带的一半、下沿完全透明，
      // 所以天幕仍是连续的，不会退回那条白色色带。
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            fill.withValues(alpha: isDark ? _scrimAlphaDark : _scrimAlphaLight),
            fill.withValues(alpha: 0),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: SkySemanticSpacing.screenPadding,
        ),
        child: SizedBox(
          height: _height,
          child: Row(
            children: <Widget>[
              // 日期占据剩余宽度并靠左：胶囊只包住文字本身，长日期（大字体下的
              // "9月3日 星期四"）在胶囊内截断，不会把右侧计数挤走。
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: _DayPill(
                    text: formatLoadDay(context, day, now: now),
                    style: theme.textTheme.titleSmall,
                  ),
                ),
              ),
              const SizedBox(width: SkySemanticSpacing.labelGap),
              _DayPill(
                text: l10n.loadResultCount(count),
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

/// 段头上的一枚胶囊标签。
///
/// 底色比工具条的"雾"实一些：段头吸顶时卡片会从它背后穿过，文字必须始终读得清。
/// 但面积只有文字那么大，实一点也不会像整条色带那样把天幕切断。
class _DayPill extends StatelessWidget {
  const _DayPill({required this.text, this.style});

  final String text;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest.withValues(
          alpha: isDark ? _pillAlphaDark : _pillAlphaLight,
        ),
        borderRadius: BorderRadius.circular(SkyRadius.pill),
        // 发丝描边：胶囊压在浅色卡片上时，光靠半透明底会和卡片粘在一起。
        border: Border.all(
          color: scheme.outlineVariant,
          width: SkyBorderWidth.hairline,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: SkySpacing.s12,
          vertical: SkySpacing.s4,
        ),
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: style,
        ),
      ),
    );
  }
}

/// 胶囊底色不透明度。比"雾带"实（0.78/0.72），因为它要单独盖住背后的卡片。
const double _pillAlphaLight = 0.9;
const double _pillAlphaDark = 0.86;

/// 段头渐变背板的顶端不透明度。取工具条雾带（0.78 / 0.72）的一半上下：
/// 只要让穿过的卡片"退到日期后面"，不需要真的挡住它。
const double _scrimAlphaLight = 0.4;
const double _scrimAlphaDark = 0.36;
