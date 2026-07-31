import "dart:async";
import "dart:convert";

import "package:dio/dio.dart";
import "package:happy_os/core/error/index.dart";
import "package:happy_os/core/network/index.dart";
import "package:happy_os/features/story/data/dto/index.dart";

/// 故事生成的远程数据源：把 SSE 协议事件翻译成**纯文本增量流**。
///
/// 职责边界：只做「协议 → 文本」，不做领域映射、不做 Failure 转换（那是 Repository 的事）。
class StoryRemoteDataSource {
  const StoryRemoteDataSource(this._client);

  final DioClient _client;

  static const String _generate = "/story/generate";

  /// 结束哨兵。两种都认：`event: done` 或 OpenAI 风格的 `data: [DONE]`。
  static const String _doneEvent = "done";
  static const String _doneSentinel = "[DONE]";

  /// 服务端在流中报错时的事件名。
  static const String _errorEvent = "error";

  /// 发起生成，返回文本增量流。
  ///
  /// [cancelToken] 由 controller 持有——用户按"停止生成"时必须靠它掐断连接，
  /// 只取消 Dart 端订阅是不够的：连接还在，后端会继续生成并继续计费。
  Stream<String> generate({
    required String experience,
    CancelToken? cancelToken,
  }) async* {
    final events = _client.postSse(
      _generate,
      data: <String, dynamic>{"experience": experience},
      cancelToken: cancelToken,
    );

    await for (final event in events) {
      // 结束：正常收流
      if (event.event == _doneEvent || event.data == _doneSentinel) return;
      // 心跳 / 空帧：跳过（很多网关每 15 秒发一个空 data 保活）
      if (event.data.isEmpty) continue;
      // 服务端在流中报错：此时 HTTP 已是 200，只能靠事件名识别
      if (event.event == _errorEvent) {
        throw ServerException(message: _extractErrorMessage(event.data));
      }
      final delta = _parseDelta(event.data);
      if (delta.isNotEmpty) yield delta;
    }
  }

  /// 解析单帧。非法 JSON 一律收敛成 [ParseException]，不让 `FormatException` 漏到上层。
  String _parseDelta(String raw) {
    try {
      final json = jsonDecode(raw);
      if (json is! Map<String, dynamic>) throw const ParseException();
      return StoryDeltaDto.fromJson(json).delta;
    } on ParseException {
      rethrow;
    } on Object {
      throw const ParseException();
    }
  }

  /// 错误帧尽力取出后端文案；取不到就返回 null 走兜底文案。
  String? _extractErrorMessage(String raw) {
    try {
      final json = jsonDecode(raw);
      return json is Map<String, dynamic> ? json["message"] as String? : null;
    } on Object {
      return null;
    }
  }
}
