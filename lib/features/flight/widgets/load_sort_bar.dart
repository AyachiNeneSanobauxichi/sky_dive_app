import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:sky_dive/core/theme/index.dart";
import "package:sky_dive/features/flight/controllers/index.dart";
import "package:sky_dive/features/flight/domain/index.dart";
import "package:sky_dive/l10n/app_localizations.dart";

/// 时间排序切换（最早优先 / 最晚优先）。
///
/// 做成**分段控件**（一个槽 + 一枚会滑动的选中片）而不是两颗独立 chip：
/// 两个选项是同一个维度的两端、必须二选一，分段控件把这层"互斥"关系画了出来；
/// 两颗各自带底色的 chip 看着像两个开关，还平白多出一块高饱和色块。
///
/// 也去掉了图标——"最早/最晚"四个字已经说完了，箭头图标只是让这一行更吵。
class LoadSortBar extends ConsumerWidget {
  const LoadSortBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final sort = ref.watch(loadQueryControllerProvider.select((q) => q.sort));

    return Container(
      padding: const EdgeInsets.all(SkySpacing.s4),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(SkyRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (final option in LoadSort.values)
            _Segment(
              label: option == LoadSort.departureAsc
                  ? l10n.loadSortEarliest
                  : l10n.loadSortLatest,
              isSelected: sort == option,
              onSelected: () {
                if (sort == option) return;
                // 切换类交互给"选择"档触感，和主行动的轻击区分开。
                HapticFeedback.selectionClick();
                ref.read(loadQueryControllerProvider.notifier).setSort(option);
              },
            ),
        ],
      ),
    );
  }
}

/// 分段控件里的一段。选中片用最亮的表面色 + 卡片阴影"浮"在槽上。
class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onSelected,
          borderRadius: BorderRadius.circular(SkyRadius.pill),
          child: AnimatedContainer(
            duration: SkyMotion.fast,
            curve: SkyMotion.standard,
            // 热区 ≥44 减去槽自身的 4pt 内边距，整体仍然是 44。
            constraints: const BoxConstraints(
              minHeight: SkyControlSize.minTapTarget - SkySpacing.s8,
            ),
            padding: const EdgeInsets.symmetric(horizontal: SkySpacing.s16),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected
                  ? (isDark ? scheme.surfaceContainerHighest : scheme.surface)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(SkyRadius.pill),
              boxShadow: isSelected && !isDark
                  ? SkyShadows.card(theme.brightness)
                  : SkyShadows.none,
            ),
            child: Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: isSelected ? scheme.onSurface : scheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
