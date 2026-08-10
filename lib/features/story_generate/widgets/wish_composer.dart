import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:happy_os/core/providers/index.dart";
import "package:happy_os/core/speech/index.dart";
import "package:happy_os/core/theme/index.dart";
import "package:happy_os/shared/widgets/index.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 心愿输入区：没带心愿进页面时（语音入口）在这里补一句再开始。
///
/// 和故事页的 `StoryComposer` 不是一回事——那个是"创作入口"（语音圆钮为主角），
/// 这里只是"把话补上"，所以不重复一颗大圆钮。
///
/// ## 语音在这里是**点按**，不是按住
/// 故事页那颗大圆钮用按住，是因为它是主路径上最重的一个动作，按住能把"我要说了"
/// 这件事表达得很重。而这一页是补一句话的场景：用户多半已经在想措辞，让他一直按着
/// 屏幕说话既累也挡视线。点一下开始、再点一下结束，手可以放下。
///
/// 识别结果和故事页一样**实时写进输入框**：边说边看见字长出来，说完直接能改、能提交。
class WishComposer extends ConsumerStatefulWidget {
  const WishComposer({
    super.key,
    required this.hint,
    required this.submitLabel,
    required this.enabled,
    required this.onSubmit,
    required this.localeId,
    required this.listeningLabel,
    required this.voiceStartLabel,
    required this.voiceStopLabel,
    required this.onSpeechUnavailable,
    required this.onSpeechEmpty,
    this.initialText,
  });

  final String hint;
  final String submitLabel;

  /// 生成进行中时置 false，防重复提交。
  final bool enabled;

  final ValueChanged<String> onSubmit;

  /// 预填文本（例如从故事页带来的草稿）。
  final String? initialText;

  /// 识别用的 locale（如 `zh_CN`）。
  final String localeId;

  /// 正在听时的状态文案。
  final String listeningLabel;

  /// 语音按钮的无障碍标签（开始 / 结束）。图标按钮没有可见文字，说明性全靠它。
  final String voiceStartLabel;
  final String voiceStopLabel;

  /// 语音用不了。原因原样交出去：没权限要引导去设置，设备不支持只能劝手打。
  final ValueChanged<SpeechAvailability> onSpeechUnavailable;

  /// 说完了但一个字都没识别到。
  final VoidCallback onSpeechEmpty;

  @override
  ConsumerState<WishComposer> createState() => _WishComposerState();
}

class _WishComposerState extends ConsumerState<WishComposer> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialText,
  );

  bool _isListening = false;

  /// 这次开口之前输入框里的内容。识别结果接在它后面，出错或取消时退回到它。
  String _baseText = "";

  /// 语音识别门面。**开场就取好**而不是每次现读：`dispose` 里也要用它放麦克风，
  /// 而那时 `ref` 已经不保证还能读（Riverpod 会在 State 销毁前后拆容器）。
  late final SpeechRecognizer _recognizer = ref.read(speechRecognizerProvider);

  @override
  void initState() {
    super.initState();
    // 提交按钮的可用性跟着文本走：空文本时禁用，而不是点了没反应。
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() => setState(() {});

  @override
  void dispose() {
    // 页面走了麦克风不能还开着。
    _recognizer.cancel();
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

  Future<void> _toggleListening() async {
    HapticFeedback.selectionClick();
    if (_isListening) {
      await _stopListening();
      return;
    }
    await _startListening();
  }

  Future<void> _startListening() async {
    // 说话时键盘没有用，还挡着下面的按钮。
    FocusScope.of(context).unfocus();
    _baseText = _controller.text;

    final availability = await _recognizer.start(
      preferredLocaleId: widget.localeId,
      onTranscript: _onTranscript,
      // 平台自己停了（说到上限 / 静音过久）：把界面退出进行态，
      // 否则按钮会一直是"结束"的样子，点了却什么都不发生。
      onDone: () {
        if (mounted && _isListening) setState(() => _isListening = false);
      },
    );
    if (!mounted) return;

    if (availability != SpeechAvailability.ready) {
      widget.onSpeechUnavailable(availability);
      return;
    }
    setState(() => _isListening = true);
  }

  Future<void> _stopListening() async {
    await _recognizer.stop();
    if (!mounted) return;
    setState(() => _isListening = false);

    // 等一拍再判空：最后一两个字常常跟在 stop 之后才作为最终结果推上来。
    await Future<void>.delayed(HappyMotion.normal);
    if (!mounted) return;
    if (_controller.text.trim() == _baseText.trim()) widget.onSpeechEmpty();
  }

  /// 识别推送给的是"当前这句的最新全文"，所以整段覆盖而不是追加。
  void _onTranscript(SpeechTranscript transcript) {
    if (!mounted) return;
    final merged = _baseText + transcript.text;
    // 程序化赋值绕开了 TextField 的 maxLength（那个只拦用户输入），得自己截断。
    final text = merged.characters.length > _maxLength
        ? merged.characters.take(_maxLength).toString()
        : merged;
    _controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
        // 进行态文案只在听的时候占位。用 AnimatedSize 收放高度，
        // 直接插一行会把下面的按钮顶一下——正说话时界面跳动最让人分心。
        AnimatedSize(
          duration: HappyMotion.fast,
          curve: HappyMotion.standard,
          alignment: Alignment.topLeft,
          child: _isListening
              ? Text(
                  widget.listeningLabel,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                )
              : const SizedBox(width: double.infinity),
        ),
        Row(
          spacing: HappySemanticSpacing.labelGap,
          children: <Widget>[
            _VoiceButton(
              isListening: _isListening,
              // 生成进行中时锁住：这一页此刻不该再产生新的输入。
              onPressed: widget.enabled ? _toggleListening : null,
              label: _isListening
                  ? widget.voiceStopLabel
                  : widget.voiceStartLabel,
            ),
            Expanded(
              child: HappyButton(
                label: widget.submitLabel,
                icon: LucideIcons.sparkles,
                onPressed: _canSubmit ? _submit : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// 语音开关按钮。听的时候换成方块（停止的通用符号）并罩一圈呼吸光环——
/// 麦克风图标本身不区分"能说"和"正在说"，只靠颜色变化在深色画布上不够醒目。
class _VoiceButton extends StatelessWidget {
  const _VoiceButton({
    required this.isListening,
    required this.onPressed,
    required this.label,
  });

  final bool isListening;
  final VoidCallback? onPressed;
  final String label;

  /// 44：最小可点热区，不能再小。
  static const double _size = HappyControlSize.minTapTarget;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final enabled = onPressed != null;

    final button = Semantics(
      button: true,
      enabled: enabled,
      label: label,
      child: Tooltip(
        message: label,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: AnimatedContainer(
            duration: HappyMotion.fast,
            curve: HappyMotion.standard,
            width: _size,
            height: _size,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isListening
                  ? scheme.primary.withValues(alpha: _listeningFillAlpha)
                  : scheme.surfaceContainerHighest,
              border: Border.all(
                color: isListening ? scheme.primary : scheme.outlineVariant,
                width: isListening
                    ? HappyBorderWidth.thick
                    : HappyBorderWidth.hairline,
              ),
            ),
            child: Icon(
              isListening ? LucideIcons.square : LucideIcons.mic,
              size: HappyIconSize.md,
              color: enabled ? scheme.primary : scheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );

    // 只有"正在听"才播呼吸：常态就该安静。系统开了减弱动效时也不播——
    // 此时进行态由上面那行文案负责，信息不会丢。
    if (!isListening || MediaQuery.disableAnimationsOf(context)) return button;

    return button
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .scaleXY(
          end: _breathScale,
          duration: HappyMotion.slow,
          curve: HappyMotion.ambientCurve,
        );
  }
}

const int _minLines = 3;
const int _maxLines = 6;
const int _maxLength = 500;

/// 聚焦时额外滚出来的底部空间，保证「开始生成」按钮不被键盘盖住。
const double _scrollPadding = HappySpacing.s96;

/// 正在听时按钮底色的透明度。浅浅一层，主要靠描边和图标表达状态。
const double _listeningFillAlpha = 0.16;

/// 呼吸动效的放大比例。只做很小一档——这是氛围，不是要抢注意力。
const double _breathScale = 1.06;
