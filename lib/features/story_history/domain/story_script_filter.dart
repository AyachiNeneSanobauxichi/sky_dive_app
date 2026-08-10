import "package:happy_os/features/story_history/domain/story_script.dart";

/// 历史页顶部的分类。
///
/// 做成**单选**而不是「篇幅 + 收藏」两组可叠加的筛选：收藏走的是另一个端点
/// （`/epicScript/favorite/page`），那个端点不认 `length`，服务端支持不了
/// "收藏里的短篇"。给出一个点了没反应的组合，不如不给。
///
/// 每个分类各自维护自己的分页（见 `StoryHistoryController` 的 family 说明），
/// 所以它必须是可作为 provider 参数的稳定值——枚举天然满足。
enum StoryScriptFilter {
  all,
  short,
  medium,
  long,
  favorite;

  /// 该分类对应的篇幅。[all] 与 [favorite] 没有篇幅约束，返回 null。
  StoryLength? get length => switch (this) {
    StoryScriptFilter.short => StoryLength.short,
    StoryScriptFilter.medium => StoryLength.medium,
    StoryScriptFilter.long => StoryLength.long,
    StoryScriptFilter.all || StoryScriptFilter.favorite => null,
  };

  /// 是否走收藏端点。
  bool get isFavoriteOnly => this == StoryScriptFilter.favorite;
}
