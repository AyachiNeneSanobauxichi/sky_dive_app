import "package:flutter/material.dart";
import "app_colors.dart";

/// 渐变令牌。
///
/// 高空基调下，渐变不是装饰而是**主要的品牌识别物**：深空蓝→高空青这条光带
/// 出现在主按钮、进度、强调文字上，天幕本身也是一道渐变，是整个产品的视觉锚点。
/// 因此禁止在 Widget 里现搓 `LinearGradient`，一律取本类令牌。
///
/// 深浅两套模式的色值不同（深色底要用高亮版品牌色才够亮），
/// 需要跟随主题的场景用 `xxxFor(brightness)` 工厂方法。
abstract final class SkyGradients {
  /// 品牌光带（浅色底）。左上→右下，符合"光从左上来"的直觉。
  static const LinearGradient brand = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[SkyColors.azure, SkyColors.skyCyan],
  );

  /// 品牌光带（深色底）。用高亮版品牌色，否则在近黑画布上会闷成一团。
  static const LinearGradient brandBright = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[SkyColors.azureBright, SkyColors.skyCyanBright],
  );

  /// 按亮度取品牌光带。
  static LinearGradient brandFor(Brightness brightness) =>
      brightness == Brightness.dark ? brandBright : brand;

  /// 三段式光带：中间插一段靛蓝，避免蓝→青在大面积上过渡发灰。
  /// 用于大尺寸表面（开屏、航线封面、进度条）。
  static const LinearGradient brandWide = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: <Color>[
      SkyColors.stratoIndigo,
      SkyColors.azureBright,
      SkyColors.skyCyanBright,
    ],
  );

  /// 伞衣光带：唯一的暖色渐变，只给"跳"这一类主行动与高亮徽标用
  /// （立即预约、名额告急、黄昏跳专场）。一屏最多一处，否则朱橙就不再是重音。
  static const LinearGradient canopy = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[SkyColors.canopy, Color(0xFFEA7B2B)],
  );

  static const LinearGradient canopyBright = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[Color(0xFFFF8A3D), SkyColors.canopyBright],
  );

  static LinearGradient canopyFor(Brightness brightness) =>
      brightness == Brightness.dark ? canopyBright : canopy;

  // ───────────────────────── 天幕 ─────────────────────────

  /// 暮色天幕：竖向渐变，天顶最暗、近地平透出余晖。
  ///
  /// 为什么不用单色画布：整屏一个色值的"黑"会让人下意识觉得是屏幕关着，
  /// 而竖向的明度梯度会立刻读成"天空"——这是高空主题里最便宜也最有效的一笔。
  static const LinearGradient nightSky = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      SkyColors.darkSkyZenith,
      SkyColors.darkBackground,
      SkyColors.darkSkyHorizon,
    ],
    stops: <double>[0, 0.55, 1],
  );

  /// 白昼天幕：同一套结构的浅色版（正午天蓝 → 近白），星点隐去、云换成白色。
  ///
  /// 蓝色带**咬到 0.52** 才交给近白：云的远层落在屏幕上四成（见 `SkyBackground`
  /// 的 `_CloudLayer.far`），蓝要一直铺到那里，白云才有底可衬。
  /// 收得太早的话上半屏就只剩一片灰白，天读不出来。
  static const LinearGradient daySky = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      SkyColors.skyDayTop,
      SkyColors.background,
      SkyColors.skyDayBottom,
    ],
    stops: <double>[0, 0.52, 1],
  );

  /// 按亮度取天幕。
  static LinearGradient skyFor(Brightness brightness) =>
      brightness == Brightness.dark ? nightSky : daySky;

  /// 地平线余晖：贴着屏幕下缘的一道暖光，深色天幕专用。
  ///
  /// 它是深色模式里唯一的暖色，作用是把"夜"说成"日落后不久的高空"——
  /// 纯冷色的深色天幕会读成太空，而跳伞不在太空里发生。
  /// [intensity] 跟随背景的光强系数。
  static LinearGradient horizonGlow({double intensity = 1}) {
    return LinearGradient(
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      colors: <Color>[
        SkyColors.sunGlow.withValues(alpha: 0.16 * intensity),
        SkyColors.sunGlow.withValues(alpha: 0.05 * intensity),
        SkyColors.sunGlow.withValues(alpha: 0),
      ],
      stops: const <double>[0, 0.45, 1],
    );
  }

  /// 云层的横截面柔光：垂直于云带方向，中间实、上下渐隐。
  /// 由 `SkyBackground` 铺几条，给天幕一个远近层次。
  /// [color] 传当前模式的云色，[intensity] 控制不透明度。
  static LinearGradient cloudBand(Color color, {double intensity = 1}) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: <Color>[
        color.withValues(alpha: 0),
        color.withValues(alpha: 0.55 * intensity),
        color.withValues(alpha: 0.28 * intensity),
        color.withValues(alpha: 0),
      ],
      stops: const <double>[0, 0.35, 0.68, 1],
    );
  }

  /// 光晕光斑：径向渐变，中心亮、边缘完全透明，叠在天幕上做氛围光
  /// （浅色是阳光，深色是地平线余晖与蓝雾）。
  /// [color] 传品牌色或余晖色，[intensity] 控制中心不透明度（0–1）。
  static RadialGradient haloBlob(Color color, {double intensity = 0.35}) {
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
    colors: <Color>[SkyColors.glassSheen, SkyColors.glassSheenFade],
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

  /// 扫光：配合 `ShaderMask` + 横向平移做骨架/文字的流光效果。
  static const LinearGradient shimmer = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: <Color>[
      SkyColors.azureBright,
      SkyColors.skyCyanBright,
      SkyColors.azureBright,
    ],
    stops: <double>[0, 0.5, 1],
    tileMode: TileMode.mirror,
  );
}
