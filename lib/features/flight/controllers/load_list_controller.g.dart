// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'load_list_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 航线列表状态与增删改。
///
/// ## 为什么写操作不把 state 打回 loading
/// 新建 / 编辑 / 分配都是**局部**变化，把整个列表打回 `AsyncLoading` 会让屏幕
/// 上已经在看的内容整块变回骨架——用户只是给一条航线加了个人，凭什么整页闪一下。
/// 所以这里统一"拿服务端返回的那条航线，就地替换本地那条"，忙碌态由发起操作的
/// 按钮自己承担（`SkyButton.isLoading`）。
///
/// ## 为什么失败时不设 AsyncError
/// 同理：失败了就把异常抛给调用方去弹 toast，列表内容留在原地。
/// 网络抖一下就把整页已加载的航线清成错误页，是在惩罚用户。
/// 唯一例外是 [LoadErrorCode.loadNotFound]——那条航线**确实**不在了，
/// 必须从本地列表里拿掉，否则用户会对着一条幽灵航线反复操作反复失败。

@ProviderFor(LoadListController)
final loadListControllerProvider = LoadListControllerProvider._();

/// 航线列表状态与增删改。
///
/// ## 为什么写操作不把 state 打回 loading
/// 新建 / 编辑 / 分配都是**局部**变化，把整个列表打回 `AsyncLoading` 会让屏幕
/// 上已经在看的内容整块变回骨架——用户只是给一条航线加了个人，凭什么整页闪一下。
/// 所以这里统一"拿服务端返回的那条航线，就地替换本地那条"，忙碌态由发起操作的
/// 按钮自己承担（`SkyButton.isLoading`）。
///
/// ## 为什么失败时不设 AsyncError
/// 同理：失败了就把异常抛给调用方去弹 toast，列表内容留在原地。
/// 网络抖一下就把整页已加载的航线清成错误页，是在惩罚用户。
/// 唯一例外是 [LoadErrorCode.loadNotFound]——那条航线**确实**不在了，
/// 必须从本地列表里拿掉，否则用户会对着一条幽灵航线反复操作反复失败。
final class LoadListControllerProvider
    extends $AsyncNotifierProvider<LoadListController, List<Load>> {
  /// 航线列表状态与增删改。
  ///
  /// ## 为什么写操作不把 state 打回 loading
  /// 新建 / 编辑 / 分配都是**局部**变化，把整个列表打回 `AsyncLoading` 会让屏幕
  /// 上已经在看的内容整块变回骨架——用户只是给一条航线加了个人，凭什么整页闪一下。
  /// 所以这里统一"拿服务端返回的那条航线，就地替换本地那条"，忙碌态由发起操作的
  /// 按钮自己承担（`SkyButton.isLoading`）。
  ///
  /// ## 为什么失败时不设 AsyncError
  /// 同理：失败了就把异常抛给调用方去弹 toast，列表内容留在原地。
  /// 网络抖一下就把整页已加载的航线清成错误页，是在惩罚用户。
  /// 唯一例外是 [LoadErrorCode.loadNotFound]——那条航线**确实**不在了，
  /// 必须从本地列表里拿掉，否则用户会对着一条幽灵航线反复操作反复失败。
  LoadListControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loadListControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loadListControllerHash();

  @$internal
  @override
  LoadListController create() => LoadListController();
}

String _$loadListControllerHash() =>
    r'9ccbf52e451b98f839c60804062b24abde78a06f';

/// 航线列表状态与增删改。
///
/// ## 为什么写操作不把 state 打回 loading
/// 新建 / 编辑 / 分配都是**局部**变化，把整个列表打回 `AsyncLoading` 会让屏幕
/// 上已经在看的内容整块变回骨架——用户只是给一条航线加了个人，凭什么整页闪一下。
/// 所以这里统一"拿服务端返回的那条航线，就地替换本地那条"，忙碌态由发起操作的
/// 按钮自己承担（`SkyButton.isLoading`）。
///
/// ## 为什么失败时不设 AsyncError
/// 同理：失败了就把异常抛给调用方去弹 toast，列表内容留在原地。
/// 网络抖一下就把整页已加载的航线清成错误页，是在惩罚用户。
/// 唯一例外是 [LoadErrorCode.loadNotFound]——那条航线**确实**不在了，
/// 必须从本地列表里拿掉，否则用户会对着一条幽灵航线反复操作反复失败。

abstract class _$LoadListController extends $AsyncNotifier<List<Load>> {
  FutureOr<List<Load>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Load>>, List<Load>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Load>>, List<Load>>,
              AsyncValue<List<Load>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
