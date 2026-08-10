import "package:freezed_annotation/freezed_annotation.dart";

part "clarification_card.freezed.dart";

/// 澄清卡：生成过程中 AI 的一次反问。
///
/// 契约来源：`story-generate.api.md` v1 + `sory-generate-new.api.md` v1（轮次字段）。
@freezed
abstract class ClarificationCard with _$ClarificationCard {
  const ClarificationCard._();

  const factory ClarificationCard({
    required String question,
    String? description,

    /// 卡片形态。决定选项是单选还是多选、是否只收文本。
    @Default(ClarificationCardType.singleSelect) ClarificationCardType type,

    @Default(<ClarificationOption>[]) List<ClarificationOption> options,

    /// 允许在选项之外补一段自由文本。
    @Default(false) bool allowCustom,

    String? inputPlaceholder,

    /// 至少要选几项。契约缺省为 1。
    @Default(1) int minSelections,

    /// 最多能选几项。为 null 表示不限。
    int? maxSelections,

    /// 当前是第几轮澄清（从 1 起）。上游没给或给了不自洽的值时为 null。
    int? round,

    /// 一共最多问几轮。与 [round] 同生同灭，见 [hasRoundProgress]。
    int? maxRounds,
  }) = _ClarificationCard;

  /// 是否拿到了完整可用的轮次信息。
  ///
  /// 两个字段在 DTO 层被校验成"要么都有且自洽、要么都为 null"，所以这里只判一个
  /// 就够——UI 靠它决定要不要显示「第 1/3 问」这类进度，避免把半套数据渲染出来。
  bool get hasRoundProgress => round != null && maxRounds != null;

  /// 是否已经是最后一轮澄清。
  ///
  /// 有它 UI 才能把最后一轮的措辞换成"回答完就开始写"——多轮问答里用户最烦的是
  /// 不知道还要答几次，这个信号比进度数字本身更值钱。轮次信息缺失时返回 false
  /// （宁可不承诺，也不要承诺错）。
  bool get isLastRound => hasRoundProgress && round! >= maxRounds!;

  /// 是否收自由文本：纯文本卡，或允许自定义的选项卡。
  bool get acceptsCustomText =>
      type == ClarificationCardType.textInput || allowCustom;

  /// 是否多选。`mixed` 也按多选处理——它是"选项可多选 + 还能补文本"。
  bool get isMultiSelect =>
      type == ClarificationCardType.multiSelect ||
      type == ClarificationCardType.mixed;

  /// 给定选择与自定义文本，能否提交。
  ///
  /// 规则对齐小程序 `ClarificationCard.vue`：纯文本卡只看文本；有选项的卡满足
  /// [minSelections] 即可，或者"允许自定义且写了文本"也放行——不然用户挑不到
  /// 合适选项时会被卡死在这一步。
  bool canSubmit({
    required Set<String> selectedValues,
    required String customText,
  }) {
    final hasCustom = customText.trim().isNotEmpty;
    if (type == ClarificationCardType.textInput) return hasCustom;
    if (selectedValues.length >= minSelections) return true;
    return allowCustom && hasCustom;
  }

  /// 把选择与自定义文本拼成提交给后端的那一句 `answer`。
  ///
  /// 拼接格式对齐小程序：多选用「、」连接，附带的自定义文本放进圆括号。
  /// 后端拿到的是一句自然语言，不是结构化答案。
  String buildAnswer({
    required Set<String> selectedValues,
    required String customText,
  }) {
    final custom = customText.trim();
    if (selectedValues.isEmpty) return custom;

    // 按 options 的顺序输出，而不是 Set 的迭代顺序——同样的勾选每次都该拼出
    // 同一句话，顺序抖动会让人以为提交内容变了。
    final labels = options
        .where((option) => selectedValues.contains(option.value))
        .map((option) => option.label)
        .join("、");
    return custom.isEmpty ? labels : "$labels（$custom）";
  }
}

/// 澄清卡的一个选项。
@freezed
abstract class ClarificationOption with _$ClarificationOption {
  const factory ClarificationOption({
    /// 提交时用的值，也是选中状态的 key。
    required String value,

    /// 展示文案。
    required String label,

    String? description,
  }) = _ClarificationOption;
}

/// 澄清卡形态。
enum ClarificationCardType {
  singleSelect,
  multiSelect,

  /// 选项 + 自由文本混合。
  mixed,

  /// 纯文本作答，没有选项。
  textInput;

  /// 从契约的 snake_case 值解析。未知值退回单选——这是最保守的形态
  /// （只让用户选一个，永远不会出现"选了 3 个但后端只认 1 个"）。
  static ClarificationCardType parse(String? raw) => switch (raw) {
    "multi_select" => ClarificationCardType.multiSelect,
    "mixed" => ClarificationCardType.mixed,
    "text_input" => ClarificationCardType.textInput,
    _ => ClarificationCardType.singleSelect,
  };
}
