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

  /// 只吐一个普通 widget，视觉全在 [_TrackYearBand] 里——**这里不读 `Theme.of`**，
  /// 原因见那个类的注释。
  ///
  /// `overlapsContent` 直接透给下游：吸顶态和常态是两套视觉（见 [_TrackYearBand]）。
  /// 这个参数变化会由 `RenderSliverPersistentHeader` 主动触发重建，不用管 `shouldRebuild`。
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => _TrackYearBand(label: label, height: _height, isPinned: overlapsContent);

  @override
  bool shouldRebuild(TrackYearHeaderDelegate oldDelegate) =>
      oldDelegate.label != label;
}

/// 吸顶条的可视部分。
///
/// 为什么单独拆一个 widget 而不是直接在 delegate 的 `build` 里画：delegate 的产物只在
/// `shouldRebuild` 为真、或吸顶偏移（`shrinkOffset` / `overlapsContent`）变化时才重建，
/// **主题切换不会触发它**。若在 delegate 里直接读 `Theme.of`，系统切换深浅色后只有
/// "当前正在吸顶、偏移量在变"的那个年份会换色，其余停着不动的年份会一直留着切换前的
/// 底色——深色模式下冒出一条白色色带就是这么来的。
/// 拆成普通 widget 后它是树上的正常节点，主题变了自己就会重建。
///
/// ## 两套视觉，由 [isPinned] 切换
/// - **常态**（在流里跟着滚）：完全透明，星空天幕直接透上来。半透明色带在这里
///   只会横切天幕，白占一道。
/// - **吸顶态**（压在内容上）：不透明 + 一条细下边线。不透明是必须的——半透明会让
///   内容从年份底下穿过，读起来是脏而不是层次；底色取 `surfaceDim`（天幕最暗端）
///   而不是画布色，比背景更暗才读成"刻意压暗的一条"，用画布色反而会因为
///   屏幕顶部的天幕更暗而显出一条偏亮的带子。
class _TrackYearBand extends StatelessWidget {
  const _TrackYearBand({
    required this.label,
    required this.height,
    required this.isPinned,
  });

  final String label;
  final double height;
  final bool isPinned;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return AnimatedContainer(
      // 吸顶/脱离的那一下要有过渡，否则色带是"啪"地出现，像闪了一下。
      duration: HappyMotion.fast,
      curve: HappyMotion.standard,
      height: height,
      alignment: Alignment.centerLeft,
      // 底色通栏（吸顶时要挡住整行穿过的内容），但文字跟内容左对齐。
      padding: const EdgeInsets.symmetric(
        horizontal: HappySemanticSpacing.screenPadding,
      ),
      decoration: BoxDecoration(
        color: isPinned ? scheme.surfaceDim : Colors.transparent,
        border: isPinned
            ? Border(
                bottom: BorderSide(
                  color: scheme.outlineVariant,
                  width: HappyBorderWidth.hairline,
                ),
              )
            : null,
      ),
      child: Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
