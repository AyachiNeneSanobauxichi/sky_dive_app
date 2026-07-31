import "package:flutter/material.dart";
import "app_colors.dart";

/// 字体家族与中文回退链。
///
/// ## 为什么不打包中文字体
/// 一套思源黑体/宋体的静态字重就是 8–16MB，打进包里两个字重直接让安装包翻倍。
/// 做法是：**只打包拉丁字体**（Inter 4 个字重 + Instrument Serif 共约 1.5MB），
/// 中文交给系统字体回退——iOS 的苹方 / 宋体、Android 的 HarmonyOS Sans / Noto，
/// 观感原生且零体积成本。回退链按平台优先级排列，命中第一个存在的即停。
///
/// ## 为什么标题用衬线体
/// HappyOS 输出的是"故事"，衬线体自带小说与电影海报的叙事感，
/// 能立刻和一水儿用 Inter 做标题的 AI 工具类产品区分开。中文标题回退到系统宋体，
/// 保持同一种"编辑气质"，不会出现英文衬线、中文黑体的割裂。
abstract final class HappyFonts {
  /// 叙事标题字体（Instrument Serif，仅 Regular + Italic，**没有粗体**）。
  static const String display = "InstrumentSerif";

  /// 界面与正文字体（Inter，400/500/600/700）。
  static const String text = "Inter";

  /// 标题的中文回退：走系统宋体，延续衬线气质。
  static const List<String> displayFallback = <String>[
    "Songti SC", // iOS / macOS
    "STSong",
    "Noto Serif CJK SC", // Android / Linux
    "Source Han Serif SC",
    "SimSun", // Windows
  ];

  /// 正文的中文回退：走系统黑体。
  static const List<String> textFallback = <String>[
    "PingFang SC", // iOS / macOS
    "HarmonyOS Sans SC", // 部分国产 Android
    "Noto Sans CJK SC", // Android / Linux
    "Source Han Sans SC",
    "Microsoft YaHei", // Windows
  ];
}

/// 全局字体令牌。
///
/// 层级设计（移动端优先）：
/// - `display*`：**衬线**，只给叙事性大标题用（故事标题、开屏、空态主文案）。
///   Instrument Serif 无粗体，所以这几档一律 `w400`，靠字号和留白拉层级，
///   写 `w700` 只会触发系统伪粗体、字形发糊。
/// - `headline* / title*`：Inter，页面与区块标题。
/// - `body*`：Inter，`bodyLarge` 行高放到 1.65 专供故事正文长阅读。
/// - `label*`：Inter，按钮与徽标，带正字距提升小字号可读性。
abstract final class HappyTextStyles {
  static TextTheme get lightTextTheme => _build(
    primary: HappyColors.textPrimary,
    secondary: HappyColors.textSecondary,
    muted: HappyColors.textMuted,
  );

  static TextTheme get darkTextTheme => _build(
    primary: HappyColors.darkTextPrimary,
    secondary: HappyColors.darkTextSecondary,
    muted: HappyColors.darkTextMuted,
  );

  /// 叙事衬线体的基底样式，供 `display*` 复用。
  static const TextStyle _serif = TextStyle(
    fontFamily: HappyFonts.display,
    fontFamilyFallback: HappyFonts.displayFallback,
    fontWeight: FontWeight.w400,
  );

  /// 界面无衬线体的基底样式，供其余所有档位复用。
  static const TextStyle _sans = TextStyle(
    fontFamily: HappyFonts.text,
    fontFamilyFallback: HappyFonts.textFallback,
  );

  static TextTheme _build({
    required Color primary,
    required Color secondary,
    required Color muted,
  }) {
    return TextTheme(
      // —— 叙事标题（衬线，w400 固定）——
      displayLarge: _serif.copyWith(
        fontSize: 44,
        height: 1.08,
        letterSpacing: -0.8,
        color: primary,
      ),
      displayMedium: _serif.copyWith(
        fontSize: 36,
        height: 1.12,
        letterSpacing: -0.6,
        color: primary,
      ),
      displaySmall: _serif.copyWith(
        fontSize: 30,
        height: 1.18,
        letterSpacing: -0.4,
        color: primary,
      ),

      // —— 页面 / 区块标题（无衬线）——
      headlineLarge: _sans.copyWith(
        fontSize: 24,
        height: 1.3,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
        color: primary,
      ),
      headlineMedium: _sans.copyWith(
        fontSize: 20,
        height: 1.35,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        color: primary,
      ),
      headlineSmall: _sans.copyWith(
        fontSize: 18,
        height: 1.4,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        color: primary,
      ),

      titleLarge: _sans.copyWith(
        fontSize: 17,
        height: 1.4,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      titleMedium: _sans.copyWith(
        fontSize: 15,
        height: 1.45,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      titleSmall: _sans.copyWith(
        fontSize: 13,
        height: 1.4,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: secondary,
      ),

      // —— 正文 ——
      // bodyLarge 专供故事长文：1.65 行高是长段落中文 + 拉丁混排的舒适区。
      bodyLarge: _sans.copyWith(
        fontSize: 16,
        height: 1.65,
        fontWeight: FontWeight.w400,
        color: primary,
      ),
      bodyMedium: _sans.copyWith(
        fontSize: 14,
        height: 1.55,
        fontWeight: FontWeight.w400,
        color: primary,
      ),
      bodySmall: _sans.copyWith(
        fontSize: 12,
        height: 1.5,
        fontWeight: FontWeight.w400,
        color: muted,
      ),

      // —— 按钮 / 徽标（小字号靠正字距救可读性）——
      labelLarge: _sans.copyWith(
        fontSize: 15,
        height: 1.2,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: primary,
      ),
      labelMedium: _sans.copyWith(
        fontSize: 13,
        height: 1.2,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        color: secondary,
      ),
      labelSmall: _sans.copyWith(
        fontSize: 11,
        height: 1.2,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.4,
        color: muted,
      ),
    );
  }
}
