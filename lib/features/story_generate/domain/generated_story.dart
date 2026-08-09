import "package:freezed_annotation/freezed_annotation.dart";

part "generated_story.freezed.dart";

/// 一篇生成完成的故事（`novel_done` 事件的结果）。
///
/// 三个 id 是后端在 `novel_done` 事件里**回注**的落库结果——所以拿到本对象就意味着
/// 内容已经存好了，客户端不需要再调一次保存接口。[scriptId] 为空说明后端这次没落库
/// （例如缺 originalQuery 兜底失败），此时「读全文」应该不可用。
@freezed
abstract class GeneratedStory with _$GeneratedStory {
  const GeneratedStory._();

  const factory GeneratedStory({
    required String content,
    String? title,
    String? scriptId,
    String? conversationId,
    String? currentVersionMessageId,
  }) = _GeneratedStory;

  /// 是否已落库可读。决定「读全文」入口给不给。
  bool get isPersisted => (scriptId ?? "").isNotEmpty;
}
