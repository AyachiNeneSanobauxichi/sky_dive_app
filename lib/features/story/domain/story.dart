import "package:freezed_annotation/freezed_annotation.dart";

part "story.freezed.dart";

/// 一篇已生成（或正在生成）的故事，用于「生成历史」列表。
// TODO(story): 接口契约未定（agent/service/story/story.api.md 为空），字段按列表 UI
//   需要先行假设。定稿后回来对齐并删除 data/mock/。
@freezed
abstract class Story with _$Story {
  const factory Story({
    required String id,

    /// 标题。生成中的故事可能还没定标题，由 UI 兜底展示。
    required String title,

    /// 列表里露出的一小段正文。
    required String excerpt,

    /// 创建时间，列表按它倒序。
    required DateTime createdAt,

    @Default(StoryStatus.ready) StoryStatus status,
  }) = _Story;
}

/// 故事状态。列表要把「还在写」和「写好了」分开表达——生成是长任务，
/// 用户会在生成中途切走，回来必须能看出哪篇还没完。
enum StoryStatus {
  /// AI 还在写。
  generating,

  /// 已完成，可阅读。
  ready,

  /// 生成失败，可重试。
  failed,
}

/// 灵感提示词。带 id 是为了「换一换」时能给列表项稳定的 key。
@freezed
abstract class InspirationPrompt with _$InspirationPrompt {
  const factory InspirationPrompt({required String id, required String text}) =
      _InspirationPrompt;
}

/// 进入聊天页的来源。决定聊天页开场怎么说话（也方便埋点区分入口效率）。
enum ChatSource {
  /// 点了文本输入区。
  text,

  /// 点了语音输入按钮。
  voice,

  /// 点了某条灵感提示。
  inspiration;

  static ChatSource tryParse(String? name) {
    for (final source in values) {
      if (source.name == name) return source;
    }
    return ChatSource.text;
  }
}
