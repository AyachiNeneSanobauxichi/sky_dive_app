import "package:freezed_annotation/freezed_annotation.dart";
import "package:happy_os/features/story/domain/index.dart";

part "inspiration_prompt_dto.freezed.dart";
part "inspiration_prompt_dto.g.dart";

/// `GET /epicScript/inspiration/recommendations` 数组里的一项（`story.api.md` v2）。
///
/// [text] 给默认空串而非 required：整批灵感里混进一条脏数据时，应该丢掉那一条，
/// 而不是让「灵感一下」整个区块解析失败（过滤见 `StoryRepository`）。
@freezed
abstract class InspirationPromptDto with _$InspirationPromptDto {
  const InspirationPromptDto._();

  const factory InspirationPromptDto({
    @Default("") String text,

    /// 情绪 / 题材标签（如 觉醒、职场）。
    String? tag,

    /// 叙事分类（如 转折、成长）。
    String? category,
  }) = _InspirationPromptDto;

  factory InspirationPromptDto.fromJson(Map<String, dynamic> json) =>
      _$InspirationPromptDtoFromJson(json);

  /// 契约没有 id，用 [text] 当标识——一条灵感就是它那句话，本身就是主键。
  /// UI 拿它做列表 key、controller 拿它给「换一换」去重，所以必须稳定：
  /// 用后端下发顺序当 id 就会在下一次推荐里错位。
  InspirationPrompt toEntity() =>
      InspirationPrompt(id: text, text: text, tag: tag, category: category);
}
