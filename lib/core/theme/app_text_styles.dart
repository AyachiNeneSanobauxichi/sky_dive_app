import "package:flutter/material.dart";
import "app_colors.dart";

/// 字体家族与 CJK 回退链。
///
/// ## 为什么不打包 CJK 字体
/// 一套思源黑体的静态字重就是 8–16MB，打进包里两个字重直接让安装包翻倍。
/// 做法是：**只打包拉丁字体**（Inter 4 个字重，约 700KB），
/// 日文/中文交给系统字体回退——iOS 的 Hiragino Sans / 苹方、
/// Android 的 Noto Sans JP / HarmonyOS Sans，观感原生且零体积成本。
/// 回退链按平台优先级排列，命中第一个存在的即停。
///
/// ## 为什么只有一个字体族
/// 航空产品的气质来自**仪表盘式的中性无衬线体**：航线代号、海拔、风速、时刻表
/// 全是数字与短标签，Inter 的等宽数字（tabular figures）和克制的字形正合适。
/// 标题层级不靠换字体族拉开，而靠**字号 + 字重 + 负字距**——
/// 混一个衬线标题进来只会把"航空"读成"文艺杂志"。
///
/// ## ⚠️ 回退链的取舍：日文优先
/// Flutter 的 `fontFamilyFallback` 是**全局**的，不随 locale 切换。本产品的主市场
/// 是日本，因此把日文字体排在中文字体之前——代价是简体中文界面下，
/// 中日共用的那部分汉字会以日文字形渲染（如「直」「骨」「今」的细节差异）。
/// 中文用户读得懂，但字形不是最地道的。
// TODO(theme): 若中文市场权重上升，改为按 locale 构建两套 TextTheme
//   （需要在 app.dart 里按当前 locale 选 ThemeData，属 infra 改动，须人工确认）。
abstract final class SkyFonts {
  /// 界面与正文字体（Inter，400/500/600/700）。全局唯一字体族。
  static const String text = "Inter";

  /// CJK 回退链：日文优先，其后中文，最后 Windows 兜底。
  static const List<String> textFallback = <String>[
    "Hiragino Sans", // iOS / macOS 日文
    "Hiragino Kaku Gothic ProN",
    "Noto Sans JP", // Android / Linux 日文
    "Yu Gothic", // Windows 日文
    "PingFang SC", // iOS / macOS 中文
    "HarmonyOS Sans SC", // 部分国产 Android
    "Noto Sans CJK SC", // Android / Linux 中文
    "Microsoft YaHei", // Windows 中文
  ];

  /// 大标题共用的回退链（与正文同族，单独留一个名字是为了将来能分开调）。
  static const List<String> displayFallback = textFallback;
}

/// 全局字体令牌。
///
/// 层级设计（移动端优先）：
/// - `display*`：**航班牌**档位。只给首屏主标题、空态主文案、成绩数字这类
///   "要被看见"的地方用。字重 w700 + 强负字距，字号一跨就是一个台阶。
/// - `headline* / title*`：页面与区块标题。
/// - `body*`：正文，`bodyLarge` 行高 1.6 供长说明文（安全须知、退改规则）阅读。
/// - `label*`：按钮与徽标，带正字距提升小字号可读性。
///
/// 全档位统一开 [FontFeature.tabularFigures]：这个 app 满屏都是时刻、海拔、
/// 价格、剩余名额——比例数字会让同一列数字左右跳动，等宽数字才对得齐。
abstract final class SkyTextStyles {
  static TextTheme get lightTextTheme => _build(
    primary: SkyColors.textPrimary,
    secondary: SkyColors.textSecondary,
    muted: SkyColors.textMuted,
  );

  static TextTheme get darkTextTheme => _build(
    primary: SkyColors.darkTextPrimary,
    secondary: SkyColors.darkTextSecondary,
    muted: SkyColors.darkTextMuted,
  );

  /// 所有档位的基底样式。
  static const TextStyle _base = TextStyle(
    fontFamily: SkyFonts.text,
    fontFamilyFallback: SkyFonts.textFallback,
    fontFeatures: <FontFeature>[FontFeature.tabularFigures()],
  );

  static TextTheme _build({
    required Color primary,
    required Color secondary,
    required Color muted,
  }) {
    return TextTheme(
      // —— 航班牌档位：大、紧、重 ——
      displayLarge: _base.copyWith(
        fontSize: 44,
        height: 1.06,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.4,
        color: primary,
      ),
      displayMedium: _base.copyWith(
        fontSize: 36,
        height: 1.1,
        fontWeight: FontWeight.w700,
        letterSpacing: -1.1,
        color: primary,
      ),
      displaySmall: _base.copyWith(
        fontSize: 30,
        height: 1.16,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.8,
        color: primary,
      ),

      // —— 页面 / 区块标题 ——
      headlineLarge: _base.copyWith(
        fontSize: 24,
        height: 1.3,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.4,
        color: primary,
      ),
      headlineMedium: _base.copyWith(
        fontSize: 20,
        height: 1.35,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
        color: primary,
      ),
      headlineSmall: _base.copyWith(
        fontSize: 18,
        height: 1.4,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        color: primary,
      ),

      titleLarge: _base.copyWith(
        fontSize: 17,
        height: 1.4,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      titleMedium: _base.copyWith(
        fontSize: 15,
        height: 1.45,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      titleSmall: _base.copyWith(
        fontSize: 13,
        height: 1.4,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: secondary,
      ),

      // —— 正文 ——
      // bodyLarge 专供长说明文：1.6 行高是长段落 CJK + 拉丁混排的舒适区。
      bodyLarge: _base.copyWith(
        fontSize: 16,
        height: 1.6,
        fontWeight: FontWeight.w400,
        color: primary,
      ),
      bodyMedium: _base.copyWith(
        fontSize: 14,
        height: 1.55,
        fontWeight: FontWeight.w400,
        color: primary,
      ),
      bodySmall: _base.copyWith(
        fontSize: 12,
        height: 1.5,
        fontWeight: FontWeight.w400,
        color: muted,
      ),

      // —— 按钮 / 徽标（小字号靠正字距救可读性）——
      labelLarge: _base.copyWith(
        fontSize: 15,
        height: 1.2,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: primary,
      ),
      labelMedium: _base.copyWith(
        fontSize: 13,
        height: 1.2,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
        color: secondary,
      ),
      labelSmall: _base.copyWith(
        fontSize: 11,
        height: 1.2,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.4,
        color: muted,
      ),
    );
  }
}
