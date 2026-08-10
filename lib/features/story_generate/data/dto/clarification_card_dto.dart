import "package:freezed_annotation/freezed_annotation.dart";
import "package:happy_os/features/story_generate/domain/index.dart";

part "clarification_card_dto.freezed.dart";
part "clarification_card_dto.g.dart";

/// `clarification_card` 事件里的 `payload.card`。
///
/// 契约来源：`story-generate.api.md` v1（选项/选择数）
/// + `sory-generate-new.api.md` v1（新增 `round` / `max_rounds` 轮次字段）。
///
/// 契约是 snake_case，逐个用 [JsonKey] 映射而不是全局改命名策略：这个 feature 里
/// 只有本文件和 [StoryOutlineDto] 是外部服务的格式，其余仍是后端自己的驼峰。
@freezed
abstract class ClarificationCardDto with _$ClarificationCardDto {
  const ClarificationCardDto._();

  const factory ClarificationCardDto({
    @Default("") String question,
    String? description,
    @JsonKey(name: "card_type") String? cardType,
    @Default(<ClarificationOptionDto>[]) List<ClarificationOptionDto> options,
    @JsonKey(name: "allow_custom") @Default(false) bool allowCustom,
    @JsonKey(name: "input_placeholder") String? inputPlaceholder,
    @JsonKey(name: "min_selections") int? minSelections,
    @JsonKey(name: "max_selections") int? maxSelections,

    /// 当前是第几轮澄清（从 1 起）。
    int? round,

    /// 一共最多问几轮。
    @JsonKey(name: "max_rounds") int? maxRounds,
  }) = _ClarificationCardDto;

  factory ClarificationCardDto.fromJson(Map<String, dynamic> json) =>
      _$ClarificationCardDtoFromJson(json);

  ClarificationCard toEntity() => ClarificationCard(
    question: question,
    description: description,
    type: ClarificationCardType.parse(cardType),
    // 丢掉没有 value 的选项：它没法提交，留在界面上只会让人点了没反应。
    options: options
        .where((option) => option.value.isNotEmpty)
        .map((option) => option.toEntity())
        .toList(),
    allowCustom: allowCustom,
    // 空串归一成 null：UI 用 `?? 兜底提示` 取默认值，只挡 null 挡不住空串，
    // 上游给个空 placeholder 就会渲染出一个没有任何提示文字的输入框。
    inputPlaceholder: (inputPlaceholder?.isEmpty ?? true)
        ? null
        : inputPlaceholder,
    minSelections: _validMinSelections(),
    maxSelections: maxSelections,
    // 轮次只在两个字段都合法（≥1 且 round ≤ maxRounds）时才透传。
    // 半套数据比没有更糟：UI 会显示出「第 0/3 轮」这种读起来像 bug 的进度。
    round: _validRound(),
    maxRounds: _validMaxRounds(),
  );

  /// 契约缺省 1；上游给 0 或负数时也拉回 1，否则"一个都不选"就能提交。
  ///
  /// 字段缺席（null）必须走缺省而不是崩溃：`text_input` 卡片本来就不带
  /// `min_selections`，而这里一旦抛异常，整条 SSE 流会被判为失败，用户看到的
  /// 是"生成失败"而不是那张输入卡。
  int _validMinSelections() {
    final min = minSelections ?? 1;
    return min < 1 ? 1 : min;
  }

  int? _validRound() {
    final current = round;
    final total = maxRounds;
    if (current == null || total == null) return null;
    if (current < 1 || total < 1 || current > total) return null;
    return current;
  }

  int? _validMaxRounds() => _validRound() == null ? null : maxRounds;
}

/// 澄清卡的一个选项。
@freezed
abstract class ClarificationOptionDto with _$ClarificationOptionDto {
  const ClarificationOptionDto._();

  const factory ClarificationOptionDto({
    @Default("") String value,
    @Default("") String label,
    String? description,
  }) = _ClarificationOptionDto;

  factory ClarificationOptionDto.fromJson(Map<String, dynamic> json) =>
      _$ClarificationOptionDtoFromJson(json);

  /// label 缺失时退回 value：宁可显示一个技术值，也好过一个空白按钮。
  ClarificationOption toEntity() => ClarificationOption(
    value: value,
    label: label.isEmpty ? value : label,
    description: description,
  );
}
