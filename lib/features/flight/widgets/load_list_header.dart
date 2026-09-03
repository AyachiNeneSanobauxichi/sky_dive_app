import "dart:ui";

import "package:flutter/material.dart";
import "package:sky_dive/core/theme/index.dart";
import "package:sky_dive/features/flight/widgets/load_search_field.dart";
import "package:sky_dive/features/flight/widgets/load_sort_bar.dart";
import "package:sky_dive/l10n/app_localizations.dart";
import "package:sky_dive/shared/widgets/index.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 航线列表的**吸顶**工具条：搜索框 + 排序 chip（+ 运营的「添加航线」）。
///
/// ## 为什么要吸顶
/// 排班时"边滚边改搜索词 / 换个排序方向"是高频动作，工具条跟着内容滚走，
/// 每次都得先滚回顶部才能改，等于给每一次筛选加了一趟来回。
///
/// ## 收起时只留搜索框
/// 整条 128 高一直钉在顶上会吃掉小屏近三分之一的可视区。所以往下滚时排序行
/// 先淡出并收起（[minExtent]），只留搜索框——搜索是随时要用的，排序改一次
/// 能管很久。
///
/// 材质与日期段头、底部导航条同一套毛玻璃：这一屏的底是天空，不透明色带会把
/// 天幕拦腰切断。
class LoadListHeaderDelegate extends SliverPersistentHeaderDelegate {
  const LoadListHeaderDelegate({
    required this.isAdmin,
    required this.onCreate,
    required this.textScaler,
  });

  final bool isAdmin;
  final VoidCallback onCreate;

  /// 当前系统字体缩放。`SliverPersistentHeaderDelegate` 的 min/maxExtent 是
  /// **没有 context 的 getter**，量不到子组件的实际高度，所以缩放系数必须由
  /// 页面传进来，高度按它算——否则用户把字体调大，内容就会顶破固定高度。
  final TextScaler textScaler;

  /// 搜索框实际占的高度。
  ///
  /// ⚠️ 不能直接用 `SkyControlSize.input`：主题给输入框的是 **minHeight 52**，
  /// 真正撑出来的是「上下各 16 内边距 + 一行正文」= 54。差这 2px 就会画红条
  /// （实测过）。所以基准取 52 + 4 留一格余量，再随字体缩放一起放大。
  double get _searchExtent =>
      textScaler.scale(SkyControlSize.input + SkySpacing.s4);

  /// 排序行高度（chip 的最小热区）。
  double get _sortExtent => textScaler.scale(SkyControlSize.minTapTarget);

  /// 展开高度 = 上留白 + 搜索框 + 间距 + 排序行 + 下留白。
  double get _expanded =>
      SkySpacing.s8 +
      _searchExtent +
      SkySemanticSpacing.itemGap +
      _sortExtent +
      SkySemanticSpacing.itemGap;

  /// 收起高度 = 上留白 + 搜索框 + 下留白。
  double get _collapsed =>
      SkySpacing.s8 + _searchExtent + SkySemanticSpacing.itemGap;

  @override
  double get maxExtent => _expanded;

  @override
  double get minExtent => _collapsed;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final isDark = theme.brightness == Brightness.dark;
    // 0 = 完全展开，1 = 完全收起。
    final progress = (shrinkOffset / (_expanded - _collapsed)).clamp(0.0, 1.0);

    final fill = theme.colorScheme.surfaceContainerLowest;
    // 雾的浓度跟着收起进度走：完全展开（首屏、没滚动）时为 0，工具条整块透明，
    // 搜索框与排序片直接浮在天幕上。
    final fillAlpha = (isDark ? _fillAlphaDark : _fillAlphaLight) * progress;

    // 原先这里是一块 alpha 0.78 的**实色矩形**：直角、上下都是硬边界，压在天幕
    // 渐变上就成了一条发白的横带，和背景割裂。改成顶浓底透的渐变，下沿融进天幕，
    // 没有那条线可看。
    Widget surface = DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            fill.withValues(alpha: fillAlpha),
            fill.withValues(alpha: fillAlpha),
            fill.withValues(alpha: 0),
          ],
          stops: const <double>[0, _fillSolidStop, 1],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          SkySemanticSpacing.screenPadding,
          SkySpacing.s8,
          SkySemanticSpacing.screenPadding,
          SkySemanticSpacing.itemGap,
        ),
        child: Column(
          children: <Widget>[
            const LoadSearchField(),
            Expanded(
              child: ClipRect(
                // 收起时高度不够放排序行，用 OverflowBox 让它按原尺寸布局
                // 再被裁掉——直接压缩会把 chip 挤变形。
                child: OverflowBox(
                  alignment: Alignment.bottomCenter,
                  minHeight: 0,
                  maxHeight: _sortExtent,
                  child: Opacity(
                    opacity: 1 - progress,
                    child: Row(
                      children: <Widget>[
                        // 排序条横向可滚：窄屏（或大字体）下两个 chip 加一个
                        // 按钮排不下时会溢出，让 chip 自己滚比截断更稳。
                        const Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: LoadSortBar(),
                          ),
                        ),
                        if (isAdmin) ...<Widget>[
                          const SizedBox(width: SkySemanticSpacing.labelGap),
                          SkyButton(
                            label: l10n.loadCreateAction,
                            icon: LucideIcons.plus,
                            size: SkyButtonSize.small,
                            isFullWidth: false,
                            // 淡到看不见时也别再能点，否则会误触。
                            onPressed: progress < _interactiveThreshold
                                ? onCreate
                                : null,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    // 展开态不套玻璃层：既没有白底可看，也省掉一次全屏 backdrop 重采样
    // （首屏正是这个状态）。滚起来之后才逐渐糊，把从下面穿过的卡片压住，
    // 保证搜索框和排序片始终读得清。
    if (progress > 0) {
      surface = ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: _blur * progress,
            sigmaY: _blur * progress,
          ),
          child: surface,
        ),
      );
    }

    return surface;
  }

  @override
  bool shouldRebuild(LoadListHeaderDelegate oldDelegate) =>
      oldDelegate.isAdmin != isAdmin ||
      oldDelegate.onCreate != onCreate ||
      oldDelegate.textScaler != textScaler;
}

/// 收起到这个程度以上，排序行就当作不可点了（视觉上已经几乎看不见）。
const double _interactiveThreshold = 0.5;

/// 毛玻璃参数。模糊半径与底部导航条取同一套，两处才是同一种材质。
const double _blur = 22;
const double _fillAlphaDark = 0.72;
const double _fillAlphaLight = 0.78;

/// 雾带保持满浓度的那一段（占自身高度的比例），此后一路淡到全透明。
/// 取 0.55：上半截够浓，能压住搜索框背后穿过的卡片；下半截交给渐变收尾。
const double _fillSolidStop = 0.55;
