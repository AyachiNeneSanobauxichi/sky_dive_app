import "package:freezed_annotation/freezed_annotation.dart";

part "story_script.freezed.dart";

/// 一篇已写完的故事（后端叫「剧本」，`EpicScriptResponse`）。
///
/// 只留**列表和阅读用得上**的字段。契约里还有 `userId` / `isSelected` / 四段式原文
/// 等等，塞进实体只会让人以为它们有用——四段式已经在映射时拼成了 [content]。
@freezed
abstract class StoryScript with _$StoryScript {
  const factory StoryScript({
    required String id,

    /// 标题。后端可能没给（早期数据），UI 用主题或兜底文案顶上。
    required String title,

    /// 列表里露出的一小段（约 90 字，已去 Markdown 符号）。
    required String summary,

    /// 创建时间，列表按它倒序。
    required DateTime createdAt,

    /// 用户当初那句心愿。它比标题更能唤起"这篇是写什么的"。
    String? theme,

    /// 全文（Markdown）。列表不需要，阅读页要。
    String? content,

    /// 关联会话 id。日后"接着改这一篇"要靠它回到生成会话。
    String? conversationId,

    /// 是否已收藏。
    ///
    /// **不来自列表接口**——契约里 `EpicScriptResponse` 没有这个字段，是仓库另外
    /// 探一次收藏列表再套上来的（见 `story-history.api.md` 的契约缺口）。
    @Default(false) bool isFavorited,
  }) = _StoryScript;
}

/// 一页故事。分页要靠 [hasMore] 决定还能不能往下滚，所以页码信息必须跟着数据走。
@freezed
abstract class StoryScriptPage with _$StoryScriptPage {
  const StoryScriptPage._();

  const factory StoryScriptPage({
    @Default(<StoryScript>[]) List<StoryScript> scripts,

    /// 已经加载到第几页（从 1 开始，0 表示一页都还没有）。
    @Default(0) int current,

    /// 后端给的总条数。用来判断"还有没有下一页"，比信 `pages` 字段稳
    /// ——`pages` 在某些实现里会因为最后一页不满而算错。
    @Default(0) int total,
  }) = _StoryScriptPage;

  /// 还能不能往下滚。
  ///
  /// 用"已拿到的条数 < 总数"判断而不是"上一页拿满了"：后端过滤掉脏数据时
  /// 会返回不满一页但仍有下一页的结果，按满不满判断会提前停住。
  bool get hasMore => scripts.length < total;
}
