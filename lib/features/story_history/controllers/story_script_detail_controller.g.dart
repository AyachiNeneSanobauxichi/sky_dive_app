// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_script_detail_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 单篇爽文详情。
///
/// **默认不发请求**：列表接口已经把全文放在 `plotJson.fullContent` 里带回来了，
/// 从列表点进来直接用缓存那一份，进页是秒开的。只有两种情况才去打
/// `/epicScript/detail`——缓存里压根没有这一条（深链接直接进来的），
/// 或者有但没有全文（早期数据）。
///
/// autoDispose（不加 keepAlive）：读完就散。全文动辄几千字，攒着几十篇不释放，
/// 内存涨得比省下的那次请求值钱。

@ProviderFor(StoryScriptDetailController)
final storyScriptDetailControllerProvider =
    StoryScriptDetailControllerFamily._();

/// 单篇爽文详情。
///
/// **默认不发请求**：列表接口已经把全文放在 `plotJson.fullContent` 里带回来了，
/// 从列表点进来直接用缓存那一份，进页是秒开的。只有两种情况才去打
/// `/epicScript/detail`——缓存里压根没有这一条（深链接直接进来的），
/// 或者有但没有全文（早期数据）。
///
/// autoDispose（不加 keepAlive）：读完就散。全文动辄几千字，攒着几十篇不释放，
/// 内存涨得比省下的那次请求值钱。
final class StoryScriptDetailControllerProvider
    extends $AsyncNotifierProvider<StoryScriptDetailController, StoryScript> {
  /// 单篇爽文详情。
  ///
  /// **默认不发请求**：列表接口已经把全文放在 `plotJson.fullContent` 里带回来了，
  /// 从列表点进来直接用缓存那一份，进页是秒开的。只有两种情况才去打
  /// `/epicScript/detail`——缓存里压根没有这一条（深链接直接进来的），
  /// 或者有但没有全文（早期数据）。
  ///
  /// autoDispose（不加 keepAlive）：读完就散。全文动辄几千字，攒着几十篇不释放，
  /// 内存涨得比省下的那次请求值钱。
  StoryScriptDetailControllerProvider._({
    required StoryScriptDetailControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'storyScriptDetailControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$storyScriptDetailControllerHash();

  @override
  String toString() {
    return r'storyScriptDetailControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  StoryScriptDetailController create() => StoryScriptDetailController();

  @override
  bool operator ==(Object other) {
    return other is StoryScriptDetailControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$storyScriptDetailControllerHash() =>
    r'1d42218364c978a55f673505fb3b862b58877678';

/// 单篇爽文详情。
///
/// **默认不发请求**：列表接口已经把全文放在 `plotJson.fullContent` 里带回来了，
/// 从列表点进来直接用缓存那一份，进页是秒开的。只有两种情况才去打
/// `/epicScript/detail`——缓存里压根没有这一条（深链接直接进来的），
/// 或者有但没有全文（早期数据）。
///
/// autoDispose（不加 keepAlive）：读完就散。全文动辄几千字，攒着几十篇不释放，
/// 内存涨得比省下的那次请求值钱。

final class StoryScriptDetailControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          StoryScriptDetailController,
          AsyncValue<StoryScript>,
          StoryScript,
          FutureOr<StoryScript>,
          String
        > {
  StoryScriptDetailControllerFamily._()
    : super(
        retry: null,
        name: r'storyScriptDetailControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 单篇爽文详情。
  ///
  /// **默认不发请求**：列表接口已经把全文放在 `plotJson.fullContent` 里带回来了，
  /// 从列表点进来直接用缓存那一份，进页是秒开的。只有两种情况才去打
  /// `/epicScript/detail`——缓存里压根没有这一条（深链接直接进来的），
  /// 或者有但没有全文（早期数据）。
  ///
  /// autoDispose（不加 keepAlive）：读完就散。全文动辄几千字，攒着几十篇不释放，
  /// 内存涨得比省下的那次请求值钱。

  StoryScriptDetailControllerProvider call(String id) =>
      StoryScriptDetailControllerProvider._(argument: id, from: this);

  @override
  String toString() => r'storyScriptDetailControllerProvider';
}

/// 单篇爽文详情。
///
/// **默认不发请求**：列表接口已经把全文放在 `plotJson.fullContent` 里带回来了，
/// 从列表点进来直接用缓存那一份，进页是秒开的。只有两种情况才去打
/// `/epicScript/detail`——缓存里压根没有这一条（深链接直接进来的），
/// 或者有但没有全文（早期数据）。
///
/// autoDispose（不加 keepAlive）：读完就散。全文动辄几千字，攒着几十篇不释放，
/// 内存涨得比省下的那次请求值钱。

abstract class _$StoryScriptDetailController
    extends $AsyncNotifier<StoryScript> {
  late final _$args = ref.$arg as String;
  String get id => _$args;

  FutureOr<StoryScript> build(String id);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<StoryScript>, StoryScript>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<StoryScript>, StoryScript>,
              AsyncValue<StoryScript>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
