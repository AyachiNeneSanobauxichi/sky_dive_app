import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:happy_os/core/theme/index.dart";
import "package:happy_os/features/story_generate/domain/index.dart";
import "package:happy_os/shared/widgets/index.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 澄清卡：AI 在动笔前的一次反问。
///
/// 四种形态（单选 / 多选 / 混合 / 纯文本）共用一张卡，差别只在选项能不能多选、
/// 要不要露文本框——分成四个组件会让"提交按钮怎么算可用"这条规则复制四份。
/// 可用性判断本身收在 [ClarificationCard.canSubmit]，UI 只负责问它。
///
/// 已作答的卡收起成一行摘要（[answer] 非空）：时间线要能回看"我当时选了什么"，
/// 但不该让人以为还能改——这一轮已经发出去了。
class ClarificationCardView extends StatefulWidget {
  const ClarificationCardView({
    super.key,
    required this.card,
    required this.answer,
    required this.enabled,
    required this.onSubmit,
    required this.submitLabel,
    required this.answeredLabel,
    required this.customHint,
  });

  final ClarificationCard card;

  /// 已提交的回答。非空即收起为摘要。
  final String? answer;

  /// 是否允许交互。上一轮还在跑时置 false，避免重复提交。
  final bool enabled;

  final ValueChanged<String> onSubmit;

  final String submitLabel;

  /// 已作答摘要的模板（接收回答文本）。
  final String Function(String answer) answeredLabel;

  /// 自定义文本框的兜底 placeholder（卡片自带 `input_placeholder` 时优先用它的）。
  final String customHint;

  @override
  State<ClarificationCardView> createState() => _ClarificationCardViewState();
}

class _ClarificationCardViewState extends State<ClarificationCardView> {
  final Set<String> _selected = <String>{};
  final TextEditingController _customController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 提交按钮的可用性跟着文本走（允许自定义时，只写文本也能提交）。
    _customController.addListener(_onTextChanged);
  }

  void _onTextChanged() => setState(() {});

  @override
  void dispose() {
    _customController.removeListener(_onTextChanged);
    _customController.dispose();
    super.dispose();
  }

  void _toggle(ClarificationOption option) {
    HapticFeedback.selectionClick();
    setState(() {
      if (!widget.card.isMultiSelect) {
        // 单选：直接替换。再点一次同一项不取消——澄清必须有答案，
        // 允许取消只会让用户卡在"一个都没选"。
        _selected
          ..clear()
          ..add(option.value);
        return;
      }
      if (_selected.contains(option.value)) {
        _selected.remove(option.value);
        return;
      }
      // 多选到上限后不再接受新选择（静默忽略，选项本身会变成禁用长相）。
      final max = widget.card.maxSelections;
      if (max != null && _selected.length >= max) return;
      _selected.add(option.value);
    });
  }

  bool get _canSubmit =>
      widget.enabled &&
      widget.card.canSubmit(
        selectedValues: _selected,
        customText: _customController.text,
      );

  void _submit() {
    if (!_canSubmit) return;
    FocusScope.of(context).unfocus();
    widget.onSubmit(
      widget.card.buildAnswer(
        selectedValues: _selected,
        customText: _customController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final answer = widget.answer;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(HappySemanticSpacing.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: HappySemanticSpacing.itemGap,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: HappySemanticSpacing.labelGap,
              children: <Widget>[
                Icon(
                  LucideIcons.messageCircleQuestion,
                  size: HappyIconSize.md,
                  color: scheme.primary,
                ),
                Expanded(
                  child: Text(
                    widget.card.question,
                    style: theme.textTheme.titleSmall,
                  ),
                ),
              ],
            ),
            if (widget.card.description case final String desc
                when desc.isNotEmpty)
              Text(
                desc,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),

            // 已作答：收起成一行摘要，不再显示可交互控件。
            if (answer != null)
              _AnsweredSummary(text: widget.answeredLabel(answer))
            else ...<Widget>[
              for (final option in widget.card.options)
                _OptionTile(
                  option: option,
                  selected: _selected.contains(option.value),
                  enabled: widget.enabled,
                  onTap: () => _toggle(option),
                ),
              if (widget.card.acceptsCustomText)
                TextField(
                  controller: _customController,
                  enabled: widget.enabled,
                  minLines: _customMinLines,
                  maxLines: _customMaxLines,
                  maxLength: _customMaxLength,
                  decoration: InputDecoration(
                    hintText: widget.card.inputPlaceholder ?? widget.customHint,
                    counterText: "",
                  ),
                ),
              HappyButton(
                label: widget.submitLabel,
                icon: LucideIcons.cornerDownLeft,
                size: HappyButtonSize.small,
                onPressed: _canSubmit ? _submit : null,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 一个选项。选中用品牌色描边 + 对勾，而不是只换底色——深色画布上纯底色变化
/// 对比度不够，扫一眼分不清选没选。
class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.option,
    required this.selected,
    required this.enabled,
    required this.onTap,
  });

  final ClarificationOption option;
  final bool selected;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Semantics(
      button: true,
      selected: selected,
      enabled: enabled,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(HappyRadius.md),
        child: AnimatedContainer(
          duration: HappyMotion.fast,
          curve: HappyMotion.standard,
          constraints: const BoxConstraints(
            minHeight: HappyControlSize.minTapTarget,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: HappySpacing.s12,
            vertical: HappySpacing.s8,
          ),
          decoration: BoxDecoration(
            color: selected
                ? scheme.primary.withValues(alpha: _selectedFillAlpha)
                : scheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(HappyRadius.md),
            border: Border.all(
              color: selected ? scheme.primary : scheme.outlineVariant,
              width: selected
                  ? HappyBorderWidth.thick
                  : HappyBorderWidth.hairline,
            ),
          ),
          child: Row(
            spacing: HappySemanticSpacing.labelGap,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(option.label, style: theme.textTheme.bodyMedium),
                    if (option.description case final String desc
                        when desc.isNotEmpty)
                      Text(
                        desc,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
              if (selected)
                Icon(
                  LucideIcons.check,
                  size: HappyIconSize.sm,
                  color: scheme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 已作答摘要。
class _AnsweredSummary extends StatelessWidget {
  const _AnsweredSummary({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: HappySemanticSpacing.labelGap,
      children: <Widget>[
        Icon(
          LucideIcons.circleCheck,
          size: HappyIconSize.sm,
          color: scheme.primary,
        ),
        Expanded(
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}

/// 选中态底色透明度。只做浅浅一层，主要靠描边表达选中。
const double _selectedFillAlpha = 0.12;

/// 自定义文本框行数与上限。澄清回答就是一两句话，不需要更大。
const int _customMinLines = 1;
const int _customMaxLines = 3;
const int _customMaxLength = 200;
