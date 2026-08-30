/// 间距刻度（4pt 栅格）。
///
/// 刻意采用**数值后缀命名**而不是 `sm/md/lg` 这类 T 恤码：T 恤码会把刻度藏起来，
/// 结果就是"缺 12 和 20"这种断档没人发现；数值命名让整条阶梯一眼可见、
/// 也让设计稿上的 "gap 20" 能一一对应，同时仍然满足"禁止魔法值"的红线。
///
/// 用法：优先用下方 [SkySemanticSpacing] 的语义别名（页面边距、卡片内边距…），
/// 只有语义别名覆盖不到时才直接用原始刻度。
abstract final class SkySpacing {
  static const double none = 0;
  static const double s2 = 2;
  static const double s4 = 4;
  static const double s6 = 6;
  static const double s8 = 8;
  static const double s12 = 12;
  static const double s16 = 16;
  static const double s20 = 20;
  static const double s24 = 24;
  static const double s32 = 32;
  static const double s40 = 40;
  static const double s48 = 48;
  static const double s56 = 56;
  static const double s64 = 64;
  static const double s80 = 80;
  static const double s96 = 96;
}

/// 语义化间距：把"用在哪"固化下来，避免同一类场景在不同页面用不同数值。
abstract final class SkySemanticSpacing {
  /// 页面左右安全边距。C 端移动端统一 20，比 16 更透气、比 24 更省横向空间。
  static const double screenPadding = SkySpacing.s20;

  /// 卡片内边距。
  static const double cardPadding = SkySpacing.s16;

  /// 大区块之间的垂直间距（一屏内的"段落"分隔）。
  static const double sectionGap = SkySpacing.s32;

  /// 同一区块内条目之间的间距。
  static const double itemGap = SkySpacing.s12;

  /// 标签与其控件之间的间距。
  static const double labelGap = SkySpacing.s8;

  /// 底部弹层顶部到内容的间距（留出拖拽把手）。
  static const double sheetTopGap = SkySpacing.s24;
}

/// 圆角刻度。整体偏大圆角，观感更"软"、更像消费级产品；
/// 也与天空主题里大量出现的圆弧（云、伞衣、光晕）同调。
abstract final class SkyRadius {
  static const double xs = 6;
  static const double sm = 10;
  static const double md = 14;
  static const double lg = 20;
  static const double xl = 28;

  /// 胶囊形（用一个足够大的值代替 `StadiumBorder`，便于和其它圆角统一插值）。
  static const double pill = 999;

  // —— 语义别名 ——

  static const double button = md;
  static const double input = md;
  static const double checkbox = xs;
  static const double card = lg;
  static const double sheet = xl;
  static const double chip = pill;
  static const double toast = md;
}

/// 描边宽度。原本这些值借用了 `SkySpacing`，语义不对——描边不是间距。
abstract final class SkyBorderWidth {
  /// 常规描边 / 分割线。
  static const double hairline = 1;

  /// 聚焦态、选中态的强调描边。
  static const double thick = 2;
}

/// 图标尺寸刻度。
abstract final class SkyIconSize {
  static const double xs = 14;
  static const double sm = 16;
  static const double md = 20;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

/// 控件最小高度（同时也是可点击热区下限，均 ≥ 44 满足移动端可达性）。
abstract final class SkyControlSize {
  static const double buttonSmall = 36;
  static const double buttonMedium = 48;
  static const double buttonLarge = 56;
  static const double input = 52;

  /// 最小可点击热区，图标按钮等无文字控件必须撑到这个尺寸。
  static const double minTapTarget = 44;
}
