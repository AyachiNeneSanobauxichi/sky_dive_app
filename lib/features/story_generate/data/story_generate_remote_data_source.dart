import "package:dio/dio.dart";
import "package:happy_os/core/network/index.dart";
import "package:happy_os/features/story_generate/domain/index.dart";

/// story-generate 远程数据源：只负责建 SSE 连接、吐协议层事件帧，**不做领域映射**。
///
/// 端点对齐 `agent/service/story-generate/story-generate.api.md` v1。
class StoryGenerateRemoteDataSource {
  const StoryGenerateRemoteDataSource(this._client);

  final DioClient _client;

  /// 发起生成（开新会话）。
  static const String _streamPath = "/shortNovel/stream";

  /// 推进已有会话（回答澄清 / 确认大纲 / 修改大纲 / 恢复）。
  static const String _followupPath = "/shortNovel/followup";

  /// 开一条新的生成会话。
  ///
  /// [cancelToken] 由 controller 持有，用户点「停止生成」时取消——`DioClient.postSse`
  /// 把主动取消当正常收流处理，不会抛错。
  Stream<SseEvent> stream({required String query, CancelToken? cancelToken}) =>
      _client.postSse(
        _streamPath,
        data: <String, dynamic>{"query": query},
        cancelToken: cancelToken,
      );

  /// 推进会话。
  ///
  /// [originalQuery] 每轮都要带：后端靠它在 `novel_done` 时落库。虽然服务端有
  /// session 缓存兜底，但那是兜底——缓存没命中就静默不保存，用户白等一场。
  Stream<SseEvent> followup({
    required String sessionId,
    required FollowupAction action,
    required String originalQuery,
    String? text,
    CancelToken? cancelToken,
  }) => _client.postSse(
    _followupPath,
    data: <String, dynamic>{
      "sessionId": sessionId,
      "action": action.wireName,
      "payload": action.buildPayload(text),
      "originalQuery": originalQuery,
    },
    cancelToken: cancelToken,
  );
}
