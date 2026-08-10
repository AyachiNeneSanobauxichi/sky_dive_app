import "package:freezed_annotation/freezed_annotation.dart";
import "package:happy_os/core/error/index.dart";
import "package:happy_os/features/story_generate/domain/index.dart";

part "story_generate_state.freezed.dart";

/// 生成页的完整状态。
///
/// **为什么不是 `AsyncValue`**：这一页的失败必须**保留已生成的内容**（用户等了半天
/// 的半篇故事不能因为一次断流就清屏），而 `AsyncError` 会把 data 换掉。所以把
/// [failure] 作为状态的一个维度，和 [timeline] 并存。
@freezed
abstract class StoryGenerateState with _$StoryGenerateState {
  const StoryGenerateState._();

  const factory StoryGenerateState({
    /// 时间线条目，按发生顺序。
    @Default(<GenerationEntry>[]) List<GenerationEntry> timeline,

    @Default(GenerationPhase.idle) GenerationPhase phase,

    /// 后端下发的会话 id。推进会话必须带它。
    String? sessionId,

    /// 首次心愿文本。每轮 followup 都要回传（后端靠它落库）。
    String? originalQuery,

    /// `status` 事件的阶段标识，用于加载文案。
    String? stage,

    /// 失败原因。与 [timeline] 并存，不清屏。
    Failure? failure,

    /// 后端业务错误码（如 [GenerationErrorCode.dailyInProgress]）。
    String? errorCode,

    /// 生成完成的结果。
    GeneratedStory? result,
  }) = _StoryGenerateState;

  /// 是否有正在进行的请求（连接中或流式中）。用于禁用重复提交。
  bool get isBusy =>
      phase == GenerationPhase.connecting || phase == GenerationPhase.streaming;

  /// 是否等待用户作答（澄清卡未答 / 大纲未决）。
  bool get isAwaitingUser => phase == GenerationPhase.awaitingUser;

  /// 当天已有未完成的会话——动作要从「重试」变成「继续上次创作」。
  bool get canResume =>
      errorCode == GenerationErrorCode.dailyInProgress &&
      (sessionId ?? "").isNotEmpty;

  /// 时间线里是否已有正文（决定失败时是"重试"还是"保留残篇 + 重试"）。
  bool get hasNovelContent => timeline.any(
    (entry) => entry is GenerationNovelEntry && entry.content.isNotEmpty,
  );

  /// 当前这段等待处在创作的哪一步，用来选加载文案。
  ///
  /// 靠**时间线最后一条**推断，而不是等后端的 `stage`：后端 stage 的取值还没定
  /// （见 `story-generate.api.md`），但"上一条是什么"本身就足以说明下一步在干嘛
  /// ——刚提交心愿 → 在理解；答完澄清 → 在搭大纲；定完大纲 → 在动笔。
  GenerationWaitStage get waitStage => switch (timeline.lastOrNull) {
    GenerationOutlineEntry() ||
    GenerationNovelEntry() => GenerationWaitStage.writing,
    GenerationClarificationEntry() => GenerationWaitStage.outlining,
    _ => GenerationWaitStage.understanding,
  };
}

/// 等待中的创作步骤。只影响加载文案，不参与业务判断。
enum GenerationWaitStage {
  /// 在读懂用户这句话。
  understanding,

  /// 在搭故事骨架。
  outlining,

  /// 在写正文。
  writing,
}

/// 生成阶段。
enum GenerationPhase {
  /// 还没开始（语音入口进来、没带心愿文本时停在这里）。
  idle,

  /// 请求已发出，首帧未到。这段窗口最脆弱，必须有明确进行态。
  connecting,

  /// 等用户回答澄清卡 / 决定大纲。
  awaitingUser,

  /// 正文流式生成中。
  streaming,

  /// 生成完成。
  done,

  /// 失败（已生成的内容仍保留在 timeline 里）。
  failed,
}

// [GenerationEntry] / [OutlineResolution] 已移到 `domain/generation_entry.dart`
// ——回放（`story-generate.api.md` v4）由数据层直接产出时间线条目，模型留在这里
// 会让数据层反过来依赖控制器层。本文件通过 `domain/index.dart` 拿到它们。
