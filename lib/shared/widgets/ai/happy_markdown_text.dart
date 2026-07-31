import "package:flutter/material.dart";
import "package:gpt_markdown/gpt_markdown.dart";
import "package:happy_os/core/theme/index.dart";

/// Markdown 文本：渲染模型输出里的加粗、列表、引用、代码块等结构。
///
/// 基于 `gpt_markdown`（专为 LLM 输出设计，能容忍**未闭合的语法**——流式生成中
/// 半个 `**` 或半张表格是常态，普通 markdown 解析器会直接抛或渲染成乱码）。
///
/// ## 什么时候用它，什么时候用 HappyStreamingText
/// - 故事正文是**散文**，没有 markdown 结构 → 用 `HappyStreamingText`（带光标，更快）。
/// - 模型返回带结构的内容（分析、要点、对话脚本）→ 用本组件。
/// - 两者不要嵌套；生成中的 markdown 建议不显示光标（`WidgetSpan` 无法插入
///   markdown 树尾部），改用外部的 [HappyThinkingIndicator] 表达"仍在生成"。
class HappyMarkdownText extends StatelessWidget {
  const HappyMarkdownText({super.key, required this.data, this.style});

  /// 原始 markdown 文本。流式场景直接喂累积到目前为止的全文。
  final String data;

  /// 正文样式。默认 `bodyLarge`（行高 1.65）。
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GptMarkdown(
      data,
      style: style ?? theme.textTheme.bodyLarge,
      // 代码块统一走令牌，不让库自带的默认色跳出设计系统
      codeBuilder: (context, name, code, closed) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(HappySemanticSpacing.cardPadding),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(HappyRadius.sm),
          border: Border.all(
            color: theme.colorScheme.outlineVariant,
            width: HappyBorderWidth.hairline,
          ),
        ),
        child: Text(
          code,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface,
            fontFamily: "monospace",
          ),
        ),
      ),
    );
  }
}
