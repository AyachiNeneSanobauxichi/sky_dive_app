// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'load_query_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 航线列表的搜索词与排序。
///
/// 单独一个 provider 而不是页面 `setState`：航线 tab 是常驻挂载的分支，
/// 用户切到预约页再切回来，搜索词与排序方式必须还在（规范要求 tab 切换不丢状态）。

@ProviderFor(LoadQueryController)
final loadQueryControllerProvider = LoadQueryControllerProvider._();

/// 航线列表的搜索词与排序。
///
/// 单独一个 provider 而不是页面 `setState`：航线 tab 是常驻挂载的分支，
/// 用户切到预约页再切回来，搜索词与排序方式必须还在（规范要求 tab 切换不丢状态）。
final class LoadQueryControllerProvider
    extends $NotifierProvider<LoadQueryController, LoadQuery> {
  /// 航线列表的搜索词与排序。
  ///
  /// 单独一个 provider 而不是页面 `setState`：航线 tab 是常驻挂载的分支，
  /// 用户切到预约页再切回来，搜索词与排序方式必须还在（规范要求 tab 切换不丢状态）。
  LoadQueryControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loadQueryControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loadQueryControllerHash();

  @$internal
  @override
  LoadQueryController create() => LoadQueryController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LoadQuery value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LoadQuery>(value),
    );
  }
}

String _$loadQueryControllerHash() =>
    r'46c107cefcf8589cfef01bcf77bad25f656fc608';

/// 航线列表的搜索词与排序。
///
/// 单独一个 provider 而不是页面 `setState`：航线 tab 是常驻挂载的分支，
/// 用户切到预约页再切回来，搜索词与排序方式必须还在（规范要求 tab 切换不丢状态）。

abstract class _$LoadQueryController extends $Notifier<LoadQuery> {
  LoadQuery build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<LoadQuery, LoadQuery>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LoadQuery, LoadQuery>,
              LoadQuery,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// 当前查询条件下**该显示**的航线。
///
/// 过滤 + 排序放在派生 provider 里，页面只管画：Widget 里做 filter/sort 会在
/// 每次重建（包括键盘弹起这种无关重建）时重算一遍整张列表。

@ProviderFor(visibleLoads)
final visibleLoadsProvider = VisibleLoadsProvider._();

/// 当前查询条件下**该显示**的航线。
///
/// 过滤 + 排序放在派生 provider 里，页面只管画：Widget 里做 filter/sort 会在
/// 每次重建（包括键盘弹起这种无关重建）时重算一遍整张列表。

final class VisibleLoadsProvider
    extends $FunctionalProvider<List<Load>, List<Load>, List<Load>>
    with $Provider<List<Load>> {
  /// 当前查询条件下**该显示**的航线。
  ///
  /// 过滤 + 排序放在派生 provider 里，页面只管画：Widget 里做 filter/sort 会在
  /// 每次重建（包括键盘弹起这种无关重建）时重算一遍整张列表。
  VisibleLoadsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'visibleLoadsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$visibleLoadsHash();

  @$internal
  @override
  $ProviderElement<List<Load>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Load> create(Ref ref) {
    return visibleLoads(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Load> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Load>>(value),
    );
  }
}

String _$visibleLoadsHash() => r'cd2ecb5ac1cfdadfdf76c4dbab5d3a1d4f779f21';

/// 当前查询条件下该显示的航线，**按天分好组**。
///
/// 分组也放在 provider 里：列表页每次重建（键盘弹起、搜索框输入）都重新分一遍组
/// 是白干，而且分组结果本身是"该显示什么"的一部分，属于业务而不是布局。

@ProviderFor(visibleLoadDays)
final visibleLoadDaysProvider = VisibleLoadDaysProvider._();

/// 当前查询条件下该显示的航线，**按天分好组**。
///
/// 分组也放在 provider 里：列表页每次重建（键盘弹起、搜索框输入）都重新分一遍组
/// 是白干，而且分组结果本身是"该显示什么"的一部分，属于业务而不是布局。

final class VisibleLoadDaysProvider
    extends
        $FunctionalProvider<
          List<LoadDayGroup>,
          List<LoadDayGroup>,
          List<LoadDayGroup>
        >
    with $Provider<List<LoadDayGroup>> {
  /// 当前查询条件下该显示的航线，**按天分好组**。
  ///
  /// 分组也放在 provider 里：列表页每次重建（键盘弹起、搜索框输入）都重新分一遍组
  /// 是白干，而且分组结果本身是"该显示什么"的一部分，属于业务而不是布局。
  VisibleLoadDaysProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'visibleLoadDaysProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$visibleLoadDaysHash();

  @$internal
  @override
  $ProviderElement<List<LoadDayGroup>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<LoadDayGroup> create(Ref ref) {
    return visibleLoadDays(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<LoadDayGroup> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<LoadDayGroup>>(value),
    );
  }
}

String _$visibleLoadDaysHash() => r'09e019f19e86a52b71eee428404af2ef065c069a';
