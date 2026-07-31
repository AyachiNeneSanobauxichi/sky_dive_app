import "dart:async";

import "package:dio/dio.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_test/flutter_test.dart";
import "package:happy_os/core/error/index.dart";
import "package:happy_os/features/story/controllers/index.dart";
import "package:happy_os/features/story/data/index.dart";
import "package:happy_os/features/story/domain/index.dart";

/// 受测试完全控制的仓库替身：想什么时候吐字、什么时候报错都由测试说了算。
///
/// 用 `implements` 而不是继承：跨库 `implements` 不要求实现私有成员，
/// 于是不必为了构造一个假仓库而先造 DioClient/Dio。
class _FakeStoryRepository implements StoryRepository {
  /// 记录收到的输入，用于验证 retry 复用了上一次的经历。
  final List<String> receivedExperiences = <String>[];

  /// 每次 generate 都新开一个 controller——真实仓库也是每次调用返回一条新流，
  /// 复用同一条单订阅流会在 retry 时炸 "Stream has already been listened to"。
  final List<StreamController<String>> sources = <StreamController<String>>[];

  /// 记录 cancelToken 是否被掐断，用于验证"停止"是真停止。
  CancelToken? lastCancelToken;

  /// 最近一次 generate 对应的数据源，测试用它推送增量。
  StreamController<String> get currentSource => sources.last;

  @override
  bool get useMock => false;

  @override
  Stream<String> generate({
    required String experience,
    CancelToken? cancelToken,
  }) {
    receivedExperiences.add(experience);
    lastCancelToken = cancelToken;
    final controller = StreamController<String>();
    sources.add(controller);
    return controller.stream;
  }

  Future<void> closeAll() async {
    for (final controller in sources) {
      if (!controller.isClosed) await controller.close();
    }
  }
}

/// 只会报错的数据源，用来验证仓库把 [AppException] 转成了 [Failure]。
class _ThrowingDataSource implements StoryRemoteDataSource {
  @override
  Stream<String> generate({
    required String experience,
    CancelToken? cancelToken,
  }) => Stream<String>.error(const NetworkException());
}

void main() {
  /// 轮询等待条件成立。pacer 用真实 timer（16ms 一帧），所以要等而不是同步断言。
  Future<void> waitFor(
    bool Function() predicate, {
    Duration timeout = const Duration(seconds: 3),
  }) async {
    final deadline = DateTime.now().add(timeout);
    while (!predicate()) {
      if (DateTime.now().isAfter(deadline)) {
        fail("等待条件超时");
      }
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }
  }

  ({ProviderContainer container, _FakeStoryRepository repository})
  setUpContainer() {
    final repository = _FakeStoryRepository();
    final container = ProviderContainer(
      overrides: [storyRepositoryProvider.overrideWithValue(repository)],
    );
    // 必须保持监听，否则 autoDispose 的 controller 会在读完立刻销毁
    container.listen(
      storyGenerationControllerProvider,
      (_, _) {},
      fireImmediately: true,
    );
    addTearDown(() async {
      container.dispose();
      await repository.closeAll();
    });
    return (container: container, repository: repository);
  }

  group("StoryGenerationController", () {
    test("初始为 idle", () {
      final env = setUpContainer();
      expect(
        env.container.read(storyGenerationControllerProvider),
        isA<StoryIdle>(),
      );
    });

    test("发起生成后先进入 thinking（首字之前不显示正文）", () {
      final env = setUpContainer();
      env.container
          .read(storyGenerationControllerProvider.notifier)
          .generate("末班地铁");

      final state = env.container.read(storyGenerationControllerProvider);
      expect(state, isA<StoryThinking>());
      expect(state.hasText, isFalse);
      expect(env.repository.receivedExperiences, <String>["末班地铁"]);
    });

    test("首字到达转 streaming，收流后转 completed", () async {
      final env = setUpContainer();
      env.container
          .read(storyGenerationControllerProvider.notifier)
          .generate("末班地铁");

      env.repository.currentSource.add("走廊的灯一盏接一盏亮起来");
      await waitFor(
        () =>
            env.container.read(storyGenerationControllerProvider)
                is StoryStreaming,
      );

      await env.repository.currentSource.close();
      await waitFor(
        () =>
            env.container.read(storyGenerationControllerProvider)
                is StoryCompleted,
      );

      final state = env.container.read(storyGenerationControllerProvider);
      expect(state.currentText, "走廊的灯一盏接一盏亮起来");
      expect((state as StoryCompleted).stoppedByUser, isFalse);
    });

    test("失败时保留已生成的部分，不清屏", () async {
      final env = setUpContainer();
      env.container
          .read(storyGenerationControllerProvider.notifier)
          .generate("末班地铁");

      env.repository.currentSource.add("已经写出来的半篇");
      await waitFor(
        () =>
            env.container.read(storyGenerationControllerProvider)
                is StoryStreaming,
      );

      env.repository.currentSource.addError(const Failure.network());
      await waitFor(
        () =>
            env.container.read(storyGenerationControllerProvider)
                is StoryFailed,
      );

      final state =
          env.container.read(storyGenerationControllerProvider) as StoryFailed;
      expect(state.text, "已经写出来的半篇");
      expect(state.failure, const Failure.network());
    });

    test("停止会掐断 HTTP 连接，并标记为用户主动停止", () async {
      final env = setUpContainer();
      final notifier = env.container.read(
        storyGenerationControllerProvider.notifier,
      );
      notifier.generate("末班地铁");

      env.repository.currentSource.add("刚写了一点");
      await waitFor(
        () =>
            env.container.read(storyGenerationControllerProvider)
                is StoryStreaming,
      );

      notifier.stop();

      final state =
          env.container.read(storyGenerationControllerProvider)
              as StoryCompleted;
      expect(state.stoppedByUser, isTrue);
      // 只取消 Dart 订阅是假停止：连接还在，后端会继续生成并继续计费
      expect(env.repository.lastCancelToken?.isCancelled, isTrue);
    });

    test("retry 复用上一次的经历", () async {
      final env = setUpContainer();
      final notifier = env.container.read(
        storyGenerationControllerProvider.notifier,
      );
      notifier.generate("末班地铁");
      notifier.retry();

      expect(env.repository.receivedExperiences, <String>["末班地铁", "末班地铁"]);
    });

    test("reset 回到 idle 并清空正文", () async {
      final env = setUpContainer();
      final notifier = env.container.read(
        storyGenerationControllerProvider.notifier,
      );
      notifier.generate("末班地铁");
      env.repository.currentSource.add("一些内容");
      await waitFor(
        () =>
            env.container.read(storyGenerationControllerProvider)
                is StoryStreaming,
      );

      notifier.reset();

      final state = env.container.read(storyGenerationControllerProvider);
      expect(state, isA<StoryIdle>());
      expect(state.hasText, isFalse);
    });
  });

  group("StoryRepository", () {
    test("流中的 AppException 被转成面向 UI 的 Failure", () async {
      final repository = StoryRepository(_ThrowingDataSource(), useMock: false);

      await expectLater(
        repository.generate(experience: "x"),
        emitsInOrder(<Object>[emitsError(const Failure.network()), emitsDone]),
      );
    });

    test("mock 模式下能吐出完整故事并正常收流", () async {
      final repository = StoryRepository(_ThrowingDataSource());
      final text = (await repository.generate(experience: "末班地铁").toList())
          .join();

      expect(text, contains("末班地铁"));
      expect(text.length, greaterThan(200));
    }, timeout: const Timeout(Duration(seconds: 60)));
  });
}
