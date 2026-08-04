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
    this.isDestructive = false,
    this.showChevron = true,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  /// 右侧的状态提示（如"开发中"），有值时不显示箭头。
  final String? trailingHint;

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
          : (showChevron
                ? Icon(
                    LucideIcons.chevronRight,
                    size: HappyIconSize.md,
                    color: scheme.onSurfaceVariant,
                  )
                : null),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(HappyRadius.md),
      ),
    );
  }
}
