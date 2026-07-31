// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_generation_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Story 仓库 DI。

@ProviderFor(storyRepository)
final storyRepositoryProvider = StoryRepositoryProvider._();

/// Story 仓库 DI。

final class StoryRepositoryProvider
    extends
        $FunctionalProvider<StoryRepository, StoryRepository, StoryRepository>
    with $Provider<StoryRepository> {
  /// Story 仓库 DI。
  StoryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storyRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storyRepositoryHash();

  @$internal
  @override
  $ProviderElement<StoryRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  StoryRepository create(Ref ref) {
    return storyRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StoryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StoryRepository>(value),
    );
  }
}

String _$storyRepositoryHash() => r'a5ad618ae48239af1de164010df11f5f2019e3e8';

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

@ProviderFor(StoryGenerationController)
final storyGenerationControllerProvider = StoryGenerationControllerProvider._();

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
final class StoryGenerationControllerProvider
    extends $NotifierProvider<StoryGenerationController, StoryGenerationState> {
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
  StoryGenerationControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storyGenerationControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storyGenerationControllerHash();

  @$internal
  @override
  StoryGenerationController create() => StoryGenerationController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StoryGenerationState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StoryGenerationState>(value),
    );
  }
}

String _$storyGenerationControllerHash() =>
    r'71ff0c1af80d7404e47e13a0ad70dc6628d73450';

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

abstract class _$StoryGenerationController
    extends $Notifier<StoryGenerationState> {
  StoryGenerationState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<StoryGenerationState, StoryGenerationState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<StoryGenerationState, StoryGenerationState>,
              StoryGenerationState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
