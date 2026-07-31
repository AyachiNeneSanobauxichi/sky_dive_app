import "dart:async";
import "dart:math" as math;

/// 把「一阵一阵到达」的文本流重整成「匀速吐字」的流。
///
/// ## 为什么必须有这一层
/// LLM 的 token 不是均匀到达的：网关会攒包，实际观测常是 300ms 静默、然后一次
/// 吐 40 个字。直接把 chunk 渲染出去，用户看到的是**一顿一顿的抽搐**，
/// 主观上比真实延迟更慢、也更像"卡住了"。
///
/// 这里在数据和渲染之间加一个缓冲：进来多快不管，出去按固定节拍。
/// 观感上就是稳定的"有人在写"。
///
/// ## 积压自适应（关键）
/// 固定"每帧 1 字"是错的：模型 2 秒吐完 2000 字，按 16ms/字要放 32 秒，
/// 用户会以为死机。所以每帧吐出的字数随积压量线性放大——**无论积压多少，
/// 都在 [ticksToDrain] 帧内追平**。既不会落后模型太久，也不会整段闪现。
abstract final class TextPacer {
  /// 默认节拍 16ms ≈ 60fps。比这更密没有意义（帧都刷不过来），
  /// 更稀（如 33ms）会让长文肉眼可见地一格一格跳。
  static const Duration defaultTick = Duration(milliseconds: 16);

  /// 默认追平窗口：45 帧 ≈ 0.72 秒。
  /// 调小 → 更贴近模型真实速度但更抽搐；调大 → 更顺滑但落后更多。
  static const int defaultTicksToDrain = 45;

  /// 包装 [source]，返回匀速吐出的**增量**流（不是累计文本，调用方自行拼接）。
  ///
  /// 语义保证：
  /// - [source] 出错时，**先把缓冲里已有的文字吐完**再转发错误——流式生成失败时
  ///   用户必须保住已经生成的部分，不能一起丢掉。
  /// - 取消订阅会同时取消上游订阅和定时器，不留悬挂 timer。
  static Stream<String> pace(
    Stream<String> source, {
    Duration tick = defaultTick,
    int ticksToDrain = defaultTicksToDrain,
  }) {
    assert(ticksToDrain > 0, "ticksToDrain 必须为正");

    late StreamController<String> controller;
    StreamSubscription<String>? subscription;
    Timer? timer;
    var pending = "";
    var sourceDone = false;
    Object? sourceError;
    StackTrace? sourceStackTrace;
    // 当前每帧吐字数。**只上调、不下调**，缓冲吐空时才归零——
    // 见 onTick 里的说明，这是避免长尾的关键。
    var rate = 0;

    void finish() {
      timer?.cancel();
      timer = null;
      if (sourceError != null) {
        controller.addError(sourceError!, sourceStackTrace);
      }
      controller.close();
    }

    void onTick() {
      if (pending.isEmpty) {
        rate = 0; // 追平完成，回到逐字节奏
        if (sourceDone) finish();
        return;
      }

      // 每帧按「当前积压 / 追平窗口」算所需速率。
      //
      // 关键在于 rate 只上调不下调：如果每帧都按当时剩余量重算，
      // 剩余量会变成几何衰减（每帧只减 1/ticksToDrain），2000 字实测要 5 秒以上，
      // 拖出一条长尾——正是这一层本来要消灭的问题。锁住峰值速率后是线性下降，
      // 无论积压多少都真的在 ticksToDrain 帧内吐完。
      final required = (pending.length / ticksToDrain).ceil();
      if (required > rate) rate = required;

      final take = math.min(math.max(1, rate), pending.length);
      controller.add(pending.substring(0, take));
      pending = pending.substring(take);
      if (pending.isEmpty && sourceDone) finish();
    }

    controller = StreamController<String>(
      onListen: () {
        timer = Timer.periodic(tick, (_) => onTick());
        subscription = source.listen(
          (chunk) => pending += chunk,
          onError: (Object error, StackTrace stackTrace) {
            // 不立即转发：先让 onTick 把缓冲吐干，保住已生成的部分
            sourceError = error;
            sourceStackTrace = stackTrace;
            sourceDone = true;
          },
          onDone: () => sourceDone = true,
        );
      },
      onCancel: () async {
        timer?.cancel();
        timer = null;
        await subscription?.cancel();
      },
    );

    return controller.stream;
  }
}
