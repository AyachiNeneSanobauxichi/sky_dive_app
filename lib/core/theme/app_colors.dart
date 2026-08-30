import "package:flutter/material.dart";

/// 全局原始色板（design token 的最底层）。
///
/// 这里**只放颜色字面量**，不含任何 Widget 逻辑。业务层禁止直接引用本类，
/// 一律通过 `Theme.of(context).colorScheme` 取色；本类只是给 `app_theme.dart`
/// 组装 [ColorScheme] 的"原料"，以及给 `app_gradients` / `app_shadows` 复用。
///
/// ## 设计基调：高空 · 双主场
/// SkyDive 是跳伞运营商的 C 端 app，核心画面是**从万米高空跃出**：
/// 头顶纯净的平流层蓝、脚下翻涌的云海、伞衣张开时那一抹朱橙。
/// 于是主题定为「高空」，且深浅两套**都是一等设计目标**——
/// - **浅色 = 白昼晴空**：客人白天挑航线、看天气、下预约，这是主流使用场景；
/// - **深色 = 暮色高空**：黄昏跳（sunset jump）与夜间查看行程，天幕压暗、地平线留一道余晖。
///
/// 两套都按 WCAG AA（正文 ≥ 4.5:1）逐色校过对比度，校验值写在各字段注释里。
///
/// 命名规则：`dark*` 前缀 = 深色模式专用；无前缀 = 浅色模式或品牌通用。
abstract final class SkyColors {
  // ───────────────────────── 品牌基色（通用） ─────────────────────────
  //
  // 品牌语言是**一道从深空蓝滑到高空青的光**，对应跳伞时抬头看到的那段天色梯度。
  // 刻意做成同色系而非撞色渐变：航空产品的可信感来自克制，
  // 真正的"跳"由下面的朱橙（伞衣色）点一下就够。

  /// 品牌主色·高空蓝。浅色底上作 primary（白字压其上 5.2:1）。
  static const Color azure = Color(0xFF0A6FC2);

  /// 品牌主色的高亮版本。深色底上 [azure] 对比度不足，改用它作 primary。
  static const Color azureBright = Color(0xFF4CC2FF);

  /// 品牌主色的暗部：渐变收尾、container 底、深色天幕里的蓝雾。
  static const Color azureDeep = Color(0xFF073B66);

  /// 品牌渐变的亮端·高空青。天顶越薄、色越青，是这条渐变的物理依据。
  static const Color skyCyan = Color(0xFF21B4E8);

  /// 高空青的高亮版本（深色底专用）。
  static const Color skyCyanBright = Color(0xFF7BE3FF);

  /// 渐变中段的靛蓝，用于三段式宽渐变，让蓝→青的长距离过渡不发灰。
  static const Color stratoIndigo = Color(0xFF2C5FBF);

  // ───────────────────────── 点缀色·伞衣朱橙 ─────────────────────────

  /// 伞衣色。降落伞、风向袋、安全标识都是这个色系；
  /// 落到日本语境上又正好是鸟居的朱色，本地观感不违和。
  /// 浅色底上作 tertiary（白字压其上 5.2:1，作正文色压白底同样 5.2:1）。
  static const Color canopy = Color(0xFFC2410C);

  /// 伞衣色的高亮版本（深色底专用，对深色卡片 8.4:1）。
  static const Color canopyBright = Color(0xFFFF9E5E);

  /// 伞衣色的暗部，用于 container 底与渐变收尾。
  static const Color canopyDeep = Color(0xFF7C2D12);

  // ───────────────────────── 语义状态色 ─────────────────────────
  //
  // 跳伞业务里这三个色是有实义的：天气可跳 = success、风速临界 = warning、
  // 停飞 = danger。所以它们不只是"提示色"，会直接出现在航班状态徽标上。

  /// 可跳 / 成功（白底 5.2:1）。
  static const Color success = Color(0xFF0B7D55);
  static const Color darkSuccess = Color(0xFF34D399);

  /// 临界 / 待确认（白底 5.1:1）。
  static const Color warning = Color(0xFFB45309);
  static const Color darkWarning = Color(0xFFFBBF24);

  /// 停飞 / 失败（白底 5.7:1）。
  static const Color danger = Color(0xFFC81E1E);
  static const Color darkDanger = Color(0xFFFF7A7A);

  // ───────────────────────── 深色模式（暮色高空） ─────────────────────────

  /// 页面画布：深海军蓝，比纯黑更像"日落后的高空"而不是关机屏。
  ///
  /// 取值刻意落在 [darkSkyZenith] 与 [darkSkyHorizon] 的中点：天幕是一道竖向渐变，
  /// 而吸顶条 / 导航条这类要"挡住内容"的地方只能用单色，用中点色它们才不会
  /// 在天幕上显出一条色差带。
  static const Color darkBackground = Color(0xFF0A1220);

  /// 天顶：天幕渐变的最暗端，越往上越接近"看不见底的平流层"。
  static const Color darkSkyZenith = Color(0xFF050A14);

  /// 地平：天幕渐变的亮端，透出日落余晖，避免整屏死黑。
  static const Color darkSkyHorizon = Color(0xFF12203A);

  /// 常规卡片底。
  static const Color darkSurface = Color(0xFF101A2B);

  /// 抬升一层：输入框、列表项、次级按钮。
  static const Color darkSurfaceElevated = Color(0xFF17233A);

  /// 再抬升一层：弹层、菜单、悬浮卡。
  static const Color darkSurfaceHighest = Color(0xFF1F2E49);

  /// 主要文字（对 [darkSurface] 约 15:1）。
  static const Color darkTextPrimary = Color(0xFFEAF2FB);

  /// 次要文字（对 [darkSurface] 约 7.7:1）。
  static const Color darkTextSecondary = Color(0xFF9DB0C9);

  /// 弱化文字（对 [darkSurface] 约 5.4:1，仍达 AA 正文标准）。
  static const Color darkTextMuted = Color(0xFF7E93AE);

  /// 常规描边（卡片、输入框未聚焦时）。
  static const Color darkBorder = Color(0xFF27374F);

  /// 极弱描边（分割线、内部网格）。
  static const Color darkBorderSubtle = Color(0xFF1A2739);

  /// 放在高亮蓝 [azureBright] 上的前景色（深海军，避免纯白的刺眼感）。
  static const Color darkOnBrand = Color(0xFF052033);

  // ───────────────────────── 浅色模式（白昼晴空） ─────────────────────────

  /// 页面画布：带蓝调的白，对应晴空天幕的中点（同 [darkBackground] 的取值逻辑）。
  static const Color background = Color(0xFFF2F7FD);

  /// 晴空天幕的高处：正午天蓝。
  ///
  /// 刻意比"淡淡的蓝"更实一档。云在浅色模式下是**白色**的，天幕不够蓝时
  /// 白云压在近白的画布上等于没画——整屏会塌成一张灰蓝色卡。
  /// 这个值上压着的正文（`textPrimary`）对比度约 11.7:1，远超 AA。
  static const Color skyDayTop = Color(0xFFBCDCFA);

  /// 晴空天幕的低处：近白，让内容区不被天色压住。
  static const Color skyDayBottom = Color(0xFFFCFDFF);

  static const Color surface = Color(0xFFFFFFFF);

  /// 抬升一层：输入框填充底、次级按钮。
  static const Color surfaceElevated = Color(0xFFEEF4FB);

  static const Color surfaceHighest = Color(0xFFFFFFFF);

  /// 主要文字（对白底约 16.5:1）。
  static const Color textPrimary = Color(0xFF0D1B2A);

  /// 次要文字（对白底约 6.8:1）。
  static const Color textSecondary = Color(0xFF4A5D75);

  /// 弱化文字（对白底约 5.1:1）。
  static const Color textMuted = Color(0xFF5C7089);

  static const Color border = Color(0xFFDCE5F0);

  static const Color borderSubtle = Color(0xFFEDF1F8);

  /// 放在高空蓝 [azure] 上的前景色。
  static const Color onBrand = Color(0xFFFFFFFF);

  // ───────────────────────── 天空元素 ─────────────────────────
  //
  // 天幕光靠渐变会显得是"色卡"而不是天空，必须有云。
  // 浅色画白色云絮，深色画云海剪影（比天幕更暗的一层），
  // 加上高空才看得见的稀疏星点与地平线余晖，一张天幕就成立了。

  /// 白昼云絮色。
  static const Color cloudLight = Color(0xFFFFFFFF);

  /// 暮色云海剪影：比 [darkBackground] 略亮的一层蓝灰，
  /// 靠明度差读出"云在天幕前面"，而不是靠描边。
  static const Color cloudDark = Color(0xFF1C2C47);

  /// 日落余晖：只出现在深色天幕的地平线附近，是深色模式唯一的暖色光源。
  static const Color sunGlow = Color(0xFFFFC98A);

  /// 高空星点。跳伞高度（4000m）之上天色已深，星点是"高"的最省钱的表达。
  /// 三种色温混着撒，比清一色白点更像天空、也更不像屏幕噪点。
  static const Color starCore = Color(0xFFFFFFFF);
  static const Color starWarm = Color(0xFFFFE7BE);
  static const Color starCool = Color(0xFFC6D3FF);

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
