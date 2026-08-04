import "package:flutter/material.dart";
import "package:happy_os/core/theme/index.dart";
import "package:happy_os/features/track/domain/index.dart";
import "package:happy_os/features/track/widgets/track_tag_meta.dart";
import "package:happy_os/l10n/app_localizations.dart";

/// 时间线上的一条轨迹：左边是**连线 + 节点**，右边是内容卡。
///
/// ## 连线怎么画
/// 用 `IntrinsicHeight` 让左侧那一列跟右侧卡片等高，再把线拆成"节点上方"与
/// "节点下方"两段：首条不画上半段、末条不画下半段，这样整条线首尾是断开的、
/// 中间是连续的——一根从头贯到尾的线会让人以为上面还有内容被截掉了。
///
/// 节点里放标签图标而不是一个纯圆点：一眼扫下来就知道这一段人生是高光还是低谷，
/// 不用逐条读标签文字。
class TrackTimelineTile extends StatelessWidget {
  const TrackTimelineTile({
    super.key,
    required this.entry,
    required this.dateLabel,
    required this.outcomePrefix,
    required this.pendingOutcomeLabel,
    required this.isFirst,
    required this.isLast,
    required this.onTap,
  });

  final TrackEntry entry;

  /// 已格式化好的日期（格式化要 locale，交给调用方）。
  final String dateLabel;

  /// 结果那一行的前缀（「后来」）。
  final String outcomePrefix;

  /// 还没有结果时的占位文案。
  final String pendingOutcomeLabel;

  final bool isFirst;
  final bool isLast;
  final VoidCallback onTap;

  /// 左侧轨道宽度：节点直径 + 两边呼吸。
  static const double _railWidth = HappySpacing.s40;

  /// 节点直径。
  static const double _nodeSize = HappySpacing.s32;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final meta = trackTagMeta(l10n, scheme, entry.tag);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            width: _railWidth,
            child: Column(
              children: <Widget>[
                // 上半段：首条不画，线才不会"从屏幕外冒出来"。
                Expanded(child: _Line(visible: !isFirst)),
                _Node(icon: meta.icon, color: meta.color, size: _nodeSize),
                Expanded(child: _Line(visible: !isLast)),
              ],
            ),
          ),
          Expanded(
            child:
                Padding
                // 卡片之间的竖向间距放在这里，线是连续的、卡片是分开的。
                (
                  padding: const EdgeInsets.only(
                    bottom: HappySemanticSpacing.itemGap,
                  ),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: onTap,
                      child: Padding(
                        padding: const EdgeInsets.all(
                          HappySemanticSpacing.cardPadding,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    entry.event,
                                    style: theme.textTheme.titleSmall,
                                  ),
                                ),
                                const SizedBox(width: HappySpacing.s8),
                                Text(
                                  dateLabel,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: HappySpacing.s6),
                            Text(
                              entry.feeling,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: scheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: HappySpacing.s8),
                            _OutcomeRow(
                              outcome: entry.outcome,
                              prefix: outcomePrefix,
                              pendingLabel: pendingOutcomeLabel,
                              accent: meta.color,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
          ),
        ],
      ),
    );
  }
}

/// 节点：带标签图标的圆，外面描一圈画布色把线"断开"，视觉上像串在线上。
class _Node extends StatelessWidget {
  const _Node({required this.icon, required this.color, required this.size});

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.colorScheme.surfaceContainerLow,
        border: Border.all(color: color, width: HappyBorderWidth.thick),
      ),
      child: Icon(icon, size: HappyIconSize.xs, color: color),
    );
  }
}

/// 连线的一段。不可见时仍占位，节点才不会上下跳。
class _Line extends StatelessWidget {
  const _Line({required this.visible});

  final bool visible;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    // ⚠️ 必须显式给高度：`ColoredBox` / `Container` 没有子节点时会收缩到
    // `constraints.smallest`，也就是高 0——线会直接消失（踩过）。
    // `double.infinity` 在这里会被外层 `Expanded` 的高度夹住，正好铺满这一段。
    return Center(
      child: Container(
        width: HappyBorderWidth.thick,
        height: double.infinity,
        // 用 outline 而非更淡的 outlineVariant：浅色主题下 outlineVariant
        // 在近白底上几乎看不见（导航条那条 hairline 踩过同一个坑）。
        color: visible ? scheme.outline : Colors.transparent,
      ),
    );
  }
}

/// 结果行：有结果时「后来 → …」，没有时给一句"还没有结果"的弱提示。
///
/// 没结果**不隐藏这一行**：留着它是在提醒"这件事还没写完"，而未完成的事恰恰是
/// story 最值得改写的素材。
class _OutcomeRow extends StatelessWidget {
  const _OutcomeRow({
    required this.outcome,
    required this.prefix,
    required this.pendingLabel,
    required this.accent,
  });

  final String? outcome;
  final String prefix;
  final String pendingLabel;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = outcome;
    final hasOutcome = text != null && text.isNotEmpty;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          hasOutcome ? prefix : pendingLabel,
          style: theme.textTheme.labelMedium?.copyWith(
            color: hasOutcome ? accent : scheme.onSurfaceVariant,
          ),
        ),
        if (hasOutcome) ...<Widget>[
          const SizedBox(width: HappySpacing.s6),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
