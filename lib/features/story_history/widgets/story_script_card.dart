import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:happy_os/core/theme/index.dart";
import "package:happy_os/features/story_history/domain/index.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 历史列表里的一条故事。
///
/// ## 一张卡分三层，从上往下越来越次要
/// 1. **标题 + 收藏星标**：左边一道渐变竖条把整张卡"锚"在品牌色上，
///    扫一列卡片时视线有一条对齐的引导线，比纯文字列表好找得多。
/// 2. **心愿 + 摘要**：心愿（`theme`）只在它和标题不一样时才露——两条一模一样的
///    文字堆在一起是噪音。它用引用样式（左边一道细线）与摘要区分开：
///    一句是"我当初想写什么"，一句是"最后写成了什么"。
/// 3. **元信息行**：篇幅徽标 · 文风 · 时间。缺哪个就不占位，不显示"未知"——
///    早期数据普遍缺 `style`，一列"未知"只会让人以为坏了。
///
/// 收藏星标做成卡片右上角的独立按钮而不是整行滑动：收藏是高频轻动作，
/// 藏进滑动手势里等于没有。删除反过来——低频且不可逆，所以只在左滑里出现。
class StoryScriptCard extends StatelessWidget {
  const StoryScriptCard({
    super.key,
    required this.script,
    required this.timeLabel,
    required this.emptyTitleLabel,
    required this.favoriteLabel,
    required this.lengthLabel,
    required this.onTap,
    required this.onToggleFavorite,
  });

  final StoryScript script;

  /// 已格式化好的时间（格式化要 locale，交给调用方）。
  final String timeLabel;

  /// 标题为空时的兜底文案（早期数据可能既没标题也没心愿）。
  final String emptyTitleLabel;

  /// 星标的无障碍标签。
  final String favoriteLabel;

  /// 篇幅的本地化名称（短篇 / 中篇 / 长篇）。为空表示这一篇没有篇幅信息。
  final String? lengthLabel;

  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final title = script.title.isEmpty ? emptyTitleLabel : script.title;
    // 心愿和标题一样时不重复露一遍。
    final wish = script.theme;
    final showsWish = wish != null && wish.isNotEmpty && wish != script.title;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // 渐变竖条：收藏过的更亮一档，暗着的那些也仍然有这条对齐线。
              Container(
                width: HappySpacing.s4,
                decoration: BoxDecoration(
                  gradient: script.isFavorited
                      ? HappyGradients.brandBright
                      : HappyGradients.brand,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(
                    HappySemanticSpacing.cardPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: HappySpacing.s8,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              title,
                              style: theme.textTheme.titleSmall,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: HappySpacing.s8),
                          _FavoriteButton(
                            isFavorited: script.isFavorited,
                            label: favoriteLabel,
                            onPressed: onToggleFavorite,
                          ),
                        ],
                      ),

                      if (showsWish) _WishLine(text: wish),

                      if (script.summary.isNotEmpty)
                        Text(
                          script.summary,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                            height: _summaryHeight,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                      _MetaRow(
                        lengthLabel: lengthLabel,
                        style: script.style,
                        timeLabel: timeLabel,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 心愿原文。左边一道细竖线（引用体）——它是用户自己的话，不是 AI 写的正文。
class _WishLine extends StatelessWidget {
  const _WishLine({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: HappySpacing.s8,
      children: <Widget>[
        Container(
          width: HappyBorderWidth.thick,
          // 高度跟着一行文字走：整段是单行截断，不需要 IntrinsicHeight 去量。
          height: _wishBarHeight,
          decoration: BoxDecoration(
            color: scheme.primary.withValues(alpha: _wishBarAlpha),
            borderRadius: BorderRadius.circular(HappyRadius.pill),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant.withValues(alpha: _wishTextAlpha),
              fontStyle: FontStyle.italic,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

/// 元信息行：篇幅徽标 · 文风 · 时间。
///
/// 篇幅做成有底色的徽标而不是纯文字：它是这一屏唯一可筛选的维度，
/// 视觉上得比旁边两条只读信息重一点，用户才会想到"原来可以按这个筛"。
class _MetaRow extends StatelessWidget {
  const _MetaRow({
    required this.lengthLabel,
    required this.style,
    required this.timeLabel,
  });

  final String? lengthLabel;
  final String? style;
  final String timeLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final muted = theme.textTheme.labelSmall?.copyWith(
      color: scheme.onSurfaceVariant.withValues(alpha: _metaAlpha),
    );

    return Row(
      spacing: HappySpacing.s8,
      children: <Widget>[
        if (lengthLabel case final String label when label.isNotEmpty)
          _LengthBadge(label: label),
        if (style case final String value when value.isNotEmpty)
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: HappySpacing.s4,
              children: <Widget>[
                Icon(
                  LucideIcons.palette,
                  size: HappyIconSize.xs,
                  color: scheme.onSurfaceVariant.withValues(alpha: _metaAlpha),
                ),
                Flexible(
                  child: Text(
                    value,
                    style: muted,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        const Spacer(),
        Text(timeLabel, style: muted),
      ],
    );
  }
}

/// 篇幅徽标。
class _LengthBadge extends StatelessWidget {
  const _LengthBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: HappySpacing.s8,
        vertical: HappySpacing.s2,
      ),
      decoration: BoxDecoration(
        color: scheme.tertiary.withValues(alpha: _badgeFillAlpha),
        borderRadius: BorderRadius.circular(HappyRadius.chip),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(color: scheme.tertiary),
      ),
    );
  }
}

/// 收藏星标。
///
/// Lucide 是纯描边图标集，**没有实心星**，所以选中态不能靠"换成实心图标"来表达。
/// 改成给星星垫一层品牌色圆底：多出来的那个圆是形状变化，扫一列卡片时一眼看得出
/// 哪些收藏了——只换颜色在深色画布上对比度不够。切换时整颗弹一下
/// （`springy` 只给这类正反馈）。
class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({
    required this.isFavorited,
    required this.label,
    required this.onPressed,
  });

  final bool isFavorited;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Semantics(
      button: true,
      selected: isFavorited,
      label: label,
      child: IconButton(
        // 图标按钮默认热区就是 48，够用；这里只把内边距收紧，别把标题挤窄。
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(
          minWidth: HappyControlSize.minTapTarget,
          minHeight: HappyControlSize.minTapTarget,
        ),
        tooltip: label,
        onPressed: () {
          // 收藏是"标记我喜欢"的时刻，给一次轻震——它比星标变色更早被感知到。
          HapticFeedback.lightImpact();
          onPressed();
        },
        icon: AnimatedScale(
          // 切到收藏时整颗放大一点点再回落，给"标记成功"一个落点。
          scale: isFavorited ? _favoritedScale : 1,
          duration: HappyMotion.fast,
          curve: HappyMotion.springy,
          child: AnimatedContainer(
            duration: HappyMotion.fast,
            curve: HappyMotion.standard,
            padding: const EdgeInsets.all(HappySpacing.s4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isFavorited
                  ? scheme.primary.withValues(alpha: _favoritedFillAlpha)
                  : Colors.transparent,
            ),
            child: Icon(
              LucideIcons.star,
              size: HappyIconSize.md,
              color: isFavorited ? scheme.primary : scheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

/// 摘要行高放宽一点：两行小字挤在一起在深色底上很难读。
const double _summaryHeight = 1.5;

/// 心愿引用条的高度与浓淡。它是"用户自己说过的话"，比摘要更淡一档，
/// 不该跟标题抢注意力。
const double _wishBarHeight = 16;
const double _wishBarAlpha = 0.5;
const double _wishTextAlpha = 0.85;

/// 元信息比摘要再淡一档：它是最次要的一层。
const double _metaAlpha = 0.7;

/// 篇幅徽标的底色透明度。
const double _badgeFillAlpha = 0.16;

/// 已收藏时星标的圆底透明度与放大比例。都只做很小一档——
/// 它是一个标记，不该在卡片上抢过标题。
const double _favoritedFillAlpha = 0.16;
const double _favoritedScale = 1.08;
