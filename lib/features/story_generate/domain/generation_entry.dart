import "package:freezed_annotation/freezed_annotation.dart";
import "package:happy_os/features/story_generate/domain/clarification_card.dart";
import "package:happy_os/features/story_generate/domain/story_outline.dart";

part "generation_entry.freezed.dart";

/// 时间线上的一条。
///
/// 用 sealed union 而不是「一个带 kind 字段的结构体」：UI 要对每种条目渲染完全不同的
/// 组件，穷尽匹配能保证新增类型时不会漏掉渲染分支。
///
/// 每条都带 [GenerationEntry.createdAt]（条目**诞生**的时刻，不是更新时刻）：
/// 时间戳一旦生成就不再变，正文条目在流式追加时靠 `copyWith` 原样带着它，
/// 所以显示的是"这段是几点开始写的"，不会每来一个 delta 就跳一次表。
///
/// 放在 domain 而不是跟着页面状态走：它有**两个**来源——实时 SSE 生成，
/// 以及从服务端消息列表还原的历史回放（`story-generate.api.md` v4）。
/// 后者由数据层直接产出，模型跟着状态类走会让数据层反过来依赖控制器层。
@freezed
sealed class GenerationEntry with _$GenerationEntry {
  /// 用户的心愿，时间线第一条。
  const factory GenerationEntry.wish({
    required String text,
    required DateTime createdAt,
  }) = GenerationWishEntry;

  /// 澄清卡。[answer] 非空表示已作答、卡片收起为摘要。
  const factory GenerationEntry.clarification({
    required ClarificationCard card,
    required DateTime createdAt,
    String? answer,
  }) = GenerationClarificationEntry;

  /// 大纲卡。[resolution] 非空表示已决定（确认或提了修改意见）。
  const factory GenerationEntry.outline({
    required StoryOutline outline,
    required DateTime createdAt,
    OutlineResolution? resolution,

    /// 用户填的修改意见（[resolution] 为 [OutlineResolution.modified] 时有值）。
    /// 回放场景下为空：意见文本没有单独落库。
    String? feedback,
  }) = GenerationOutlineEntry;

  /// 正文。生成中 [isStreaming] 为 true，末尾显示光标。
  const factory GenerationEntry.novel({
    required String content,
    required DateTime createdAt,
    @Default(true) bool isStreaming,
  }) = GenerationNovelEntry;
}

/// 用户对大纲的处置。
enum OutlineResolution {
  /// 确认，直接开写。
  confirmed,

  /// 提了修改意见，让 AI 重出大纲。
  modified,
}
