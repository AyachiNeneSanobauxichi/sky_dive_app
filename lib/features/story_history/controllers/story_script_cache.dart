import "package:happy_os/features/story_history/controllers/story_history_controller.dart";
import "package:happy_os/features/story_history/domain/index.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

/// 各分类缓存里已经加载到的全部剧本（按 id 去重，先出现的优先）。
///
/// 给"手上只有一个 id、但不想为此多打一次接口"的场景用：详情页秒开、生成页回放
/// 取心愿与全文的兜底。
///
/// ⚠️ 这是一次**快照读取**，不是可监听的状态——它不会因为列表更新而通知谁。
/// 所以做成普通函数而不是 provider：provider 会诱使调用方去 `watch` 它，
/// 然后疑惑为什么列表变了这里没动。
///
/// 只读**已经存在**的分类实例：`ref.read` 一个还没建过的 provider 等于替用户发起
/// 一次他没要求的分页请求。没加载过就当没有，调用方自己回落到请求详情。
List<StoryScript> readCachedScripts(Ref ref) {
  final seen = <String>{};
  return <StoryScript>[
    for (final filter in StoryScriptFilter.values)
      if (ref.exists(storyHistoryControllerProvider(filter)))
        ...?ref
            .read(storyHistoryControllerProvider(filter))
            .value
            ?.scripts
            .where((script) => seen.add(script.id)),
  ];
}
