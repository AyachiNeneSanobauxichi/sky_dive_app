import "package:flutter/material.dart";
import "package:happy_os/core/theme/index.dart";

/// 经历输入区：用户写下一段真实经历，等着被改写成故事。
///
/// 用大字号 + 多行 + 无边框的"稿纸"观感，而不是常规表单输入框——这是产品的
/// 核心输入，越像"写日记"越好，越像"填表"越糟。
class ExperienceComposer extends StatelessWidget {
  const ExperienceComposer({
    super.key,
    required this.controller,
    required this.hint,
    this.enabled = true,
  });

  final TextEditingController controller;
  final String hint;
  final bool enabled;

  /// 最少行数。先占住高度，避免输入时输入框不断长高导致布局跳动。
  static const int _minLines = 6;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(HappySemanticSpacing.cardPadding),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(HappyRadius.card),
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
          width: HappyBorderWidth.hairline,
        ),
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        minLines: _minLines,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        style: theme.textTheme.bodyLarge,
        decoration: InputDecoration(
          // 去掉主题里的填充与描边：外层 Container 已经承担了容器角色，
          // 再套一层框会显得局促
          filled: false,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          hintText: hint,
          hintStyle: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
