import "dart:convert";

import "package:dio/dio.dart";
import "package:happy_os/core/error/index.dart";
import "package:happy_os/core/network/index.dart";
import "package:happy_os/features/story_generate/data/dto/index.dart";
import "package:happy_os/features/story_generate/data/story_generate_remote_data_source.dart";
import "package:happy_os/features/story_generate/domain/index.dart";
import "package:happy_os/shared/utils/logger.dart";

/// story-generate 仓库：把协议层的 [SseEvent] 翻译成领域 [GenerationEvent]，
/// 并把底层 [AppException] 收敛成面向 UI 的 [Failure]。
///
/// controller 只依赖本类，不接触 Dio / SSE 帧 / DTO。
class StoryGenerateRepository {
  const StoryGenerateRepository(this._remote);

  final StoryGenerateRemoteDataSource _remote;

  /// 上游用来标记流结束的哨兵值，不是业务事件。
  static const String _doneSentinel = "[DONE]";

  /// 发起生成。
  Stream<GenerationEvent> start({
    required String query,
    CancelToken? cancelToken,
  }) => _decode(_remote.stream(query: query, cancelToken: cancelToken));

  /// 推进会话。
  Stream<GenerationEvent> followup({
    required String sessionId,
    required FollowupAction action,
    required String originalQuery,
    String? text,
    CancelToken? cancelToken,
  }) => _decode(
    _remote.followup(
      sessionId: sessionId,
      action: action,
      originalQuery: originalQuery,
      text: text,
      cancelToken: cancelToken,
    ),
  );

  /// SSE 帧 → 领域事件。
  ///
  /// 三条容错原则，都是为了「一帧坏数据不能弄断整场生成」：
  /// 1. 空帧 / `[DONE]` 哨兵直接跳过；
  /// 2. JSON 解析失败或结构不对的帧跳过，不抛——上游偶发一帧脏数据是常态；
  /// 3. 认不出的 `type` 映射成 `GenerationEvent.unknown` 交给 controller 忽略，
  ///    而不是在这里抛异常。
  ///
  /// 真正会中断的只有连接级异常（[AppException]），转成 [Failure] 抛给 controller。
  Stream<GenerationEvent> _decode(Stream<SseEvent> source) async* {
    // 只为排障：分清「服务端根本没按 SSE 回」和「回了 SSE 但内容我们不认」。
    // 前者帧数为 0（响应体里没有一行 `data:`，解码器全丢了），后者帧数 > 0。
    // 两种情况在 UI 上都是一句"服务开小差了"，但修法完全不同。
    var frameCount = 0;
    try {
      await for (final frame in source) {
        frameCount++;
        final event = _parseFrame(frame);
        if (event != null) yield event;
      }
    } on AppException catch (e) {
      throw e.toFailure();
    }
    if (frameCount == 0) {
      AppLogger.w(
        "[story-generate] SSE 流已结束但一帧未收到："
        "响应大概率不是 text/event-stream（例如后端回了普通 JSON 错误体）。"
        "请对照 story-generate.api.md 核对端点与鉴权。",
      );
    }
  }

  GenerationEvent? _parseFrame(SseEvent frame) {
    final raw = frame.data.trim();
    if (raw.isEmpty || raw == _doneSentinel) return null;

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        AppLogger.w("[story-generate] 事件 data 不是 JSON 对象，已跳过：$raw");
        return null;
      }
      final dto = GenerationEventDto.fromJson(decoded);
      // 事件类型以 data 里的 `type` 为准，缺失时才退到 SSE 的 `event:` 名——
      // 两者按契约同值，但 data 是唯一必然存在的那一份。
      final normalized = dto.type.isNotEmpty
          ? dto
          : dto.copyWith(type: frame.event);
      final event = normalized.toEntity();
      if (event is GenerationUnknownEvent) {
        AppLogger.w("[story-generate] 未识别的事件类型 ${event.type}，已忽略：$raw");
      }
      return event;
    } on FormatException {
      // 半截 JSON / 非 JSON 心跳帧：跳过这一帧，流继续。
      AppLogger.w("[story-generate] 事件 data 不是合法 JSON，已跳过：$raw");
      return null;
    }
  }
}
