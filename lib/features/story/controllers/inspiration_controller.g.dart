// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspiration_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Story 仓库 DI：组装 DataSource（依赖全局 DioClient）。
///
// TODO(story): 生成历史接口定稿后也复用本 provider，别再各自 new 一份。

@ProviderFor(storyRepository)
final storyRepositoryProvider = StoryRepositoryProvider._();

/// Story 仓库 DI：组装 DataSource（依赖全局 DioClient）。
///
// TODO(story): 生成历史接口定稿后也复用本 provider，别再各自 new 一份。

final class StoryRepositoryProvider
    extends
        $FunctionalProvider<StoryRepository, StoryRepository, StoryRepository>
    with $Provider<StoryRepository> {
  /// Story 仓库 DI：组装 DataSource（依赖全局 DioClient）。
  ///
  // TODO(story): 生成历史接口定稿后也复用本 provider，别再各自 new 一份。
  StoryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storyRepositoryProvider',
        isAutoDispose: false,
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

String _$storyRepositoryHash() => r'3ca3ac9b0cfcee1aa95ce3d3583055850348e447';

/// 「灵感一下」控制器：从灵感池里抽几条展示，支持换一换。
///
/// 抽签逻辑放在 controller 而不是 UI：换一换要保证**和上一轮不重复**——
/// 换了一下还是同样三条，用户会以为按钮坏了。池子不够大时（少于两屏）
/// 才允许重复，否则永远换不出来。

@ProviderFor(InspirationController)
final inspirationControllerProvider = InspirationControllerProvider._();

/// 「灵感一下」控制器：从灵感池里抽几条展示，支持换一换。
///
/// 抽签逻辑放在 controller 而不是 UI：换一换要保证**和上一轮不重复**——
/// 换了一下还是同样三条，用户会以为按钮坏了。池子不够大时（少于两屏）
/// 才允许重复，否则永远换不出来。
final class InspirationControllerProvider
    extends
        $AsyncNotifierProvider<InspirationController, List<InspirationPrompt>> {
  /// 「灵感一下」控制器：从灵感池里抽几条展示，支持换一换。
  ///
  /// 抽签逻辑放在 controller 而不是 UI：换一换要保证**和上一轮不重复**——
  /// 换了一下还是同样三条，用户会以为按钮坏了。池子不够大时（少于两屏）
  /// 才允许重复，否则永远换不出来。
  InspirationControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inspirationControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inspirationControllerHash();

  @$internal
  @override
  InspirationController create() => InspirationController();
}

String _$inspirationControllerHash() =>
    r'33c9d947a93c7944854a4f64b75833f055f72e19';

/// 「灵感一下」控制器：从灵感池里抽几条展示，支持换一换。
///
/// 抽签逻辑放在 controller 而不是 UI：换一换要保证**和上一轮不重复**——
/// 换了一下还是同样三条，用户会以为按钮坏了。池子不够大时（少于两屏）
/// 才允许重复，否则永远换不出来。

abstract class _$InspirationController
    extends $AsyncNotifier<List<InspirationPrompt>> {
  FutureOr<List<InspirationPrompt>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<InspirationPrompt>>,
              List<InspirationPrompt>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<InspirationPrompt>>,
                List<InspirationPrompt>
              >,
              AsyncValue<List<InspirationPrompt>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
