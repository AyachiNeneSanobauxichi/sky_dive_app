import "package:flutter/material.dart";
import "package:sky_dive/core/theme/index.dart";
import "package:sky_dive/l10n/app_localizations.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 航线页面 / 弹层的统一页头：返回 + 标题 + 副标题 + 可选尾部动作。
///
/// 详情页、表单页、选人弹层共用一个页头，免得三处各写一遍慢慢长歪。
/// [onBack] 为空时不显示返回键（弹层顶部已有拖拽把手，再加一个返回是重复入口）。
class LoadHeader extends StatelessWidget {
  const LoadHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onBack,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final subtitleText = subtitle;
    final back = onBack;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        if (back != null) ...<Widget>[
          IconButton(
            onPressed: back,
            tooltip: l10n.commonBack,
            icon: const Icon(LucideIcons.arrowLeft, size: SkyIconSize.lg),
          ),
          const SizedBox(width: SkySpacing.s4),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.headlineSmall,
              ),
              if (subtitleText != null) ...<Widget>[
                const SizedBox(height: SkySpacing.s4),
                Text(
                  subtitleText,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
        ?trailing,
      ],
    );
  }
}
