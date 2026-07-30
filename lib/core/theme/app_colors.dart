import "package:flutter/material.dart";

/// 全局色板：只放"原始颜色值"，不含任何 Widget 逻辑。
/// Widget 里不要直接用这里的常量，而是通过 Theme.of(context).colorScheme 取；
/// 这里只是给 app_theme.dart 组装 ColorScheme 的"原料"。
///
/// 主色调：紫罗兰（Violet）+ 品红点缀（Pink），面向客户的现代品牌观感。
/// 完整 M3 色板由 app_theme.dart 用 ColorScheme.fromSeed 从 [seed] 生成，
/// 保证浅色/深色两套都协调且对比度达标。
abstract final class HappyColors {
  // —— 品牌色（用作 seed 与点缀）——
  static const Color seed = Color(0xFF7C3AED); // 紫罗兰主色（生成整套色板的种子）
  static const Color primary = seed;
  static const Color accent = Color(0xFFEC4899); // 品红点缀（映射到 tertiary）

  // —— 语义状态色 ——
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  // —— 浅色模式中性色 ——
  static const Color background = Color(0xFFFCFAFF); // 页面底色（带一丝紫调）
  static const Color surface = Color(0xFFFFFFFF); // 卡片/输入框底色
  static const Color textPrimary = Color(0xFF1C1A24); // 主要文字（近黑带紫）
  static const Color textSecondary = Color(0xFF6B6777); // 次要文字/提示
  static const Color border = Color(0xFFE7E3F0); // 分割线/边框

  // —— 深色模式中性色 ——
  static const Color darkBackground = Color(0xFF14121A); // 页面底色（近黑带紫）
  static const Color darkSurface = Color(0xFF1F1B2E); // 卡片/输入框底色（略微抬升）
  static const Color darkTextPrimary = Color(0xFFF3F0FA); // 主要文字
  static const Color darkTextSecondary = Color(0xFFA9A2BC); // 次要文字/提示
  static const Color darkBorder = Color(0xFF2E2A3D); // 分割线/边框
}
