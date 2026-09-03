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

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: _blur, sigmaY: _blur),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLowest.withValues(
              alpha: isDark ? _fillAlphaDark : _fillAlphaLight,
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
                              const SizedBox(
                                width: SkySemanticSpacing.labelGap,
                              ),
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
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(LoadListHeaderDelegate oldDelegate) =>
      oldDelegate.isAdmin != isAdmin ||
      oldDelegate.onCreate != onCreate ||
      oldDelegate.textScaler != textScaler;
}

/// 收起到这个程度以上，排序行就当作不可点了（视觉上已经几乎看不见）。
const double _interactiveThreshold = 0.5;

/// 毛玻璃参数。与日期段头、底部导航条取同一套，几条"雾带"才是同一种材质。
const double _blur = 22;
const double _fillAlphaDark = 0.72;
const double _fillAlphaLight = 0.78;
