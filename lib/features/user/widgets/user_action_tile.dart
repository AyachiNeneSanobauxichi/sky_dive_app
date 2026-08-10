import "package:flutter/material.dart";
import "package:happy_os/core/theme/index.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 功能项（档案设置 / 多账号切换 / 与开发者对话 / 退出登录）。
///
/// [isDestructive] 用错误色画图标与文字：退出登录这类操作要在**点之前**就看出来
/// 它和别的项不是一类，不能只靠二次确认弹窗兜。
class UserActionTile extends StatelessWidget {
  const UserActionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailingHint,
    this.trailingValue,
    this.isDestructive = false,
    this.showChevron = true,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  /// 右侧的状态提示（如"开发中"），有值时不显示箭头——那种项点了也去不了别处。
  final String? trailingHint;

  /// 右侧的当前取值（如语言选的是"简体中文"），**箭头照常显示**。
  ///
  /// 和 [trailingHint] 分开是因为两者说的是不同的事：hint 说"这项还没做"，
  /// value 说"这项现在是什么，点进去能改"。共用一个参数会让设置项看起来像是禁用的。
  final String? trailingValue;

  final bool isDestructive;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final foreground = isDestructive ? scheme.error : scheme.onSurface;
    final hint = trailingHint;

    return ListTile(
      // 整行可点，热区天然 ≥ 44（ListTile 默认最小高度 56）。
      onTap: onTap,
      leading: Icon(icon, size: HappyIconSize.lg, color: foreground),
      title: Text(
        label,
        style: theme.textTheme.bodyLarge?.copyWith(color: foreground),
      ),
      trailing: hint != null
          ? Text(
              hint,
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            )
          : _buildTrailing(theme, scheme),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(HappyRadius.md),
      ),
    );
  }

  /// 尾部：当前取值（可有可无）+ 箭头。
  ///
  /// 取值用 `mainAxisSize.min` 的 Row 而不是塞进 title 那一侧：设置项的值靠右、
  /// 紧贴箭头，扫一列设置时所有的值对齐在同一条竖线上。
  Widget? _buildTrailing(ThemeData theme, ColorScheme scheme) {
    final value = trailingValue;
    final chevron = showChevron
        ? Icon(
            LucideIcons.chevronRight,
            size: HappyIconSize.md,
            color: scheme.onSurfaceVariant,
          )
        : null;
    if (value == null) return chevron;

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: HappySpacing.s4,
      children: <Widget>[
        Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
        ?chevron,
      ],
    );
  }
}
