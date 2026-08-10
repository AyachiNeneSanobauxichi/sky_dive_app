import "package:happy_os/features/story_history/controllers/story_history_controller.dart";
import "package:happy_os/features/story_history/controllers/story_script_cache.dart";
import "package:happy_os/features/story_history/domain/index.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "story_script_detail_controller.g.dart";

/// 单篇爽文详情。
///
/// **默认不发请求**：列表接口已经把全文放在 `plotJson.fullContent` 里带回来了，
/// 从列表点进来直接用缓存那一份，进页是秒开的。只有两种情况才去打
/// `/epicScript/detail`——缓存里压根没有这一条（深链接直接进来的），
/// 或者有但没有全文（早期数据）。
///
/// autoDispose（不加 keepAlive）：读完就散。全文动辄几千字，攒着几十篇不释放，
/// 内存涨得比省下的那次请求值钱。
@riverpod
class StoryScriptDetailController extends _$StoryScriptDetailController {
  @override
  Future<StoryScript> build(String id) async {
    final cached = readCachedScripts(
      ref,
    ).where((script) => script.id == id).firstOrNull;
    if ((cached?.content ?? "").trim().isNotEmpty) return cached!;

    return ref
        .read(storyHistoryRepositoryProvider)
        .fetchDetail(id, isFavorited: cached?.isFavorited ?? false);
  }

  /// 切换收藏。
  ///
  /// 乐观更新 + 失败回滚，和列表里那颗星一个脾气。成功后挨个通知已加载的分类，
  /// 退回列表时星标已经是对的（见 `StoryHistoryController.syncFavorite`）。
  Future<void> toggleFavorite() async {
    final script = state.value;
    if (script == null) return;
    final next = !script.isFavorited;

    state = AsyncData<StoryScript>(script.copyWith(isFavorited: next));
    try {
      // 以服务端返回的为准，不信本地取反：并发点两下时两者会对不上。
      final result = await ref
          .read(storyHistoryRepositoryProvider)
          .toggleFavorite(script.id);
      state = AsyncData<StoryScript>(script.copyWith(isFavorited: result));
      for (final filter in StoryScriptFilter.values) {
        final provider = storyHistoryControllerProvider(filter);
        if (ref.exists(provider)) {
          ref.read(provider.notifier).syncFavorite(script.id, isFavorited: result);
        }
      }
    } on Object {
      state = AsyncData<StoryScript>(script);
      rethrow;
    }
  }
}
