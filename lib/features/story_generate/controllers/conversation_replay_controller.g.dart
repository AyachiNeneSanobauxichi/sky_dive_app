// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_replay_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 会话回放仓库 DI。

@ProviderFor(conversationReplayRepository)
final conversationReplayRepositoryProvider =
    ConversationReplayRepositoryProvider._();

/// 会话回放仓库 DI。

final class ConversationReplayRepositoryProvider
    extends
        $FunctionalProvider<
          ConversationReplayRepository,
          ConversationReplayRepository,
          ConversationReplayRepository
        >
    with $Provider<ConversationReplayRepository> {
  /// 会话回放仓库 DI。
  ConversationReplayRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'conversationReplayRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$conversationReplayRepositoryHash();

  @$internal
  @override
  $ProviderElement<ConversationReplayRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ConversationReplayRepository create(Ref ref) {
    return conversationReplayRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ConversationReplayRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ConversationReplayRepository>(value),
    );
  }
}

String _$conversationReplayRepositoryHash() =>
    r'a3ab0156efdca5c434447de42670f3993e79d5bd';

/// 一次已完成创作的只读回放（`story-generate.md` v4）。
///
/// ## 为什么按 conversationId 缓存
/// 详情页点「继续编辑」时会**先 await 这个 provider 再跳转**——先确认真有东西可看，
/// 再把用户送过去。跳过去之后生成页 watch 的是同一个 key，数据已经在手上，
/// 不会又转一次圈。
///
/// keepAlive 只到没人看为止（默认 autoDispose）：一篇回放动辄几千字，
/// 攒着不放不值当；同一篇来回进出的间隔里，页面本身一直在监听，不会重复请求。

@ProviderFor(conversationReplay)
final conversationReplayProvider = ConversationReplayFamily._();

/// 一次已完成创作的只读回放（`story-generate.md` v4）。
///
/// ## 为什么按 conversationId 缓存
/// 详情页点「继续编辑」时会**先 await 这个 provider 再跳转**——先确认真有东西可看，
/// 再把用户送过去。跳过去之后生成页 watch 的是同一个 key，数据已经在手上，
/// 不会又转一次圈。
///
/// keepAlive 只到没人看为止（默认 autoDispose）：一篇回放动辄几千字，
/// 攒着不放不值当；同一篇来回进出的间隔里，页面本身一直在监听，不会重复请求。

final class ConversationReplayProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<GenerationEntry>>,
          List<GenerationEntry>,
          FutureOr<List<GenerationEntry>>
        >
    with
        $FutureModifier<List<GenerationEntry>>,
        $FutureProvider<List<GenerationEntry>> {
  /// 一次已完成创作的只读回放（`story-generate.md` v4）。
  ///
  /// ## 为什么按 conversationId 缓存
  /// 详情页点「继续编辑」时会**先 await 这个 provider 再跳转**——先确认真有东西可看，
  /// 再把用户送过去。跳过去之后生成页 watch 的是同一个 key，数据已经在手上，
  /// 不会又转一次圈。
  ///
  /// keepAlive 只到没人看为止（默认 autoDispose）：一篇回放动辄几千字，
  /// 攒着不放不值当；同一篇来回进出的间隔里，页面本身一直在监听，不会重复请求。
  ConversationReplayProvider._({
    required ConversationReplayFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'conversationReplayProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$conversationReplayHash();

  @override
  String toString() {
    return r'conversationReplayProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<GenerationEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<GenerationEntry>> create(Ref ref) {
    final argument = this.argument as String;
    return conversationReplay(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ConversationReplayProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$conversationReplayHash() =>
    r'2b464cc9f390e0c2649e477aca7445313e1d2961';

/// 一次已完成创作的只读回放（`story-generate.md` v4）。
///
/// ## 为什么按 conversationId 缓存
/// 详情页点「继续编辑」时会**先 await 这个 provider 再跳转**——先确认真有东西可看，
/// 再把用户送过去。跳过去之后生成页 watch 的是同一个 key，数据已经在手上，
/// 不会又转一次圈。
///
/// keepAlive 只到没人看为止（默认 autoDispose）：一篇回放动辄几千字，
/// 攒着不放不值当；同一篇来回进出的间隔里，页面本身一直在监听，不会重复请求。

final class ConversationReplayFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<GenerationEntry>>, String> {
  ConversationReplayFamily._()
    : super(
        retry: null,
        name: r'conversationReplayProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 一次已完成创作的只读回放（`story-generate.md` v4）。
  ///
  /// ## 为什么按 conversationId 缓存
  /// 详情页点「继续编辑」时会**先 await 这个 provider 再跳转**——先确认真有东西可看，
  /// 再把用户送过去。跳过去之后生成页 watch 的是同一个 key，数据已经在手上，
  /// 不会又转一次圈。
  ///
  /// keepAlive 只到没人看为止（默认 autoDispose）：一篇回放动辄几千字，
  /// 攒着不放不值当；同一篇来回进出的间隔里，页面本身一直在监听，不会重复请求。

  ConversationReplayProvider call(String conversationId) =>
      ConversationReplayProvider._(argument: conversationId, from: this);

  @override
  String toString() => r'conversationReplayProvider';
}
