import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:happy_os/core/theme/index.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 标签编辑器：已有标签的 chip 列表 + 一个"打字回车即添加"的输入框。
///
/// 爱好和个性标签都是**开放集合**（后端收的是任意字符串数组），所以不能用固定选项，
/// 只能让用户自己写。做成 chip 而不是"用逗号分隔的一行文本"：
/// 逗号分隔看着省事，但用户永远不确定该用中文逗号还是英文逗号，
/// 而删掉中间某一个要在一长串文本里做手术。
class UserTagEditor extends StatefulWidget {
  const UserTagEditor({
    super.key,
    required this.tags,
    required this.onChanged,
    required this.hint,
    required this.removeLabel,
    this.enabled = true,
  });

  final List<String> tags;
  final ValueChanged<List<String>> onChanged;

  final String hint;

  /// 删除按钮的无障碍标签模板（接收标签文本）。
  final String Function(String tag) removeLabel;

  final bool enabled;

  @override
  State<UserTagEditor> createState() => _UserTagEditorState();
}

class _UserTagEditorState extends State<UserTagEditor> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _add(String raw) {
    final value = raw.trim();
    // 空的不加、重复的不加。重复标签对 AI 没有增量信息，只会占满一屏。
    if (value.isEmpty || widget.tags.contains(value)) {
      _controller.clear();
      return;
    }
    HapticFeedback.selectionClick();
    widget.onChanged(<String>[...widget.tags, value]);
    _controller.clear();
  }

  void _remove(String tag) {
    HapticFeedback.selectionClick();
    widget.onChanged(widget.tags.where((t) => t != tag).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: HappySemanticSpacing.labelGap,
      children: <Widget>[
        if (widget.tags.isNotEmpty)
          Wrap(
            spacing: HappySpacing.s8,
            runSpacing: HappySpacing.s8,
            children: <Widget>[
              for (final tag in widget.tags)
                _TagChip(
                  label: tag,
                  removeLabel: widget.removeLabel(tag),
                  onRemove: widget.enabled ? () => _remove(tag) : null,
                ),
            ],
          ),
        TextField(
          controller: _controller,
          enabled: widget.enabled,
          textInputAction: TextInputAction.done,
          maxLength: _maxTagLength,
          // 回车即添加，并且**不收键盘**：加标签往往是连着加好几个，
          // 每加一个就要重新点开键盘会让人放弃。
          onSubmitted: _add,
          decoration: InputDecoration(
            hintText: widget.hint,
            counterText: "",
            suffixIcon: IconButton(
              icon: const Icon(LucideIcons.plus, size: HappyIconSize.md),
              // 空文本时禁用：点了没反应比灰着更让人困惑。
              onPressed: widget.enabled && _controller.text.trim().isNotEmpty
                  ? () => _add(_controller.text)
                  : null,
            ),
          ),
          // 按钮的可用性跟着文本走。
          onChanged: (_) => setState(() {}),
        ),
      ],
    );
  }
}

/// 一个标签。删除键是 chip 自带的 `onDeleted`，热区由 Material 保证。
class _TagChip extends StatelessWidget {
  const _TagChip({
    required this.label,
    required this.removeLabel,
    required this.onRemove,
  });

  final String label;
  final String removeLabel;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Chip(
      label: Text(label, style: theme.textTheme.bodyMedium),
      deleteIcon: const Icon(LucideIcons.x, size: HappyIconSize.xs),
      onDeleted: onRemove,
      deleteButtonTooltipMessage: removeLabel,
      backgroundColor: scheme.surfaceContainerHighest,
      side: BorderSide(
        color: scheme.outlineVariant,
        width: HappyBorderWidth.hairline,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(HappyRadius.chip),
      ),
    );
  }
}

/// 单个标签的字数上限。标签就是一两个词，给长了会把 chip 撑成一整行。
const int _maxTagLength = 12;
