import "package:happy_os/core/network/index.dart";

/// Story 远程数据源：只发原始请求、拿信封解包后的 `data`，**不做领域映射**。
///
/// 端点对齐 `agent/service/story/story.api.md` v2。
class StoryRemoteDataSource {
  const StoryRemoteDataSource(this._client);

  final DioClient _client;

  /// 灵感推荐。后端按当前用户推荐，故需鉴权头（由 AuthInterceptor 注入）。
  static const String _inspirationRecommendations =
      "/epicScript/inspiration/recommendations";

  /// 返回类型是 `List` 而不是 `Map`：本接口信封里的 `data` 直接就是数组。
  Future<List<dynamic>> fetchInspirationRecommendations() =>
      _client.get<List<dynamic>>(_inspirationRecommendations);
}
