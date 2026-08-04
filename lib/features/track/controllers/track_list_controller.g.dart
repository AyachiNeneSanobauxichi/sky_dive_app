// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_list_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 轨迹列表控制器（v2）。
///
/// 直接读 mock 数据源而不是经 Repository：接口契约还没定
/// （`agent/service/track/track.api.md` 为空），此刻造一层 DTO→Entity 的映射等于凭空
/// 发明契约，定稿后必然重写。等契约落地时在这里换成仓库调用，页面一行都不用改。
///
/// **列表始终整体持有、筛选在 UI 层做**：标签筛选切换必须是瞬时的（点一下 chip
/// 要立刻出结果），不能每次都回一趟数据源；真接口上分页后再把筛选下推到查询参数。
// TODO(track): track.api.md 定稿后改为经 Repository 取数（筛选下推成查询参数），
//   并删除 data/mock/。

@ProviderFor(TrackListController)
final trackListControllerProvider = TrackListControllerProvider._();

/// 轨迹列表控制器（v2）。
///
/// 直接读 mock 数据源而不是经 Repository：接口契约还没定
/// （`agent/service/track/track.api.md` 为空），此刻造一层 DTO→Entity 的映射等于凭空
/// 发明契约，定稿后必然重写。等契约落地时在这里换成仓库调用，页面一行都不用改。
///
/// **列表始终整体持有、筛选在 UI 层做**：标签筛选切换必须是瞬时的（点一下 chip
/// 要立刻出结果），不能每次都回一趟数据源；真接口上分页后再把筛选下推到查询参数。
// TODO(track): track.api.md 定稿后改为经 Repository 取数（筛选下推成查询参数），
//   并删除 data/mock/。
final class TrackListControllerProvider
    extends $AsyncNotifierProvider<TrackListController, List<TrackEntry>> {
  /// 轨迹列表控制器（v2）。
  ///
  /// 直接读 mock 数据源而不是经 Repository：接口契约还没定
  /// （`agent/service/track/track.api.md` 为空），此刻造一层 DTO→Entity 的映射等于凭空
  /// 发明契约，定稿后必然重写。等契约落地时在这里换成仓库调用，页面一行都不用改。
  ///
  /// **列表始终整体持有、筛选在 UI 层做**：标签筛选切换必须是瞬时的（点一下 chip
  /// 要立刻出结果），不能每次都回一趟数据源；真接口上分页后再把筛选下推到查询参数。
  // TODO(track): track.api.md 定稿后改为经 Repository 取数（筛选下推成查询参数），
  //   并删除 data/mock/。
  TrackListControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'trackListControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$trackListControllerHash();

  @$internal
  @override
  TrackListController create() => TrackListController();
}

String _$trackListControllerHash() =>
    r'c7840738d9e90d18f495df4ff2502e5673779d87';

/// 轨迹列表控制器（v2）。
///
/// 直接读 mock 数据源而不是经 Repository：接口契约还没定
/// （`agent/service/track/track.api.md` 为空），此刻造一层 DTO→Entity 的映射等于凭空
/// 发明契约，定稿后必然重写。等契约落地时在这里换成仓库调用，页面一行都不用改。
///
/// **列表始终整体持有、筛选在 UI 层做**：标签筛选切换必须是瞬时的（点一下 chip
/// 要立刻出结果），不能每次都回一趟数据源；真接口上分页后再把筛选下推到查询参数。
// TODO(track): track.api.md 定稿后改为经 Repository 取数（筛选下推成查询参数），
//   并删除 data/mock/。

abstract class _$TrackListController extends $AsyncNotifier<List<TrackEntry>> {
  FutureOr<List<TrackEntry>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<TrackEntry>>, List<TrackEntry>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<TrackEntry>>, List<TrackEntry>>,
              AsyncValue<List<TrackEntry>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
