import "package:happy_os/core/providers/index.dart";
import "package:happy_os/features/story_generate/data/index.dart";
import "package:happy_os/features/story_generate/domain/index.dart";
import "package:happy_os/features/story_history/controllers/index.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "conversation_replay_controller.g.dart";

/// 会话回放仓库 DI。
@Riverpod(keepAlive: true)
ConversationReplayRepository conversationReplayRepository(Ref ref) =>
    ConversationReplayRepository(
      ConversationReplayRemoteDataSource(ref.watch(dioClientProvider)),
    );

/// 一次已完成创作的只读回放（`story-generate.md` v4）。
///
/// ## 为什么按 conversationId 缓存
/// 详情页点「继续编辑」时会**先 await 这个 provider 再跳转**——先确认真有东西可看，
/// 再把用户送过去。跳过去之后生成页 watch 的是同一个 key，数据已经在手上，
/// 不会又转一次圈。
///
/// keepAlive 只到没人看为止（默认 autoDispose）：一篇回放动辄几千字，
/// 攒着不放不值当；同一篇来回进出的间隔里，页面本身一直在监听，不会重复请求。
@riverpod
Future<List<GenerationEntry>> conversationReplay(
  Ref ref,
  String conversationId,
) {
  // 心愿与正文可能没落进消息表（见 `story-generate.api.md` v4 的三个坑）。
  // 历史列表如果已经加载过这一篇，就地拿它的 theme 和全文补上，不为兜底多打接口；
  // 深链接直接进来时拿不到，那就少渲染一条，不影响其余部分。
  final script = readCachedScripts(ref)
      .where((script) => script.conversationId == conversationId)
      .firstOrNull;

  return ref
      .read(conversationReplayRepositoryProvider)
      .fetchReplay(
        conversationId,
        fallbackWish: script?.theme,
        fallbackNovel: script?.content,
      );
}
