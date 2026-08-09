import "package:flutter/material.dart";
import "app_colors.dart";

/// 渐变令牌。
///
/// 星空基调下，渐变不是装饰而是**主要的品牌识别物**：紫罗兰→品红这条光带
/// 出现在主按钮、进度、强调文字和背景星云上，天幕本身也是一道渐变，
/// 是整个产品的视觉锚点。
/// 因此禁止在 Widget 里现搓 `LinearGradient`，一律取本类令牌。
///
/// 深浅两套模式的色值不同（深色底要用高亮版品牌色才够亮），
/// 需要跟随主题的场景用 `xxxFor(brightness)` 工厂方法。
abstract final class HappyGradients {
  /// 品牌光带（浅色底）。左上→右下，符合"光从左上来"的直觉。
  static const LinearGradient brand = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[HappyColors.violet, HappyColors.magenta],
  );

  /// 品牌光带（深色底）。用高亮版品牌色，否则在近黑画布上会闷成一团。
  static const LinearGradient brandBright = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[HappyColors.violetBright, HappyColors.magentaBright],
  );

  /// 按亮度取品牌光带。
  static LinearGradient brandFor(Brightness brightness) =>
      brightness == Brightness.dark ? brandBright : brand;

  /// 三段式光带：中间插一段靛蓝，避免紫→品红在大面积上过渡发灰。
  /// 用于大尺寸表面（开屏、故事封面、进度条）。
  static const LinearGradient brandWide = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: <Color>[
      HappyColors.indigo,
      HappyColors.violetBright,
      HappyColors.magentaBright,
    ],
  );

  // ───────────────────────── 星空天幕 ─────────────────────────

  /// 夜空天幕：竖向渐变，天顶最暗、近地平透出星云余光。
  ///
  /// 为什么不用单色画布：整屏一个色值的"黑"会让人下意识觉得是屏幕关着，
  /// 而竖向的明度梯度会立刻读成"天空"——这是星空主题里最便宜也最有效的一笔。
  static const LinearGradient nightSky = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      HappyColors.darkSkyZenith,
      HappyColors.darkBackground,
      HappyColors.darkSkyHorizon,
    ],
    stops: <double>[0, 0.55, 1],
  );

  /// 白昼天幕：同一套结构的浅色版（晨蓝 → 近白），星点隐去、换云絮。
  static const LinearGradient daySky = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      HappyColors.skyDayTop,
      HappyColors.background,
      HappyColors.skyDayBottom,
    ],
    stops: <double>[0, 0.45, 1],
  );

  /// 按亮度取天幕。
  static LinearGradient skyFor(Brightness brightness) =>
      brightness == Brightness.dark ? nightSky : daySky;

  /// 银河带的横截面柔光：垂直于带子方向，中间亮、两侧透明。
  /// 由 `HappyStarfieldBackground` 斜着铺一条，给星野一个疏密结构。
  /// [intensity] 跟随背景的光强系数。
  static LinearGradient milkyWayBand({double intensity = 1}) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: <Color>[
        HappyColors.milkyWay.withValues(alpha: 0),
        HappyColors.milkyWay.withValues(alpha: 0.10 * intensity),
        HappyColors.milkyWay.withValues(alpha: 0.04 * intensity),
        HappyColors.milkyWay.withValues(alpha: 0),
      ],
      stops: const <double>[0, 0.38, 0.62, 1],
    );
  }

  /// 星云光斑（原极光光斑）：径向渐变，中心亮、边缘完全透明，叠在天幕上做氛围光。
  /// [color] 传品牌色，[intensity] 控制中心不透明度（0–1）。
  static RadialGradient nebulaBlob(Color color, {double intensity = 0.35}) {
    return RadialGradient(
      colors: <Color>[
        color.withValues(alpha: intensity),
        color.withValues(alpha: intensity * 0.4),
        color.withValues(alpha: 0),
      ],
      stops: const <double>[0, 0.55, 1],
    );
  }

  /// 玻璃层的边缘高光：从左上的白色微光渐隐到右下，模拟边缘受光。
  static const LinearGradient glassSheen = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[HappyColors.glassSheen, HappyColors.glassSheenFade],
  );

  /// 内容底部的渐隐遮罩：让滚动内容"融进"画布而不是被硬切断。
  /// [surface] 传当前画布色。
  static LinearGradient bottomScrim(Color surface) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: <Color>[surface.withValues(alpha: 0), surface],
    );
  }

  /// AI 生成中的流光：配合 `ShaderMask` + 横向平移做文字/骨架的扫光效果。
  static const LinearGradient shimmer = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: <Color>[
      HappyColors.violetBright,
      HappyColors.magentaBright,
      HappyColors.violetBright,
    ],
    stops: <double>[0, 0.5, 1],
    tileMode: TileMode.mirror,
  );
}
