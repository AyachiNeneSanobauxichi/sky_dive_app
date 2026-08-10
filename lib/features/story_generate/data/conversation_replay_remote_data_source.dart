import "package:happy_os/core/network/index.dart";

/// 会话回放的远程数据源：只发原始请求，不做领域映射。
///
/// 端点对齐 `agent/service/story-generate/story-generate.api.md` v4。
class ConversationReplayRemoteDataSource {
  const ConversationReplayRemoteDataSource(this._client);

  final DioClient _client;

  static const String _listByConversation = "/message/listByConversation";

  /// 一次会话里的全部消息。
  ///
  /// 返回类型是 `List` 而不是 `Map`：本接口信封里的 `data` 直接就是数组。
  ///
  /// `includeVersions` 固定传 false：回放要的是"当初那一遍"，把每条消息的历史版本
  /// 都摊开会让时间线里出现好几份大纲和正文，读起来像是 AI 写重复了。
  Future<List<dynamic>> fetchMessages(String conversationId) =>
      _client.get<List<dynamic>>(
        _listByConversation,
        query: <String, dynamic>{
          "conversationId": conversationId,
          "includeVersions": false,
        },
      );
}
