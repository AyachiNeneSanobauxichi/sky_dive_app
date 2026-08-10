import "dart:async";
import "dart:convert";

import "sse_event.dart";

/// SSE 字节流 → 事件流解码器。
///
/// ## 三个必须处理对的细节（自己拼字符串一定会踩）
/// 1. **UTF-8 多字节字符会被 TCP 分块切断**。一个汉字 3 字节，很可能前 2 字节在
///    这个 chunk、第 3 字节在下一个。所以必须用**有状态**的 `utf8.decoder`
///    转换整条流，绝不能对每个 chunk 单独 `utf8.decode`——那样会吐乱码。
/// 2. **一个事件可能跨多个 chunk，一个 chunk 也可能含多个事件**。分帧只能靠
///    「空行」这个协议信号，不能假设 chunk 边界 == 事件边界。
/// 3. **流结束时最后一帧可能没有空行收尾**。很多网关直接关连接，此时缓冲里的
///    最后一帧必须补吐，否则稳定丢失最后一个 token。
abstract final class SseDecoder {
  /// 把原始字节流解码为 SSE 事件流。
  static Stream<SseEvent> decode(Stream<List<int>> bytes) {
    // 有状态解码：跨 chunk 的半个汉字会被正确缓存到下一块。
    //
    // ⚠️ 必须用 `utf8.decoder.bind(bytes)`，**不能**写成 `bytes.transform(utf8.decoder)`。
    // 参数声明是 `Stream<List<int>>`，但 Dio 实际给的是 `Stream<Uint8List>`；而
    // `Stream<T>.transform` 会按**运行时**的 T 去要求 `StreamTransformer<Uint8List, String>`，
    // `utf8.decoder` 只是 `StreamTransformer<List<int>, String>`——泛型协变下不满足，
    // 于是在**第一次订阅时**就抛 TypeError（"Utf8Decoder is not a subtype of…"）。
    // 静态分析完全看不出来，表现是「连接 200、一帧都解不出来」。
    // `bind` 的入参是 `Stream<List<int>>`，`Stream<Uint8List>` 是它的子类型，天然安全。
    return utf8.decoder
        .bind(bytes)
        // 同时兼容 \n、\r\n、\r 三种换行
        .transform(const LineSplitter())
        .transform(
          StreamTransformer<String, SseEvent>.fromBind(_framesFromLines),
        );
  }

  /// 按 SSE 协议把行流聚合成事件帧。
  static Stream<SseEvent> _framesFromLines(Stream<String> lines) async* {
    var eventName = "";
    String? id;
    final data = StringBuffer();
    // 标记「当前帧收到过任何字段」。用它而不是 data.isNotEmpty 判断，
    // 因为 `data:` 后面跟空串也是合法帧（心跳常这么发）。
    var hasField = false;

    SseEvent buildEvent() => SseEvent(
      event: eventName.isEmpty ? SseEvent.defaultEvent : eventName,
      data: data.toString(),
      id: id,
    );

    await for (final line in lines) {
      // 空行 = 帧结束
      if (line.isEmpty) {
        if (hasField) {
          yield buildEvent();
          eventName = "";
          id = null;
          data.clear();
          hasField = false;
        }
        continue;
      }

      // 以 ":" 开头的是注释行。很多网关拿它当心跳保活，直接忽略。
      if (line.startsWith(":")) continue;

      final separator = line.indexOf(":");
      final field = separator == -1 ? line : line.substring(0, separator);
      var value = separator == -1 ? "" : line.substring(separator + 1);
      // 协议规定：": " 后紧跟的**单个**空格属于分隔符，要剥掉；后续空格是数据。
      if (value.startsWith(" ")) value = value.substring(1);

      switch (field) {
        case "event":
          eventName = value;
          hasField = true;
        case "data":
          // 多行 data 用 \n 拼接（协议规定）
          if (data.isNotEmpty) data.write("\n");
          data.write(value);
          hasField = true;
        case "id":
          id = value;
          hasField = true;
        case "retry":
          // 重连间隔建议值。当前不做自动重连，忽略。
          break;
        default:
          // 未知字段按协议忽略
          break;
      }
    }

    // 收尾：流关了但最后一帧没有空行，补吐，否则丢最后一个 token。
    if (hasField) yield buildEvent();
  }
}
