import "package:flutter/material.dart";
import "package:sky_dive/core/theme/index.dart";
import "package:sky_dive/shared/widgets/button/sky_button.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 失败重试卡。
///
/// 流式生成失败和普通请求失败**不是一回事**：可能已经生成了一半。所以这张卡是
/// 内联在内容下方的（不是弹窗、不是整页错误态），上方已生成的文字要留在原地——
/// 用户辛苦等来的半篇故事不能因为一次网络抖动就被清屏。
///
/// 全部文案由调用方从 `AppLocalizations` 传入（红线 #9）。
class SkyRetryCard extends StatelessWidget {
  const SkyRetryCard({
    super.key,
    required this.message,
    required this.retryLabel,
    required this.onRetry,
    this.isRetrying = false,
  });

  /// 失败原因（通常来自 `Failure.displayMessage`）。
  final String message;

  final String retryLabel;
  final VoidCallback onRetry;

  /// 重试进行中：按钮进入忙碌态，防重复点击。
  final bool isRetrying;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(SkySemanticSpacing.cardPadding),
      decoration: BoxDecoration(
        // 错误色只做低透明度底 + 描边，不整块铺红：铺红会让人以为数据全丢了
        color: scheme.error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(SkyRadius.card),
        border: Border.all(
          color: scheme.error.withValues(alpha: 0.32),
          width: SkyBorderWidth.hairline,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: SkySemanticSpacing.itemGap,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: SkySemanticSpacing.labelGap,
            children: <Widget>[
              Icon(
                LucideIcons.circleAlert,
                size: SkyIconSize.md,
                color: scheme.error,
              ),
              Expanded(child: Text(message, style: theme.textTheme.bodyMedium)),
            ],
          ),
          SkyButton(
            label: retryLabel,
            icon: LucideIcons.rotateCcw,
            onPressed: onRetry,
            isLoading: isRetrying,
            variant: SkyButtonVariant.secondary,
            size: SkyButtonSize.small,
            isFullWidth: false,
          ),
        ],
      ),
    );
  }
}
