import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:sky_dive/core/theme/index.dart";
import "package:sky_dive/l10n/app_localizations.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 名额上限步进器（顾客 / 摄影师各一个）。
///
/// 名额是个位数的小整数，用 +/- 步进比键盘输入快得多，也天然挡掉了
/// "输入 -3 / 输入 999" 这类脏值——边界由 [min] / [max] 卡死，
/// 到界的那一侧直接**禁用**（不是能点但没反应）。
class LoadCapacityStepper extends StatelessWidget {
  const LoadCapacityStepper({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.helperText,
  });

  final IconData icon;
  final String label;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  /// 到达下界的原因说明（"已经排了 3 人"）。只在到界时给，平时不占位吓人。
  final String? helperText;

  void _step(int delta) {
    HapticFeedback.selectionClick();
    onChanged((value + delta).clamp(min, max));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final helper = helperText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(icon, size: SkyIconSize.sm, color: scheme.onSurfaceVariant),
            const SizedBox(width: SkySpacing.s8),
            Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
            IconButton(
              onPressed: value > min ? () => _step(-1) : null,
              tooltip: l10n.loadCapacityDecrease,
              icon: const Icon(LucideIcons.minus, size: SkyIconSize.md),
            ),
            // 定宽避免 8 → 10 时两侧按钮左右跳动。
            SizedBox(
              width: SkySpacing.s32,
              child: Text(
                "$value",
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium,
              ),
            ),
            IconButton(
              onPressed: value < max ? () => _step(1) : null,
              tooltip: l10n.loadCapacityIncrease,
              icon: const Icon(LucideIcons.plus, size: SkyIconSize.md),
            ),
          ],
        ),
        if (helper != null && value <= min)
          Padding(
            // 缩进对齐上一行的文字（图标 16 + 间距 8）。
            padding: const EdgeInsets.only(left: SkySpacing.s24),
            child: Text(
              helper,
              style: theme.textTheme.labelSmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),
      ],
    );
  }
}
