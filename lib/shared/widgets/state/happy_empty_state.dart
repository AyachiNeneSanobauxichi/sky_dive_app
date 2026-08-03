import "package:flutter/material.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:happy_os/core/theme/index.dart";
import "package:happy_os/shared/widgets/brand/happy_brand_mark.dart";
import "package:happy_os/shared/widgets/button/happy_button.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 通用空态：品牌标记 + 标题 + 说明 + **一个引导下一步的行动**。
///
/// 规范要求空态不是兜底而是引导位（见 skill `17-ux-interaction.md`），所以这里把
/// "行动"做成一等参数：只显示"暂无数据"的空态在本项目里不合规。
/// [actionLabel] 为空时才退化成纯说明（例如功能尚未上线、连按钮都无处可去）。
///
/// 下沉到 shared 是因为三个业务模块（story / track / user）都要用同一套空态骨架，
/// 各写一遍必然长歪。
class HappyEmptyState extends StatelessWidget {
  const HappyEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    this.actionLabel,
    this.onAction,
  });

  /// 品牌标记里的图标，用来区分不同模块的空态。
  final IconData icon;

  /// 主文案（衬线大标题，叙事感）。
  final String title;

  /// 一句话说明"这里将会有什么 / 为什么现在是空的"。
  final String description;

  /// 引导行动的按钮文案；为空则不显示按钮。
  final String? actionLabel;

  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = actionLabel;

    return Center(
      child: SingleChildScrollView(
        // 小屏 / 大字体下也不会溢出：空态本身不长，但标题是衬线大字。
        padding: const EdgeInsets.all(HappySemanticSpacing.screenPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: HappySemanticSpacing.itemGap,
          children: <Widget>[
            HappyBrandMark(icon: icon),
            const SizedBox(height: HappySpacing.s8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall,
            ),
            Text(
              description,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (label != null) ...<Widget>[
              const SizedBox(height: HappySpacing.s8),
              HappyButton(
                label: label,
                onPressed: onAction,
                isFullWidth: false,
                icon: LucideIcons.arrowRight,
              ),
            ],
          ],
        ),
      ),
    ).animate().fadeIn(duration: HappyMotion.slow, curve: HappyMotion.standard);
  }
}
