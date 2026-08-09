import "package:flutter/material.dart";
import "package:happy_os/core/theme/index.dart";
import "package:happy_os/shared/widgets/index.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 心愿输入区：没带心愿进页面时（语音入口）在这里补一句再开始。
///
/// 和故事页的 `StoryComposer` 不是一回事——那个是"创作入口"（语音圆钮为主角），
/// 这里只是"把话补上"，所以只留文本输入，不重复一颗大圆钮。
class WishComposer extends StatefulWidget {
  const WishComposer({
    super.key,
    required this.hint,
    required this.submitLabel,
    required this.enabled,
    required this.onSubmit,
    this.initialText,
  });

  final String hint;
  final String submitLabel;

  /// 生成进行中时置 false，防重复提交。
  final bool enabled;

  final ValueChanged<String> onSubmit;

  /// 预填文本（例如从故事页带来的草稿）。
  final String? initialText;

  @override
  State<WishComposer> createState() => _WishComposerState();
}

class _WishComposerState extends State<WishComposer> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialText,
  );

  @override
  void initState() {
    super.initState();
    // 提交按钮的可用性跟着文本走：空文本时禁用，而不是点了没反应。
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() => setState(() {});

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  bool get _canSubmit => widget.enabled && _controller.text.trim().isNotEmpty;

  void _submit() {
    if (!_canSubmit) return;
    FocusScope.of(context).unfocus();
    widget.onSubmit(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: HappySemanticSpacing.itemGap,
      children: <Widget>[
        TextField(
          controller: _controller,
          enabled: widget.enabled,
          minLines: _minLines,
          maxLines: _maxLines,
          maxLength: _maxLength,
          keyboardType: TextInputType.multiline,
          // 多行输入用 newline：提交靠下面的按钮，回车该换行。
          textInputAction: TextInputAction.newline,
          // 聚焦时把输入框**和下面的按钮**一起顶到键盘上方，
          // 只留默认的 20 会把主行动压在键盘底下。
          scrollPadding: const EdgeInsets.only(bottom: _scrollPadding),
          decoration: InputDecoration(hintText: widget.hint, counterText: ""),
        ),
        HappyButton(
          label: widget.submitLabel,
          icon: LucideIcons.sparkles,
          onPressed: _canSubmit ? _submit : null,
        ),
      ],
    );
  }
}

const int _minLines = 3;
const int _maxLines = 6;
const int _maxLength = 500;

/// 聚焦时额外滚出来的底部空间，保证「开始生成」按钮不被键盘盖住。
const double _scrollPadding = HappySpacing.s96;
