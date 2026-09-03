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

  /// 已经飞走的班次：整卡褪色。它还在列表里（要能回看），但不再是"可操作"的东西。
  /// 褪色方式见 [_mutedFilter]。
  final bool isMuted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final radius = BorderRadius.circular(SkyRadius.card);

    Widget card = DecoratedBox(
      decoration: BoxDecoration(
        color: isDark ? scheme.surfaceContainer : scheme.surface,
        borderRadius: radius,
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
    );

    if (isMuted) {
      card = ColorFiltered(
        colorFilter: ColorFilter.matrix(_mutedFilter(isDark: isDark)),
        child: card,
      );
    }

    // 没有阴影托着的卡（深色、以及已起飞的褪色卡）需要一条发丝描边兜住边界，
    // 否则压在天幕上会读成"背景的一块"。
    //
    // 描边必须画在褪色滤镜**外面**：滤镜会把这条线连同底色一起往画布方向推，
    // 浅色下推完就成了白线——而它恰恰是这张卡此时唯一的边界。
    if (isDark || isMuted) {
      card = DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(
          borderRadius: radius,
          border: Border.all(
            color: scheme.outlineVariant,
            width: SkyBorderWidth.hairline,
          ),
        ),
        child: card,
      );
    }

    return card;
  }
}

/// 已起飞卡片的"褪色"滤镜。
///
/// ## 为什么不用 `Opacity`
/// 半透明会让卡片的实底透出背后的**天幕**：卡片跟着发灰、边界变软，整张卡读成
/// 背景的一部分，反而比正常卡片更难扫（浅色下尤其明显）。
///
/// 改成保持实底不动，只做两件事：**降饱和**（[_mutedSaturation]）抽掉时刻的蓝、
/// 状态色、座位点阵的鲜活度；**沿画布方向推一档亮度**（[_mutedShift]）——浅色下
/// 往白推、深色下往黑推，于是卡片是"沉下去"而不是"透出去"。
///
/// 成本和原来的 `Opacity` 一样是一个 saveLayer，不多花。
List<double> _mutedFilter({required bool isDark}) {
  // Rec.709 亮度权重：降饱和就是把三个通道按亮度往灰轴上拉。
  const double lumR = 0.2126;
  const double lumG = 0.7152;
  const double lumB = 0.0722;
  const double s = _mutedSaturation;
  const double inv = 1 - s;
  // 最后一列是常量偏移（0–255 色阶）。白底加正偏移会被 clamp 在白，所以浅色卡
  // 的底不变、只有上面的深色文字被推浅；深色卡则整体压暗一档。
  final double shift = isDark ? -_mutedShiftDark : _mutedShiftLight;
  return <double>[
    lumR * inv + s,
    lumG * inv,
    lumB * inv,
    0,
    shift,
    lumR * inv,
    lumG * inv + s,
    lumB * inv,
    0,
    shift,
    lumR * inv,
    lumG * inv,
    lumB * inv + s,
    0,
    shift,
    0,
    0,
    0,
    1,
    0,
  ];
}

/// 褪色后保留多少饱和度。留一点而不是全灰：全灰会让"已起飞"看着像禁用或出错。
const double _mutedSaturation = 0.25;

/// 浅色下的亮度推移量（0–255 色阶）。白底会被 clamp 住不变，实际只把卡上的
/// 深色文字推浅一档：够读出"这条过去了"，又不至于糊掉文字。
const double _mutedShiftLight = 26;

/// 深色下的推移量要小得多。深色卡是靠**比画布高一档的表面色**浮起来的，
/// 压暗 26 会把它按回天幕里、整张卡塌进背景（实测过）。这里只轻轻退一档，
/// "这条过去了"主要交给降饱和——把时刻的蓝、剩余位数的蓝抽成灰。
const double _mutedShiftDark = 10;
