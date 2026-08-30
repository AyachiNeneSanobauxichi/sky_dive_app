import "dart:math" as math;

import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_animate/flutter_animate.dart";
import "package:sky_dive/core/theme/index.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";

/// 分离式验证码输入框（OTP）：N 个格子 + 一层透明输入区。
///
/// 为什么不自绘一套输入逻辑：**透明的原生 [TextField] 盖在格子上**，格子只当"皮肤"。
/// 这样系统键盘、长按粘贴、iOS 从短信里推荐验证码（`AutofillHints.oneTimeCode`）
/// 全部照常工作；自绘 6 个独立输入框看着一样，但粘贴 6 位数会只落进第一格，
/// 短信自动填充也会失效。
///
/// 交互约定：
/// - **活动格**（下一个待输入位置）加品牌描边 + 光晕 + 闪烁光标，"焦点在这儿"不用猜；
/// - **填满即完成**：触发 [onCompleted] 并给一次轻触感，供调用方自动提交，省掉一次点击；
/// - **输入过程中不报错**（见 [autovalidateMode]），校验错误就地显示在格子下方
///   （本组件是 `FormField`，直接参与 `Form.validate`）。
class SkyOtpField extends StatefulWidget {
  const SkyOtpField({
    super.key,
    required this.controller,
    this.focusNode,
    this.length = 6,
    this.onChanged,
    this.onCompleted,
    this.validator,
    this.enabled = true,
    this.autofocus = false,
    this.isSuccess = false,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;

  /// 格子数量（同时是输入长度上限）。
  final int length;

  final ValueChanged<String>? onChanged;

  /// 填满时回调，参数是完整验证码。
  final ValueChanged<String>? onCompleted;

  final FormFieldValidator<String>? validator;

  /// 提交中置 false：锁住输入。
  final bool enabled;

  final bool autofocus;

  /// 校验通过：每格换成对勾并点亮成品牌色。
  ///
  /// 给调用方一个"成功了"的落点——校验通过往往紧接着换页，没有这一下确认，
  /// 用户刚填完最后一位就被弹走，不知道自己填对没填对。
  final bool isSuccess;

  /// 何时自动校验。
  ///
  /// ⚠️ 定长 OTP 配"必须 N 位"的校验规则时，**应当传 [AutovalidateMode.disabled]**：
  /// 边输边校验意味着从敲下第 1 位起整排就一直红着，直到最后一位落位才变回正常
  /// ——用户什么都没做错，只是还没输完，却全程被当成填错了。红色在这里是噪音，
  /// 不是信息。校验交给它真正成立的时刻：提交时的 `Form.validate()`。
  ///
  /// 默认值保持 [AutovalidateMode.onUserInteraction] 只是为了不改变既有调用方的
  /// 行为；新接入的调用方按上面的理由自行选择。
  final AutovalidateMode autovalidateMode;

  @override
  State<SkyOtpField> createState() => _SkyOtpFieldState();
}

class _SkyOtpFieldState extends State<SkyOtpField> {
  late final FocusNode _focusNode;

  /// 只释放自己创建的 FocusNode；外部传入的由外部负责。
  late final bool _ownsFocusNode;

  /// 当前 `FormField` 的句柄，用来在**外部直接改 controller** 时同步校验值。
  FormFieldState<String>? _field;

  /// 上一次的输入长度，用来判断这次是"逐位输入"还是"一次性填入多位"（粘贴 / 自动填充）。
  int _previousLength = 0;

  /// 每次一次性填入多位就自增，驱动格子逐个入场。
  ///
  /// 粘贴时 6 个数字瞬间同时出现，缺少"填进去了"的确认感；逐格入场把这件事说清楚。
  /// 逐位输入**不**播（每敲一下都动一次只会闪）。
  int _fillToken = 0;

  /// 本次批量填入覆盖的下标区间 `[_fillStart, _fillEnd)`。
  /// 只有落在区间内的格子才播入场——之前已填的、以及之后手敲的都保持静止。
  int _fillStart = 0;
  int _fillEnd = 0;

  @override
  void initState() {
    super.initState();
    _ownsFocusNode = widget.focusNode == null;
    _focusNode = widget.focusNode ?? FocusNode();
    // 焦点与文本都会改变格子的长相（活动格、已填数字），两者都要触发重绘。
    _focusNode.addListener(_onVisualStateChanged);
    widget.controller.addListener(_onVisualStateChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onVisualStateChanged);
    _focusNode.removeListener(_onVisualStateChanged);
    if (_ownsFocusNode) _focusNode.dispose();
    super.dispose();
  }

  void _onVisualStateChanged() {
    if (!mounted) return;
    final text = widget.controller.text;

    // 一次多进 2 位以上＝粘贴或短信自动填充：让格子逐个入场确认"填进去了"。
    // 判定必须放在这里而不是 onChanged：controller 的监听先于 onChanged 触发，
    // 在那边比长度时"上一次长度"已经被刷新过，delta 永远是 0。
    if (text.length - _previousLength >= 2) {
      _fillToken++;
      _fillStart = _previousLength;
      _fillEnd = text.length;
    } else if (text.length < _previousLength) {
      // 删除 / 被清空：上一批的区间作废，之后手敲的位不该借它的动效。
      _fillStart = 0;
      _fillEnd = 0;
    }
    _previousLength = text.length;

    _syncFieldValue(text);
    setState(() {});
  }

  /// 外部直接改 controller（例如登录失败后清空重填）时，`FormField` 的值必须跟着走，
  /// 否则校验还在拿旧值判断。
  void _syncFieldValue(String text) {
    final field = _field;
    if (field == null || field.value == text) return;
    if (text.isEmpty) {
      // 被清空：连校验错误一起复位。否则刚弹的"验证码不正确"下面会立刻再冒一条
      // "请输入验证码"，两条互相打架。
      field.reset();
    } else {
      field.didChange(text);
    }
  }

  void _handleChanged(FormFieldState<String> field, String value) {
    field.didChange(value);
    widget.onChanged?.call(value);
    if (value.length == widget.length) {
      // 填满是一个明确的"完成"时刻，给一次轻震；逐位输入不震，否则连成一串噪音。
      HapticFeedback.lightImpact();
      widget.onCompleted?.call(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FormField<String>(
      initialValue: widget.controller.text,
      validator: widget.validator,
      autovalidateMode: widget.autovalidateMode,
      builder: (field) {
        _field = field;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Row(
                  spacing: SkySemanticSpacing.labelGap,
                  children: <Widget>[
                    for (var i = 0; i < widget.length; i++)
                      Expanded(child: _buildBox(context, i, field.hasError)),
                  ],
                ),
                // 透明输入层盖满格子：点哪一格都是聚焦整个输入。
                Positioned.fill(child: _buildInput(field)),
              ],
            ),
            if (field.hasError)
              Padding(
                padding: const EdgeInsets.only(top: SkySpacing.s4),
                child: Text(
                  field.errorText!,
                  style: theme.inputDecorationTheme.errorStyle,
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildBox(BuildContext context, int index, bool hasError) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = widget.controller.text;
    final isFilled = index < text.length;
    // 活动格 = 下一个待输入位置；填满后停在最后一格，避免焦点框"跑出去"。
    final isActive =
        widget.enabled &&
        _focusNode.hasFocus &&
        index == math.min(text.length, widget.length - 1);

    // 成功态优先级最高：整排点亮，压过焦点与错误的长相。
    final isSuccess = widget.isSuccess;
    final borderColor = isSuccess
        ? scheme.primary
        : hasError
        ? scheme.error
        // 未激活格用 outline 而不是 outlineVariant：后者是"分割线级"的极弱描边，
        // 在深色画布上和格子填充色几乎同值，6 个格子会读成 6 块死灰而不是"待填的槽"。
        : (isActive ? scheme.primary : scheme.outline);

    return AnimatedContainer(
      duration: SkyMotion.fast,
      curve: SkyMotion.standard,
      height: SkyControlSize.input,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSuccess
            ? scheme.primary.withValues(alpha: 0.16)
            : isFilled
            ? scheme.surfaceContainerHigh
            : scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(SkyRadius.input),
        border: Border.all(
          color: borderColor,
          width: isActive ? SkyBorderWidth.thick : SkyBorderWidth.hairline,
        ),
        // 深色画布上只靠描边不够醒目，活动格与成功态补一层品牌光晕。
        boxShadow: isSuccess || (isActive && !hasError)
            ? SkyShadows.glow(scheme.primary, intensity: 0.2)
            : SkyShadows.none,
      ),
      child: isSuccess
          ? _buildCheck(context, index)
          : isFilled
          ? _buildDigit(context, text[index], index)
          : (isActive ? const _Caret() : const SizedBox.shrink()),
    );
  }

  /// 成功态：数字换成对勾，逐格弹入（`springy` 只用于这类正反馈）。
  Widget _buildCheck(BuildContext context, int index) {
    final check = Icon(
      LucideIcons.check,
      size: SkyIconSize.md,
      color: Theme.of(context).colorScheme.primary,
    );
    if (MediaQuery.disableAnimationsOf(context)) return check;

    return check
        .animate()
        .scaleXY(
          begin: 0.6,
          end: 1,
          duration: SkyMotion.normal,
          curve: SkyMotion.springy,
          delay: SkyMotion.stagger * index,
        )
        .fadeIn(duration: SkyMotion.fast);
  }

  /// 已填格里的数字。一次性填入（粘贴 / 自动填充）时逐格入场，逐位输入时静态显示。
  Widget _buildDigit(BuildContext context, String digit, int index) {
    final text = Text(digit, style: Theme.of(context).textTheme.headlineSmall);
    final inFillBatch = index >= _fillStart && index < _fillEnd;
    if (_fillToken == 0 ||
        !inFillBatch ||
        MediaQuery.disableAnimationsOf(context)) {
      return text;
    }

    // key 带 token：token 变化即换新的 Animate，动效重播一次而不是常驻。
    return text
        .animate(key: ValueKey<String>("fill-$_fillToken-$index"))
        .fadeIn(duration: SkyMotion.fast)
        .scaleXY(
          begin: 0.8,
          end: 1,
          duration: SkyMotion.fast,
          curve: SkyMotion.springy,
          // 相对本批第一格排队，粘贴 4 位时不会先干等前面几格的延迟。
          delay: SkyMotion.stagger * (index - _fillStart),
        );
  }

  /// 透明的真实输入框：所有输入能力都来自它，视觉上完全不可见。
  Widget _buildInput(FormFieldState<String> field) {
    return TextField(
      controller: widget.controller,
      focusNode: _focusNode,
      enabled: widget.enabled,
      autofocus: widget.autofocus,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.done,
      autofillHints: const <String>[AutofillHints.oneTimeCode],
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(widget.length),
      ],
      // 文本、光标、选区全部隐藏：显示由格子负责（光标见 [_Caret]）。
      style: const TextStyle(color: Colors.transparent),
      cursorColor: Colors.transparent,
      showCursor: false,
      enableInteractiveSelection: false,
      decoration: const InputDecoration(
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        filled: false,
        isDense: true,
        contentPadding: EdgeInsets.zero,
        // 主题给输入框配了 minHeight，这里必须清掉，否则会把 Stack 撑高。
        constraints: BoxConstraints(),
        counterText: "",
      ),
      onChanged: (value) => _handleChanged(field, value),
    );
  }
}

/// 活动格里的闪烁光标。
class _Caret extends StatelessWidget {
  const _Caret();

  @override
  Widget build(BuildContext context) {
    final bar = Container(
      width: SkyBorderWidth.thick,
      height: SkyIconSize.md,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(SkyBorderWidth.thick),
      ),
    );

    // 尊重系统「减弱动态效果」：关掉闪烁，保留静态光标。
    if (MediaQuery.disableAnimationsOf(context)) return bar;

    return bar
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .fadeOut(duration: SkyMotion.slow, curve: SkyMotion.ambientCurve);
  }
}
