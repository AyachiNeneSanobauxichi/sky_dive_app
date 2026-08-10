// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_generate_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// story-generate 仓库 DI。

@ProviderFor(storyGenerateRepository)
final storyGenerateRepositoryProvider = StoryGenerateRepositoryProvider._();

/// story-generate 仓库 DI。

final class StoryGenerateRepositoryProvider
    extends
        $FunctionalProvider<
          StoryGenerateRepository,
          StoryGenerateRepository,
          StoryGenerateRepository
        >
    with $Provider<StoryGenerateRepository> {
  /// story-generate 仓库 DI。
  StoryGenerateRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storyGenerateRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storyGenerateRepositoryHash();

  @$internal
  @override
  $ProviderElement<StoryGenerateRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  StoryGenerateRepository create(Ref ref) {
    return storyGenerateRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StoryGenerateRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StoryGenerateRepository>(value),
    );
  }
}

String _$storyGenerateRepositoryHash() =>
    r'300091febbdc314c82252f5130145733b5d686b6';

/// 生成会话编排器：把多轮 SSE 拼成一条时间线。
///
/// ## 一次生成是**多条流**，不是一条
/// 每轮（发起 / 回答澄清 / 确认大纲）都是一次独立的 SSE 请求，服务端在这一轮该说的
/// 话说完就关流。所以**流正常结束不等于生成结束**——结束时该处于什么状态由这一轮
/// 最后收到的事件决定（澄清卡 → 等作答；`novel_done` → 完成）。只有"什么都没收到
/// 就断了"才是真的失败（[_finishRound]）。
///
/// ## 失败不清屏
/// 失败时只写 [StoryGenerateState.failure]，timeline 原样保留。用户等了几十秒的
/// 半篇故事，不能因为一次网络抖动就没了。

@ProviderFor(StoryGenerateController)
final storyGenerateControllerProvider = StoryGenerateControllerProvider._();

/// 生成会话编排器：把多轮 SSE 拼成一条时间线。
///
/// ## 一次生成是**多条流**，不是一条
/// 每轮（发起 / 回答澄清 / 确认大纲）都是一次独立的 SSE 请求，服务端在这一轮该说的
/// 话说完就关流。所以**流正常结束不等于生成结束**——结束时该处于什么状态由这一轮
/// 最后收到的事件决定（澄清卡 → 等作答；`novel_done` → 完成）。只有"什么都没收到
/// 就断了"才是真的失败（[_finishRound]）。
///
/// ## 失败不清屏
/// 失败时只写 [StoryGenerateState.failure]，timeline 原样保留。用户等了几十秒的
/// 半篇故事，不能因为一次网络抖动就没了。
final class StoryGenerateControllerProvider
    extends $NotifierProvider<StoryGenerateController, StoryGenerateState> {
  /// 生成会话编排器：把多轮 SSE 拼成一条时间线。
  ///
  /// ## 一次生成是**多条流**，不是一条
  /// 每轮（发起 / 回答澄清 / 确认大纲）都是一次独立的 SSE 请求，服务端在这一轮该说的
  /// 话说完就关流。所以**流正常结束不等于生成结束**——结束时该处于什么状态由这一轮
  /// 最后收到的事件决定（澄清卡 → 等作答；`novel_done` → 完成）。只有"什么都没收到
  /// 就断了"才是真的失败（[_finishRound]）。
  ///
  /// ## 失败不清屏
  /// 失败时只写 [StoryGenerateState.failure]，timeline 原样保留。用户等了几十秒的
  /// 半篇故事，不能因为一次网络抖动就没了。
  StoryGenerateControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storyGenerateControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storyGenerateControllerHash();

  @$internal
  @override
  StoryGenerateController create() => StoryGenerateController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StoryGenerateState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StoryGenerateState>(value),
    );
  }
}

String _$storyGenerateControllerHash() =>
    r'b84cc3f3cdf47a760efbce2b5f46d70b7279c053';

/// 生成会话编排器：把多轮 SSE 拼成一条时间线。
///
/// ## 一次生成是**多条流**，不是一条
/// 每轮（发起 / 回答澄清 / 确认大纲）都是一次独立的 SSE 请求，服务端在这一轮该说的
/// 话说完就关流。所以**流正常结束不等于生成结束**——结束时该处于什么状态由这一轮
/// 最后收到的事件决定（澄清卡 → 等作答；`novel_done` → 完成）。只有"什么都没收到
/// 就断了"才是真的失败（[_finishRound]）。
///
/// ## 失败不清屏
/// 失败时只写 [StoryGenerateState.failure]，timeline 原样保留。用户等了几十秒的
/// 半篇故事，不能因为一次网络抖动就没了。

abstract class _$StoryGenerateController extends $Notifier<StoryGenerateState> {
  StoryGenerateState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<StoryGenerateState, StoryGenerateState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<StoryGenerateState, StoryGenerateState>,
              StoryGenerateState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
