import "package:freezed_annotation/freezed_annotation.dart";

part "inspiration_prompt.freezed.dart";

/// 灵感提示词（`story.api.md` v2）。
///
/// [id] 用于「换一换」时给列表项稳定的 key。契约里没有 id 字段，映射时用 [text] 充当
/// （见 `InspirationPromptDto.toEntity`）——一条灵感就是它那句话，本身即主键。
@freezed
abstract class InspirationPrompt with _$InspirationPrompt {
  const factory InspirationPrompt({
    required String id,
    required String text,

    /// 情绪 / 题材标签（如 觉醒、职场）。契约有，但当前 UI 还没展示。
    String? tag,

    /// 叙事分类（如 转折、成长）。契约有，但当前 UI 还没展示。
    String? category,
  }) = _InspirationPrompt;
}
