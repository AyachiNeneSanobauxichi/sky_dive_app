import "dart:math" as math;

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:happy_os/core/providers/index.dart";
import "package:happy_os/core/speech/index.dart";
import "package:happy_os/core/theme/index.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 创作入口区（v2）：**居中突出**的语音圆钮 + 可输入的文本框 + 生成按钮。
///
/// 这是产品主路径的第一个动作，所以做成一屏里最显眼的东西：一颗会发光的大圆居中，
/// 下面才是文本框。两条路径并列——想说话的按住圆钮，想打字的直接在下面写。
///
/// ## 语音：按住说话，边说边出字，上滑取消
/// 录音的心智就是按住不放：先给 [holdHint]（按住说给 AI 听），按下去换成
/// [listeningHint]（在听，说吧…）+ 圆钮放大、光晕跟着音量涨落、跟手上移。
/// 短按不开始识别，改成把手势教给用户（[onVoiceTapped]，调用方给轻提示）——
/// 否则用户点一下就开了麦克风，"按住"这个心智永远建立不起来。
///
/// **识别结果实时写进输入框**，而不是松手后一次性塞进来：
/// ① 边说边看见字长出来，本身就是"它听见了"的证据，比任何进行态动画都可信；
/// ② 识别难免出错，落在可编辑的输入框里用户能立刻改，再点生成；
/// ③ 中途取消只要把文本退回 [_baseText] 即可，不需要处理"最终结果迟到"的时序。
///
/// **上滑取消是真的能取消**：上滑越过阈值后圆钮变成错误色的叉、文案变「松开取消」，
/// 松手时丢弃这次识别、输入框退回说话前的内容。阈值按**圆钮自身尺寸**算而不是写死
/// 一个数（见 [_cancelThreshold]）：不同手型下"手指已经离开这颗圆"才是用户真实的
/// 心理判断。越过/退回阈值各给一次轻触感——手指此时盖着圆钮，很可能看不见界面。
///
/// ## 文本：就地输入，点按钮带着草稿进生成页
/// 输入框是真的 `TextField`（不是"点开跳页"的假输入框），用户想到什么可以立刻写。
/// 点「生成」时把文本**带进生成页**（走路由 query，刷新/深链接也能恢复），
/// 生成从这段文字开始，同时**清空本页输入框**——草稿已经交出去了，留在这里只会让
/// 用户下次写新的之前先手动删一遍（见 [_onSubmit]）。空文本时按钮禁用而不是点了没反应。
class StoryComposer extends ConsumerStatefulWidget {
  const StoryComposer({
    super.key,
    required this.hint,
    required this.holdHint,
    required this.releaseHint,
    required this.listeningHint,
    required this.cancelHint,
    required this.cancelReleaseHint,
    required this.submitLabel,
    required this.submitHint,
    required this.remainingLabel,
    required this.localeId,
    required this.onFocusChanged,
    required this.onSubmit,
    required this.onSpeechUnavailable,
    required this.onSpeechEmpty,
    required this.onVoiceTapped,
  });

  /// 文本框里的提示文案。
  final String hint;

  /// 语音圆钮下方的常态提示（按住说给 AI 听）。
  final String holdHint;

  /// 按住、但识别还没起来时的提示（松开结束）。这段窗口很短（初始化 + 权限），
  /// 但不能没有文案——按下去毫无变化的那一瞬间最容易让人以为没响应。
  final String releaseHint;

  /// 识别真的开始之后的提示（在听，说吧…）。它和 [releaseHint] 的区别是**信息**：
  /// 一个说"松手就结束"，一个说"麦克风已经开了，现在说的话算数"。
  final String listeningHint;

  /// 按住期间的次级提示（上滑取消）。
  final String cancelHint;

  /// 已上滑、松手即取消时的提示（松开取消）。
  final String cancelReleaseHint;

  /// 生成按钮的无障碍标签 / 长按提示（图标按钮没有可见文字，说明性靠它和
  /// [submitHint] 补）。
  final String submitLabel;

  /// 输入框左下角那行小字（写完点右边生成）。
  final String submitHint;

  /// 剩余字数提示（只在接近上限时出现）。
  final String Function(int remaining) remainingLabel;

  /// 识别用的 locale（如 `zh_CN`）。传 app 当前语言，具体用哪个由设备装了哪些
  /// 语言包决定（见 `SpeechRecognizer`）。
  final String localeId;

  /// 点生成：带着已输入的文本去对话页。
  final ValueChanged<String> onSubmit;

  /// 语音用不了。**两种原因给的出路完全不同**，所以把原因原样交给调用方：
  /// 没权限要引导去设置，设备不支持只能劝用户手打。
  final ValueChanged<SpeechAvailability> onSpeechUnavailable;

  /// 说完了但一个字都没识别到（说得太轻 / 环境太吵 / 一按就松）。
  /// 静默失败是最糟的：用户以为说过了，输入框却还是空的。
  final VoidCallback onSpeechEmpty;

  /// 短按语音圆钮：不开麦，由调用方提示"要按住"。
  final VoidCallback onVoiceTapped;

  /// 输入框获得/失去焦点。页面据此折叠上方的灵感区——打字时灵感用不上，
  /// 收起来能把输入区顶到屏幕中部、把生成键完整露出来。
  final ValueChanged<bool> onFocusChanged;

  @override
  ConsumerState<StoryComposer> createState() => _StoryComposerState();
}

class _StoryComposerState extends ConsumerState<StoryComposer> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  /// 输入框是否聚焦：描边加粗 + 通知页面折叠灵感区。
  bool _hasFocus = false;

  bool _isHolding = false;

  /// 麦克风真的开了（区别于"手指按下了但识别还没起来"）。
  bool _isListening = false;

  /// 这次开口之前输入框里的内容。识别结果实时追加在它后面，
  /// 取消时把文本退回到它——一个字段就把"撤销这次语音"讲完了。
  String _baseText = "";

  /// 最近一次音量回调值，驱动圆钮光晕跟着说话涨落。
  double _soundLevel = 0;

  /// 已上滑越过阈值：此时松手是取消，不是发送。
  bool _isCancelling = false;

  /// 当前上滑距离（负值向上），用来做跟手位移。
  double _dragDy = 0;

  /// 语音圆钮直径。这是本页最大的可点元素——它就该是最显眼的那个。
  static const double _voiceSize = HappySpacing.s80;

  /// 取消阈值：**手指离开圆钮边缘**再多走一点。
  ///
  /// 用半径 + 一点余量而不是写死 48：不同手型/握姿下固定值的手感差别很大，
  /// 而"我已经把手指拖出这颗圆了"是用户脑子里真正的判断依据。
  /// 按下点通常落在圆心附近，所以"移动超过半径 + 余量"约等于"拖出圆外"。
  static const double _cancelThreshold =
      _voiceSize / 2 + _ringGap + HappySpacing.s12;

  /// 跟手位移：上滑距离乘这个系数，最多抬 [_maxLift]。
  /// 阻尼让位移"跟得上但跟不满"，既有反馈又不会把布局拖乱。
  static const double _followFactor = 0.25;
  static const double _maxLift = HappySpacing.s8;

  /// 文本上限与"接近上限"的门槛。只在剩下不多时才提示，不一直占位吓人。
  static const int _maxLength = 500;
  static const int _remainingHintAt = 50;

  /// 语音识别门面。**在 initState 里就取好**而不是每次现读：`dispose` 里也要用它
  /// 放麦克风，而那时 `ref` 已经不保证还能读（Riverpod 会在 State 销毁前后拆容器）。
  late final SpeechRecognizer _recognizer = ref.read(speechRecognizerProvider);

  @override
  void initState() {
    super.initState();
    // 监听文本变化：生成按钮的可用性、字数提示都跟着变。
    _controller.addListener(_onTextChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  void _onTextChanged() => setState(() {});

  void _onFocusChanged() {
    if (_hasFocus == _focusNode.hasFocus) return;
    setState(() => _hasFocus = _focusNode.hasFocus);
    widget.onFocusChanged(_hasFocus);
  }

  @override
  void dispose() {
    // 页面走了麦克风不能还开着。不 await：dispose 里不能异步等待，
    // 而 cancel 本身对未在监听的会话是空操作。
    _recognizer.cancel();
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    super.dispose();
  }

  /// 长按被系统打断（来电、手势被上层抢走）：和上滑取消同样处理，丢弃这次识别。
  void _onLongPressCancel() {
    if (!_isHolding && !_isListening) return;
    _reset();
    setState(() => _isListening = false);
    _recognizer.cancel();
    _controller.value = TextEditingValue(
      text: _baseText,
      selection: TextSelection.collapsed(offset: _baseText.length),
    );
  }

  void _reset() {
    if (!_isHolding && !_isCancelling && _dragDy == 0) return;
    setState(() {
      _isHolding = false;
      _isCancelling = false;
      _dragDy = 0;
    });
  }

  void _onLongPressStart(LongPressStartDetails _) {
    // 开始说话是个重要时刻，给一次明确的中等触感。
    HapticFeedback.mediumImpact();
    // 按住说话时先收键盘：不然键盘顶着，圆钮和提示都可能被挡住。
    FocusScope.of(context).unfocus();
    setState(() {
      _isHolding = true;
      _isCancelling = false;
      _dragDy = 0;
    });
    _startListening();
  }

  /// 开麦。首帧之前就把 [_baseText] 记下来——识别结果要接在它后面。
  Future<void> _startListening() async {
    _baseText = _controller.text;
    _soundLevel = 0;

    final availability = await _recognizer.start(
      preferredLocaleId: widget.localeId,
      onTranscript: _onTranscript,
      onSoundLevel: _onSoundLevel,
      onDone: _onListeningEndedByPlatform,
    );
    if (!mounted) return;

    if (availability != SpeechAvailability.ready) {
      // 开不了麦就别让界面停在"按住说话"的进行态里骗人。
      _reset();
      setState(() => _isListening = false);
      widget.onSpeechUnavailable(availability);
      return;
    }
    // 手指可能在初始化期间就松开了：那时这次会话已经被 _onLongPressEnd 收掉，
    // 这里再点亮进行态就成了幽灵状态。
    if (!_isHolding) return;
    setState(() => _isListening = true);
  }

  /// 识别推送。给的是"当前这句的最新全文"，所以整段覆盖而不是追加。
  void _onTranscript(SpeechTranscript transcript) {
    if (!mounted) return;
    final merged = _baseText + transcript.text;
    // 程序化赋值绕开了 TextField 的 maxLength（那个只拦用户输入），得自己截断，
    // 否则说得久了字数会冲破上限、计数变负数。
    final text = merged.characters.length > _maxLength
        ? merged.characters.take(_maxLength).toString()
        : merged;
    _controller.value = TextEditingValue(
      text: text,
      // 光标钉在末尾：识别是在往后写，插入点跟着走才像"它在替我打字"。
      selection: TextSelection.collapsed(offset: text.length),
    );
  }

  void _onSoundLevel(double level) {
    if (!mounted) return;
    setState(() => _soundLevel = level);
  }

  /// 平台自己停了（说到上限 / 静音过久 / 永久性错误），手指可能还按着。
  void _onListeningEndedByPlatform() {
    if (!mounted || !_isListening) return;
    // 已识别的内容留在输入框里——平台把话听完了才停的，那些字是有效的。
    setState(() {
      _isListening = false;
      _isHolding = false;
      _isCancelling = false;
      _dragDy = 0;
    });
  }

  void _onLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    final dy = math.min(0.0, details.localOffsetFromOrigin.dy);
    final cancelling = dy < -_cancelThreshold;
    // 越过/退回阈值时各给一次轻触感：手指盖着圆钮，得靠手感知道自己在哪一边。
    if (cancelling != _isCancelling) HapticFeedback.selectionClick();
    setState(() {
      _dragDy = dy;
      _isCancelling = cancelling;
    });
  }

  Future<void> _onLongPressEnd(LongPressEndDetails _) async {
    final cancelled = _isCancelling;
    final wasListening = _isListening;
    _reset();
    setState(() => _isListening = false);
    final recognizer = _recognizer;

    if (cancelled) {
      // 取消不弹提示：松手前界面已经明说了"松开取消"，什么都没发生就是预期结果。
      // 但输入框要退回说话前的样子——刚才实时写进去的那些字必须一起撤掉。
      HapticFeedback.selectionClick();
      await recognizer.cancel();
      if (!mounted) return;
      _controller.value = TextEditingValue(
        text: _baseText,
        selection: TextSelection.collapsed(offset: _baseText.length),
      );
      return;
    }

    HapticFeedback.lightImpact();
    await recognizer.stop();
    if (!mounted || !wasListening) return;

    // 等一拍再判空：最后一两个字常常跟在 stop 之后才作为"最终结果"推上来，
    // 立刻判空会把说了话的人也报成"没听清"。
    await Future<void>.delayed(HappyMotion.normal);
    if (!mounted) return;

    if (_controller.text.trim() == _baseText.trim()) {
      widget.onSpeechEmpty();
      return;
    }
    // 识别到了：把焦点交给输入框。用户下一步要么直接点生成，要么改两个错字,
    // 两者都需要光标已经在文本末尾。
    _focusNode.requestFocus();
  }

  /// 圆钮光晕强度：常态 → 按住 → 跟着说话的音量往上冲。
  ///
  /// 音量值在两个平台上量纲不同（iOS 给分贝、Android 给一个自家的刻度），没法精确
  /// 归一化。这里只取"正值越大越响"这一条共性，除以一个上限再夹紧：值域对不上时
  /// 最坏也只是光晕不怎么动，不会闪烁或炸开。
  double get _glowIntensity {
    if (!_isHolding) return _idleGlow;
    if (!_isListening) return _holdingGlow;
    final level = (_soundLevel / _soundLevelCeiling).clamp(0.0, 1.0);
    return _holdingGlow + (_speakingGlow - _holdingGlow) * level;
  }

  /// 点生成：收键盘 + 把草稿交给生成页 + **清空输入框**。
  ///
  /// 清空不是丢草稿：这段话已经随路由 query 进了生成页，还会作为时间线第一条
  /// 留在那里。留在这里反而是负担——用户从生成页回来时看见的应该是一个准备好写
  /// 下一篇的空框，而不是上一篇的残句，否则每次都要先手动删一遍。
  void _onSubmit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    FocusScope.of(context).unfocus();
    widget.onSubmit(text);
    // 放在回调之后：先把文本交出去，再动 controller，避免调用方读到空串。
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final canSubmit = _controller.text.trim().isNotEmpty;
    final remaining = _maxLength - _controller.text.characters.length;
    // 跟手抬起量：越上滑抬得越多，但有上限（阻尼）。
    final lift = (-_dragDy * _followFactor).clamp(0.0, _maxLift);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Center(
          child: Semantics(
            button: true,
            label: widget.holdHint,
            child: GestureDetector(
              onLongPressStart: _onLongPressStart,
              onLongPressMoveUpdate: _onLongPressMoveUpdate,
              onLongPressEnd: _onLongPressEnd,
              onLongPressCancel: _onLongPressCancel,
              onTap: widget.onVoiceTapped,
              child: Transform.translate(
                offset: Offset(0, -lift),
                child: AnimatedScale(
                  scale: _isHolding ? _holdingScale : 1,
                  duration: HappyMotion.fast,
                  curve: HappyMotion.standard,
                  // 外圈"收音环"：底部导航中间那颗也是渐变圆，一屏两颗发光圆容易分不清。
                  // 加一圈带间隙的描边把这颗区分出来——顺带更像"对着它说话"的靶心。
                  child: AnimatedContainer(
                    duration: HappyMotion.fast,
                    curve: HappyMotion.standard,
                    padding: const EdgeInsets.all(_ringGap),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: (_isCancelling ? scheme.error : scheme.primary)
                            .withValues(
                              alpha: _isHolding
                                  ? _ringAlphaHolding
                                  : _ringAlphaIdle,
                            ),
                        width: HappyBorderWidth.thick,
                      ),
                    ),
                    child: SizedBox(
                      width: _voiceSize,
                      height: _voiceSize,
                      // 取消态用叠一层错误色圆来切换，而不是让渐变和纯色互相插值
                      // （BoxDecoration 在 gradient↔color 之间过渡容易出现闪色）。
                      child: Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: HappyGradients.brandFor(
                                theme.brightness,
                              ),
                              boxShadow: HappyShadows.glow(
                                scheme.primary,
                                // 按住时光晕加强，开麦后再跟着音量涨落：
                                // 手指盖住圆钮时光是唯一还看得见的反馈，而"它随我
                                // 的声音在动"比任何固定动画都更能证明真的听见了。
                                intensity: _glowIntensity,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Icon(
                              LucideIcons.mic,
                              size: HappyIconSize.xl,
                              color: scheme.onPrimary,
                            ),
                          ),
                          AnimatedOpacity(
                            opacity: _isCancelling ? 1 : 0,
                            duration: HappyMotion.fast,
                            curve: HappyMotion.standard,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: scheme.error,
                              ),
                              alignment: Alignment.center,
                              child: Icon(
                                LucideIcons.x,
                                size: HappyIconSize.xl,
                                color: scheme.onError,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: HappySpacing.s12),
        Center(
          child: Text(
            // 三段式：要取消 > 已开麦 > 按住了但麦还没起来。中间那档是新加的，
            // 它是唯一能说明"现在说的话算数"的文案。
            switch ((_isHolding, _isCancelling, _isListening)) {
              (true, true, _) => widget.cancelReleaseHint,
              (true, false, true) => widget.listeningHint,
              (true, false, false) => widget.releaseHint,
              _ => widget.holdHint,
            },
            style: theme.textTheme.labelMedium?.copyWith(
              color: switch ((_isHolding, _isCancelling)) {
                (true, true) => scheme.error,
                (true, false) => scheme.primary,
                _ => scheme.onSurfaceVariant,
              },
            ),
          ),
        ),
        // 次级提示「上滑取消」：**位置常驻**，只切换透明度。
        // 让它按需出现会把下面的输入框顶一下——按住的瞬间界面跳动最容易让人松手。
        const SizedBox(height: HappySpacing.s4),
        Center(
          child: AnimatedOpacity(
            opacity: _isHolding && !_isCancelling ? 1 : 0,
            duration: HappyMotion.fast,
            curve: HappyMotion.standard,
            child: Text(
              widget.cancelHint,
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
        // 语音与文本是同一个"创作"单元，间距用 20 而不是 sectionGap：
        // 拉开一整段会让它们看起来像两件不相干的事，也把生成按钮更推出屏幕。
        const SizedBox(height: HappySpacing.s20),
        // 输入框与生成按钮**同处一个容器**：按钮做成右下角的圆形发送键，
        // 永远不会被内容挤出屏幕，也省掉一整行按钮高度。左下角留一行小字补偿
        // 图标丢掉的说明性（快到字数上限时让位给计数）。
        Container(
          padding: const EdgeInsets.fromLTRB(
            HappySpacing.s16,
            HappySpacing.s12,
            HappySpacing.s12,
            HappySpacing.s12,
          ),
          decoration: BoxDecoration(
            color: scheme.surfaceContainer,
            borderRadius: BorderRadius.circular(HappyRadius.input),
            border: Border.all(
              color: _hasFocus ? scheme.primary : scheme.outlineVariant,
              width: _hasFocus
                  ? HappyBorderWidth.thick
                  : HappyBorderWidth.hairline,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                controller: _controller,
                focusNode: _focusNode,
                maxLength: _maxLength,
                minLines: _inputMinLines,
                maxLines: _inputMaxLines,
                // 多行输入用 newline：提交靠右下角的圆钮，回车该换行。
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                scrollPadding: const EdgeInsets.only(
                  bottom: _inputScrollPadding,
                ),
                // 外层容器已经画好了"输入框"的样子，里面这个必须彻底裸奔。
                // ⚠️ 光用 `InputDecoration.collapsed` 不够：主题里配了
                // `enabledBorder` / `focusedBorder` / `filled`，它们会盖过
                // `collapsed` 的 `border: none`，结果框里再套一个框。
                // 计数器同理——`maxLength` 会自动挂一个 "16/500"，这里要显式清掉，
                // 字数提示由左下角那行小字统一负责。
                decoration: InputDecoration(
                  hintText: widget.hint,
                  isCollapsed: true,
                  filled: false,
                  contentPadding: EdgeInsets.zero,
                  counterText: "",
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                ),
              ),
              const SizedBox(height: HappySpacing.s8),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      // 计数只在快到上限时出现，平时这行讲"写完点右边"。
                      remaining > _remainingHintAt
                          ? widget.submitHint
                          : widget.remainingLabel(remaining),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: remaining > _remainingHintAt
                            ? scheme.onSurfaceVariant
                            : scheme.error,
                      ),
                    ),
                  ),
                  const SizedBox(width: HappySpacing.s8),
                  _SendButton(
                    label: widget.submitLabel,
                    // 空文本时禁用而不是点了没反应（禁用态有明确长相）。
                    onPressed: canSubmit ? _onSubmit : null,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 输入框右下角的发送键：可用时是品牌渐变 + 光晕，禁用时是安静的表面色。
///
/// 图标（而不是文字按钮）意味着说明性要别处补：左边那行小字讲"写完点右边"，
/// 无障碍与长按提示走 [label]（就是「生成爽文」那句）。
class _SendButton extends StatelessWidget {
  const _SendButton({required this.label, required this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  /// 44：最小可点热区，不能再小。
  static const double _size = HappyControlSize.minTapTarget;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final enabled = onPressed != null;

    return Tooltip(
      message: label,
      child: Semantics(
        button: true,
        enabled: enabled,
        label: label,
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
              gradient: enabled
                  ? HappyGradients.brandFor(theme.brightness)
                  : null,
              color: enabled ? null : scheme.surfaceContainerHighest,
              boxShadow: enabled
                  ? HappyShadows.glow(scheme.primary, intensity: _sendGlow)
                  : HappyShadows.none,
            ),
            child: Icon(
              LucideIcons.sparkles,
              size: HappyIconSize.md,
              color: enabled ? scheme.onPrimary : scheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

/// 发送键可用时的光晕强度。比语音圆钮弱一档：它是次要的主行动。
const double _sendGlow = 0.3;

/// 按住时语音圆钮的放大比例。
const double _holdingScale = 1.08;

/// 收音环与圆钮之间的间隙。
const double _ringGap = HappySpacing.s6;

/// 收音环的描边透明度（常态 / 按住）。按住时更实，像"环收紧了"。
const double _ringAlphaIdle = 0.28;
const double _ringAlphaHolding = 0.7;

/// 语音圆钮的光晕强度（常态 / 按住 / 说到最响）。
const double _idleGlow = 0.35;
const double _holdingGlow = 0.6;
const double _speakingGlow = 0.95;

/// 音量归一化的分母。正常说话大致落在这个量级，超过就按最响算。
const double _soundLevelCeiling = 10;

/// 输入框行数：默认两行（够写一句经历），最多三行后内部滚动。
/// 不敢再多——下面还有「生成」按钮，输入框越高按钮越容易被挤出屏幕。
const int _inputMinLines = 2;
const int _inputMaxLines = 3;

/// 聚焦时要额外滚出来的底部空间：得把输入框**和下面的生成按钮**一起顶到键盘上方，
/// 只留默认的 20 会把按钮压在键盘底下——主行动看不见等于没有。
const double _inputScrollPadding = HappySpacing.s96;
