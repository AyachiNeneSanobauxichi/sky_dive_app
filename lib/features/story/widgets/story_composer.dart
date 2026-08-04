import "dart:math" as math;

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:happy_os/core/theme/index.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 创作入口区（v2）：**居中突出**的语音圆钮 + 可输入的文本框 + 生成按钮。
///
/// 这是产品主路径的第一个动作，所以做成一屏里最显眼的东西：一颗会发光的大圆居中，
/// 下面才是文本框。两条路径并列——想说话的按住圆钮，想打字的直接在下面写。
///
/// ## 语音：按住说话，上滑取消
/// 录音的心智就是按住不放：先给 [holdHint]（按住说给 AI 听），按下去换成
/// [releaseHint]（松开结束）+ 圆钮放大、光晕加强、跟手上移，松手才走。
/// 短按不跳页，改成把手势教给用户（[onVoiceTapped]，调用方给轻提示）——
/// 否则用户点一下就被弹进对话页，"按住"这个心智永远建立不起来。
///
/// **上滑取消是真的能取消**（不是只写一行提示）：上滑越过阈值后圆钮变成错误色的叉、
/// 文案变「松开取消」，松手什么都不发生。阈值按**圆钮自身尺寸**算而不是写死一个数
/// （见 [_cancelThreshold]）：不同手型下"手指已经离开这颗圆"才是用户真实的心理判断。
/// 越过/退回阈值各给一次轻触感——手指此时盖着圆钮，很可能看不见界面。
///
/// ⚠️ 这里**不真的录音**：录音要权限、要波形，属于对话页的能力。
/// 按住只是"带着我要说话这个意图"进对话页。
// TODO(story): 接入真实录音（麦克风权限 + 音量波形 + 已录时长）。上滑取消的手势与
//   视觉已经做好，接录音时把"取消"从"什么都不做"改成"丢弃这段录音"即可。
///
/// ## 文本：就地输入，点按钮带着草稿进对话页
/// 输入框是真的 `TextField`（不是"点开跳页"的假输入框），用户想到什么可以立刻写。
/// 草稿不会丢在这一页：点「生成」时把文本**带进对话页**（走路由 query，刷新/深链接
/// 也能恢复），对话从这段文字开始。空文本时按钮禁用而不是点了没反应。
class StoryComposer extends StatefulWidget {
  const StoryComposer({
    super.key,
    required this.hint,
    required this.holdHint,
    required this.releaseHint,
    required this.cancelHint,
    required this.cancelReleaseHint,
    required this.submitLabel,
    required this.submitHint,
    required this.remainingLabel,
    required this.onFocusChanged,
    required this.onSubmit,
    required this.onVoiceComplete,
    required this.onVoiceTapped,
  });

  /// 文本框里的提示文案。
  final String hint;

  /// 语音圆钮下方的常态提示（按住说给 AI 听）。
  final String holdHint;

  /// 按住期间的提示（松开结束）。
  final String releaseHint;

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

  /// 点生成：带着已输入的文本去对话页。
  final ValueChanged<String> onSubmit;

  /// 按住后松手：带着"要说话"的意图进对话页。
  final VoidCallback onVoiceComplete;

  /// 短按语音圆钮：不跳页，由调用方提示"要按住"。
  final VoidCallback onVoiceTapped;

  /// 输入框获得/失去焦点。页面据此折叠上方的灵感区——打字时灵感用不上，
  /// 收起来能把输入区顶到屏幕中部、把生成键完整露出来。
  final ValueChanged<bool> onFocusChanged;

  @override
  State<StoryComposer> createState() => _StoryComposerState();
}

class _StoryComposerState extends State<StoryComposer> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  /// 输入框是否聚焦：描边加粗 + 通知页面折叠灵感区。
  bool _hasFocus = false;

  bool _isHolding = false;

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
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.removeListener(_onFocusChanged);
    _focusNode.dispose();
    super.dispose();
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
    // 开始"录音"是个重要时刻，给一次明确的中等触感。
    HapticFeedback.mediumImpact();
    // 按住说话时先收键盘：不然键盘顶着，圆钮和提示都可能被挡住。
    FocusScope.of(context).unfocus();
    setState(() {
      _isHolding = true;
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

  void _onLongPressEnd(LongPressEndDetails _) {
    final cancelled = _isCancelling;
    _reset();
    if (cancelled) {
      // 取消不是失败，不弹提示：松手前界面已经明说了"松开取消"，
      // 松手后什么都没发生本身就是预期结果。
      HapticFeedback.selectionClick();
      return;
    }
    HapticFeedback.lightImpact();
    widget.onVoiceComplete();
  }

  /// 点生成：收键盘 + 把草稿交给对话页。
  void _onSubmit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    FocusScope.of(context).unfocus();
    widget.onSubmit(text);
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
              onLongPressCancel: _reset,
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
                                // 按住时光晕加强：手指盖住圆钮时，
                                // 光是唯一还看得见的反馈。
                                intensity: _isHolding
                                    ? _holdingGlow
                                    : _idleGlow,
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
            switch ((_isHolding, _isCancelling)) {
              (true, true) => widget.cancelReleaseHint,
              (true, false) => widget.releaseHint,
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

/// 语音圆钮的光晕强度（常态 / 按住）。
const double _idleGlow = 0.35;
const double _holdingGlow = 0.6;

/// 输入框行数：默认两行（够写一句经历），最多三行后内部滚动。
/// 不敢再多——下面还有「生成」按钮，输入框越高按钮越容易被挤出屏幕。
const int _inputMinLines = 2;
const int _inputMaxLines = 3;

/// 聚焦时要额外滚出来的底部空间：得把输入框**和下面的生成按钮**一起顶到键盘上方，
/// 只留默认的 20 会把按钮压在键盘底下——主行动看不见等于没有。
const double _inputScrollPadding = HappySpacing.s96;
