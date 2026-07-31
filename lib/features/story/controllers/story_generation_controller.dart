import "dart:async";

import "package:dio/dio.dart";
import "package:happy_os/core/error/index.dart";
import "package:happy_os/core/providers/index.dart";
import "package:happy_os/features/story/data/index.dart";
import "package:happy_os/features/story/domain/index.dart";
import "package:happy_os/shared/utils/index.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "story_generation_controller.g.dart";

/// Story 仓库 DI。
@riverpod
StoryRepository storyRepository(Ref ref) =>
    StoryRepository(StoryRemoteDataSource(ref.watch(dioClientProvider)));

/// 故事流式生成控制器。
///
/// 这是整条流式链路的编排点，做四件事：
/// 1. **接流**：仓库给原始增量 → 过 [TextPacer] 整形成匀速 → 累积成全文；
/// 2. **状态迁移**：idle → thinking →（首字到达）streaming → completed / failed；
/// 3. **中断**：取消订阅 **并** 掐断 HTTP 连接（少一个都不算真停）；
/// 4. **重试**：记住上一次的输入，失败后可原样重来。
///
/// 用同步 `Notifier` 而非 `AsyncNotifier`：状态迁移由流事件驱动，不是一次
/// `Future` 的成败，用 `AsyncValue` 反而要跟状态机打架（见 [StoryGenerationState] 注释）。
@riverpod
class StoryGenerationController extends _$StoryGenerationController {
  StreamSubscription<String>? _subscription;
  CancelToken? _cancelToken;

  /// 累积正文。用 StringBuffer 而不是 `state.text + delta`：
  /// 每帧字符串拼接在长文下是 O(n²)，一篇 3000 字的故事会明显掉帧。
  final StringBuffer _buffer = StringBuffer();

  /// 上一次的输入，供 [retry] 复用。
  String _lastExperience = "";

  @override
  StoryGenerationState build() {
    // provider 被销毁（离开页面）时必须掐断连接，否则后台还在生成、还在计费
    ref.onDispose(_abort);
    return const StoryGenerationState.idle();
  }

  /// 发起生成。重复调用会先中止上一次。
  void generate(String experience) {
    _abort();
    _buffer.clear();
    _lastExperience = experience;
    state = const StoryGenerationState.thinking();

    final cancelToken = CancelToken();
    _cancelToken = cancelToken;

    final raw = ref
        .read(storyRepositoryProvider)
        .generate(experience: experience, cancelToken: cancelToken);

    // 匀速整形：模型攒包到达，这里重整成稳定节拍再交给 UI
    _subscription = TextPacer.pace(
      raw,
    ).listen(_onDelta, onError: _onError, onDone: _onDone, cancelOnError: true);
  }

  /// 用户主动停止。已生成的部分保留，标记为 [StoryCompleted.stoppedByUser]。
  void stop() {
    if (!state.isBusy) return;
    _abort();
    state = StoryGenerationState.completed(
      text: _buffer.toString(),
      stoppedByUser: true,
    );
  }

  /// 重试：用上一次的输入从头再生成一遍。
  ///
  // TODO(story): 后端支持「续写」后改为携带已生成文本续跑，而不是整篇重来——
  //   失败在第 2000 字时重头生成既慢又费 token。
  void retry() {
    if (_lastExperience.isEmpty) return;
    generate(_lastExperience);
  }

  /// 回到空闲态（清空正文，回到输入界面）。
  void reset() {
    _abort();
    _buffer.clear();
    state = const StoryGenerationState.idle();
  }

  void _onDelta(String delta) {
    _buffer.write(delta);
    state = StoryGenerationState.streaming(text: _buffer.toString());
  }

  void _onError(Object error, StackTrace stackTrace) {
    // 仓库已把 AppException 转成 Failure；其余（含 bug）归为 unknown 但仍记日志
    final failure = error is Failure ? error : const Failure.unknown();
    if (error is! Failure) {
      AppLogger.e("故事流式生成出现非预期错误", error, stackTrace);
    }
    _releaseSubscription();
    state = StoryGenerationState.failed(
      text: _buffer.toString(),
      failure: failure,
    );
  }

  void _onDone() {
    _releaseSubscription();
    state = StoryGenerationState.completed(text: _buffer.toString());
  }

  /// 正常收流后的清理：请求已结束，不需要再取消连接。
  void _releaseSubscription() {
    _subscription?.cancel();
    _subscription = null;
    _cancelToken = null;
  }

  /// 中止：取消订阅**并**掐断 HTTP 连接。
  ///
  /// 只取消 Dart 订阅是假停止——连接还开着，服务端会把整篇写完，token 照扣。
  void _abort() {
    _subscription?.cancel();
    _subscription = null;
    final token = _cancelToken;
    _cancelToken = null;
    if (token != null && !token.isCancelled) {
      token.cancel("stopped by user");
    }
  }
}
