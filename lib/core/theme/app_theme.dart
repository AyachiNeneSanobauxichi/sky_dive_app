import "package:animations/animations.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "index.dart";

/// 应用主题装配。
///
/// ## 为什么不用 `ColorScheme.fromSeed`
/// `fromSeed` 会按 M3 的调色算法自动推导 30 多个角色色，好处是省事，
/// 坏处是这些角色（尤其 `*Container` 和各级 `surfaceContainer*`）的明度台阶
/// 由算法决定，做不出"暮色海军蓝 + 精确三级表面"这种有个性的深色画布，
/// 也保不住浅色下"晴空白蓝"那一点点冷调。既然深浅两套都是一等设计目标，
/// 这里改为**逐角色显式指定**，全部取自 [SkyColors]，
/// 结果完全可预测、可评审、可做对比度校验。
abstract final class SkyTheme {
  /// 浅色主题（白昼晴空）。客人白天挑航线、看天气、下预约的主场景。
  static final ThemeData light = _build(_lightScheme, SkyColors.background);

  /// 深色主题（暮色高空）。黄昏跳与夜间查看行程。
  static final ThemeData dark = _build(_darkScheme, SkyColors.darkBackground);

  // ───────────────────────── 色板 ─────────────────────────

  static const ColorScheme _lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: SkyColors.azure,
    onPrimary: SkyColors.onBrand,
    primaryContainer: Color(0xFFDBEBFA),
    onPrimaryContainer: SkyColors.azureDeep,
    // secondary 保持中性，避免和品牌色抢戏；强调一律走 tertiary（伞衣朱橙）
    secondary: SkyColors.surfaceElevated,
    onSecondary: SkyColors.textPrimary,
    secondaryContainer: SkyColors.surfaceElevated,
    onSecondaryContainer: SkyColors.textSecondary,
    tertiary: SkyColors.canopy,
    onTertiary: SkyColors.onBrand,
    tertiaryContainer: Color(0xFFFCE7DA),
    onTertiaryContainer: SkyColors.canopyDeep,
    error: SkyColors.danger,
    onError: SkyColors.onBrand,
    errorContainer: Color(0xFFFDE4E4),
    onErrorContainer: Color(0xFF7F1D1D),
    surface: SkyColors.surface,
    onSurface: SkyColors.textPrimary,
    onSurfaceVariant: SkyColors.textSecondary,
    // surfaceDim 指向天幕最深端（正午天蓝）：吸顶条这类"要压住内容"的遮罩取它，
    // 才能比画布更实，读成刻意的压色而不是一条色差带。
    surfaceDim: SkyColors.skyDayTop,
    surfaceBright: SkyColors.surface,
    surfaceContainerLowest: SkyColors.surface,
    surfaceContainerLow: SkyColors.background,
    surfaceContainer: SkyColors.surfaceElevated,
    surfaceContainerHigh: SkyColors.surfaceElevated,
    surfaceContainerHighest: Color(0xFFE4EDF7),
    outline: SkyColors.border,
    outlineVariant: SkyColors.borderSubtle,
    shadow: SkyColors.textPrimary,
    scrim: SkyColors.scrim,
    inverseSurface: SkyColors.darkSurface,
    onInverseSurface: SkyColors.darkTextPrimary,
    inversePrimary: SkyColors.azureBright,
    // surfaceTint 置为透明：M3 的"色调抬升"会给卡片蒙一层蓝雾，
    // 和我们精确定义的三级表面色阶打架。层级改由 surfaceContainer* 表达。
    surfaceTint: Color(0x00000000),
  );

  static const ColorScheme _darkScheme = ColorScheme(
    brightness: Brightness.dark,
    // 品牌主色在深色底上用高亮版，否则对比度不足
    primary: SkyColors.azureBright,
    onPrimary: SkyColors.darkOnBrand,
    primaryContainer: SkyColors.azureDeep,
    onPrimaryContainer: SkyColors.darkTextPrimary,
    secondary: SkyColors.darkSurfaceHighest,
    onSecondary: SkyColors.darkTextPrimary,
    secondaryContainer: SkyColors.darkSurfaceElevated,
    onSecondaryContainer: SkyColors.darkTextSecondary,
    tertiary: SkyColors.canopyBright,
    onTertiary: Color(0xFF3B1405),
    tertiaryContainer: SkyColors.canopyDeep,
    onTertiaryContainer: SkyColors.darkTextPrimary,
    error: SkyColors.darkDanger,
    onError: Color(0xFF3B0A0A),
    errorContainer: SkyColors.danger,
    onErrorContainer: SkyColors.darkTextPrimary,
    surface: SkyColors.darkSurface,
    onSurface: SkyColors.darkTextPrimary,
    onSurfaceVariant: SkyColors.darkTextSecondary,
    surfaceDim: SkyColors.darkSkyZenith,
    surfaceBright: SkyColors.darkSurfaceHighest,
    surfaceContainerLowest: SkyColors.darkBackground,
    surfaceContainerLow: SkyColors.darkSurface,
    surfaceContainer: SkyColors.darkSurfaceElevated,
    surfaceContainerHigh: SkyColors.darkSurfaceElevated,
    surfaceContainerHighest: SkyColors.darkSurfaceHighest,
    outline: SkyColors.darkBorder,
    outlineVariant: SkyColors.darkBorderSubtle,
    shadow: Color(0xFF000000),
    scrim: SkyColors.scrim,
    inverseSurface: SkyColors.surface,
    onInverseSurface: SkyColors.textPrimary,
    inversePrimary: SkyColors.azure,
    surfaceTint: Color(0x00000000),
  );

  // ───────────────────────── 装配 ─────────────────────────

  static ThemeData _build(ColorScheme scheme, Color scaffoldBackground) {
    final isDark = scheme.brightness == Brightness.dark;
    final textTheme = isDark
        ? SkyTextStyles.darkTextTheme
        : SkyTextStyles.lightTextTheme;

    return ThemeData(
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffoldBackground,
      textTheme: textTheme,
      // 全局字体族：兜住没走 textTheme 的零散文本（如第三方组件内部）
      fontFamily: SkyFonts.text,
      fontFamilyFallback: SkyFonts.textFallback,
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
        thickness: SkyBorderWidth.hairline,
        space: SkyBorderWidth.hairline,
      ),
      iconTheme: IconThemeData(
        color: scheme.onSurfaceVariant,
        size: SkyIconSize.lg,
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
      iconTheme: IconThemeData(color: scheme.onSurface, size: SkyIconSize.lg),
      // 状态栏图标要和画布明暗相反才看得清
      systemOverlayStyle: isDark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
    );
  }

  // 底部导航条不配 navigationBarTheme：首页的条子是自绘的（中间「预约」要做成
  // 凸起的品牌渐变圆，M3 NavigationBar 的固定布局塞不进去），配了也没人用。
  // 相关视觉决策都写在 `features/home/widgets/home_bottom_nav_bar.dart`。

  /// 输入框：填充式而非描边式。深色底上一个"凹下去的槽"比一圈细线更清晰，
  /// 也更贴近当下 C 端产品的观感；聚焦时才用品牌色描边给出强反馈。
  static InputDecorationThemeData _inputDecorationTheme(
    ColorScheme scheme,
    TextTheme textTheme,
  ) {
    OutlineInputBorder border(Color color, double width) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(SkyRadius.input),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return InputDecorationThemeData(
      filled: true,
      fillColor: scheme.surfaceContainer,
      constraints: const BoxConstraints(minHeight: SkyControlSize.input),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: SkySpacing.s16,
        vertical: SkySpacing.s16,
      ),
      // 未聚焦时描边和填充同色：视觉上只剩一个"槽"，不显脏
      enabledBorder: border(scheme.outlineVariant, SkyBorderWidth.hairline),
      focusedBorder: border(scheme.primary, SkyBorderWidth.thick),
      errorBorder: border(scheme.error, SkyBorderWidth.hairline),
      focusedErrorBorder: border(scheme.error, SkyBorderWidth.thick),
      disabledBorder: border(scheme.outlineVariant, SkyBorderWidth.hairline),
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
        minimumSize: const Size.fromHeight(SkyControlSize.buttonMedium),
        textStyle: textTheme.labelLarge,
        padding: const EdgeInsets.symmetric(horizontal: SkySpacing.s24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SkyRadius.button),
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
        minimumSize: const Size.fromHeight(SkyControlSize.buttonMedium),
        textStyle: textTheme.labelLarge,
        foregroundColor: scheme.onSurface,
        padding: const EdgeInsets.symmetric(horizontal: SkySpacing.s24),
        side: BorderSide(color: scheme.outline, width: SkyBorderWidth.hairline),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SkyRadius.button),
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
        minimumSize: const Size(0, SkyControlSize.minTapTarget),
        padding: const EdgeInsets.symmetric(horizontal: SkySpacing.s12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SkyRadius.sm),
        ),
      ),
    );
  }

  static IconButtonThemeData _iconButtonTheme(ColorScheme scheme) {
    return IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: scheme.onSurfaceVariant,
        minimumSize: const Size.square(SkyControlSize.minTapTarget),
        shape: const CircleBorder(),
      ),
    );
  }

  static CheckboxThemeData _checkboxTheme(ColorScheme scheme) {
    return CheckboxThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SkyRadius.checkbox),
      ),
      side: BorderSide(color: scheme.outline, width: SkyBorderWidth.thick),
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
        borderRadius: BorderRadius.circular(SkyRadius.card),
        side: BorderSide(
          color: scheme.outlineVariant,
          width: SkyBorderWidth.hairline,
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
          top: Radius.circular(SkyRadius.sheet),
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
