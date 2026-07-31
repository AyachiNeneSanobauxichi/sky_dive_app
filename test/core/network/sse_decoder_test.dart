import "dart:convert";

import "package:flutter_test/flutter_test.dart";
import "package:happy_os/core/network/index.dart";

void main() {
  /// 把字符串按字节切成若干块喂进解码器，模拟 TCP 分块。
  Stream<List<int>> chunked(String raw, {List<int> splitAt = const <int>[]}) {
    final bytes = utf8.encode(raw);
    if (splitAt.isEmpty) return Stream<List<int>>.value(bytes);

    final chunks = <List<int>>[];
    var previous = 0;
    for (final index in splitAt) {
      chunks.add(bytes.sublist(previous, index));
      previous = index;
    }
    chunks.add(bytes.sublist(previous));
    return Stream<List<int>>.fromIterable(chunks);
  }

  test("按空行分帧，逐帧解出 event 与 data", () async {
    final events = await SseDecoder.decode(
      chunked("event: delta\ndata: one\n\nevent: delta\ndata: two\n\n"),
    ).toList();

    expect(events.map((e) => e.event), <String>["delta", "delta"]);
    expect(events.map((e) => e.data), <String>["one", "two"]);
  });

  test("UTF-8 多字节字符被 chunk 切断也能正确还原", () async {
    // "data: " 占 6 字节，"你" 占第 6/7/8 字节——在 8 处切开等于把"你"劈成两半。
    // 这是自己拼字符串最常踩的坑：对每个 chunk 单独 utf8.decode 会吐乱码。
    final events = await SseDecoder.decode(
      chunked("data: 你好世界\n\n", splitAt: <int>[8]),
    ).toList();

    expect(events.single.data, "你好世界");
  });

  test("多行 data 用换行拼接", () async {
    final events = await SseDecoder.decode(
      chunked("data: first\ndata: second\n\n"),
    ).toList();

    expect(events.single.data, "first\nsecond");
  });

  test("以冒号开头的注释行（网关心跳）被忽略，不产生事件", () async {
    final events = await SseDecoder.decode(
      chunked(": keep-alive\n\ndata: real\n\n"),
    ).toList();

    expect(events.length, 1);
    expect(events.single.data, "real");
  });

  test("流结束时最后一帧没有空行收尾，仍然补吐", () async {
    // 很多网关写完最后一个 token 直接关连接。不补吐就稳定丢最后一段文字。
    final events = await SseDecoder.decode(chunked("data: tail")).toList();

    expect(events.single.data, "tail");
  });

  test("缺省事件名为 message，并解出 id", () async {
    final events = await SseDecoder.decode(
      chunked("id: 42\ndata: x\n\n"),
    ).toList();

    expect(events.single.event, "message");
    expect(events.single.id, "42");
  });

  test("兼容 CRLF 换行", () async {
    final events = await SseDecoder.decode(
      chunked("event: delta\r\ndata: crlf\r\n\r\n"),
    ).toList();

    expect(events.single.event, "delta");
    expect(events.single.data, "crlf");
  });

  test("data 值只剥掉冒号后的第一个空格，后续空格属于数据", () async {
    final events = await SseDecoder.decode(
      chunked("data:  leading\n\n"),
    ).toList();

    expect(events.single.data, " leading");
  });
}
