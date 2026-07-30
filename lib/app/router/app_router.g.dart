// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 应用路由器（v2）：登录态驱动重定向。
///
/// 用 provider 装配，以便 watch [authControllerProvider]：登录态变化通过
/// [GoRouter.refreshListenable] 触发 go_router 重算 redirect
/// （登录 → home、登出/失效 → login）。
///
/// keepAlive 必需：autoDispose 会在无监听者时重建 GoRouter，导致导航栈丢失。

@ProviderFor(router)
final routerProvider = RouterProvider._();

/// 应用路由器（v2）：登录态驱动重定向。
///
/// 用 provider 装配，以便 watch [authControllerProvider]：登录态变化通过
/// [GoRouter.refreshListenable] 触发 go_router 重算 redirect
/// （登录 → home、登出/失效 → login）。
///
/// keepAlive 必需：autoDispose 会在无监听者时重建 GoRouter，导致导航栈丢失。

final class RouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  /// 应用路由器（v2）：登录态驱动重定向。
  ///
  /// 用 provider 装配，以便 watch [authControllerProvider]：登录态变化通过
  /// [GoRouter.refreshListenable] 触发 go_router 重算 redirect
  /// （登录 → home、登出/失效 → login）。
  ///
  /// keepAlive 必需：autoDispose 会在无监听者时重建 GoRouter，导致导航栈丢失。
  RouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'routerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$routerHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return router(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }
}

String _$routerHash() => r'd2a8d49bae6291c2d4e69ce22f119fe9267c748e';
