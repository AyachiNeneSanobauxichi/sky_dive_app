import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:sky_dive/core/theme/index.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 设置分组里的一行。
///
/// 两种用法由 [isSelected] 区分：
/// - 传 `null`：普通跳转行，右侧是箭头（条款、隐私政策…）；带 [value] 时
///   箭头前还会显示当前值（"外观 · 跟随系统"），点进去才是二级选择菜单。
/// - 传 `true` / `false`：单选行，右侧是对勾。
///
/// 单选行**选中时仍可点**：点已选中项什么都不会变，但把它禁用掉会让人以为
/// "这一项坏了"。这里的做法是照常响应、不给触感（没发生变化就不该有反馈）。
class AccountOptionTile extends StatelessWidget {
  const AccountOptionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.description,
    this.value,
    this.isSelected,
    this.isDestructive = false,
  });

  final IconData icon;
  final String label;

  /// 副标题。用于解释这一项意味着什么（如"跟随手机的昼夜设置"）。
  final String? description;

  /// 行尾的当前值（跳转行专用）。收进二级菜单的设置项**必须**把当前值留在
  /// 一级页面上，否则用户得点进去才知道自己现在选的是什么。
  final String? value;

  final VoidCallback onTap;

  /// null = 跳转行；非 null = 单选行。
  final bool? isSelected;

  /// 破坏性行为（退出登录）用错误色。
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selected = isSelected;
    final foreground = isDestructive
        ? theme.colorScheme.error
        : selected == true
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurface;

    return InkWell(
      onTap: () {
        // 已经是选中项就不震：没有发生变化，给触感反而像"又切了一次"。
        if (selected != true) HapticFeedback.selectionClick();
        onTap();
      },
      child: ConstrainedBox(
        // 行高不写死：尊重系统字体缩放，长文案要能把这一行撑高。
        constraints: const BoxConstraints(minHeight: SkyControlSize.input),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: SkySemanticSpacing.cardPadding,
            vertical: SkySpacing.s12,
          ),
          child: Row(
            children: <Widget>[
              Icon(icon, size: SkyIconSize.md, color: foreground),
              const SizedBox(width: SkySemanticSpacing.itemGap),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      label,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: foreground,
                      ),
                    ),
                    if (description != null) ...<Widget>[
                      const SizedBox(height: SkySpacing.s2),
                      Text(
                        description!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: SkySemanticSpacing.itemGap),
              if (value != null)
                Padding(
                  padding: const EdgeInsets.only(right: SkySpacing.s6),
                  child: Text(
                    value!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              _Trailing(isSelected: selected, isDestructive: isDestructive),
            ],
          ),
        ),
      ),
    );
  }
}

class _Trailing extends StatelessWidget {
  const _Trailing({required this.isSelected, required this.isDestructive});

  final bool? isSelected;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 破坏性行为不给尾部图标：一个箭头会暗示"点进去还有一页"，
    // 而退出登录是**就地发生**的事。
    if (isDestructive) return const SizedBox.shrink();

    if (isSelected == null) {
      return Icon(
        LucideIcons.chevronRight,
        size: SkyIconSize.md,
        color: theme.colorScheme.onSurfaceVariant,
      );
    }

    // 对勾用淡入淡出而不是直接显隐：切换选项时两个对勾一进一出，
    // 硬切会让人看不清"选中的跳过去了"。
    return AnimatedOpacity(
      opacity: isSelected! ? 1 : 0,
      duration: SkyMotion.fast,
      curve: SkyMotion.standard,
      child: Icon(
        LucideIcons.check,
        size: SkyIconSize.md,
        color: theme.colorScheme.primary,
      ),
    );
  }
}
