// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_history_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// story-history 仓库 DI。

@ProviderFor(storyHistoryRepository)
final storyHistoryRepositoryProvider = StoryHistoryRepositoryProvider._();

/// story-history 仓库 DI。

final class StoryHistoryRepositoryProvider
    extends
        $FunctionalProvider<
          StoryHistoryRepository,
          StoryHistoryRepository,
          StoryHistoryRepository
        >
    with $Provider<StoryHistoryRepository> {
  /// story-history 仓库 DI。
  StoryHistoryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storyHistoryRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storyHistoryRepositoryHash();

  @$internal
  @override
  $ProviderElement<StoryHistoryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  StoryHistoryRepository create(Ref ref) {
    return storyHistoryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StoryHistoryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StoryHistoryRepository>(value),
    );
  }
}

String _$storyHistoryRepositoryHash() =>
    r'0fd71d11b0591f63289b47af30193bce324d2b3e';

/// 历史列表控制器：分页 + 收藏 + 删除。
///
/// ## 状态怎么分的
/// **首屏**的加载/错误交给 `AsyncValue`；**加载更多**的进行态与失败放在
/// [StoryScriptPage] 之外的两个字段里（[isLoadingMore] / [loadMoreFailure]）。
/// 混在一起的话，翻第 3 页失败会把已经看到的两页一起换成错误页——用户读到一半
/// 的列表凭什么因为下一页没拿到就消失。
///
/// ## keepAlive
/// story 首页和历史全量页共用本控制器：从首页点进来是**秒开**，不会再转一次圈。
/// 两处看到的收藏/删除结果也天然一致，不存在"删了回到首页还在"。

@ProviderFor(StoryHistoryController)
final storyHistoryControllerProvider = StoryHistoryControllerProvider._();

/// 历史列表控制器：分页 + 收藏 + 删除。
///
/// ## 状态怎么分的
/// **首屏**的加载/错误交给 `AsyncValue`；**加载更多**的进行态与失败放在
/// [StoryScriptPage] 之外的两个字段里（[isLoadingMore] / [loadMoreFailure]）。
/// 混在一起的话，翻第 3 页失败会把已经看到的两页一起换成错误页——用户读到一半
/// 的列表凭什么因为下一页没拿到就消失。
///
/// ## keepAlive
/// story 首页和历史全量页共用本控制器：从首页点进来是**秒开**，不会再转一次圈。
/// 两处看到的收藏/删除结果也天然一致，不存在"删了回到首页还在"。
final class StoryHistoryControllerProvider
    extends $AsyncNotifierProvider<StoryHistoryController, StoryScriptPage> {
  /// 历史列表控制器：分页 + 收藏 + 删除。
  ///
  /// ## 状态怎么分的
  /// **首屏**的加载/错误交给 `AsyncValue`；**加载更多**的进行态与失败放在
  /// [StoryScriptPage] 之外的两个字段里（[isLoadingMore] / [loadMoreFailure]）。
  /// 混在一起的话，翻第 3 页失败会把已经看到的两页一起换成错误页——用户读到一半
  /// 的列表凭什么因为下一页没拿到就消失。
  ///
  /// ## keepAlive
  /// story 首页和历史全量页共用本控制器：从首页点进来是**秒开**，不会再转一次圈。
  /// 两处看到的收藏/删除结果也天然一致，不存在"删了回到首页还在"。
  StoryHistoryControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storyHistoryControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storyHistoryControllerHash();

  @$internal
  @override
  StoryHistoryController create() => StoryHistoryController();
}

String _$storyHistoryControllerHash() =>
    r'60a2e12656d009a050e167d749a847ae6157cf05';

/// 历史列表控制器：分页 + 收藏 + 删除。
///
/// ## 状态怎么分的
/// **首屏**的加载/错误交给 `AsyncValue`；**加载更多**的进行态与失败放在
/// [StoryScriptPage] 之外的两个字段里（[isLoadingMore] / [loadMoreFailure]）。
/// 混在一起的话，翻第 3 页失败会把已经看到的两页一起换成错误页——用户读到一半
/// 的列表凭什么因为下一页没拿到就消失。
///
/// ## keepAlive
/// story 首页和历史全量页共用本控制器：从首页点进来是**秒开**，不会再转一次圈。
/// 两处看到的收藏/删除结果也天然一致，不存在"删了回到首页还在"。

abstract class _$StoryHistoryController
    extends $AsyncNotifier<StoryScriptPage> {
  FutureOr<StoryScriptPage> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<StoryScriptPage>, StoryScriptPage>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<StoryScriptPage>, StoryScriptPage>,
              AsyncValue<StoryScriptPage>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
