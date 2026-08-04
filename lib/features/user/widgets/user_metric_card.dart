import "package:flutter/material.dart";
import "package:happy_os/core/theme/index.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";
import "package:skeletonizer/skeletonizer.dart";

/// 成长指标卡：深度觉醒等级 / 星厉契合度共用一张。
///
/// 两个指标都是"抽象数值"，光给数字没有体感，所以每张卡都配一条进度：
/// 数值负责精确、进度条负责一眼看出"到哪了"。
///
/// 整张卡可点（[onTap]）：这两个是自造概念，用户第一次看到不知道怎么涨，
/// 点开一张说明卡比在卡面上硬塞一行解释更划算。右上角有个问号提示"这里能点"。
class UserMetricCard extends StatelessWidget {
  const UserMetricCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.progress,
    required this.caption,
    required this.onTap,
  });

  /// 点击打开该指标的说明。
  final VoidCallback onTap;

  final IconData icon;

  /// 指标名（如"深度觉醒等级"）。
  final String label;

  /// 主数值，已格式化好的字符串（如 "Lv.7" / "87%"）。
  final String value;

  /// 进度 0–1。
  final double progress;

  /// 进度下方的一句说明（如"距下一级还差 36%"）。
  final String caption;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      // Card 自带描边与圆角，这里只补水波纹的裁剪半径，让 InkWell 不溢出圆角。
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(HappyRadius.card),
        child: Padding(
          padding: const EdgeInsets.all(HappySemanticSpacing.cardPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(icon, size: HappyIconSize.sm, color: scheme.primary),
                  const SizedBox(width: HappySpacing.s6),
                  Expanded(
                    child: Text(
                      label,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // 弱提示"可点"：问号比箭头更贴"这是解释"而不是"这里能跳转"。
                  Icon(
                    LucideIcons.circleHelp,
                    size: HappyIconSize.sm,
                    color: scheme.onSurfaceVariant,
                  ),
                ],
              ),
              const SizedBox(height: HappySpacing.s8),
              // 数值用品牌渐变着色：这是本页最该被看见的两个数字。
              ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (bounds) => HappyGradients.brandFor(
                  theme.brightness,
                ).createShader(bounds),
                child: Text(value, style: theme.textTheme.headlineMedium),
              ),
              const SizedBox(height: HappySpacing.s8),
              // 骨架态下把进度条也盖住：否则会亮出一个"真实"的进度，
              // 用户以为数据到了，其实还在加载。
              Skeleton.shade(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(HappyRadius.pill),
                  child: LinearProgressIndicator(
                    value: progress.clamp(0, 1),
                    minHeight: HappySpacing.s6,
                    backgroundColor: scheme.surfaceContainerHighest,
                  ),
                ),
              ),
              const SizedBox(height: HappySpacing.s6),
              Text(
                caption,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
