import "package:happy_os/core/error/index.dart";
import "package:happy_os/features/story/data/dto/index.dart";
import "package:happy_os/features/story/data/story_remote_data_source.dart";
import "package:happy_os/features/story/domain/index.dart";

/// Story 仓库：负责 DTO→Entity 映射，并把底层 [AppException] 统一转成面向 UI 的
/// [Failure] 抛出。controller 只依赖本类，不接触 DataSource / DTO / Dio。
///
/// 已生成故事的列表 / 收藏 / 删除**不在这里**，归 `features/story_history/`
/// （全应用只有那一份历史数据源）。
class StoryRepository {
  const StoryRepository(this._remote);

  final StoryRemoteDataSource _remote;

  /// 灵感池。「换一换」在本地从这一池里抽，所以一次要拿全量推荐。
  Future<List<InspirationPrompt>> fetchInspirations() => _guard(() async {
    final raw = await _remote.fetchInspirationRecommendations();
    final prompts = <InspirationPrompt>[];
    final seen = <String>{};
    for (final item in raw) {
      // 单条脏数据（不是对象 / 没有正文）只丢它自己，不连坐整批推荐。
      if (item is! Map<String, dynamic>) continue;
      final prompt = InspirationPromptDto.fromJson(item).toEntity();
      if (prompt.text.isEmpty) continue;
      // 按正文去重：id 由正文派生，重复项会让列表出现重复 key 直接抛异常，
      // 也会让「换一换」的去重集合算错。
      if (seen.add(prompt.id)) prompts.add(prompt);
    }
    return prompts;
  });

  /// 统一异常收敛：底层抛的 [AppException] 转成 [Failure] 再抛出，controller 用
  /// `AsyncValue.guard` 即可拿到 Failure 渲染文案（解析异常等非 AppException 原样上抛）。
  Future<T> _guard<T>(Future<T> Function() run) async {
    try {
      return await run();
    } on AppException catch (e) {
      throw e.toFailure();
    }
  }
}
