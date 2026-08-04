import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:happy_os/core/theme/index.dart";
import "package:happy_os/features/track/domain/index.dart";
import "package:happy_os/features/track/widgets/track_tag_meta.dart";
import "package:happy_os/l10n/app_localizations.dart";

/// 标签筛选栏：全部 / 童年 / 高光 / 低谷 / 美好瞬间。
///
/// 横向可滚动而不是折成两行：标签会越加越多（真实数据里还可能有自定义标签），
/// 换行会把下面的时间线越推越低。
///
/// 每个 chip 上带**条数**：筛选前就知道点进去有没有东西，省掉"点进去发现是空的"
/// 这一次白跑。某个标签下 0 条时 chip 压暗但仍可点（点进去有空态引导去记一笔）。
class TrackTagFilter extends StatelessWidget {
  const TrackTagFilter({
    super.key,
    required this.selected,
    required this.counts,
    required this.totalCount,
    required this.onSelect,
  });

  /// 当前选中的标签；null = 全部。
  final TrackTag? selected;

  /// 各标签的条数。
  final Map<TrackTag, int> counts;

  /// 全部条数（「全部」那颗 chip 用）。
  final int totalCount;

  final ValueChanged<TrackTag?> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      // 让 chip 能滚到屏幕边缘之外，但首尾贴着页面边距。
      padding: const EdgeInsets.symmetric(horizontal: HappySpacing.none),
      child: Row(
        spacing: HappySpacing.s8,
        children: <Widget>[
          _TagChip(
            label: l10n.trackFilterAll,
            count: totalCount,
            isSelected: selected == null,
            color: scheme.primary,
            onTap: () => onSelect(null),
          ),
          for (final tag in TrackTag.values)
            _TagChip(
              label: trackTagMeta(l10n, scheme, tag).label,
              icon: trackTagMeta(l10n, scheme, tag).icon,
              count: counts[tag] ?? 0,
              isSelected: selected == tag,
              color: trackTagMeta(l10n, scheme, tag).color,
              onTap: () => onSelect(tag),
            ),
        ],
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({
    required this.label,
    required this.count,
    required this.isSelected,
    required this.color,
    required this.onTap,
    this.icon,
  });

  final String label;
  final IconData? icon;
  final int count;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isEmpty = count == 0;
    final foreground = isSelected
        ? scheme.onPrimary
        : (isEmpty ? scheme.onSurfaceVariant.withValues(alpha: 0.6) : color);

    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: InkWell(
        onTap: () {
          // 切换筛选是"选择"语义。
          HapticFeedback.selectionClick();
          onTap();
        },
        borderRadius: BorderRadius.circular(HappyRadius.chip),
        child: AnimatedContainer(
          duration: HappyMotion.fast,
          curve: HappyMotion.standard,
          // 高度撑到最小热区：chip 视觉可以矮，热区不能。
          constraints: const BoxConstraints(
            minHeight: HappyControlSize.minTapTarget,
          ),
          padding: const EdgeInsets.symmetric(horizontal: HappySpacing.s16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            // 选中用品牌渐变实心，未选中只描边：一眼能看出"现在筛的是哪一个"。
            gradient: isSelected
                ? HappyGradients.brandFor(theme.brightness)
                : null,
            color: isSelected ? null : Colors.transparent,
            borderRadius: BorderRadius.circular(HappyRadius.chip),
            border: isSelected
                ? null
                : Border.all(
                    color: scheme.outlineVariant,
                    width: HappyBorderWidth.hairline,
                  ),
          ),
          child: Row(
            spacing: HappySpacing.s6,
            children: <Widget>[
              if (icon != null)
                Icon(icon, size: HappyIconSize.sm, color: foreground),
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(color: foreground),
              ),
              Text(
                "$count",
                style: theme.textTheme.labelSmall?.copyWith(
                  color: isSelected
                      ? scheme.onPrimary.withValues(alpha: 0.7)
                      : scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
