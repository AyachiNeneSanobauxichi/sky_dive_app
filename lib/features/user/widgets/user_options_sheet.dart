import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:happy_os/core/theme/index.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 单选面板：标题 + 一列选项，选中的那项打勾。
///
/// 语言、深浅色这类设置用**底部面板**而不是跳一个二级页：选项就两三个，
/// 为它推一整屏再退回来，用户会觉得改个语言像办手续。选完立刻生效并关闭，
/// 不需要"确定"按钮——单选没有中间态可确认。
class UserOptionsSheet<T> extends StatelessWidget {
  const UserOptionsSheet({
    super.key,
    required this.title,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final String title;

  /// 选项列表，顺序即展示顺序。
  final List<UserOption<T>> options;

  final T selected;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: HappySemanticSpacing.cardPadding,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(
                HappySemanticSpacing.screenPadding,
                0,
                HappySemanticSpacing.screenPadding,
                HappySemanticSpacing.labelGap,
              ),
              child: Text(title, style: theme.textTheme.titleMedium),
            ),
            for (final option in options)
              ListTile(
                title: Text(option.label),
                subtitle: option.description == null
                    ? null
                    : Text(option.description!),
                trailing: option.value == selected
                    ? Icon(
                        LucideIcons.check,
                        size: HappyIconSize.md,
                        color: scheme.primary,
                      )
                    : null,
                onTap: () {
                  // 已经选中的那项也允许点：关掉面板是用户此刻唯一的意图，
                  // 点了没反应会让人以为面板卡住了。
                  if (option.value != selected) {
                    HapticFeedback.selectionClick();
                    onSelected(option.value);
                  }
                  Navigator.of(context).pop();
                },
              ),
          ],
        ),
      ),
    );
  }
}

/// 一个选项。[description] 用来解释那些光看标题说不清的选项（如"跟随系统"）。
@immutable
class UserOption<T> {
  const UserOption({
    required this.value,
    required this.label,
    this.description,
  });

  final T value;
  final String label;
  final String? description;
}
