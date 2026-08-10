import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:happy_os/core/theme/index.dart";
import "package:happy_os/features/story_history/domain/index.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 历史列表里的一条故事。
///
/// 卡片上只放三样东西：标题、两行摘要、时间。写完的故事**没有状态**可言
/// （分页拿到的都是已落库的成稿），所以这里不像旧版那样有"生成中/失败"的角标——
/// 那是 mock 时代凭空假设出来的，接口里根本没有。
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

  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final title = script.title.isEmpty ? emptyTitleLabel : script.title;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(HappySemanticSpacing.cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: HappySpacing.s6,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.titleSmall,
                      maxLines: 1,
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
              if (script.summary.isNotEmpty)
                Text(
                  script.summary,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              Text(
                timeLabel,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: scheme.onSurfaceVariant.withValues(alpha: _timeAlpha),
                ),
              ),
            ],
          ),
        ),
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

/// 时间戳比摘要再淡一档：它是元信息里最次要的一层。
const double _timeAlpha = 0.7;

/// 已收藏时星标的圆底透明度与放大比例。都只做很小一档——
/// 它是一个标记，不该在卡片上抢过标题。
const double _favoritedFillAlpha = 0.16;
const double _favoritedScale = 1.08;
