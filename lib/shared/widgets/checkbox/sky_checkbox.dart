import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:sky_dive/core/theme/index.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 全局复选框（自绘方框 + 文案，整行可点）。
///
/// 不直接用 Material 的 `Checkbox`：它的方框固定 18pt、勾选动画是描边生长，
/// 在深色画布上又小又灰；这里换成品牌渐变填充 + 淡入的勾，
/// 选中状态在余光里也能一眼认出。
class SkyCheckbox extends StatelessWidget {
  const SkyCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
    this.isError = false,
    this.labelAlignment = CrossAxisAlignment.start,
  });

  final bool value;

  /// 传 `null` 表示禁用。
  final ValueChanged<bool>? onChanged;

  final Widget label;

  /// 校验未通过：方框描边转为错误色。
  final bool isError;

  /// 方框与文案的对齐方式。
  ///
  /// 默认 [CrossAxisAlignment.start]——文案换行到两三行时，方框要和**第一行**齐平，
  /// 居中会让它掉到段落中间。但如果文案确定只有一行、且行高被行内元素
  /// （比如可点的协议链接）撑高了，就该传 [CrossAxisAlignment.center]，
  /// 否则方框会孤零零地贴在那一行的顶上。
  final CrossAxisAlignment labelAlignment;

  /// 方框边长。比 Material 默认的 18 大一圈，移动端更好点也更好看。
  static const double _boxSize = 22;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final enabled = onChanged != null;

    return Semantics(
      checked: value,
      enabled: enabled,
      child: InkWell(
        onTap: enabled
            ? () {
                HapticFeedback.selectionClick();
                onChanged!(!value);
              }
            : null,
        borderRadius: BorderRadius.circular(SkyRadius.sm),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: SkySpacing.s4),
          child: Row(
            crossAxisAlignment: labelAlignment,
            spacing: SkySpacing.s12,
            children: <Widget>[
              _buildBox(context, scheme, enabled),
              Expanded(
                child: DefaultTextStyle.merge(
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: enabled
                        ? scheme.onSurfaceVariant
                        : scheme.onSurface.withValues(alpha: 0.38),
                  ),
                  child: label,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBox(BuildContext context, ColorScheme scheme, bool enabled) {
    final borderColor = switch ((isError, enabled)) {
      (true, _) => scheme.error,
      (false, false) => scheme.outlineVariant,
      (false, true) => scheme.outline,
    };

    return AnimatedContainer(
      duration: SkyMotion.instant,
      curve: SkyMotion.standard,
      width: _boxSize,
      height: _boxSize,
      decoration: BoxDecoration(
        gradient: value && enabled
            ? SkyGradients.brandFor(Theme.of(context).brightness)
            : null,
        color: value && enabled ? null : Colors.transparent,
        borderRadius: BorderRadius.circular(SkyRadius.checkbox),
        border: value && enabled
            ? null
            : Border.all(color: borderColor, width: SkyBorderWidth.thick),
      ),
      child: AnimatedOpacity(
        opacity: value ? 1 : 0,
        duration: SkyMotion.instant,
        child: Icon(
          LucideIcons.check,
          size: SkyIconSize.xs,
          color: scheme.onPrimary,
        ),
      ),
    );
  }
}
