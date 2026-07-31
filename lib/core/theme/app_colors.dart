import "package:flutter/material.dart";

/// 全局原始色板（design token 的最底层）。
///
/// 这里**只放颜色字面量**，不含任何 Widget 逻辑。业务层禁止直接引用本类，
/// 一律通过 `Theme.of(context).colorScheme` 取色；本类只是给 `app_theme.dart`
/// 组装 [ColorScheme] 的"原料"，以及给 `app_gradients` / `app_shadows` 复用。
///
/// ## 设计基调：深色优先 · 电影感
/// HappyOS 把用户的真实经历改写成惊险故事，主场景是"夜里读自己的故事"。
/// 因此深色是**一等设计目标**（近黑带紫的画布 + 紫罗兰→品红的光源），
/// 浅色是完整支持的副场，两套都按 WCAG AA（正文 ≥ 4.5:1）校过对比度。
///
/// 命名规则：`dark*` 前缀 = 深色模式专用；无前缀 = 浅色模式或品牌通用。
abstract final class HappyColors {
  // ───────────────────────── 品牌基色（通用） ─────────────────────────

  /// 品牌主色·紫罗兰。浅色底上作 primary 使用。
  static const Color violet = Color(0xFF7C3AED);

  /// 品牌主色的高亮版本。深色底上 #7C3AED 对比度不足，改用它作 primary。
  static const Color violetBright = Color(0xFFA78BFA);

  /// 品牌主色的暗部，用于渐变收尾与 container 底。
  static const Color violetDeep = Color(0xFF4C1D95);

  /// 品牌点缀色·品红。与紫罗兰构成"光源"渐变的另一端。
  static const Color magenta = Color(0xFFDB2777);

  /// 品红的高亮版本（深色底专用）。
  static const Color magentaBright = Color(0xFFF472B6);

  /// 渐变中段的靛蓝，让紫→品红的过渡不发灰。
  static const Color indigo = Color(0xFF6366F1);

  // ───────────────────────── 语义状态色 ─────────────────────────

  static const Color success = Color(0xFF059669);
  static const Color darkSuccess = Color(0xFF34D399);
  static const Color warning = Color(0xFFD97706);
  static const Color darkWarning = Color(0xFFFBBF24);
  static const Color danger = Color(0xFFDC2626);
  static const Color darkDanger = Color(0xFFFF7070);

  // ───────────────────────── 深色模式（主场） ─────────────────────────

  /// 页面画布：近黑带紫，比纯黑更有"夜色"而不是"关机屏"。
  static const Color darkBackground = Color(0xFF0A0711);

  /// 常规卡片底。
  static const Color darkSurface = Color(0xFF13101D);

  /// 抬升一层：输入框、列表项、次级按钮。
  static const Color darkSurfaceElevated = Color(0xFF1B1729);

  /// 再抬升一层：弹层、菜单、悬浮卡。
  static const Color darkSurfaceHighest = Color(0xFF241F35);

  /// 主要文字（对 [darkSurface] 约 16:1）。
  static const Color darkTextPrimary = Color(0xFFF4F1FC);

  /// 次要文字（对 [darkSurface] 约 7:1）。
  static const Color darkTextSecondary = Color(0xFFA79CC4);

  /// 弱化文字（对 [darkSurface] 约 5:1，仍达 AA 正文标准）。
  static const Color darkTextMuted = Color(0xFF8A80A8);

  /// 常规描边（卡片、输入框未聚焦时）。
  static const Color darkBorder = Color(0xFF332C4A);

  /// 极弱描边（分割线、内部网格）。
  static const Color darkBorderSubtle = Color(0xFF221D33);

  /// 放在亮紫 [violetBright] 上的前景色（深紫，避免纯白的刺眼感）。
  static const Color darkOnBrand = Color(0xFF1A0B33);

  // ───────────────────────── 浅色模式（副场） ─────────────────────────

  /// 页面画布：带一丝紫调的暖白。
  static const Color background = Color(0xFFFBF9FF);

  static const Color surface = Color(0xFFFFFFFF);

  /// 抬升一层：输入框填充底、次级按钮。
  static const Color surfaceElevated = Color(0xFFF5F1FD);

  static const Color surfaceHighest = Color(0xFFFFFFFF);

  /// 主要文字（对白底约 17:1）。
  static const Color textPrimary = Color(0xFF15102A);

  /// 次要文字（对白底约 6.5:1）。
  static const Color textSecondary = Color(0xFF5C5478);

  /// 弱化文字（对白底约 5:1）。
  static const Color textMuted = Color(0xFF6E6688);

  static const Color border = Color(0xFFE6E0F2);

  static const Color borderSubtle = Color(0xFFF1EDF9);

  /// 放在紫罗兰 [violet] 上的前景色。
  static const Color onBrand = Color(0xFFFFFFFF);

  // ───────────────────────── 覆盖层 / 玻璃 ─────────────────────────

  /// 玻璃层的高光描边起点（白色低透明度），用于模拟边缘受光。
  static const Color glassSheen = Color(0x33FFFFFF);

  /// 玻璃层的高光描边终点（近乎透明）。
  static const Color glassSheenFade = Color(0x0AFFFFFF);

  /// 深色玻璃的填充底。
  static const Color darkGlassFill = Color(0x1FFFFFFF);

  /// 浅色玻璃的填充底。
  static const Color glassFill = Color(0xB8FFFFFF);

  /// 模态遮罩。
  static const Color scrim = Color(0xB3000000);
}
