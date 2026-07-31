import "package:flutter/material.dart";
import "app_colors.dart";

/// 渐变令牌。
///
/// 深色电影感基调下，渐变不是装饰而是**主要的品牌识别物**：紫罗兰→品红这条光带
/// 出现在主按钮、进度、强调文字和背景极光上，是整个产品的视觉锚点。
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

  /// 极光光斑：径向渐变，中心亮、边缘完全透明，叠在画布上做氛围光。
  /// [color] 传品牌色，[intensity] 控制中心不透明度（0–1）。
  static RadialGradient auroraBlob(Color color, {double intensity = 0.35}) {
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
