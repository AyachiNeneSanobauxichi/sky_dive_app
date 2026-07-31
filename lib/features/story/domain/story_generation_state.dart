import "package:freezed_annotation/freezed_annotation.dart";
import "package:happy_os/core/error/index.dart";

part "story_generation_state.freezed.dart";

/// 故事流式生成的状态机。
///
/// 为什么不用 `AsyncValue<String>`：`AsyncValue` 只有 loading / data / error 三态，
/// 装不下流式生成的两个关键区别——
/// 1. **「思考中」和「正在写」是两种不同的等待**。前者一个字都没有、要显示等待指示；
///    后者已经有内容、要显示文字和光标。`AsyncLoading` 无法区分。
/// 2. **失败时必须保住已生成的部分**。`AsyncError` 丢掉 data，用户等来的半篇故事
///    就没了；这里 [StoryFailed] 显式携带 [StoryFailed.text]。
@freezed
sealed class StoryGenerationState with _$StoryGenerationState {
  /// 空闲：还没发起生成。
  const factory StoryGenerationState.idle() = StoryIdle;

  /// 思考中：请求已发出，还没收到第一个字。这段窗口可能长达数秒，必须有反馈。
  const factory StoryGenerationState.thinking() = StoryThinking;

  /// 正在流式生成。[text] 是累积到目前为止的全文。
  const factory StoryGenerationState.streaming({required String text}) =
      StoryStreaming;

  /// 生成结束。[stoppedByUser] 区分「写完了」和「用户按了停止」，
  /// UI 据此决定文案（"完成" vs "已停止"）。
  const factory StoryGenerationState.completed({
    required String text,
    @Default(false) bool stoppedByUser,
  }) = StoryCompleted;

  /// 生成失败。[text] 保留已生成的部分，UI **不要清屏**。
  const factory StoryGenerationState.failed({
    required String text,
    required Failure failure,
  }) = StoryFailed;
}

/// 状态查询便捷方法，避免 UI 到处写 switch。
extension StoryGenerationStateX on StoryGenerationState {
  /// 当前应展示的文本（各状态统一出口）。
  String get currentText => switch (this) {
    StoryIdle() || StoryThinking() => "",
    StoryStreaming(:final text) => text,
    StoryCompleted(:final text) => text,
    StoryFailed(:final text) => text,
  };

  /// 是否正在进行中（思考或生成）。决定是否显示"停止"按钮。
  bool get isBusy => switch (this) {
    StoryThinking() || StoryStreaming() => true,
    _ => false,
  };

  /// 是否已有可展示的正文。
  bool get hasText => currentText.isNotEmpty;
}
