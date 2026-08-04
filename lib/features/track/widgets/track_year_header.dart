import "package:flutter/material.dart";
import "package:happy_os/core/theme/index.dart";

/// 时间线上的年份吸顶标题。
///
/// 为什么需要它：轨迹跨度可能很大（童年那几条和今年的混在一条线上），只靠每张卡右上角
/// 的日期，"人生跨度"这件事会被埋在文字里。吸顶的年份让用户滚动时始终知道
/// "我现在在看哪一年"。
///
/// 配 `SliverMainAxisGroup` 使用：每一年是一个 group，所以上一年的标题会被下一年
/// **顶走**而不是一直堆在顶上——用普通 `pinned` sliver 会越滚越多顶几个标题。
class TrackYearHeaderDelegate extends SliverPersistentHeaderDelegate {
  const TrackYearHeaderDelegate({required this.label});

  /// 已格式化好的年份文案（格式化要 locale，交给调用方）。
  final String label;

  /// 吸顶条高度。刚够放一行 label，不抢内容的高度。
  static const double _height = HappySpacing.s32;

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

    return Container(
      height: _height,
      alignment: Alignment.centerLeft,
      // 底色通栏（吸顶时要挡住整行穿过的内容），但文字跟内容左对齐。
      padding: const EdgeInsets.symmetric(
        horizontal: HappySemanticSpacing.screenPadding,
      ),
      // 半透明画布色：吸顶时内容从它下面穿过要看不见，但又不能糊成一条实心色带
      // 把极光切断。
      color: theme.scaffoldBackgroundColor.withValues(alpha: _bandAlpha),
      child: Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(TrackYearHeaderDelegate oldDelegate) =>
      oldDelegate.label != label;
}

/// 吸顶条底色的不透明度：够挡住下面穿过的文字，又不至于把极光切成两段。
const double _bandAlpha = 0.92;
