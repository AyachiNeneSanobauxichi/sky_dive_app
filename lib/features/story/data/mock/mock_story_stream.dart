import "dart:async";
import "dart:math";

import "package:happy_os/core/error/index.dart";

/// 假的流式故事生成源。
///
/// 后端 `/story/generate` 还没上线，用它把「SSE → 吐字节流 → 状态机 → UI」整条链路
/// 先跑通。**刻意模拟真实网关的三个不友好行为**，否则本地看起来完美、接上真接口就露馅：
/// 1. **首字延迟**：鉴权 + 排队 + prompt 组装，真实场景常有 1 秒以上；
/// 2. **攒包到达**：大多数 chunk 很小，偶尔一次大包；
/// 3. **随机长停顿**：网关缓冲导致的 700ms 静默——这条专门用来验证 `TextPacer`
///    有没有把节奏抹平。去掉它，吐字节流器就失去了存在意义的证据。
///
// TODO(story): 后端 /story/generate 上线后**删除整个 data/mock/ 目录**，
//   并把 StoryRepository 的 useMock 默认值改为 false。
abstract final class MockStoryStream {
  /// 首字延迟。
  static const Duration _firstTokenDelay = Duration(milliseconds: 1100);

  /// chunk 最小 / 最大字数。
  static const int _minChunk = 6;
  static const int _chunkJitter = 18;

  /// 长停顿出现的概率分母（1/20 概率）。
  static const int _stallOdds = 20;
  static const Duration _stallDuration = Duration(milliseconds: 700);
  static const int _baseGapMs = 40;
  static const int _gapJitterMs = 120;

  /// 生成文本增量流。
  ///
  /// [failMidway] 为 true 时在约三分之一处抛 [NetworkException]，
  /// 用来验证「失败保留已生成部分 + 重试」这条路径。
  static Stream<String> generate({
    required String experience,
    bool failMidway = false,
  }) async* {
    final random = Random();
    await Future<void>.delayed(_firstTokenDelay);

    final full = _compose(experience);
    var cursor = 0;

    while (cursor < full.length) {
      final size = _minChunk + random.nextInt(_chunkJitter);
      final end = min(cursor + size, full.length);
      yield full.substring(cursor, end);
      cursor = end;

      if (failMidway && cursor > full.length ~/ 3) {
        throw const NetworkException();
      }

      final stalled = random.nextInt(_stallOdds) == 0;
      await Future<void>.delayed(
        stalled
            ? _stallDuration
            : Duration(milliseconds: _baseGapMs + random.nextInt(_gapJitterMs)),
      );
    }
  }

  /// 把用户输入编织进开头，让 mock 也能体现"这是你的经历"这个产品内核。
  static String _compose(String experience) =>
      "你记得的版本是这样的：$experience\n\n"
      "但那天真正发生的事，比你记得的更长一点。\n\n"
      "电梯在十七楼停下时，门开了，外面没有人。走廊的声控灯一盏接一盏亮起来，"
      "像有人替你把路铺到尽头。你走出去，身后的电梯没有关门——它就那样敞着，等着。\n\n"
      "第三扇门是你的。钥匙插进锁孔的一瞬间，你听见走廊另一端有东西落在地上，很轻，"
      "像一枚硬币，又像一颗牙。你没有回头。后来你告诉所有人，你没有回头是因为不害怕。"
      "其实不是。是因为你已经看见了——门上的猫眼里，有光在动。有人正从里面往外看你。\n\n"
      "你把钥匙抽了出来。整条走廊的灯同时熄灭。黑暗里，你听见自己的门从内侧被打开了一条缝，"
      "然后是一个非常耐心、非常熟悉的声音，用你母亲的语气说：「回来啦？饭在锅里。」\n\n"
      "你母亲三年前就搬走了。\n\n"
      "你退了半步。声控灯没有再亮——它需要声音，而你已经不敢发出任何声音。"
      "你在黑里数自己的心跳，数到第七下的时候，那条门缝，又开大了一点。";
}
