// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspiration_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
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
    r'c93b384c396d825b5cecabdafb74f3baa3b69b2f';

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
