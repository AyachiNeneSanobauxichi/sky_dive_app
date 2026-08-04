// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_history_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 生成历史控制器（v2）。
///
/// 直接读 mock 数据源而不是经 Repository：接口契约还没定
/// （`agent/service/story/story.api.md` 为空），此刻造一层 DTO→Entity 的映射等于凭空
/// 发明契约，定稿后必然重写。等契约落地时在这里换成仓库调用，页面一行都不用改。
// TODO(story): story.api.md 定稿后改为经 Repository 取数，并删除 data/mock/。

@ProviderFor(StoryHistoryController)
final storyHistoryControllerProvider = StoryHistoryControllerProvider._();

/// 生成历史控制器（v2）。
///
/// 直接读 mock 数据源而不是经 Repository：接口契约还没定
/// （`agent/service/story/story.api.md` 为空），此刻造一层 DTO→Entity 的映射等于凭空
/// 发明契约，定稿后必然重写。等契约落地时在这里换成仓库调用，页面一行都不用改。
// TODO(story): story.api.md 定稿后改为经 Repository 取数，并删除 data/mock/。
final class StoryHistoryControllerProvider
    extends $AsyncNotifierProvider<StoryHistoryController, List<Story>> {
  /// 生成历史控制器（v2）。
  ///
  /// 直接读 mock 数据源而不是经 Repository：接口契约还没定
  /// （`agent/service/story/story.api.md` 为空），此刻造一层 DTO→Entity 的映射等于凭空
  /// 发明契约，定稿后必然重写。等契约落地时在这里换成仓库调用，页面一行都不用改。
  // TODO(story): story.api.md 定稿后改为经 Repository 取数，并删除 data/mock/。
  StoryHistoryControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storyHistoryControllerProvider',
        isAutoDispose: true,
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
    r'd4b442d10e60be7cc002f68aa43d2d82f19e49d5';

/// 生成历史控制器（v2）。
///
/// 直接读 mock 数据源而不是经 Repository：接口契约还没定
/// （`agent/service/story/story.api.md` 为空），此刻造一层 DTO→Entity 的映射等于凭空
/// 发明契约，定稿后必然重写。等契约落地时在这里换成仓库调用，页面一行都不用改。
// TODO(story): story.api.md 定稿后改为经 Repository 取数，并删除 data/mock/。

abstract class _$StoryHistoryController extends $AsyncNotifier<List<Story>> {
  FutureOr<List<Story>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Story>>, List<Story>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Story>>, List<Story>>,
              AsyncValue<List<Story>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
