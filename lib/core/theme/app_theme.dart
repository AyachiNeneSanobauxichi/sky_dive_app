import "package:animations/animations.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "index.dart";

/// 应用主题装配。
///
/// ## 为什么不用 `ColorScheme.fromSeed`
/// `fromSeed` 会按 M3 的调色算法自动推导 30 多个角色色，好处是省事，
/// 坏处是这些角色（尤其 `*Container` 和各级 `surfaceContainer*`）的明度台阶
/// 由算法决定，做不出"近黑带紫 + 精确三级表面"这种有个性的深色画布。
/// 既然深色是一等设计目标，这里改为**逐角色显式指定**，全部取自 [HappyColors]，
/// 结果完全可预测、可评审、可做对比度校验。
abstract final class HappyTheme {
  /// 深色主题（主场）。
  static final ThemeData dark = _build(_darkScheme, HappyColors.darkBackground);

  /// 浅色主题（副场）。
  static final ThemeData light = _build(_lightScheme, HappyColors.background);

  // ───────────────────────── 色板 ─────────────────────────

  static const ColorScheme _darkScheme = ColorScheme(
    brightness: Brightness.dark,
    // 品牌主色在深色底上用高亮版，否则对比度不足
    primary: HappyColors.violetBright,
    onPrimary: HappyColors.darkOnBrand,
    primaryContainer: HappyColors.violetDeep,
    onPrimaryContainer: HappyColors.darkTextPrimary,
    // secondary 保持中性，避免和品牌色抢戏；强调一律走 tertiary（品红）
    secondary: HappyColors.darkSurfaceHighest,
    onSecondary: HappyColors.darkTextPrimary,
    secondaryContainer: HappyColors.darkSurfaceElevated,
    onSecondaryContainer: HappyColors.darkTextSecondary,
    tertiary: HappyColors.magentaBright,
    onTertiary: HappyColors.darkOnBrand,
    tertiaryContainer: HappyColors.magenta,
    onTertiaryContainer: HappyColors.darkTextPrimary,
    error: HappyColors.darkDanger,
    onError: HappyColors.darkOnBrand,
    errorContainer: HappyColors.danger,
    onErrorContainer: HappyColors.darkTextPrimary,
    surface: HappyColors.darkSurface,
    onSurface: HappyColors.darkTextPrimary,
    onSurfaceVariant: HappyColors.darkTextSecondary,
    surfaceDim: HappyColors.darkBackground,
    surfaceBright: HappyColors.darkSurfaceHighest,
    surfaceContainerLowest: HappyColors.darkBackground,
    surfaceContainerLow: HappyColors.darkSurface,
    surfaceContainer: HappyColors.darkSurfaceElevated,
    surfaceContainerHigh: HappyColors.darkSurfaceElevated,
    surfaceContainerHighest: HappyColors.darkSurfaceHighest,
    outline: HappyColors.darkBorder,
    outlineVariant: HappyColors.darkBorderSubtle,
    shadow: Color(0xFF000000),
    scrim: HappyColors.scrim,
    inverseSurface: HappyColors.surface,
    onInverseSurface: HappyColors.textPrimary,
    inversePrimary: HappyColors.violet,
    // surfaceTint 置为透明：M3 的"色调抬升"会给深色卡片蒙一层紫雾，
    // 和我们精确定义的三级表面色阶打架。层级改由 surfaceContainer* 表达。
    surfaceTint: Color(0x00000000),
  );

  static const ColorScheme _lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: HappyColors.violet,
    onPrimary: HappyColors.onBrand,
    primaryContainer: Color(0xFFEDE4FE),
    onPrimaryContainer: HappyColors.violetDeep,
    secondary: HappyColors.surfaceElevated,
    onSecondary: HappyColors.textPrimary,
    secondaryContainer: HappyColors.surfaceElevated,
    onSecondaryContainer: HappyColors.textSecondary,
    tertiary: HappyColors.magenta,
    onTertiary: HappyColors.onBrand,
    tertiaryContainer: Color(0xFFFCE7F3),
    onTertiaryContainer: Color(0xFF831843),
    error: HappyColors.danger,
    onError: HappyColors.onBrand,
    errorContainer: Color(0xFFFEE2E2),
    onErrorContainer: Color(0xFF7F1D1D),
    surface: HappyColors.surface,
    onSurface: HappyColors.textPrimary,
    onSurfaceVariant: HappyColors.textSecondary,
    surfaceDim: Color(0xFFEFEAF8),
    surfaceBright: HappyColors.surface,
    surfaceContainerLowest: HappyColors.surface,
    surfaceContainerLow: HappyColors.background,
    surfaceContainer: HappyColors.surfaceElevated,
    surfaceContainerHigh: HappyColors.surfaceElevated,
    surfaceContainerHighest: Color(0xFFEDE8F7),
    outline: HappyColors.border,
    outlineVariant: HappyColors.borderSubtle,
    shadow: Color(0xFF1B0F3B),
    scrim: HappyColors.scrim,
    inverseSurface: HappyColors.darkSurface,
    onInverseSurface: HappyColors.darkTextPrimary,
    inversePrimary: HappyColors.violetBright,
    surfaceTint: Color(0x00000000),
  );

  // ───────────────────────── 装配 ─────────────────────────

  static ThemeData _build(ColorScheme scheme, Color scaffoldBackground) {
    final isDark = scheme.brightness == Brightness.dark;
    final textTheme = isDark
        ? HappyTextStyles.darkTextTheme
        : HappyTextStyles.lightTextTheme;

    return ThemeData(
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffoldBackground,
      textTheme: textTheme,
      // 全局字体族：兜住没走 textTheme 的零散文本（如第三方组件内部）
      fontFamily: HappyFonts.text,
      fontFamilyFallback: HappyFonts.textFallback,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      // 默认 InkSparkle 的火花效果偏"工具感"，C 端用更克制的水波
      splashFactory: InkRipple.splashFactory,
      appBarTheme: _appBarTheme(scheme, textTheme, scaffoldBackground),
      inputDecorationTheme: _inputDecorationTheme(scheme, textTheme),
      filledButtonTheme: _filledButtonTheme(scheme, textTheme),
      outlinedButtonTheme: _outlinedButtonTheme(scheme, textTheme),
      textButtonTheme: _textButtonTheme(scheme, textTheme),
      iconButtonTheme: _iconButtonTheme(scheme),
      checkboxTheme: _checkboxTheme(scheme),
      cardTheme: _cardTheme(scheme),
      bottomSheetTheme: _bottomSheetTheme(scheme),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: HappyBorderWidth.hairline,
        space: HappyBorderWidth.hairline,
      ),
      iconTheme: IconThemeData(
        color: scheme.onSurfaceVariant,
        size: HappyIconSize.lg,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        linearTrackColor: scheme.surfaceContainerHighest,
        circularTrackColor: scheme.surfaceContainerHighest,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: scheme.primary,
        selectionColor: scheme.primary.withValues(alpha: 0.28),
        selectionHandleColor: scheme.primary,
      ),
      pageTransitionsTheme: _pageTransitionsTheme(scaffoldBackground),
    );
  }

  /// 透明 AppBar：让页面背景（极光/渐变）从顶部一直贯穿，不被一条色带切断。
  static AppBarThemeData _appBarTheme(
    ColorScheme scheme,
    TextTheme textTheme,
    Color scaffoldBackground,
  ) {
    final isDark = scheme.brightness == Brightness.dark;
    return AppBarThemeData(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: textTheme.headlineSmall,
      foregroundColor: scheme.onSurface,
      iconTheme: IconThemeData(color: scheme.onSurface, size: HappyIconSize.lg),
      // 状态栏图标要和画布明暗相反才看得清
      systemOverlayStyle: isDark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
    );
  }

  /// 输入框：填充式而非描边式。深色底上一个"凹下去的槽"比一圈细线更清晰，
  /// 也更贴近当下 C 端产品的观感；聚焦时才用品牌色描边给出强反馈。
  static InputDecorationThemeData _inputDecorationTheme(
    ColorScheme scheme,
    TextTheme textTheme,
  ) {
    OutlineInputBorder border(Color color, double width) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(HappyRadius.input),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return InputDecorationThemeData(
      filled: true,
      fillColor: scheme.surfaceContainer,
      constraints: const BoxConstraints(minHeight: HappyControlSize.input),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: HappySpacing.s16,
        vertical: HappySpacing.s16,
      ),
      // 未聚焦时描边和填充同色：视觉上只剩一个"槽"，不显脏
      enabledBorder: border(scheme.outlineVariant, HappyBorderWidth.hairline),
      focusedBorder: border(scheme.primary, HappyBorderWidth.thick),
      errorBorder: border(scheme.error, HappyBorderWidth.hairline),
      focusedErrorBorder: border(scheme.error, HappyBorderWidth.thick),
      disabledBorder: border(scheme.outlineVariant, HappyBorderWidth.hairline),
      hintStyle: textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
      labelStyle: textTheme.bodyMedium?.copyWith(
        color: scheme.onSurfaceVariant,
      ),
      floatingLabelStyle: textTheme.labelMedium?.copyWith(
        color: scheme.primary,
      ),
      errorStyle: textTheme.bodySmall?.copyWith(color: scheme.error),
      prefixIconColor: scheme.onSurfaceVariant,
      suffixIconColor: scheme.onSurfaceVariant,
    );
  }

  static FilledButtonThemeData _filledButtonTheme(
    ColorScheme scheme,
    TextTheme textTheme,
  ) {
    return FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(HappyControlSize.buttonMedium),
        textStyle: textTheme.labelLarge,
        padding: const EdgeInsets.symmetric(horizontal: HappySpacing.s24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(HappyRadius.button),
        ),
      ),
    );
  }

  static OutlinedButtonThemeData _outlinedButtonTheme(
    ColorScheme scheme,
    TextTheme textTheme,
  ) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size.fromHeight(HappyControlSize.buttonMedium),
        textStyle: textTheme.labelLarge,
        foregroundColor: scheme.onSurface,
        padding: const EdgeInsets.symmetric(horizontal: HappySpacing.s24),
        side: BorderSide(
          color: scheme.outline,
          width: HappyBorderWidth.hairline,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(HappyRadius.button),
        ),
      ),
    );
  }

  static TextButtonThemeData _textButtonTheme(
    ColorScheme scheme,
    TextTheme textTheme,
  ) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: scheme.primary,
        textStyle: textTheme.labelMedium?.copyWith(color: scheme.primary),
        minimumSize: const Size(0, HappyControlSize.minTapTarget),
        padding: const EdgeInsets.symmetric(horizontal: HappySpacing.s12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(HappyRadius.sm),
        ),
      ),
    );
  }

  static IconButtonThemeData _iconButtonTheme(ColorScheme scheme) {
    return IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: scheme.onSurfaceVariant,
        minimumSize: const Size.square(HappyControlSize.minTapTarget),
        shape: const CircleBorder(),
      ),
    );
  }

  static CheckboxThemeData _checkboxTheme(ColorScheme scheme) {
    return CheckboxThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(HappyRadius.checkbox),
      ),
      side: BorderSide(color: scheme.outline, width: HappyBorderWidth.thick),
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return scheme.primary;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStatePropertyAll<Color>(scheme.onPrimary),
      visualDensity: VisualDensity.compact,
    );
  }

  static CardThemeData _cardTheme(ColorScheme scheme) {
    return CardThemeData(
      color: scheme.surfaceContainerLow,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(HappyRadius.card),
        side: BorderSide(
          color: scheme.outlineVariant,
          width: HappyBorderWidth.hairline,
        ),
      ),
    );
  }

  static BottomSheetThemeData _bottomSheetTheme(ColorScheme scheme) {
    return BottomSheetThemeData(
      backgroundColor: scheme.surfaceContainerLow,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      modalBarrierColor: scheme.scrim,
      showDragHandle: true,
      dragHandleColor: scheme.outline,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(HappyRadius.sheet),
        ),
      ),
    );
  }

  /// 页面转场：Android 用共享横轴（有明确的"前进/后退"方向感，
  /// 比默认 Zoom 更适合以流程为主的 C 端 App），iOS 保留系统侧滑手势。
  static PageTransitionsTheme _pageTransitionsTheme(Color fillColor) {
    return PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: SharedAxisPageTransitionsBuilder(
          transitionType: SharedAxisTransitionType.horizontal,
          fillColor: fillColor,
        ),
        TargetPlatform.iOS: const CupertinoPageTransitionsBuilder(),
        TargetPlatform.macOS: const CupertinoPageTransitionsBuilder(),
      },
    );
  }
}
