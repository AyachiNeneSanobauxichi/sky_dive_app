import "dart:async";

import "package:flutter_test/flutter_test.dart";
import "package:happy_os/shared/utils/index.dart";

void main() {
  /// 收集流的全部产出（含错误）。
  Future<({List<String> chunks, Object? error})> drain(
    Stream<String> stream,
  ) async {
    final chunks = <String>[];
    Object? error;
    await stream
        .listen(chunks.add, onError: (Object e) => error = e)
        .asFuture<void>()
        .catchError((Object _) {});
    return (chunks: chunks, error: error);
  }

  test("一次性灌入的长文本会被拆成多帧吐出，而不是原样透传", () async {
    // 模型攒包一次吐 60 字是常态。如果 pacer 原样透传，UI 上就是"整段闪现"。
    final source = Stream<String>.value("字" * 60);
    final result = await drain(TextPacer.pace(source));

    expect(result.chunks.length, greaterThan(1));
    expect(result.chunks.join(), "字" * 60);
  });

  test("内容与顺序完全保真", () async {
    final source = Stream<String>.fromIterable(<String>["abc", "def", "ghi"]);
    final result = await drain(TextPacer.pace(source));

    expect(result.chunks.join(), "abcdefghi");
  });

  test("上游出错时先把缓冲吐完，再转发错误", () async {
    // 这是流式生成失败时的关键语义：用户等来的半篇故事不能跟着错误一起丢。
    final controller = StreamController<String>();
    final paced = TextPacer.pace(controller.stream);

    final chunks = <String>[];
    Object? error;
    paced.listen(chunks.add, onError: (Object e) => error = e);

    controller.add("已经生成的这一段必须留下来");
    controller.addError(const FormatException("boom"));
    await controller.close();

    // 等 pacer 把缓冲吐干并转发错误
    await Future<void>.delayed(const Duration(milliseconds: 400));

    expect(chunks.join(), "已经生成的这一段必须留下来");
    expect(error, isA<FormatException>());
  });

  test("积压越多每帧吐越多：大积压不会被慢慢挤 10 秒", () async {
    // 2000 字按「每帧 1 字」要放 32 秒，用户会以为死机。
    // 追平窗口保证无论积压多少都在 ticksToDrain 帧内吐完。
    final source = Stream<String>.value("字" * 2000);
    final stopwatch = Stopwatch()..start();
    final result = await drain(TextPacer.pace(source));
    stopwatch.stop();

    expect(result.chunks.join().length, 2000);
    // 45 帧 × 16ms ≈ 0.72s，留足余量避免 CI 抖动导致假红
    expect(stopwatch.elapsed, lessThan(const Duration(seconds: 3)));
  });

  test("取消订阅后不再吐字（不留悬挂 timer）", () async {
    final controller = StreamController<String>();
    final chunks = <String>[];
    final subscription = TextPacer.pace(controller.stream).listen(chunks.add);

    controller.add("前半段");
    await Future<void>.delayed(const Duration(milliseconds: 120));
    final countAtCancel = chunks.length;
    await subscription.cancel();

    controller.add("取消之后的内容");
    await Future<void>.delayed(const Duration(milliseconds: 200));
    await controller.close();

    expect(chunks.length, countAtCancel);
  });
}
