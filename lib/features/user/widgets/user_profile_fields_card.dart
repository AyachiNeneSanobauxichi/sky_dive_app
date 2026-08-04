import "package:flutter/material.dart";
import "package:happy_os/core/theme/index.dart";
import "package:happy_os/features/user/domain/index.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 一条档案字段（图标 + 标签 + 值）。值为空表示"未填写"。
class UserProfileField {
  const UserProfileField({
    required this.key,
    required this.icon,
    required this.label,
    this.value,
  });

  /// 稳定标识：点这一行时带着它跳到设置页定位对应输入项。
  final UserProfileFieldKey key;

  /// 行首小图标。八九行纯文字堆在一起时，图标是最省力的"扫读锚点"——
  /// 用户找"城市"时看图标比逐行读标签快。
  final IconData icon;

  final String label;

  /// 已格式化好的展示值；null / 空串都算未填写。
  final String? value;

  bool get isEmpty => value == null || value!.isEmpty;
}

/// 个人档案卡：字段两列对齐 + 爱好用 chip 平铺。
///
/// 字段顺序由调用方决定（按"身份 → 时空 → 职业 → 兴趣"排）；本组件只负责呈现。
/// 未填写的字段**照样列出来**而不是隐藏：留着空位用户才知道还能补什么，
/// 也是"完善档案"这个引导的落点。
///
/// **每一行都可点**（[onFieldTap]）：直接跳到设置页里对应的那一项，省掉"进整页设置
/// 再自己找字段"这一层。未填写的行右侧给一个加号图标，明示"这里能补"。
class UserProfileFieldsCard extends StatelessWidget {
  const UserProfileFieldsCard({
    super.key,
    required this.title,
    required this.fields,
    required this.emptyValueLabel,
    required this.hobbiesLabel,
    required this.hobbiesIcon,
    required this.hobbies,
    required this.actionLabel,
    required this.onAction,
    required this.onFieldTap,
  });

  /// 点某一行：带着该字段的 key 跳到设置页。
  final ValueChanged<UserProfileFieldKey> onFieldTap;

  final String title;
  final List<UserProfileField> fields;

  /// 未填写字段的占位文案。
  final String emptyValueLabel;

  final String hobbiesLabel;

  /// 爱好那一行的图标（和上面各字段的行首图标同一档）。
  final IconData hobbiesIcon;

  final List<String> hobbies;

  /// 卡片右上角的可见入口（编辑档案）。长按/隐藏手势不能是唯一路径，所以这里必须有。
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(HappySemanticSpacing.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(title, style: theme.textTheme.titleMedium),
                ),
                TextButton(onPressed: onAction, child: Text(actionLabel)),
              ],
            ),
            const SizedBox(height: HappySpacing.s4),
            for (final field in fields)
              _FieldRow(
                field: field,
                emptyValueLabel: emptyValueLabel,
                onTap: () => onFieldTap(field.key),
              ),
            const SizedBox(height: HappySpacing.s12),
            // 爱好整块也可点：它是最后一个"字段"，行为要和上面一致。
            InkWell(
              onTap: () => onFieldTap(UserProfileFieldKey.hobbies),
              borderRadius: BorderRadius.circular(HappyRadius.sm),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: HappySpacing.s4),
                child: Row(
                  children: <Widget>[
                    Icon(
                      hobbiesIcon,
                      size: HappyIconSize.sm,
                      color: scheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: HappySpacing.s8),
                    Text(
                      hobbiesLabel,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: HappySpacing.s8),
            if (hobbies.isEmpty)
              Text(
                emptyValueLabel,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              )
            else
              Wrap(
                spacing: HappySpacing.s8,
                runSpacing: HappySpacing.s8,
                children: <Widget>[
                  for (final hobby in hobbies) _HobbyChip(label: hobby),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _FieldRow extends StatelessWidget {
  const _FieldRow({
    required this.field,
    required this.emptyValueLabel,
    required this.onTap,
  });

  final UserProfileField field;
  final String emptyValueLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(HappyRadius.sm),
      child: Padding(
        // 行高撑到 44：整行是热区，得满足最小可点尺寸。
        padding: const EdgeInsets.symmetric(vertical: HappySpacing.s12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 未填写的行连图标一起压暗：一眼扫下来"哪几行还空着"就出来了，
            // 不用逐行去读右侧的值。
            Icon(
              field.icon,
              size: HappyIconSize.sm,
              color: field.isEmpty
                  ? scheme.onSurfaceVariant.withValues(alpha: _emptyIconAlpha)
                  : scheme.onSurfaceVariant,
            ),
            const SizedBox(width: HappySpacing.s8),
            Text(
              field.label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: HappySpacing.s16),
            Expanded(
              child: Text(
                field.isEmpty ? emptyValueLabel : field.value!,
                textAlign: TextAlign.right,
                style: theme.textTheme.bodyMedium?.copyWith(
                  // 未填写压成弱色，和已填内容一眼分开。
                  color: field.isEmpty
                      ? scheme.onSurfaceVariant
                      : scheme.onSurface,
                ),
              ),
            ),
            const SizedBox(width: HappySpacing.s4),
            // 未填写给加号（明示"可补"），已填给箭头（明示"可改"）。
            Icon(
              field.isEmpty ? LucideIcons.plus : LucideIcons.chevronRight,
              size: HappyIconSize.sm,
              color: field.isEmpty ? scheme.primary : scheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class _HobbyChip extends StatelessWidget {
  const _HobbyChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: HappySpacing.s12,
        vertical: HappySpacing.s6,
      ),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: _chipFillAlpha),
        borderRadius: BorderRadius.circular(HappyRadius.chip),
        border: Border.all(
          color: scheme.primary.withValues(alpha: _chipBorderAlpha),
          width: HappyBorderWidth.hairline,
        ),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelMedium?.copyWith(color: scheme.primary),
      ),
    );
  }
}

/// 爱好 chip 的底色/描边透明度：品牌色低透明度即可，铺满会盖过正文。
const double _chipFillAlpha = 0.12;
const double _chipBorderAlpha = 0.32;

/// 未填写行的行首图标不透明度。压到 0.55——再低在浅色主题上就看不见了。
const double _emptyIconAlpha = 0.55;
