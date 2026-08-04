import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:happy_os/core/theme/index.dart";
import "package:happy_os/l10n/app_localizations.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 首页底部导航条（v2）。
///
/// 只负责"显示三个 tab + 报告点了哪个"，选中态与切换由外壳（`HomeShell`）持有的
/// `StatefulNavigationShell` 决定——导航条自身无状态，才不会和路由状态两份真相打架。
///
/// 顺序 track → story → user：先有轨迹才有素材可改写，动线起点放"素材源"。
///
/// ## 形态：悬浮的玻璃胶囊
/// 不是贴着屏幕底边的一整条色板，而是**左右留边、四周描边的胶囊**，浮在极光画布上
/// （首页把极光放在 Scaffold 外层，光能透过 [_glassAlpha] 的底色）。整条贴边的板子
/// 在深色画布上会把屏幕"截断"，胶囊则读作一个可操作的控件。
/// 中间的 story 是产品主路径，做成探出胶囊上沿的品牌渐变圆，核心动作落在动线正中。
///
/// ## 为什么自绘而不用 M3 `NavigationBar`
/// 上面这两件（越界的凸起圆、胶囊外形）`NavigationBar` 的固定布局都做不到。代价是
/// M3 白送的东西要自己兜，下面逐条补了：选中态自己画（见 [_TabSlot]）、
/// 底部手势条用 `viewPadding` 自己让、每格热区整格（≥44）、每格带 [Semantics]
/// （button + selected）。
///
/// ## 按下反馈：缩放，不用水波纹
/// 每格热区有整格那么宽，`InkWell` 的水波会漫出图标很远、看着像点错了地方。
/// 所以改成 [HappyMotion.pressScale] 的按压缩放（触感由外壳在 onTap 时给），
/// 反馈范围正好落在被按的那个元素上。
class HomeBottomNavBar extends StatelessWidget {
  const HomeBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onSelect,
    this.onStoryLongPress,
    this.storyBadgeCount = 0,
  });

  final int currentIndex;
  final ValueChanged<int> onSelect;

  /// 长按中间 story 圆：快捷创作菜单（可选）。
  final VoidCallback? onStoryLongPress;

  /// story tab 的角标数（生成完成待查看）。0 表示不显示。
  final int storyBadgeCount;

  /// 玻璃底不透明度。0.72 是实测平衡点：再透文字对比度不够，再实就没有透光感。
  static const double _glassAlpha = 0.72;

  /// 内容区总高（不含系统手势条与外边距）。
  static const double _contentHeight = HappySpacing.s80;

  /// 胶囊相对顶部下移量——让出这一条给中间凸起圆"探头"。
  static const double _lift = HappySpacing.s20;

  /// 没有系统手势条时（旧机型 / 模拟器）也要留的底部呼吸。
  static const double _minBottomGap = HappySpacing.s12;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    // 手势条高度自己让：本条不是 M3 NavigationBar，Scaffold 不会代劳。
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(
        left: HappySemanticSpacing.screenPadding,
        right: HappySemanticSpacing.screenPadding,
        bottom: bottomInset > 0 ? bottomInset : _minBottomGap,
      ),
      child: SizedBox(
        height: _contentHeight,
        child: Stack(
          // 凸起圆要探出胶囊，别裁掉。
          clipBehavior: Clip.none,
          children: <Widget>[
            Positioned(
              left: 0,
              right: 0,
              top: _lift,
              bottom: 0,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerLow.withValues(
                    alpha: _glassAlpha,
                  ),
                  borderRadius: BorderRadius.circular(HappyRadius.pill),
                  border: Border.all(
                    color: scheme.outline,
                    width: HappyBorderWidth.hairline,
                  ),
                  // 浅色下靠投影托起来；深色下投影不可见，靠描边与凸起圆的光晕。
                  boxShadow: HappyShadows.card(theme.brightness),
                ),
              ),
            ),
            // 槽位铺满整个高度（含上方留白），凸起圆探出去的那截才有可点热区。
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: _TabSlot(
                      icon: LucideIcons.footprints,
                      selectedIcon: LucideIcons.footprints,
                      label: l10n.homeTabTrack,
                      isSelected: currentIndex == 0,
                      onTap: () => onSelect(0),
                    ),
                  ),
                  Expanded(
                    child: _RaisedTabSlot(
                      icon: LucideIcons.bookOpen,
                      label: l10n.homeTabStory,
                      isSelected: currentIndex == 1,
                      badgeCount: storyBadgeCount,
                      onTap: () => onSelect(1),
                      onLongPress: onStoryLongPress,
                    ),
                  ),
                  Expanded(
                    child: _TabSlot(
                      icon: LucideIcons.userRound,
                      selectedIcon: LucideIcons.userRoundCheck,
                      label: l10n.homeTabUser,
                      isSelected: currentIndex == 2,
                      onTap: () => onSelect(2),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 可按压的槽位外壳：按下缩放（替代水波纹）+ 转发点击 / 长按。
///
/// 用 [GestureDetector] 而不是 `InkWell` 是刻意的（见 [HomeBottomNavBar] 类注释）：
/// 整格宽的水波会漫出图标太远。反馈由 [AnimatedScale] 的按压缩放承担，范围精确。
class _PressableSlot extends StatefulWidget {
  const _PressableSlot({
    required this.onTap,
    required this.child,
    this.onLongPress,
    this.baseScale = 1,
  });

  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final Widget child;

  /// 未按下时的基准缩放（凸起圆用它表达未选中态，两个缩放相乘）。
  final double baseScale;

  @override
  State<_PressableSlot> createState() => _PressableSlotState();
}

class _PressableSlotState extends State<_PressableSlot> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    if (_isPressed == value) return;
    setState(() => _isPressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final scale =
        widget.baseScale * (_isPressed ? HappyMotion.pressScale : 1.0);

    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      // opaque：整格都是热区，透明处也要接手势（≥44 的可点区靠它成立）。
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: scale,
        duration: HappyMotion.instant,
        curve: HappyMotion.standard,
        child: widget.child,
      ),
    );
  }
}

/// 普通 tab 槽位：图标 + 标签，整格可点。
///
/// ## 选中态怎么表达
/// 不用实心胶囊底：那块色板在 48×32 里几乎铺满，抢过了图标本身，看着像图标被"框住"
/// 而不是被点亮。改成三件事叠加——
/// 1. **图标换成品牌渐变着色**（[ShaderMask]）：和中间凸起圆同一条紫→品红光带，
///    整条导航条的选中语言统一，且这一下变化足够明显；
/// 2. **轻微放大**（[_selectedIconScale]）：形状上也有差异，不只靠颜色；
/// 3. 背后一层**无硬边的径向光晕**（[HappyGradients.auroraBlob]）：给出"这里亮着"
///    的存在感，但不会像色板那样占满格子。
class _TabSlot extends StatelessWidget {
  const _TabSlot({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;

  /// 选中态尽量换成同族的"实心/带标记"图标：让"我在哪"除了颜色还有形状差异，
  /// 对色觉障碍用户也分得清。同族里没有对应变体时传同一个即可。
  final IconData selectedIcon;

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final color = isSelected ? scheme.primary : scheme.onSurfaceVariant;

    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: _PressableSlot(
        onTap: onTap,
        child: Column(
          // 底部对齐：中间那格更高，靠这个让三个标签落在同一条基线上。
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            // 固定尺寸的图标位：选中时图标会放大，尺寸写死才不会把标签顶来顶去。
            SizedBox(
              width: HappySpacing.s48,
              height: HappySpacing.s32,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  // 光晕淡入淡出，不参与布局。
                  AnimatedOpacity(
                    opacity: isSelected ? 1 : 0,
                    duration: HappyMotion.fast,
                    curve: HappyMotion.standard,
                    child: Container(
                      width: HappySpacing.s32,
                      height: HappySpacing.s32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: HappyGradients.auroraBlob(
                          scheme.primary,
                          intensity: _haloIntensity,
                        ),
                      ),
                    ),
                  ),
                  AnimatedScale(
                    scale: isSelected ? _selectedIconScale : 1,
                    duration: HappyMotion.fast,
                    curve: HappyMotion.standard,
                    child: _TabIcon(
                      icon: isSelected ? selectedIcon : icon,
                      isSelected: isSelected,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: HappySpacing.s4),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(color: color),
            ),
            const SizedBox(height: HappySpacing.s8),
          ],
        ),
      ),
    );
  }
}

/// tab 图标：选中时用品牌渐变着色，未选中是普通单色。
///
/// [ShaderMask] 把渐变刷到图标的不透明像素上——图标字形本身当遮罩用，
/// 所以不需要额外准备渐变版图标资源。
class _TabIcon extends StatelessWidget {
  const _TabIcon({
    required this.icon,
    required this.isSelected,
    required this.color,
  });

  final IconData icon;
  final bool isSelected;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final glyph = Icon(icon, size: HappyIconSize.lg, color: color);
    if (!isSelected) return glyph;

    final gradient = HappyGradients.brandFor(Theme.of(context).brightness);
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(bounds),
      child: glyph,
    );
  }
}

/// 凸起的 story 槽位：圆形入口探出胶囊上沿，标签仍与两侧对齐。
///
/// ## 选中/未选中的差别
/// 早先两态都是满渐变、只差一点缩放与光晕，几乎看不出区别。现在拉开：
/// - **选中**：品牌渐变填充 + 品牌光晕 + 白色图标，原尺寸；
/// - **未选中**：中性表面色填充 + 描边 + 弱色图标，缩到 [_unselectedScale]、无光晕。
///
/// 保持"凸起的圆"这个形状不变（它是主路径入口，不该在未选中时退化成普通图标），
/// 但填充从"发光的品牌色"变成"安静的表面色"，一眼就能分辨。
class _RaisedTabSlot extends StatelessWidget {
  const _RaisedTabSlot({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.badgeCount,
    required this.onTap,
    this.onLongPress,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final int badgeCount;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  /// 凸起圆直径。48 是算过的上限：48 + 标签 + 呼吸正好填满
  /// [HomeBottomNavBar._contentHeight]，再大就顶出胶囊外、上半截点不到。
  static const double _size = HappySpacing.s48;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: _PressableSlot(
        onTap: onTap,
        onLongPress: onLongPress,
        // 未选中时整格缩一点：让主入口在"不是当前页"时收敛一档，
        // 但仍保持渐变与存在感（它是主路径，不该被压成灰图标）。
        baseScale: isSelected ? 1 : _unselectedScale,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Stack(
              // 角标要贴在圆的右上角外侧。
              clipBehavior: Clip.none,
              children: <Widget>[
                AnimatedContainer(
                  duration: HappyMotion.fast,
                  curve: HappyMotion.standard,
                  width: _size,
                  height: _size,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: isSelected
                        ? HappyGradients.brandFor(theme.brightness)
                        : null,
                    color: isSelected ? null : scheme.surfaceContainerHighest,
                    border: isSelected
                        ? null
                        : Border.all(
                            color: scheme.outline,
                            width: HappyBorderWidth.hairline,
                          ),
                    boxShadow: isSelected
                        ? HappyShadows.glow(
                            scheme.primary,
                            intensity: _glowSelected,
                          )
                        : HappyShadows.none,
                  ),
                  child: Icon(
                    icon,
                    size: HappyIconSize.md,
                    color: isSelected
                        ? scheme.onPrimary
                        : scheme.onSurfaceVariant,
                  ),
                ),
                if (badgeCount > 0)
                  Positioned(
                    top: -HappySpacing.s4,
                    right: -HappySpacing.s4,
                    child: _StoryBadge(count: badgeCount),
                  ),
              ],
            ),
            const SizedBox(height: HappySpacing.s4),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: isSelected ? scheme.primary : scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: HappySpacing.s8),
          ],
        ),
      ),
    );
  }
}

/// story 角标：数字冒出来时弹一下。
///
/// "故事生成好了"是正反馈时刻，直接闪现会被忽略，所以用
/// [HappyMotion.springy] 弹入。`key` 绑数字：每次数字变化都重挂一次，动效重播，
/// 从 1 变 2 也会弹——这正是"又好了一篇"该有的提示。
///
/// 用品红（tertiary）而不是红色：这不是错误，是好消息。
class _StoryBadge extends StatelessWidget {
  const _StoryBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      key: ValueKey<int>(count),
      constraints: const BoxConstraints(minWidth: HappySpacing.s20),
      height: HappySpacing.s20,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: HappySpacing.s4),
      decoration: BoxDecoration(
        color: scheme.tertiary,
        borderRadius: BorderRadius.circular(HappyRadius.pill),
        // 描一圈画布色，角标压在渐变圆上时边界才清楚。
        border: Border.all(
          color: theme.scaffoldBackgroundColor,
          width: HappyBorderWidth.thick,
        ),
      ),
      child: Text(
        "$count",
        style: theme.textTheme.labelSmall?.copyWith(color: scheme.onTertiary),
      ),
    ).animate().scale(duration: HappyMotion.normal, curve: HappyMotion.springy);
  }
}

/// 选中图标背后光晕的中心强度。径向渐变边缘为全透明，所以不会出现硬边色块。
const double _haloIntensity = 0.22;

/// 选中图标的放大比例。只放这么一点：再大会和中间凸起圆抢体量。
const double _selectedIconScale = 1.1;

/// 未选中时凸起圆的缩放比。
const double _unselectedScale = 0.92;

/// 凸起圆选中时的光晕强度。未选中不发光（用中性表面色 + 描边表达"安静"）。
const double _glowSelected = 0.45;
