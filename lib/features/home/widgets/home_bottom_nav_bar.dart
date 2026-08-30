import "dart:ui";

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:sky_dive/core/theme/index.dart";
import "package:sky_dive/l10n/app_localizations.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 首页的三个 tab。
///
/// 顺序即动线：先看有什么可跳（发现）→ 再看自己约了什么（履约）→ 最后才是账号。
enum HomeTab {
  flights(icon: LucideIcons.planeTakeoff),
  bookings(icon: LucideIcons.calendarCheck),
  account(icon: LucideIcons.circleUser);

  const HomeTab({required this.icon});

  final IconData icon;

  /// tab 文案。放这里而不是在 Widget 里 switch：加 tab 时漏翻译会直接编译报错。
  String label(AppLocalizations l10n) => switch (this) {
    HomeTab.flights => l10n.tabFlights,
    HomeTab.bookings => l10n.tabBookings,
    HomeTab.account => l10n.tabAccount,
  };
}

/// 底部 tab 栏。
///
/// 自绘而不是用 `NavigationBar`，为了三件 M3 默认给不了的事：
/// 1. **毛玻璃**——内容从条子底下滑过去（`Scaffold.extendBody`），
///    实心条会把天幕硬生生切断，玻璃条才保得住"内容浮在天上"这件事；
/// 2. **跑道指示条**——选中项顶上那道品牌渐变短线，是这个产品的识别物
///    （M3 的胶囊指示器在任何 app 上长得都一样）；
/// 3. **触感**——切 tab 给一次 `selectionClick`，缺了会明显发木。
class HomeBottomNavBar extends StatelessWidget {
  const HomeBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onSelected,
  });

  final int currentIndex;

  /// 传入被点的下标。**重复点当前 tab 也会回调**——那是"回到该 tab 顶层"的
  /// 通用手势，拦在这里会让用户在深层页面里找不到回去的路。
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: _blur, sigmaY: _blur),
        child: DecoratedBox(
          decoration: BoxDecoration(
            // 半透明画布色而不是 surface：条子要读成"天幕蒙了一层雾"，
            // 而不是一块贴在天上的卡片。
            color: theme.colorScheme.surfaceContainerLowest.withValues(
              alpha: isDark ? _fillAlphaDark : _fillAlphaLight,
            ),
            border: Border(
              top: BorderSide(
                color: theme.colorScheme.outlineVariant,
                width: SkyBorderWidth.hairline,
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: _barHeight,
              child: Row(
                children: <Widget>[
                  for (var i = 0; i < HomeTab.values.length; i++)
                    Expanded(
                      child: _NavItem(
                        tab: HomeTab.values[i],
                        label: HomeTab.values[i].label(l10n),
                        isSelected: i == currentIndex,
                        onTap: () {
                          // 已经在这个 tab 上就不再震：重复点是"回顶层"，
                          // 不是一次切换，给同样的触感会读成"点错了又切了一次"。
                          if (i != currentIndex) {
                            HapticFeedback.selectionClick();
                          }
                          onSelected(i);
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.tab,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final HomeTab tab;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isSelected
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurfaceVariant;

    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: InkWell(
        onTap: onTap,
        // 水波限制在条子内，别溢出到内容区上
        borderRadius: BorderRadius.circular(SkyRadius.sm),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // 跑道指示条：选中项顶上的一道品牌渐变短线。
            AnimatedContainer(
              duration: SkyMotion.normal,
              curve: SkyMotion.standard,
              height: _indicatorHeight,
              width: isSelected ? _indicatorWidth : 0,
              decoration: BoxDecoration(
                gradient: SkyGradients.brandFor(theme.brightness),
                borderRadius: BorderRadius.circular(_indicatorHeight),
              ),
            ),
            const SizedBox(height: SkySpacing.s8),
            AnimatedScale(
              // 选中时图标略放大：颜色变化在小尺寸上不够醒目，
              // 加一点尺寸差才一眼看得出选的是哪个。
              scale: isSelected ? _selectedIconScale : 1,
              duration: SkyMotion.normal,
              curve: SkyMotion.standard,
              child: Icon(tab.icon, size: SkyIconSize.lg, color: color),
            ),
            const SizedBox(height: SkySpacing.s4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ───────────────────────── 条子的构图常数 ─────────────────────────

/// 条子高度（不含底部安全区）。三行内容（指示条 / 图标 / 文字）加上下留白，
/// 单个 tab 的热区宽度是屏宽的三分之一，远超 44 的下限。
const double _barHeight = 62;

const double _blur = 22;
const double _fillAlphaDark = 0.72;
const double _fillAlphaLight = 0.78;

const double _indicatorHeight = 3;
const double _indicatorWidth = 26;
const double _selectedIconScale = 1.08;
