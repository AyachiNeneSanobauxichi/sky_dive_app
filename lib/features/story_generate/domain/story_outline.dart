import "package:freezed_annotation/freezed_annotation.dart";

part "story_outline.freezed.dart";

/// 故事大纲：正文开写前给用户确认的骨架（`story-generate.api.md` v1）。
@freezed
abstract class StoryOutline with _$StoryOutline {
  const StoryOutline._();

  const factory StoryOutline({
    String? title,

    /// 一句话梗概。
    String? logline,

    /// 分幕节拍。
    @Default(<OutlineBeat>[]) List<OutlineBeat> beats,

    String? ending,
  }) = _StoryOutline;

  /// 整张卡是否没有任何可展示内容。上游偶尔会下发空壳大纲，
  /// 空壳卡还照样问"确认还是修改"会让人无从判断。
  bool get isEmpty =>
      (title?.isEmpty ?? true) &&
      (logline?.isEmpty ?? true) &&
      beats.isEmpty &&
      (ending?.isEmpty ?? true);
}

/// 大纲里的一个节拍。
@freezed
abstract class OutlineBeat with _$OutlineBeat {
  const factory OutlineBeat({
    /// 序号。上游可能不给，UI 用下标兜底。
    int? order,

    String? title,
    String? summary,
  }) = _OutlineBeat;
}
