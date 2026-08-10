import "package:freezed_annotation/freezed_annotation.dart";
import "package:happy_os/features/story_history/data/dto/story_script_dto.dart";
import "package:happy_os/features/story_history/domain/index.dart";

part "story_script_page_dto.freezed.dart";
part "story_script_page_dto.g.dart";

/// `PageResult<EpicScriptResponse>`（`00-通用约定.md` 的分页结构）。
///
/// 四个计数字段全给默认值：后端偶尔只回 `records`（例如空结果），
/// 少一个 `total` 不该让整页历史打不开。
@freezed
abstract class StoryScriptPageDto with _$StoryScriptPageDto {
  const StoryScriptPageDto._();

  const factory StoryScriptPageDto({
    @Default(<StoryScriptDto>[]) List<StoryScriptDto> records,
    @Default(1) int current,
    @Default(0) int size,
    @Default(0) int total,
    @Default(0) int pages,
  }) = _StoryScriptPageDto;

  factory StoryScriptPageDto.fromJson(Map<String, dynamic> json) =>
      _$StoryScriptPageDtoFromJson(json);

  /// [favoriteIds] 是仓库另外探来的已收藏 id 集合（列表接口不带收藏态）。
  ///
  /// [allFavorited] 给收藏端点用：那一页的每一条按定义都是已收藏的，不必再拿
  /// 探来的集合去对——探测只取了前 100 条，收藏多的用户会有几条被误标成未收藏。
  StoryScriptPage toEntity({
    Set<String> favoriteIds = const <String>{},
    bool allFavorited = false,
  }) => StoryScriptPage(
    scripts: <StoryScript>[
      for (final record in records)
        record.toEntity(
          isFavorited: allFavorited || favoriteIds.contains(record.id),
        ),
    ],
    current: current,
    // total 缺失（为 0）但确实拿到了记录时，退化成"至少有这么多条"，
    // 否则 hasMore 会立刻算成 false，用户滚到底再也加载不出下一页。
    total: total > 0 ? total : records.length,
  );
}
