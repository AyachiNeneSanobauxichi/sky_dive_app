import "package:flutter/material.dart";
import "package:happy_os/core/theme/index.dart";
import "package:happy_os/features/story_generate/controllers/index.dart";
import "package:happy_os/features/story_generate/domain/index.dart";
import "package:happy_os/shared/widgets/index.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 大纲卡：正文开写前的最后一个决策点。
///
/// 两个动作**不等价**，所以视觉权重也不等：「确认大纲」是主行动（渐变实心），
/// 「修改大纲」是次要行动，且**必须先写意见**才可点——不写意见就让 AI 改，它只能
/// 瞎猜，改出来还是不对。空意见时按钮禁用，而不是点了弹一句"请填写"。
///
/// 已决定的卡收起成一行结论（[resolution] 非空），保留在时间线里可回看。
class OutlineCardView extends StatefulWidget {
  const OutlineCardView({
    super.key,
    required this.outline,
    required this.resolution,
    required this.feedback,
    required this.enabled,
    required this.onConfirm,
    required this.onModify,
    required this.title,
    required this.endingLabel,
    required this.emptyLabel,
    required this.confirmLabel,
    required this.modifyLabel,
    required this.feedbackHint,
    required this.confirmedLabel,
    required this.modifiedLabel,
  });

  final StoryOutline outline;

  /// 已作出的处置。非空即收起为结论行。
  final OutlineResolution? resolution;

  /// 已提交的修改意见。
  final String? feedback;

  /// 是否允许交互。上一轮还在跑时置 false。
  final bool enabled;

  final VoidCallback onConfirm;
  final ValueChanged<String> onModify;

  final String title;
  final String endingLabel;

  /// 大纲为空壳时的说明文案。
  final String emptyLabel;

  final String confirmLabel;
  final String modifyLabel;
  final String feedbackHint;
  final String confirmedLabel;

  /// 已提交修改意见的摘要模板（接收意见文本）。
  final String Function(String feedback) modifiedLabel;

  @override
  State<OutlineCardView> createState() => _OutlineCardViewState();
}

class _OutlineCardViewState extends State<OutlineCardView> {
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 「修改大纲」的可用性跟着意见文本走。
    _feedbackController.addListener(_onTextChanged);
  }

  void _onTextChanged() => setState(() {});

  @override
  void dispose() {
    _feedbackController.removeListener(_onTextChanged);
    _feedbackController.dispose();
    super.dispose();
  }

  bool get _canModify =>
      widget.enabled && _feedbackController.text.trim().isNotEmpty;

  void _confirm() {
    FocusScope.of(context).unfocus();
    widget.onConfirm();
  }

  void _modify() {
    if (!_canModify) return;
    FocusScope.of(context).unfocus();
    widget.onModify(_feedbackController.text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final outline = widget.outline;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(HappySemanticSpacing.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: HappySemanticSpacing.itemGap,
          children: <Widget>[
            Row(
              spacing: HappySemanticSpacing.labelGap,
              children: <Widget>[
                Icon(
                  LucideIcons.listTree,
                  size: HappyIconSize.md,
                  color: scheme.tertiary,
                ),
                Text(widget.title, style: theme.textTheme.titleSmall),
              ],
            ),

            if (outline.isEmpty)
              Text(
                widget.emptyLabel,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              )
            else ...<Widget>[
              if (outline.title case final String value when value.isNotEmpty)
                Text(value, style: theme.textTheme.titleMedium),
              if (outline.logline case final String value when value.isNotEmpty)
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              for (final (index, beat) in outline.beats.indexed)
                _BeatRow(beat: beat, fallbackOrder: index + 1),
              if (outline.ending case final String value when value.isNotEmpty)
                _EndingRow(label: widget.endingLabel, text: value),
            ],

            // 已决定：收起成一行结论。
            if (widget.resolution case final OutlineResolution resolution)
              _ResolutionSummary(
                text: switch (resolution) {
                  OutlineResolution.confirmed => widget.confirmedLabel,
                  OutlineResolution.modified => widget.modifiedLabel(
                    widget.feedback ?? "",
                  ),
                },
              )
            else ...<Widget>[
              TextField(
                controller: _feedbackController,
                enabled: widget.enabled,
                minLines: _feedbackMinLines,
                maxLines: _feedbackMaxLines,
                maxLength: _feedbackMaxLength,
                decoration: InputDecoration(
                  hintText: widget.feedbackHint,
                  counterText: "",
                ),
              ),
              Row(
                spacing: HappySemanticSpacing.labelGap,
                children: <Widget>[
                  Expanded(
                    child: HappyButton(
                      label: widget.modifyLabel,
                      icon: LucideIcons.pencilLine,
                      variant: HappyButtonVariant.secondary,
                      size: HappyButtonSize.small,
                      onPressed: _canModify ? _modify : null,
                    ),
                  ),
                  Expanded(
                    child: HappyButton(
                      label: widget.confirmLabel,
                      icon: LucideIcons.sparkles,
                      size: HappyButtonSize.small,
                      onPressed: widget.enabled ? _confirm : null,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 一个节拍：序号胶囊 + 标题 + 摘要。
class _BeatRow extends StatelessWidget {
  const _BeatRow({required this.beat, required this.fallbackOrder});

  final OutlineBeat beat;

  /// 上游没给 order 时用列表下标兜底。
  final int fallbackOrder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: HappySemanticSpacing.labelGap,
      children: <Widget>[
        Container(
          width: HappyIconSize.lg,
          height: HappyIconSize.lg,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: scheme.primary.withValues(alpha: _orderFillAlpha),
          ),
          child: Text(
            "${beat.order ?? fallbackOrder}",
            style: theme.textTheme.labelSmall?.copyWith(color: scheme.primary),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (beat.title case final String value when value.isNotEmpty)
                Text(value, style: theme.textTheme.bodyMedium),
              if (beat.summary case final String value when value.isNotEmpty)
                Text(
                  value,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 结局行。用一个标签把它和普通节拍区分开——它是终点，不是第 N 幕。
class _EndingRow extends StatelessWidget {
  const _EndingRow({required this.label, required this.text});

  final String label;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: HappySemanticSpacing.labelGap,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: HappySpacing.s8,
            vertical: HappySpacing.s2,
          ),
          decoration: BoxDecoration(
            color: scheme.tertiary.withValues(alpha: _orderFillAlpha),
            borderRadius: BorderRadius.circular(HappyRadius.chip),
          ),
          child: Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(color: scheme.tertiary),
          ),
        ),
        Expanded(child: Text(text, style: theme.textTheme.bodySmall)),
      ],
    );
  }
}

/// 已决定的结论行。
class _ResolutionSummary extends StatelessWidget {
  const _ResolutionSummary({required this.text});

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

/// 序号胶囊 / 结局标签的底色透明度。
const double _orderFillAlpha = 0.16;

/// 修改意见输入框的行数与上限。
const int _feedbackMinLines = 1;
const int _feedbackMaxLines = 3;
const int _feedbackMaxLength = 200;
