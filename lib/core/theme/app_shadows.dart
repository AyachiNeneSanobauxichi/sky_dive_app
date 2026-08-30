import "package:flutter/material.dart";
import "app_colors.dart";

/// 阴影 / 光晕令牌。
///
/// ## 深色模式为什么不能只靠阴影
/// 暗底上投黑影等于什么都没发生——Material 默认的 elevation 在深色下几乎不可见。
/// 所以这里分两条路：
/// - **浅色**：用常规的柔和投影表达层级（[card] / [lifted]），投影色带蓝调
///   （不是纯黑），落在晴空画布上才不显脏。
/// - **深色**：投影只用来"压暗周边"，真正的层级由 [glow]（品牌色光晕）
///   和表面色阶（`surface` → `surfaceElevated` → `surfaceHighest`）共同表达。
abstract final class SkyShadows {
  static const List<BoxShadow> none = <BoxShadow>[];

  /// 卡片级阴影。
  static List<BoxShadow> card(Brightness brightness) {
    return brightness == Brightness.dark
        ? const <BoxShadow>[
            BoxShadow(
              color: Color(0x66000000),
              blurRadius: 24,
              offset: Offset(0, 8),
            ),
          ]
        : const <BoxShadow>[
            BoxShadow(
              color: Color(0x140D1B2A),
              blurRadius: 18,
              offset: Offset(0, 6),
            ),
            BoxShadow(
              color: Color(0x0A0D1B2A),
              blurRadius: 4,
              offset: Offset(0, 1),
            ),
          ];
  }

  /// 悬浮层阴影（弹层、底部抽屉、FAB）。
  static List<BoxShadow> lifted(Brightness brightness) {
    return brightness == Brightness.dark
        ? const <BoxShadow>[
            BoxShadow(
              color: Color(0x8C000000),
              blurRadius: 40,
              offset: Offset(0, 16),
            ),
          ]
        : const <BoxShadow>[
            BoxShadow(
              color: Color(0x240D1B2A),
              blurRadius: 32,
              offset: Offset(0, 12),
            ),
          ];
  }

  /// 品牌光晕：主按钮、选中态、进行中的元素用它"发光"。
  ///
  /// 这是深色模式表达"这个元素是活的/可点的"的主要手段，
  /// [intensity] 控制强度（按下时调低、悬停时调高）。
  static List<BoxShadow> glow(Color color, {double intensity = 0.35}) {
    return <BoxShadow>[
      BoxShadow(
        color: color.withValues(alpha: intensity),
        blurRadius: 24,
        spreadRadius: -4,
        offset: const Offset(0, 6),
      ),
    ];
  }

  /// 品牌主光晕（高空蓝），最常用的那一个。
  static List<BoxShadow> brandGlow({double intensity = 0.35}) =>
      glow(SkyColors.azure, intensity: intensity);
}
