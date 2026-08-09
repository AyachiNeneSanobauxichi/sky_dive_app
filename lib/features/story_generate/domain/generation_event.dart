import "package:freezed_annotation/freezed_annotation.dart";
import "package:happy_os/features/story_generate/domain/clarification_card.dart";
import "package:happy_os/features/story_generate/domain/story_outline.dart";

part "generation_event.freezed.dart";

/// 生成会话的一个事件（`story-generate.api.md` v1 的 SSE 事件流）。
///
/// 做成 sealed union 而不是「一个带 type 字段的大对象」：controller 要对事件做穷尽
/// 处理，编译器能替我们盯住"新增了一种事件却忘了处理"——SSE 事件是外部服务定义的，
/// 后续加类型是必然的。
///
/// 未知类型的事件由 Repository 映射成 [GenerationEvent.unknown] 而不是抛异常：
/// 上游加一个我们还不认识的事件不该让整条生成中断。
@freezed
sealed class GenerationEvent with _$GenerationEvent {
  /// 阶段提示。只更新加载文案，不产生时间线条目。
  const factory GenerationEvent.status({
    required String sessionId,

    /// 阶段标识（如 `processing`）。契约没有枚举值清单，按字符串透传。
    String? stage,
  }) = GenerationStatusEvent;

  /// 澄清卡：AI 反问，等用户作答。
  const factory GenerationEvent.clarification({
    required String sessionId,
    required ClarificationCard card,
  }) = GenerationClarificationEvent;

  /// 大纲：等用户确认或提修改意见。
  const factory GenerationEvent.outline({
    required String sessionId,
    required StoryOutline outline,
  }) = GenerationOutlineEvent;

  /// 正文开始。后续 [GenerationEvent.delta] 往这一条上累加。
  const factory GenerationEvent.novelStart({required String sessionId}) =
      GenerationNovelStartEvent;

  /// 正文增量片段。
  const factory GenerationEvent.delta({
    required String sessionId,
    required String text,
  }) = GenerationDeltaEvent;

  /// 正文完成，后端此时已落库。
  const factory GenerationEvent.done({
    required String sessionId,

    /// 全文。上游可能不带，此时由 controller 用累加的增量兜底。
    String? fullText,
    String? title,

    /// 落库后的剧本 id。有它才谈得上「读全文」。
    String? scriptId,
    String? conversationId,
    String? currentVersionMessageId,
  }) = GenerationDoneEvent;

  /// 生成失败。
  const factory GenerationEvent.failed({
    required String sessionId,
    String? code,
    String? message,
  }) = GenerationFailedEvent;

  /// 未识别的事件类型。原样留下 [type] 便于排查，不中断生成。
  const factory GenerationEvent.unknown({
    required String sessionId,
    required String type,
  }) = GenerationUnknownEvent;
}

/// 后端约定的生成错误码。
abstract final class GenerationErrorCode {
  /// 当天已有未完成的会话。这不是"失败"而是"有活儿没干完"——UI 要把动作从
  /// 「重试」换成「继续上次创作」，并用返回的 sessionId 走 retry。
  static const String dailyInProgress = "DAILY_GENERATION_IN_PROGRESS";
}
