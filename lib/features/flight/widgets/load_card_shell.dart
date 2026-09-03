import "package:flutter/material.dart";
import "package:sky_dive/core/theme/index.dart";

/// 航线 / 预约卡片的**外壳**：一张浮在天空上的实心卡。
///
/// ## 为什么不用主题里的 `Card`
/// `CardTheme` 给的是 `surfaceContainerLow` + 描边、零阴影——那是给"页面里的分组
/// 容器"用的。可这两个列表的底是**天幕渐变**：淡蓝卡片压在淡蓝天上，边界靠一条
/// 发丝线撑着，整屏就糊成一片，看着像后台表格而不是消费级产品。
///
/// 所以列表卡片改成：浅色下用最亮的 `surface`（近白）+ 柔和投影把卡"抬"起来；
/// 深色下投影没有意义，改用比画布高一档的表面色 + 发丝描边表达层级
/// （见 `09-theming-ui.md`：深色靠色阶，浅色靠阴影）。
///
/// 抽成组件是因为航线卡和预约卡必须长成同一种材质——两处各写一遍，
/// 迟早一处圆角 20 一处 14。
class LoadCardShell extends StatelessWidget {
  const LoadCardShell({
    super.key,
    required this.child,
    this.onTap,
    this.isMuted = false,
  });

  final Widget child;
  final VoidCallback? onTap;

  /// 已经飞走的班次：整卡压暗。它还在列表里（要能回看），但不再是"可操作"的东西。
  final bool isMuted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final radius = BorderRadius.circular(SkyRadius.card);

    return Opacity(
      opacity: isMuted ? _mutedOpacity : 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isDark ? scheme.surfaceContainer : scheme.surface,
          borderRadius: radius,
          border: isDark
              ? Border.all(
                  color: scheme.outlineVariant,
                  width: SkyBorderWidth.hairline,
                )
              : null,
          boxShadow: isDark || isMuted
              ? SkyShadows.none
              : SkyShadows.card(theme.brightness),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: radius,
          child: InkWell(
            onTap: onTap,
            borderRadius: radius,
            child: Padding(
              padding: const EdgeInsets.all(SkySpacing.s20),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

/// 已起飞卡片的整体不透明度。压到七成：读得清，但一眼就知道"这条过去了"。
const double _mutedOpacity = 0.7;
