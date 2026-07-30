import "package:flutter/material.dart";
import "index.dart";

/// 应用主题：从品牌 seed 生成完整 M3 色板（浅色/深色各一套），
/// 再把关键角色锁定为品牌值（点缀色、卡片底、文字色），
/// 其余角色（container/outline/surfaceVariant 等）交给 fromSeed 自动协调，
/// 保证两套模式都好看且对比度达标。
abstract final class HappyTheme {
  static ThemeData get light => _build(
    _scheme(Brightness.light),
    HappyTextStyles.lightTextTheme,
    HappyColors.background,
  );

  static ThemeData get dark => _build(
    _scheme(Brightness.dark),
    HappyTextStyles.darkTextTheme,
    HappyColors.darkBackground,
  );

  /// 从 seed 生成整套色板，仅锁定品牌关键角色。
  static ColorScheme _scheme(Brightness brightness) {
    final base = ColorScheme.fromSeed(
      seedColor: HappyColors.seed,
      brightness: brightness,
    );
    final isLight = brightness == Brightness.light;
    return base.copyWith(
      // 品红点缀 → tertiary（与紫罗兰主色形成对比强调）
      tertiary: HappyColors.accent,
      onTertiary: Colors.white,
      // 干净画布：纯白/抬升卡片底 + 高对比文字
      surface: isLight ? HappyColors.surface : HappyColors.darkSurface,
      onSurface: isLight
          ? HappyColors.textPrimary
          : HappyColors.darkTextPrimary,
    );
  }

  static ThemeData _build(
    ColorScheme scheme,
    TextTheme textTheme,
    Color scaffoldBackground,
  ) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffoldBackground,
      textTheme: textTheme,
      inputDecorationTheme: _inputDecorationTheme(scheme, textTheme),
      filledButtonTheme: _filledButtonTheme(textTheme),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: 1,
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  static InputDecorationTheme _inputDecorationTheme(
    ColorScheme scheme,
    TextTheme textTheme,
  ) {
    OutlineInputBorder border(Color color, [double width = HappySpacing.xxxs]) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(HappyRadius.input),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return InputDecorationTheme(
      enabledBorder: border(scheme.outline),
      focusedBorder: border(scheme.primary, HappySpacing.xxs),
      errorBorder: border(scheme.error),
      focusedErrorBorder: border(scheme.error, HappySpacing.xxs),
      errorStyle: textTheme.bodySmall?.copyWith(color: scheme.error),
    );
  }

  static FilledButtonThemeData _filledButtonTheme(TextTheme textTheme) {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(HappySpacing.xxxl), // 高度统一，宽度不强制
        textStyle: textTheme.labelLarge, // 用全局按钮字体令牌，不写死字号/字重
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(HappyRadius.button),
        ),
      ),
    );
  }
}
